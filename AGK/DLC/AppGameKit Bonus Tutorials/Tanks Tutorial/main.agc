
// Project: tanks 
// Created: 2017-04-18

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "tanks" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//Set up the player types
Type player
	//X and Y are the position on screen.
	x as float
	y as float
	//Which sprite will it use
	sprite as integer
	//We'll also need a special collison sprite
	colsprite as integer
	//In this game we move in the direction we are facing, so we'll
	//need to know what that is.
	rotation as float
	//Is the player controlled by the computer
	iscomputer as integer
	//Let's set up a variable to allow use to adjust the speed
	speed as float
	//How long since the tank last fired
	firerate as integer
	//And, for this game, we'll introduce some lives to give
	//everyone a few goes
	lives as integer
	//If the tanks is destroyed, we will spin it around
	//We need to know if it's spinning.
	spinning as integer
	//And for how long, so we will need a timer
	spintime as integer
	//For AI, we need to know if a collision has occured
	hascollided as integer
	//For AI, we'll need to know if the tank is turning around
	//An obstacle. We'll flag this 
	isturning as integer
	//and where it is turning
	turnwhere as integer	
EndType

//We only want 2 players, so we'll set up an array.
Dim tanks[2] as player

//Let's create a couple of text objects for the number of lives
CreateText(1,"0")
SetTextSize(1,90)
SetTextPosition(1,16,16)

CreateText(2,"0")
SetTextSize(2,90)
SetTextPosition(2,963,16)

//We'll need an image for our tank,
//Let's load it in.

LoadImage(1,"tank.png")

//We'll also need an image for our special collision sprite

LoadImage(2,"colsprite.png")

//Set up tanks fire sprites

Type tankfire
	//As tank fire, we need 2 sets of cordinates,
	//X and Y are the bullets current position
	x as float
	y as float
	//DX and DY are the destination.
	dx as float
	dy as float
	//Give it somewhere to store the sprite number
	sprite as integer
	//Is the bullet active?
	active as integer
	//How fast is it moving.
	speed as float
	//Who fired the bullet?
	//We'll need to know which player fired the bullet so we
	//don't shoot ourselves
	who as integer
EndType

//And now we set up the array.
//We'll allow 20, which is more than we'll need, but it will
//allow you to play around with fire rate and speed.
Dim tfire[20] as tankfire

//Let's set up some bullets.

//We only have 1 image to use, so let's load that in as image 2
LoadImage(3,"bullet.png")

For makebullets=1 to 20
	//give it a sprite number, starting at 100
	tfire[makebullets].sprite=99+makebullets
	//Make the sprite
	CreateSprite(tfire[makebullets].sprite,3)
	//Hide the sprites offscreen by moving them somewhere outside the screen
	//boundries
	SetSpritePosition(tfire[makebullets].sprite,-10000,-10000)
	//Set bullet depth to appear underneath the tanks
	SetSpriteDepth(tfire[makebullets].sprite,7)
	//We also want the bullets to be offset by thier centre
	SetSpriteOffset(tfire[makebullets].sprite,4,7)
Next makebullets

//Now we've done that, we can set up the player stats
//So let's jump to our reset routine,
//This will allow us to set our player details up
//in the first place, as well as allow us to reset them between games.
//We can choose a full reset, restoring lives 
//Or a partial reset, just resetting the tanks position and rotation.
//We'll use the value 0 for partial, and 1 for full
//For now, we'll want a full reset

resetplayers(1)

//Lastly, sprite wise, we'll need a background

LoadImage(4,"backdrop.png")
CreateSprite(5,4)

//Classic tank games have obstacles, so let's make some.
//We'll allow an obstacle every 64x64 pixels, which equals
//16 across, and 12 down
//Using this system we can easily create maps

//Firstly let's load an image

LoadImage(5,"wall.png")

Type bricks
	//Which sprite number will it have
sprite as integer
//Is the wall active, we can create our own maps by turning a
//brink on or off.
active as integer
EndType

Dim obstacles[16,12] as bricks

nextsprite=200

//Let's make all the sprites
For across=1 to 16
	For down=1 to 12
		obstacles[across,down].sprite=nextsprite
		CreateSprite(nextsprite,5)
		SetSpritePosition(nextsprite,-64+(across*64),-64+(down*64))
		inc nextsprite,1
	Next down
