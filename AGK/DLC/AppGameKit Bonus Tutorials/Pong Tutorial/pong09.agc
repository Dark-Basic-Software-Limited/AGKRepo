
// Project: pong 
// An AppGameKit tutorial
// Created: 2017-04-04

// Show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "pong" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // Allow the user to resize the window

// Set display properties
SetVirtualResolution( 1024, 768 ) // Doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // Allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // Use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // Since version 2.0.22 we can use nicer default fonts


// Well set up our variables here
Type playerinfo
	// This will store the x and y position of the bat on our screen, we'll use floats for more 		//Accurate positioning.
	x as float
	y as float
	// Store the number of sprite will we be using
	sprite as integer
	// We'll also be allowing the speed to be changed.
	speed as float
	// And for coding reasons we'll need to know the direction the bat last moved in
	lastmove as integer
	// We're going to need to know how long it was since the last move
	lastmovetime as integer
	// As we may not have anyone to play with let's allow for a player to be the computer
	computer as integer
	// Finallly, we'll need a score
	score as integer	
EndType

Type ballinfo
	x as float
	y as float
	sprite as float
	speed as float
	// These two are slightly different as they will control which direction the ball is moving in
	movex as float
	movey as float
EndType

// Notice how we can create custom variables for normal variables as well as arrays?
Global ball as ballinfo
// Well use sprite and image 2 for the ball. Sprites and Images can share the same value.
ball.sprite=2
LoadImage(ball.sprite,"ball.png")
CreateSprite(ball.sprite,ball.sprite)
// Set it's position
ball.x=512
ball.y=340
// Set the ball sprite at x and y
SetSpritePosition(ball.sprite,ball.x,ball.y)
// Set it's movement direction
// No up or down movement for now
ball.movey=0
// We introduce another useful command here, RandomSign has a 50/50 chance of creating a //negative version of the number
// In the brackets, in this case it will either produce -1 or 1.
// This will create a 50/50 chance of the ball being moved left or right at first
ball.movex=RandomSign(1)
// Lastly let's have some speedy movement
ball.speed=4


// This is the last of the variables we'll be looking at today, the array, a very powerful way of //referencing multiple values.
// In this case 2, one of each of the players.

Dim player[2] as playerinfo

Global playerimage=1 
// We're defining a global variable which we'll use to reference our bat image, 		
// you don't need to do this, but most coder find words easier to remember than numbers.
// Load the image from our media folder, assigning it to the image number defined by playerimage 
// (in this case 1)
LoadImage(playerimage,"bat.png")

// Now to give some values to our array, let's start with player one, who will store their 
// Information in slot 1 of the array.
// These x and y positions will place player one 64 pixel in from the left hand side and in the
// Middle of the screen vertically.
player[1].x=64
player[1].y=320
// We will be using sprite 10 for the players bat
player[1].sprite=10
// Let's set a speed of 8 (this will move the bat 8 pixels at a time)
player[1].speed=8
// Last move is already 0, as all new variables are set to a value of 0. We're simply doing it again
// To demonstrate adding values
player[1].lastmove=0
// Is the player run by the computer? In this case a value of 0 says it is controlled by the player.
player[1].computer=0
// Let's also set the score to 0
player[1].score=0
// Lastly let's actually make a sprite for the player bat and position it at position player[1].x,player[1].y
CreateSprite(player[1].sprite,playerimage)
// Let's place it.
SetSpritePosition(player[1].sprite,player[1].x,player[1].y)

// And now let's do the same for player 2
player[2].x=916 // 64 pixels + the width of the image, which we know to be 44 pixels, in from the right of the screen.
player[2].y=320
// We will be using sprite 11 for the players bat
player[2].sprite=11
// Let's set a speed of 8 (this will move the bat 8 pixels at a time)
player[2].speed=8
// Last move is already 0, as all new variables are set to a value of 0. We're simply doing it again to
// demonstrate adding values
player[2].lastmove=0
// Is the player run by the computer? In this case a value of 1 says it is controlled by the computer.
player[2].computer=1
// Let's also set the score to 0
player[2].score=0
// Lastly let's actually make a sprite for the player bat and position it at position player[2].x,player[2].y

