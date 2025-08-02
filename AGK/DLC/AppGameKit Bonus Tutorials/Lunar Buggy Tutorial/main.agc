
// Project: moon patrol 
// Created: 2017-06-12

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "moon patrol" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//this is where we link to our other files
//this one contains all of our player code, such as displaying the player, moving them,
//shooting and controlling bullets, etc
#include "playerstuff.agc"
//next we will link to everything terrain related, including building and moving the terrain
#include "terrainstuff.agc"
//now we'll link to all the functions that control alien things, moving, shooting etc,
#include "alienstuff.agc"
//the next set of functions we'll link to is all explosions, player and aliens
#include "explosionstuff.agc"
//the last set to link to controls what we'll call admin, this include the main menu, updating scores, etc.
#include "adminstuff.agc"

//ok, now on with the show

//as normal let's set up some types. First for the player

	
Type moonbuggy
	
	//the buggy's positionw will be stored here
	x as float
	y as float
	//store the player sprite number here
	sprite as integer
	lives as integer
	//we'll store our wheel sprites here
	wheel1 as integer
	wheel2 as integer
	wheel3 as integer
	//the wheels will turn
	wheelangle as integer
	//the buggy can jump
	jumping as integer
	//up or down
	jumpdirection as integer
	//score
	score as integer
	//
	dead as integer
	//
	deadtime as integer
	
EndType

//let's set up the global variable for the player
//using the types set out in moonbuggy
Global player as moonbuggy

//we'll use sprite 100 for the player
player.sprite=100
//load in the image
LoadImage(player.sprite,"buggy.png")
// and create the sprite
CreateSprite(player.sprite,player.sprite)
//set up the variables that will hold the player position
player.x=300
player.y=600
//and give the player 3 lives
player.lives=3

//we will also need 3 wheels.
//Let's make those.
player.wheel1=150
player.wheel2=151
player.wheel3=152

//load the image
LoadImage(player.wheel1,"wheel.png")

//we can use a loop for this
For makewheels=player.wheel1 to player.wheel3
	//create the sprites
	CreateSprite(makewheels,player.wheel1)
	//set the shape to polygon collision
	SetSpriteShape(makewheels,3)
Next makewheels

//We'll also load is some media for debris for our explosion
//We've numbered this 153-158 as we'll be applying physics to the debris and the wheels.

//we'll use another loop
For debris=1 to 5
	//our debris is called, debris1, debris2, etc
	//we can use a string for this
	//if you recall, STR() converts a numberic value into a string
	a$="debris"+str(debris)+".png"
	//load the image
	loadimage(152+debris,a$)
	//create the sprite
	createsprite(152+debris,152+debris)
	//set the sprites off screen for a nice tidy display
	SetSpritePosition(152+debris,-10000,-1000)
	//end the loop
Next debris

//we're going to need some terrain,
//so, let's set up a type

Type land
	
	x as float
	y as float
	sprite as integer
	image as integer
	active as integer
	
EndType

//this is where we'll load in all the other images we'll need
//and create the sprites
//if you've followed the tutorial closely, you should understand what we've done here,
global ground=104
global hole=105
global rock=106
global background1=107
global background2=108
global background3=109
global backgroundleft=110
global backgroundright=111
Global playerfireimage=112
global ufo=113
global alienfire=114
global dust=115
global shipbang=116
global rockbang=117

loadimage(ground,"terrain.png")
loadimage(hole,"hole.png")
loadimage(rock,"rock.png")

loadimage(background1,"background1.png")
Createsprite(background1,background1)
SetSpritePosition(background1,0,0)
SetSpriteDepth(background1,14)

loadimage(background2,"background2.png")
Createsprite(background2,background2)
SetSpritePosition(background2,0,360)
SetSpriteDepth(background2,12)

global backgroundx=0

loadimage(background3,"background3.png")
Createsprite(background3,background3)
SetSpritePosition(background3,0,410)
SetSpriteDepth(background3,11)

//we're going to need a store the terrain in
//so let's make an ARRAY, using the type "land"
Dim terrain[50] as land

