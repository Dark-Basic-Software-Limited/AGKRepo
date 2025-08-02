
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
do
    
	 //Now let's look at another kind of loop
    //The For - Next loop isn't conditional 
    //This will run through the numbers specified, in this case 1 to 2
    For checkbothbats=1 to 2
	//pass the value that the loop is currently at to controlbats()
	controlbats(checkbothbats)
	//the next commands, updates the loop, and if it hasn't reached its target it will run
	//all the commands between the For and related Next
    Next checkbothbats
    
    Print( ScreenFPS() )
    Sync()
loop

//We pass the number of the bat we want to control to this function
//Which is an example of local variable, and only applies to this Function, if you tried to find out it's value outside of this Function
//You'll receive an error.

Function controlbats(which)
	
	//let's make sure that we only use bats that exist
	//We will be using a series of If - EndIF loops here
	//If is a conditional statement, and is either True or False.
	//When the True/False test is passed any code between the If and the EndIf will be run
	
	//Is the value of which (our local variable) equal 1 or 2 (our only possible bats)
	
	If which=1 or which=2
		//is the bat controlled by the player. Remember we set player[?].computer to 0 if it is
		//If it is, then run this If-Endif loop
		if player[which].computer=0
			//Let's use the arrow keys on the keyboard to move the player up and down
			//We can read the keyboard using a special command for devices with a 				//keyboard called GetRawKeyState(?) - We replace the ? with the scancode of 			//the key we want to read.	
			//if the up arrow (scancode 38) is pressed
			If GetRawKeyState(38)=1
				//decrease the Y (vertical) value of the bat, that is up the screen
				dec player[which].y,player[which].speed
				//mark the player as last having move negatively (up the screen)
				player[which].lastmove=-2
				//We'll record the time it happened here
				player[which].lastmovetime=GetMilliSeconds()
			Endif
			
			//if the down arrow (scancode 40) is pressed
			If GetRawKeyState(40)=1
				//increase the Y (vertical) value of the bat, that is down the screen
				inc player[which].y,player[which].speed
				//mark the player as last having move possitively (down the screen)
				player[which].lastmove=2
				//We'll record the time it happened here
				player[which].lastmovetime=GetMilliSeconds()
			Endif
			
		endif
		
		//is the bat controlled by the computer? Remember we set player[?].computer to 1
		// if it is then run this If-Endif loop
		if player[which].computer=1
		endif
		
		//now lets' make sure that the bat can't leave the screen
		
		//If player[?].y is less than 8,
		If player[which].y<8 
			//set it to 8
			player[which].y=8
		endif
		
		//If player[?].y is greater than 632
		If player[which].y>632
			//set it to 632
			player[which].y=632
		endif
		
		//now let's update the actual sprite postion with it's new cordinated
		SetSpritePosition(player[which].sprite,player[which].x,player[which].y)

		//So we can calculate some bounce from the bat a little later,
		//We'll check how long ago it was since the bat moved
		//If it's more than half a second ago, let's forget the bat moved.
		if GetMilliseconds()-player[which].lastmovetime>500
			player[which].lastmove=0
		endif
		
	Endif
	
EndFunction