CreateSprite(player[2].sprite,playerimage)
// Now player 2 needs to have the bat facing the other way, and we've got a great command for this.
SetSpriteFlip(player[2].sprite,1,0)
// Let's place it.
SetSpritePosition(player[2].sprite,player[2].x,player[2].y)

//Let's make a background.
global background=3
loadimage(background,"background.png")
createsprite(background,background)
// This is another new command. Sprites can have layer, the higher the depth, the
//further back a sprite will be drawn. 100 will draw the sprite in behind other sprites.
SetSpriteDepth(background,100)

// Let's create a text object that will display the score.
CreateText(1,"0")
// Just like sprites, we can assign it a screen position
SetTextPosition(1,70,40)
// We want this text to be quite large, so we'll give it a size of 80
SetTextSize(1,80)
// Let's do it all again for a second object.
CreateText(2,"0")
SetTextPosition(2,920,40)
SetTextSize(2,80)
do
    
       // Now let's look at another kind of loop
    // The For - Next loop isn't conditional 
    // This will run through the numbers specified, in this case 1 to 2
    For checkbothbats=1 to 2
	// Pass the value that the loop is currently at to controlbats()
	controlbats(checkbothbats)
	// The next commands, updates the loop, and if it hasn't reached its target it will run
	// All the commands between the For and related Next
    Next checkbothbats
	
    Print( ScreenFPS() )
    
    // Let's more the ball
	moveball()
	// Update score
	score()

	
    Sync()
loop

//We pass the number of the bat we want to control to this function
//Which is an example of local variable, and only applies to this Function, if you tried to find out it's // value outside of this Function
//You'll receive an error.

Function controlbats(which)
	
	// Let's make sure that we only use bats that exist
	// We will be using a series of If - EndIF loops here
	// If is a conditional statement, and is either True or False.
	// When the True/False test is passed any code between the If and the EndIf will be run
	
	// Is the value of which (our local variable) equal 1 or 2 (our only possible bats)
	
	If which=1 or which=2
		// Is the bat controlled by the player. Remember we set player[?].computer to 0 if it is
		// If it is, then run this If-Endif loop
		if player[which].computer=0
			// Let's use the arrow keys on the keyboard to move the player up and down
			// We can read the keyboard using a special command for devices with a 				// keyboard called GetRawKeyState(?) - We replace the ? with the scancode 			// of the key we want to read.	
			// If the up arrow (scancode 38) is pressed
			If GetRawKeyState(38)=1
				// Decrease the Y (vertical) value of the bat, that is up the screen
				dec player[which].y,player[which].speed
				// Mark the player as last having move negatively (up the screen)
				player[which].lastmove=-2
				// We'll record the time it happened here
				player[which].lastmovetime=GetMilliSeconds()
			Endif
			
			// If the down arrow (scancode 40) is pressed
			If GetRawKeyState(40)=1
				// Increase the Y (vertical) value of the bat, that is down the screen
				inc player[which].y,player[which].speed
				// Mark the player as last having move possitively (down the screen)
				player[which].lastmove=2
				// We'll record the time it happened here
				player[which].lastmovetime=GetMilliSeconds()
			Endif
			
		endif
		
		// Is the bat controlled by the computer? Remember we set player[?].computer to 1
		// If it is then run this If-Endif loop
		if player[which].computer=1
			// If its the computer, call the computermove(?) Function.
			// The code will return here afterwards.
			computermove(which)
		endif
		
		// Now lets' make sure that the bat can't leave the screen
		
		// If player[?].y is less than 8,
		If player[which].y<8 
			// Set it to 8
			player[which].y=8
		Endif
		
		// If player[?].y is greater than 632
		If player[which].y>632
			// Set it to 632
			player[which].y=632
		Endif
		
		// Now let's update the actual sprite postion with it's new cordinated
		SetSpritePosition(player[which].sprite,player[which].x,player[which].y)

		// So we can calculate some bounce from the bat a little later,
		// We'll check how long ago it was since the bat moved
		// If it's more than half a second ago, let's forget the bat moved.
		If GetMilliseconds()-player[which].lastmovetime>500
			player[which].lastmove=0
		Endif
		
		// Time to look at some collisions.
		// We'll compare each bat to see if it's hit the ball
		// GetSpriteCollision will return 0 if the two sprites have not collided
		// and 1 if they have.
		If GetSpriteCollision(player[which].sprite,ball.sprite)=1
			// By seeying ball.movex to a negative of it's own value, we effectively reverse it's 		// direction
			ball.movex=-ball.movex
			// Now let's see if the bat was moving, we're simulate a little physics here
			If player[which].lastmove<>0
				ball.movey=player[which].lastmove
			Endif
		Endif

		
	Endif
	