//make some terrain
landstart=0

//we'll make some terrain here to start with
//the first 50 pieces of terrain will be flat.
//so will use the "ground" image

For maketerrain=1 to 50
	terrain[maketerrain].sprite=maketerrain+299
	CreateSprite(terrain[maketerrain].sprite,ground)
	//notice that we've set physics for the terrain so our
	//smashed lunar buggy can bounce off it.
	//we don't need to worry about complex shape and are treating 
	//the sprite physics as static as we don't want the ground
	//bouncing around.
	SetSpritePhysicsOn(terrain[maketerrain].sprite,1)
	//do the usual when setting the land position, etc
	terrain[maketerrain].x=landstart
	terrain[maketerrain].y=656	
	terrain[maketerrain].image=ground
	//we're only interested in making the the first 19 active
	//as after that we'll be generating new terrain
	if maketerrain<19
	terrain[maketerrain].active=1
	endif
	SetSpritePosition(terrain[maketerrain].sprite,terrain[maketerrain].x,terrain[maketerrain].y)
	//the terrain pieces need to be 64 pixels apart.
	inc landstart,64
Next maketerrain

//we will need the player to fire some bullets.
//once again, this should make sense to you if you've followed the tutorials
//again, if not, please re-read the previous tutorials
Type playerfire
	
	x as float
	y as float
	sprite as integer
	active as integer
	direction as integer
	
EndType

Dim pfire[40] as playerfire

LoadImage(playerfireimage,"pfire.png")

For makefire=1 to 40
	pfire[makefire].sprite=makefire+399
	CreateSprite(pfire[makefire].sprite,playerfireimage)
	//remember to set up the sprites animation frames
	SetSpriteAnimation(pfire[makefire].sprite,25,25,5)
	//and play it so we can see it animated
	PlaySprite(pfire[makefire].sprite)
	//once again, we'll place it off screen so the sprite is hidden.
	SetSpritePosition(pfire[makefire].sprite,-10000,-10000)
Next makefire

Global playerlastfire=0

//okay, now let's make some aliens to shoot.
//this again, should be familar to you so we'll
//spare you a repeat of the details
Type alientype
	x as float
	y as float
	active as integer
	sprite as integer
	direction as integer
	angle as integer
	speed as integer
EndType

dim aliens[20] as alientype

//Let's load our image that all the aliens will share
LoadImage(ufo,"ufo.png")

//now we create our aliens, using sprites 500 - 520
For makealiens=1 to 20
	aliens[makealiens].sprite=makealiens+499
	CreateSprite(aliens[makealiens].sprite,ufo)
	SetSpritePosition(aliens[makealiens].sprite,-10000,-1000)
Next makealiens

//the aliens can shoot as well, so we'll need some aliens bullets
//this is very similar to the player fire system
//but has 2 new variables, DX and DY. This is because
//the aliens fire at the players last know position when firing
//and these will hold the precalculated movement need for the bullets
//to arrive at that point,
Type alienfire
	x as float
	y as float
	dx as float
	dy as float
	active as integer
	sprite as integer
	speed as integer	
EndType

//set the ARRAY and make the bullets.
Dim afire[40] as alienfire

for makealienfiresprites=1 to 40
	afire[makealienfiresprites].sprite=makealienfiresprites+599
	createsprite(afire[makealienfiresprites].sprite,playerfireimage)
	SetSpriteAnimation(afire[makealienfiresprites].sprite,25,25,5)
	SetSpriteSize(afire[makealienfiresprites].sprite,48,48)
	PlaySprite(afire[makealienfiresprites].sprite)
	SetSpritePosition(afire[makealienfiresprites].sprite,-10000,-10000)
next makealienfiresprites

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

//load some images for them
loadimage(dust,"dust.png")
loadimage(rockbang,"rockbang.png")
loadimage(shipbang,"shipbang.png")

//and make the sprites
For makebang=1 to 40
	bangit[makebang].sprite=makebang+699
	createsprite(bangit[makebang].sprite,dust)
	SetSpritePosition(bangit[makebang].sprite,-10000,-10000)