Next across

//We'll also be using sounds in this game
//These 2 sound effects are taken from the Sound Library DLC.
Global fire=1
LoadSound(fire,"fire.wav")
Global bang=2
LoadSound(bang,"bang.wav")

//We'll store the currenttime here
Global currenttime=0

//You can create multiple levels
//Let's set up a variable to hold the current one.
Global level=1

makelevel(level)

//Main loop
do
	
	currenttime=GetMilliseconds()
    
    //Run through the players
    For loopthroughplayers=1 to 2
		SetTextString(loopthroughplayers,str(tanks[loopthroughplayers].lives))
		//We can only control the tank if it's not spinning
		If tanks[loopthroughplayers].spinning=0
			controlplayer(loopthroughplayers)
			Else
			//If it is spinning, let's do it!
			Inc tanks[loopthroughplayers].rotation,16
			//Set the angle
			SetSpriteAngle(tanks[loopthroughplayers].sprite,tanks[loopthroughplayers].rotation)
			//Only spin for 2 seconds.
			If currenttime-tanks[loopthroughplayers].spintime>2000
				//Afterward, reset tank position
				//If one of the players has run out of lives, reset everything
				If tanks[loopthroughplayers].lives=0
				resetplayers(1)
				Else
				resetplayers(0)
				EndIf
				//Stop the tanks spinning
				tanks[loopthroughplayers].spinning=0
				
			EndIf
		EndIf
    Next loopthroughplayers
    
    //Move any bullets
    movefire()
    
    //Let's see if any bullet has hit a tank
    tankhit=checkhit()
    
    //Set the tank spinning
    If tankhit<>0
		//Play the bang sound effect
		PlaySound(bang)
		If tanks[tankhit].spinning=0
			tanks[tankhit].spinning=1
			tanks[tankhit].spintime=currenttime
		EndIf
	Endif
	

  //  Print( ScreenFPS() )
  
  // Update the screen.
    Sync()
