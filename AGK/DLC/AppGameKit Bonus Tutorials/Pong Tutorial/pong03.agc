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

do
    	
    Print( ScreenFPS() )
    Sync()
loop


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
    
	
    Print( ScreenFPS() )
    Sync()
loop