EndFunction

Function moveball()
	
	// Add the value of ball.movex and ball.movey to the balls position
	// We multiply it by the balls speed so it moves quickly
	// Remember we can change the speed of the ball.
	ball.x=ball.x+ball.movex*ball.speed
	ball.y=ball.y+ball.movey*ball.speed
	// Now let's update the position of the ball sprite.
	SetSpritePosition(ball.sprite,ball.x,ball.y)
	
	// We also need to see if the ball has bounced of the side of the screen by checking the ball's Y 
	// position. We can do this easily by checking if it's near the edge
	// and we only need to reverse it's Y move just as we did with
	// the X move just know
	
	if ball.y<8 or ball.y>740
		ball.movey=-ball.movey
	endif

	
EndFunction

Function computermove(which)
	
	// All we're doing here is tracking the ball
	// We'll do this by comparing the bat position Y (vertical) with the ball Y (Vertical)
	
	// If the player bat below the ball (greater than)
	If player[which].y>ball.y
		// Decrease the Y (vertical) value of the bat, that is up the screen
		Dec player[which].y,player[which].speed
		// Mark the player as last having move negatively (up the screen)
		player[which].lastmove=-2
		// We'll record the time it happened here
		player[which].lastmovetime=GetMilliSeconds()
	Endif
	
	// If the player bat above the ball (less than)
	If player[which].y<ball.y
		// Increase the Y (vertical) value of the bat, that is down the screen
		Inc player[which].y,player[which].speed
		// Mark the player as last having move possitively (down the screen)
		player[which].lastmove=2
		// We'll record the time it happened here
		player[which].lastmovetime=GetMilliSeconds()
	Endif
	
	// Let's see if someone has won a point.
	// We've check the balls position to see if it's offscreen.
	// We'll also make a local variable to see if we need to reset the ball.
	
	// We're also keeping the comments limited here, see if you can work it out.
	
	Local hasballleft=0
	
	If ball.x>1056
		hasballleft=1
		inc player[1].score,1
	Endif
	
	If ball.x<-32
		hasballleft=1
		inc player[2].score,1
	Endif

	// We need to know if a player has won
	// This happens when one player reaches 10
	// So, let's check for that.
	If player[1].score=10 or player[2].score=10
		// Reset everthing, effectively reseting the game
		hasballleft=1
		player[1].score=0
		player[2].score=0
	Endif


	// We'll also need to reset the ball postion if it's left the screen.
	if hasballleft=1
		//Set it's position
		ball.x=512
		ball.y=340
		//Set the ball sprite at x and y
		SetSpritePosition(ball.sprite,ball.x,ball.y)
		//Set it's movement direction
		ball.movex=RandomSign(1)
		// No up or downmovement for now
		ball.movey=0
	endif

		
Endfunction

Function score()
	
	//You might be wondering what kind of variable this is.
	//Well, it's a String variable. We can simply add the symbol $ to the end of a variable to
	//create a String.
	Local change$
	//Not let's assign the score to it, using Str to convert the numeric score to a string.
	change$=str(player[1].score)
	//Finally let's alter the text to contain the new string.
	SetTextString(1,change$)
	//Let's do it again for the text object 2.
	change$=str(player[2].score)
	SetTextString(2,change$)
	
EndFunction