loop

  
Function controlplayer(whichone)
	
	//Set a couple of variables,
	//turn is which way a tank is turning
	//forward is if the tank needs to move forward
	turn=0
	forward=0
	
	//If the player isn't the computer.
	If tanks[whichone].iscomputer=0
		
		//Is it player 1?
		If whichone=1
			//Z turn left
			If GetRawKeyState(90)
				turn=-1
			Endif
			
			//X turn right
			If GetRawKeyState(88)
				turn=1
			Endif
			
			//S move forward
			If GetRawKeyState(83)
				forward=1
			Endif
			
			//Space to fire, only 1 shot a second and only if the neither tank is spinning
			If GetRawKeyState(32) and currenttime-tanks[whichone].firerate>1000 and tanks[1].spinning=0 and tanks[2].spinning=0
				//Make fire
				makefire(whichone)
			Endif
		Endif
		
		//Is it player 2?
		If whichone=2
			//Left arrow turn left
			If GetRawKeyState(37)
				turn=-1
			Endif
			
			//Right arrow turn right
			If GetRawKeyState(39)
				turn=1
			Endif
			
			//up arrow move forward
			If GetRawKeyState(38)
				forward=1
			Endif
			
			//Ctrl to fire, only 1 shot a second and only if the neither tank is spinning
			If GetRawKeyState(17) and currenttime-tanks[whichone].firerate>1000 and tanks[1].spinning=0 and tanks[2].spinning=0
				//Make fire
				makefire(whichone)
			Endif		

		Endif
	
	EndIf
	
	//If the player is the computer,
	//Let's make it think
	//Bear in mind that this is very simple AI
	//Based on obstacle avoidance and opponent position
	//There are more efficent, but more advanced techniques
	If tanks[whichone].iscomputer=1
		//Find out which tanks we are looking at.
		otherone=1
		If whichone=1 
			otherone=2
		Endif
		
		//find the angle between the 2 tanks
		theangleis=FindAngle(tanks[whichone].x,tanks[whichone].y,tanks[otherone].x,tanks[otherone].y)
		
		//If the other one is below the active tank,
		//turn to face it.
		If theangleis<tanks[whichone].rotation 
			turn=-2
		EndIf
		
		//If the other one is above the active tank,
		//turn to face it.
		If theangleis>tanks[whichone].rotation 
			turn=2
		EndIf
			
		//When to move
		//Find the difference between the 2 angles
		//We use ABS to force negatives into positves as we
		//Only need the actual difference in degrees
		testangle=Abs(tanks[whichone].rotation-theangleis)
		
		//We also want to know how close the tanks are,
		//So they don't collide
		tankdistance#=GetDistance#(tanks[whichone].x,tanks[whichone].y,tanks[otherone].x,tanks[otherone].y)
		
		//If the tank angle is far enough away, move tank
		If tankdistance#>100
			forward=1
		EndIf
		
		//Should the tank fire
		//For this we'll only allow an enemy shot every 2 seconds
		//And that the angle makes the shoot make sense
		//And lastly that it is within 500 pixels
		//And only if niether tank is spinning
		If currenttime-tanks[whichone].firerate>2000 and testangle<20 and tankdistance#<500 and tanks[1].spinning=0 and tanks[2].spinning=0
			//Make fire
			makefire(whichone)
		Endif
	
	Endif
	
	//Now that we've decided where to move to
	//We can use the movement for both player and computer.
	
	//Now, let's make sure we can't leave the screen
	
	If tanks[whichone].x<64
		tanks[whichone].x=64
		forward=0
	EndIf
	
	If tanks[whichone].x>924
		tanks[whichone].x=924
		forward=0
	EndIf
	
	If tanks[whichone].y<64
		tanks[whichone].y=64
		forward=0
	EndIf
	
	If tanks[whichone].y>704
		tanks[whichone].y=704
		forward=0
	EndIf
	
	//Now we've decided on our ideal move, let's check for obstacles if the tank isn't already avoiding one
		
		If tanks[whichone].isturning=0 and tanks[whichone].hascollided=0
			//Run through all the brick sprites
			For checkhits=200 to 361
				//Has the collision sprite hit a brick sprite
				If GetSpriteCollision(tanks[whichone].colsprite,checkhits) and GetSpriteActive(checkhits)
					
					//Check the position of the sprites against the position of the colsprite
					//We can then work out which direction is best to avoid the sprite
					If  (GetSpriteX(checkhits)>=GetSpriteX(tanks[whichone].colsprite)) or (GetSpriteY(checkhits)>=GetSpriteY(tanks[whichone].colsprite))
						tanks[whichone].isturning=checkhits
						tanks[whichone].turnwhere=4
					Endif
					
					//Check the position of the sprites against the position of the colsprite
					//We can then work out which direction is best to avoid the sprite
					If (GetSpriteX(checkhits)<GetSpriteX(tanks[whichone].colsprite)) or (GetSpriteY(checkhits)<GetSpriteY(tanks[whichone].colsprite))
						tanks[whichone].isturning=checkhits
						tanks[whichone].turnwhere=-4
					Endif
					
					//End the loop if we have collided as we 
					//Only need to check one brick.
					checkhits=362
				EndIf
			Next checkhits
		Endif
		
		
	//If this collision is a human, then we only care if the tank
	//Has actually hit something,
	//If so, cancel automatic turning
	//And prevent forward movement
		
		If tanks[whichone].isturning<>0 and tanks[whichone].iscomputer=0
			tanks[whichone].isturning=0
			forward=0
		EndIf
	
	//If the tank is avoiding an obstacle, keep turning until colsprite is no longer touching it.
	If tanks[whichone].isturning>0 
		If GetSpriteCollision(tanks[whichone].colsprite,tanks[whichone].isturning) or tanks[whichone].hascollided<>0
			turn=tanks[whichone].turnwhere
			//Stop the tank from moving
			forward=0
			//If the tank has stopped colliding, start a timer
		ElseIf tanks[whichone].hascollided=0
			tanks[whichone].hascollided=currenttime	
		EndIf
	Endif
	

	//If movement is automated,
	//Keep turning for 1000 miliseconds after the tank has cleared the obstacle
	//to ensure we make it through the gap.
	If currenttime-tanks[whichone].hascollided>1000
		tanks[whichone].hascollided=0
		tanks[whichone].isturning=0
		tanks[whichone].turnwhere=0
	Endif
	
	If tanks[otherone].spinning<>0
		turn=0
		forward=0
	Endif
	

	If turn<>0 or forward<>0
			//If the tank is turning or moving let's find out what happens.
			//Set the rotation by adding the turn left or right to the current angle
			tanks[whichone].rotation=wrapangle(tanks[whichone].rotation+turn)
			SetSpriteAngle(tanks[whichone].sprite,tanks[whichone].rotation)
			
			//Set a position for the collison sprite
			tempx#=tanks[whichone].x+(sin(tanks[whichone].rotation)*32)
			tempy#=tanks[whichone].y-(cos(tanks[whichone].rotation)*32)
			SetSpritePositionByOffset(tanks[whichone].colsprite,tempx#,tempy#)
			
			//If it's moving...
			If forward<>0
				//Using a little bit of math and we can move the sprite forward 
				//towards it's direction of facing
				//Notice how we adjust the final move by the tanks speed.
				Inc tanks[whichone].x,sin(tanks[whichone].rotation)*tanks[whichone].speed
				Inc tanks[whichone].y,-cos(tanks[whichone].rotation)*tanks[whichone].speed
				//Set the new position
				SetSpritePositionByOffset(tanks[whichone].sprite,tanks[whichone].x,tanks[whichone].y)
				
			EndIf
			
		Endif
	
EndFunction
  
Function resetplayers(between)
	
	//First of all, let's make sure that any moving bullets are cancelled.
	
	For bullets=1 to 20
		tfire[bullets].active=0
		SetSpritePosition(tfire[bullets].sprite,-10000,-10000)
	Next bullets
	
	//Set up player 1
	tanks[1].x=64
	tanks[1].y=384
	tanks[1].sprite=1
	tanks[1].colsprite=2
	tanks[1].rotation=90
	tanks[1].iscomputer=0
	tanks[1].speed=4
	tanks[1].firerate=800
	
	If between=1
	tanks[1].lives=3
	EndIf
	
	//This is a special bit of code to create a tanks sprite if it doesn't exist.
	//This will only be set up once.
	
	//First we check if it exists.
	
	If GetSpriteExists(tanks[1].sprite)=0
		//If not make it
		CreateSprite(tanks[1].sprite,1)
		//We will also want to rotate the tank around it's middle
		//We can do this by setting an offset, so that it rotates around the centre
		SetSpriteOffset(tanks[1].sprite,24,42)
		//And the collision sprite
		CreateSprite(tanks[1].colsprite,2)
		//We don't need to see the colsprite, as we can still
		//Check collisions on non visible sprite.
		SetSpriteVisible(tanks[1].colsprite,0)
		//We will also want to rotate the colsprite around it's middle
		//We can do this by setting an offset, so that it rotates around the centre
		SetSpriteOffset(tanks[1].colsprite,16,16)
		
		//Place the tank at depth 5, so bullets will appear underneath for a better
		//Firing effect
		SetSpriteDepth(tanks[1].sprite,5)
		SetSpriteDepth(tanks[1].colsprite,5)
		//We also want the tanks to be different colours
		//We'll make the 1st one blue
		SetSpriteColor(tanks[1].sprite,0,0,255,255)
	EndIf
	
	//Set the tanks angle
	SetSpriteAngle(tanks[1].sprite,tanks[1].rotation)
	//Set it's position
	SetSpritePositionByOffset(tanks[1].sprite,tanks[1].x,tanks[1].y)

	
	//Set up player 2
	tanks[2].x=924
	tanks[2].y=384
	tanks[2].sprite=3
	tanks[2].colsprite=4
	tanks[2].rotation=270
	tanks[2].iscomputer=1
	tanks[2].speed=4
	tanks[2].firerate=800
	
	If between=1
	tanks[2].lives=3
	EndIf
	
	//This is a special bit of code to create a tanks sprite if it doesn't exist.
	//This will only be set up once.
	
	//First we check if it exists.
	
	If GetSpriteExists(tanks[2].sprite)=0
		//If not make it
		CreateSprite(tanks[2].sprite,1)
		//We will also want to rotate the tank around it's middle
		//We can do this by setting an offset, so that it rotates around the centre
		SetSpriteOffset(tanks[2].sprite,24,42)
		//And the collision sprite
		CreateSprite(tanks[2].colsprite,2)
		//We don't need to see the colsprite, as we can still
		//Check collisions on non visible sprite.
		SetSpriteVisible(tanks[2].colsprite,0)
		//We will also want to rotate the tank around it's middle
		//We can do this by setting an offset, so that it rotates around the centre
		SetSpriteOffset(tanks[2].colsprite,16,16)
		//Place the tank at depth 5, so bullets will appear underneath for a better
		//Firing effect
		SetSpriteDepth(tanks[2].sprite,5)
		SetSpriteDepth(tanks[2].colsprite,5)
		//We also want the tanks to be different colours
		//We'll make the 2nd one red
		SetSpriteColor(tanks[2].sprite,255,0,0,255)
	EndIf
	
	//Set the tanks angle
	SetSpriteAngle(tanks[2].sprite,tanks[2].rotation)
	//Set it's position
	SetSpritePositionByOffset(tanks[2].sprite,tanks[2].x,tanks[2].y)
	 
EndFunction

Function makefire(which)
	
	freebullet=0
	
	For find=1 to 20
		//Is the bullet free for use?
		if tfire[find].active=0
			//Set freebullet to the available space
			freebullet=find
			//By setting find to 21 (more than the end of the For-Next loop, we
			//can end the loop
			find=21
		EndIf
	Next find
	
	
	//Have we found a space
	If freebullet<>0
		//Play the fire sound
		PlaySound(fire)
		//Set the last time the tank fired timer
		tanks[which].firerate=currenttime
		//Set which tank the bullet belongs to,
		//As we don't want to shoot ourselves.
		tfire[freebullet].who=which
		tfire[freebullet].active=1
		SetSpriteAngle(tfire[freebullet].sprite,tanks[which].rotation)
		tfire[freebullet].x=GetSpriteXByOffset(tanks[which].sprite)
		tfire[freebullet].y=GetSpriteYByOffset(tanks[which].sprite)
		tfire[freebullet].speed=16
		
		
		tdestx#=tfire[freebullet].x+sin(tanks[which].rotation)*2000
		tdesty#=tfire[freebullet].y-cos(tanks[which].rotation)*2000
		
		settankfiredest(tfire[freebullet].x,tfire[freebullet].y,tdestx#,tdesty#,freebullet)
		
		SetSpritePositionByOffset(tfire[freebullet].sprite,tfire[freebullet].x,tfire[freebullet].y)
		
	Endif
	
EndFunction

Function movefire()
	
	//Take a look at all the bullets
	For movebullet=1 to 20
		//If the bullet is in use
		If tfire[movebullet].active=1
			//Move it
			Inc tfire[movebullet].x,tfire[movebullet].dx*tfire[movebullet].speed
			Inc tfire[movebullet].y,tfire[movebullet].dy*tfire[movebullet].speed
			//update the bullet sprite on screen
			SetSpritePositionByOffset(tfire[movebullet].sprite,tfire[movebullet].x,tfire[movebullet].y)
			
			//Let's see if the bullet has left the screen
			
			If tfire[movebullet].x<-32 or tfire[movebullet].x>1056 or tfire[movebullet].y<-32 or tfire[movebullet].y>800
				tfire[movebullet].active=0
			EndIf
		EndIf
		//Look at the next one
	Next movebullet
	
EndFunction


Function settankfiredest(x1,y1,x,y,number)
	
	originalX# = x1
    originalY# = y1

    // work out the destination
    destinationX# = x
    destinationY# = y
    distanceX# = destinationX# - originalX#
    distanceY# = destinationY# - originalY#
    //We use a little maths to work out the distance
    distanceFromAtoB# = sqrt ( ( distanceX# * distanceX# ) + ( distanceY# * distanceY# ) )
	//From this we can calculate how the sprite needs to move to reach it's target
    if ( distanceFromAtoB# <> 0.0 )
       tfire[number].dx = distanceX# / distanceFromAtoB#
       tfire[number].dy = distanceY# / distanceFromAtoB#
    endif
  
  endfunction
  
  Function checkhit()
	
	//Set up a variable to store
	//Which, if any tank has been hit
	hastankbeenhit=0
	
	//Loop through the tanks
	For whichtank=1 to 2
		//Loop through the bullets
		For whichbullet=1 to 20
			//Is the bullet active
			If tfire[whichbullet].active<>0
				//Let's check to see if we hit a wall
				//There are 192 wall sprites, numbered 200 - 391
				For checkwall=200 to 391
				 //We're only interested in the active ones	
				 If GetSpriteActive(checkwall)<>0
					If GetSpriteCollision(tfire[whichbullet].sprite,checkwall)
						tfire[whichbullet].active=0
						//Disable it, making it available to be chosen again
						//And hide it off the screen.
						SetSpritePosition(tfire[whichbullet].sprite,-10000,-10000)
						//If it's hit a wall, there no need to check if it hits a tank
						//So we'll set the tfire[whichbullet].who to 0
						tfire[whichbullet].who=0
					Endif
				 Endif
				Next checkwall
				//Make sure it doesn't belong to this tank
				//So we don't shoot ourselves
				If tfire[whichbullet].who<>whichtank
					//Check to see if the bullet sprite and the tank sprite collide
					If GetSpriteCollision(tfire[whichbullet].sprite,tanks[whichtank].sprite)
						//Decrease the lives
						Dec tanks[whichtank].lives,1
						//If we've got a hit, flag the tank
						hastankbeenhit=whichtank
						//We don't want the bullet to contine
						tfire[whichbullet].active=0
						//Disable it, making it available to be chosen again
						//And hide it off the screen.
						SetSpritePosition(tfire[whichbullet].sprite,-10000,-10000)
						//Only one bullet can hit a tank at a time,
						//So we will force an end to our loop as we
						//Don't need to continue
						whichbullet=21
					EndIf
				Endif
			EndIf
		Next whichbullet
	Next whichtank
	
//Return which tank, if any, has been hit.
	
EndFunction hastankbeenhit

//This command will return a value that does not exceed the range of 0 to 360. 
function wrapangle( angle as float) 
    local iChunkOut as integer
    local breakout as integer
    iChunkOut = angle
    iChunkOut = iChunkOut - mod( iChunkOut, 360 )
    angle = angle - iChunkOut
    breakout = 10000
	//Wrap the value
    while angle < 0.0 or angle >= 360.0 
        if angle < 0.0 then angle = angle + 360.0
        if angle >= 360.0 then angle = angle - 360.0
        //Make sure we don't get caught in a loop
        //If we've made 1000 attempts and don't have a result
        //Exit the while - endwhile loop
        dec breakout  
        if  breakout = 0  then exit
    endwhile
    if  breakout = 0  then angle = 0.0
endfunction angle


// 2d distance function

Function GetDistance#( X1#, Y1#, X2#, Y2#)
        
   Dist_X# = X1# - X2#
   Dist_Y# = Y1# - Y2#
   Distance# = Sqrt(Dist_X# * Dist_X# + Dist_Y# * Dist_Y#)
        
EndFunction Distance#


//This function calculates the difference between
//2 angles.
Function findangle(x#,y#,x1#,y1#)
	
	point1#=x#-x1#
	point2#=y#-y1#
	angle=ATanFull(point1#,point2#)-180
	angle=wrapangle(angle)
	
EndFunction angle



Function makelevel(whichlevel)
	
	//Firstly, we need to deactivate all the sprites, so
	//We're only using the ones we need.
	For across=1 to 16
		For down=1 to 12
			//Hide the sprite
			SetSpriteVisible(obstacles[across,down].sprite,0)
			//Make it inactive so it can't be detected
			//For collisions.
			SetSpriteActive(obstacles[across,down].sprite,0)
			//Clear the map
			obstacles[across,down].active=0
		Next down
	Next across

//Let's make a level
//All we need to do is set the square we want to have a block in
//As active by setting it to one.
//An easy way to make a map would be to plot it on graph paper
//More advanced users might try to make an editor.

//This is the first level
If whichlevel=1
	obstacles[4,3].active=1
	obstacles[13,3].active=1
	obstacles[4,10].active=1
	obstacles[13,10].active=1
	obstacles[8,6].active=1
EndIf

//Build the map

	For across=1 to 16
		For down=1 to 12
			If obstacles[across,down].active=1
				//Show the sprite
				SetSpriteVisible(obstacles[across,down].sprite,1)
				//Make it active so it can be detected
				//For collisions.
				SetSpriteActive(obstacles[across,down].sprite,1)
			EndIf	
		Next down
	Next across
	
	
EndFunction
