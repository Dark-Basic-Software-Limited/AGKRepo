
// Project: Meteor Dash 
// Created: 2017-07-18

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Meteor Dash" )
SetWindowSize( 1024, 768, 1)
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) 
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
//set up basic 3D stuff
//set all 3D objects to appear at depth 50 is
//relation to 2D objects (text and sprites)
SetGlobal3DDepth(50)
//set the camera range
SetCameraRange(1,.1,10000)
//hide the mouse
SetRawMouseVisible(0)

//first we'll create a sprite for space
global space=1:LoadImage(space,"space.png")
CreateSprite(space,space)
//place it at the back, so it's drawn first
SetSpriteDepth(space,100)
//and another of the cockpit
Global cockpit=2
LoadImage(cockpit,"cockpit.png")
CreateSprite(cockpit,cockpit)
SetSpriteDepth(cockpit,10)
SetSpritePosition(cockpit,0,540)
//now we will need a crosshair
Global crosshair=3
LoadImage(crosshair,"crosshair.png")
CreateSprite(crosshair,crosshair)

//let's create a 3D object.
Global rockparent=4:LoadObject(rockparent,"asteroid.x")
//we will need to give it a texture
LoadImage(rockparent,"asteroid.png")
//link the image with the object
SetObjectImage(rockparent,rockparent,0)
//hide the object by placing it a long way away
SetObjectPosition(rockparent,-10000,-10000,-10000)
//and make it invisible
SetObjectVisible(rockparent,0)

type rocks
	
	x as float
	y as float
	z as float
	scale as float
	object as integer
	angle as integer
	speed as integer
	distance as integer
	
endtype

Dim asteroids[100] as rocks

setupstorm()

//make some player stats

type player
	damage as integer
	score as integer
	recharge as integer
endtype

Global ship as player

ship.damage=0
ship.score=0

//taking a left from our previous tutorial
//we will be using 2D explosions, virtually
//duplicating the code from our Lunar Buggy 
//tutorial

//now we will need some explosions
//the idea of explosions may seem complicated
//but are nothing more than an animated sprite
//played from start to finish
Type explosions
	x as float
	y as float
	sprite as integer
	active as integer
EndType

//we'll allow for 40
dim bangit[40] as explosions

Global rockbang=5

loadimage(rockbang,"rockbang.png")

//and make the sprites
For makebang=1 to 40
	bangit[makebang].sprite=makebang+699
	createsprite(bangit[makebang].sprite,rockbang)
	//set the animation frame
	//the ship explosion is
	//64 sprite wide, 70 pixel hight and has 8 frames
	SetSpriteAnimation(bangit[makebang].sprite,64,70,8)
	SetSpritePosition(bangit[makebang].sprite,-10000,-10000)
	//same depth as the 3D objects
	SetSpriteDepth(bangit[makebang].sprite,50)
Next makebang

//load some sounds
Global laser:laser=LoadSound("laser.wav")
Global bang:bang=LoadSound("bang.wav")
Global shiphit:shiphit=LoadSound("shiphit.wav")
//timers
Global currenttime as integer
Global frameadjust as float
ship.recharge=currenttime

Do
	
	//set frame adjust to 60 * by the time it took to draw the last frame
	//this will produce a value we can multiple all movement by to ensure
	//the appearance of smooth movement
	frameadjust=60*GetFrameTime()
	currenttime=GetMilliseconds()
    
    showcrosshair()
	shootgun()
	moveasteroids()
	controlbangs()
	stats()
	
	If GetRawKeyState(27)
		end
	EndIf
 
    Sync()
Loop

Function showcrosshair()
	
	If currenttime-ship.recharge>500
		SetSpriteColor(crosshair,255,255,255,255)
		else
		SetSpriteColor(crosshair,127,0,0,255)
	Endif
	
	SetSpritePosition(crosshair,GetPointerX(),GetPointerY())
	
EndFunction