Next makebang

//we will be using a timer system to ensure smooth movement
global currenttime=0
global frameadjust as float

//the next thing to do is load some sounds
//we will let the system decide on the numbers
//using this method each sound will be give the next free number

//all of the sounds are available in the AppGameKit sound library
//DLC pack available on Steam.

//The music is taken from the official SpaceShooter demo included with AppGameKit

Global shipsound:shipsound=loadsound("shipsound.wav")
Global rocksound:rocksound=loadsound("rocksound.wav")
Global dustsound:dustsound=loadsound("dustsound.wav")
Global alienzap:alienzap=loadsound("alienzap.wav")
Global playerzap:playerzap=loadsound("playerzap.wav")

Global music:music=LoadMusicOgg("track1.ogg")

//lastly, we need some text objects for score, lives and title text
//there shouldn't be anything here that we've not already covered, but as before,
//if you don't understand anything, don't be afraid to reference the earlier
//tutorials

CreateText(1,"")
SetTextSize(1,64)
SetTextPosition(1,48,16)

CreateText(2,"")
SetTextSize(2,64)
SetTextPosition(2,440,16)

CreateText(3,"LUNAR BUGGY")
SetTextSize(3,96)
SetTextPosition(3,240,32)

CreateText(4,"Press ENTER")
SetTextSize(4,72)
SetTextPosition(4,340,400)

//we'll display the player to start things off
//this is part of the playerstuff.agc
displayplayer()

//and call the main menu
//this is part of adminstuff.agc
mainmenu()

do
	
	//if our background music has stopped playing
	//start it up again
	If GetMusicPlayingOgg(music)=0
		PlayMusicOgg(music)
	EndIf

//set frame adjust to 60 * by the time it took to draw the last frame
//this will produce a value we can multiple all movement by to ensure
//the appearance of smooth movement
	frameadjust=60*GetFrameTime()
	//we store the current time as a performance saver
	//calling GetMilliseconds() using quite a lot of processing power
	//and as we rarely need 100% millisecond accuracy, a single call a frame
	//is enough
	currenttime=GetMilliseconds()
    
  //if the player isn't dead, 
  //let's play the game
	if player.dead=0
	//update the terrain
    drawterrain()
    //get some input from the player
    //and handle it if required
    controlplayer()
    //move the player around
    moveplayer()
    //display the player by drawing the buggy and wheels again
    displayplayer()
    //move the terrain
    moveterrain()
    
    //we'll spawn the alien ships sparingly
    //however we could change this number
	//to have more or less ships, the higher the number, the fewer ships
		If random(1,1000)>990
			spawnalienship()
		Endif
	
    Endif
    
    //if the player is dead
    If player.dead<>0
		//and has been dead for more than 4 seconds (or 4000 milliseconds)
		If currenttime-player.deadtime>4000
			//hide the buggy parts and all the wheels
			For move=150 to 157
				SetSpritePosition(move,-10000,-10000)
				//and turn of the physics for now
				SetSpritePhysicsOff(move)
			Next move
			//make the player alive again
			//reset the buggy position
			player.dead=0
			player.x=300
			player.y=600
			//and reset the level
			//part of adminstuff.agc
			resetlevel()
			
			//if the player has run out of lives.
			//we'll just go back to the main menu
			if player.lives=0
				//part of adminstuff.agc
				mainmenu()
			Endif
		Endif
	EndIf
    
    //regardless of wether the player is alive or dead
    //we'll need to keep moving the player bullets
    //part of playerstuff.agc
    movefire()
    //move the alien ships
    //part of alienstuff.agc
    movealienships()
    //move the alien bullets
    //part of alienstuff.agc
    movealienfire()
    //check on our explosions
    //part of explosionstuff.agc
    controlbangs()
    // and display our score and lives.
    // part of adminstuff.agc
    stats()
    
    
    //draw everything from the backbuffer to the frontbuffer (the screen)
    Sync()
    //and do it all again
loop