Function findundercrosshair()
	
	//get the crosshair position on screen
	pointerx#=GetPointerX()+24
	pointery#=GetPointerY()+24
	
	//AppGameKit allows you to quickly
	//find a point in 3D space from a 2D position
	tempx#=Get3DVectorXFromScreen(pointerx#,pointery#)
	tempy#=Get3DVectorYFromScreen(pointerx#,pointery#)
	tempz#=Get3DVectorZFromScreen(pointerx#,pointery#)
	
	//we take those positions
	startx#=tempx#
	starty#=tempy#
	startz#=tempz#
	
	//calculate an end position
	endx#=10000*startx#
	endy#=10000*starty#
	endz#=10000*startz#
	
	//and raycast from the start position to the end position
	whichone=ObjectRayCast(0,startx#,starty#,startx#,endx#,endy#,endz#)
	
EndFunction whichone

Function shootgun()
	
	whichone=findundercrosshair()
	
    if GetRawMouseLeftPressed() and currenttime-ship.recharge>500
		PlaySound(laser)
		ship.recharge=currenttime
		if whichone<>0
			tempdistance#=asteroids[whichone-99].distance
			makebang(GetPointerX()+24,GetPointerY()+24,tempdistance#)
			makenewasteroid(whichone-99)
			PlaySound(bang)
			inc ship.score,100
		endif
    endif
	
EndFunction

Function makenewasteroid(which)
	
	//set up a new position
	tempx=random(1,1000)
	tempx=RandomSign(tempx)
	asteroids[which].x=tempx
	tempy=random(1,1000)
	asteroids[which].y=-tempy
	//at a random distance
	asteroids[which].z=random(1000,4000)
	
	asteroids[which].angle=random(1,360)
	asteroids[which].speed=random(1,3)

	SetObjectPosition(asteroids[which].object,asteroids[which].x,asteroids[which].y,asteroids[which].z)
	
EndFunction

Function moveasteroids()
	
	For move=1 to 100
		Dec asteroids[move].z,asteroids[move].speed*frameadjust
		SetObjectPosition(asteroids[move].object,asteroids[move].x,asteroids[move].y,asteroids[move].z)
		tempanglex=GetObjectAngleX(asteroids[move].object)
		tempanglez=GetObjectAngleZ(asteroids[move].object)+asteroids[move].speed
		SetObjectRotation(asteroids[move].object,GetObjectAngleX(asteroids[move].object),GetObjectAngleY(asteroids[move].object),tempanglez)
		
		if asteroids[move].z<-100
			makenewasteroid(move)
		endif
		
	    asteroids[move].distance=distance(0,0,0,asteroids[move].x,asteroids[move].y,asteroids[move].z)
	    
	    If asteroids[move].distance<400 and asteroids[move].distance>0
			//find a point in 2D space from a 3D object
			x1#=GetScreenXFrom3D(asteroids[move].x,asteroids[move].y,asteroids[move].z)
			Y1#=GetScreenXFrom3D(asteroids[move].x,asteroids[move].y,asteroids[move].z)
			
			tempdistance#=asteroids[move].distance
			makebang(x1#,y1#,tempdistance#)
			
			makenewasteroid(move)
			inc ship.damage,random(4,10)
			PlaySound(shiphit)
			PlaySound(bang)
			
			if ship.damage>100
				ship.damage=100
			endif
		endif
		
	Next move
		
	
EndFunction

Function setupstorm()
	
For makerocks=1 to 100
	//assign the object a number
	asteroids[makerocks].object=99+makerocks
	
	If GetObjectExists(asteroids[makerocks].object)=0
	CloneObject(asteroids[makerocks].object,rockparent)
	createtext(makerocks,"")
	SetObjectVisible(asteroids[makerocks].object,1)
	endif
	
	//
	tempx=random(1,1000)
	tempx=RandomSign(tempx)
	asteroids[makerocks].x=tempx
	tempy=random(1,1000)
	asteroids[makerocks].y=-tempy
	asteroids[makerocks].z=random(1000,4000)
	
	asteroids[makerocks].angle=random(1,360)
	asteroids[makerocks].speed=random(1,3)
	
	SetObjectPosition(asteroids[makerocks].object,asteroids[makerocks].x,asteroids[makerocks].y,asteroids[makerocks].z)
	
Next makerocks

EndFunction

Function stats()
	
	Print("SCORE:"+str(ship.score))
	Print("DAMAGE:"+str(ship.damage)+"%")
	
EndFunction

 
Function distance(x1#,y1#,z1#,x2#,y2#,z2#)
  
   returndistance#=0
  
   distx#=x1#-x2#
   disty#=y1#-y2#
   distz#=z1#-z2#
   
   returndistance#=Sqrt(distx#*distx#+disty#*disty#+distz#*distz#)

EndFunction returndistance#

Function makebang(x,y,size#)
	
	if size#>1000 then size#=1000
	size#=1000-size#
	
	if size#<16 then size#=16

	//find a free space
	usethis=findfreebang()
	
	//if it exists
	If usethis<>0
		
		//set the sprites position
		bangit[usethis].x=x-(size#/2)
		bangit[usethis].y=y-(size#/2)
		//make it active
		bangit[usethis].active=1
		//set the sprite playing at 12 frames a second
		PlaySprite(bangit[usethis].sprite,12)
	
		SetSpriteSize(bangit[usethis].sprite,size#,size#)
				
	Endif
	 
EndFunction

 
Function findfreebang()
	
	//find a free explosion
	//this is exactly like the code for finding a player fire space
	//and an alien fire space
	use=0
	
	For find=1 to 40
		if bangit[find].active=0
			use=find
			find=41
		Endif
	Next find
	 
EndFunction use

Function controlbangs()
	
	//now we will take a look at the explosion sprites
	For check=1 to 40
		//as always, if it active
		If bangit[check].active=1
			//move is slightly to the left to match the lands movement
			bangit[check].x=bangit[check].x-1*frameadjust
			//we can use GetSpriteCurrentFrame to find out the current frame it's using
			//we can use GetSpriteFrameCount to find out how many frames it has
			//if GetSpriteCurrentFrame()=GetSpriteFrameCount()
			//we know the sprite has played all of it's frames
			If GetSpriteCurrentFrame(bangit[check].sprite)=GetSpriteFrameCount(bangit[check].sprite)
				//so we make it inactive (and available again)
				//and move it off screen completely
				bangit[check].active=0
				bangit[check].x=-10000
				bangit[check].y=-10000
			EndIf
			//update the sprite position
			SetSpritePosition(bangit[check].sprite,bangit[check].x,bangit[check].y)
		EndIf
		//keeep on checking
	Next check
	
EndFunction
