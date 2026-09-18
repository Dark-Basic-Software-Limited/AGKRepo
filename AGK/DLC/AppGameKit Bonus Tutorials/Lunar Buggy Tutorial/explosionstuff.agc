

Function explodebuggy()
	
	//if the player has died (i.e. this function has been called)
	//reduce the number of player lives.
	dec player.lives,1
	//flag the player as dead
	player.dead=1
	//move the player sprite off screen
	SetSpritePosition(player.sprite,-10000,-1000)
	
	//now we work some illusionary magic
	tempx=player.x
	//we have some broken pieces that look just like
	//the buggy when placed next to each other
	//like a jigsaw
	//Note: we are running this loop backwards, and we use
	//the new command STEP -1 to indicate we will jump backwards.
	//You can sue the STEP command to skip through a FOR - NEXT
	//at any speed and in both directions
		For placedebris=157 to 153 step-1
		//we grab the sprites width for the 
		//debris piece
		tempwidth=GetSpriteWidth(placedebris)
		//set it's position
		SetSpritePosition(placedebris,tempx,player.y)
		//then move the sprite position along by it's
		//width, so each sprite is correctly placed
		//next to each other
		Inc tempx,tempwidth
		//finish the loop
	Next placedebris
	
	//we'll run through each debris sprite
	For bang=150 to 157
		//and turn phyiscs on 
		//in this case we are using dynamic physics (2), the most
		//common setting for natural physics objects
		SetSpritePhysicsOn(bang,2)
		//give it some force
		SetSpritePhysicsAngularImpulse(bang,random(800,1000))
		//if it's a wheel...
		If bang<player.wheel3+1
		//allow it to bounce
		SetSpritePhysicsRestitution(bang,1)
		//and let it rotate
		SetSpritePhysicsCanRotate(bang,1)
		//and of course, give it some force
		SetSpritePhysicsAngularImpulse(bang,random(3500,6000))
		
		Endif
		//keep going
	Next bang	
	
	//set the time the player died
	//they will be dead for 4000 milliseconds before
	//the game resets,
	//see the main.agc code 
	player.deadtime=currenttime
	
EndFunction



Function makebang(x,y,whichtype)
	
	//find a free space
	usethis=findfreebang()
	
	//if it exists
	If usethis<>0
		
		//set the sprites position
		bangit[usethis].x=x
		bangit[usethis].y=y
		//make it active
		bangit[usethis].active=1
		
		//run through the different types of explosions
		//1 = dust (when an alien bullet hits the terrain)
		//2 = a flash, for when a rock explodes
		//3 = an explosion for when an alien ship is destroyed.
		Select whichtype
			
			//dust
			Case 1
				//set the sprite image
				SetSpriteImage(bangit[usethis].sprite,dust)
				//set the animation frame
				//the dust sprite frame is
				//24 wide, 24 high and has 12 frames.
				SetSpriteAnimation(bangit[usethis].sprite,24,24,12)
				//set the sprite playing at 30 frame a second
				PlaySprite(bangit[usethis].sprite,30)
				PlaySound(dustsound)
			EndCase
			
			//rock
			Case 2
				//set the sprite image
				SetSpriteImage(bangit[usethis].sprite,rockbang)
				//set the animation frame
				//the rock explosion sprite frame is
				//64 wide, 64 high and has 6 frames.
				SetSpriteAnimation(bangit[usethis].sprite,64,64,6)
				//set the sprite playing at 12 frames a second
				PlaySprite(bangit[usethis].sprite,12)
				//play the sound for the exploding rock
				PlaySound(rocksound)
			EndCase
			
			//ship
			Case 3
				//set the sprite image
				SetSpriteImage(bangit[usethis].sprite,shipbang)
				//set the animation frame
				//the ship explosion is
				//64 sprite wide, 70 pixel hight and has 8 frames
				SetSpriteAnimation(bangit[usethis].sprite,64,70,8)
				//set the sprite playing at 12 frames a second
				PlaySprite(bangit[usethis].sprite,12)
				//play the ship exploding sound
				PlaySound(shipsound)
			EndCase
			
		EndSelect
		
		//as we are changing the sprites image
		//these images can be smaller or larger than the sprite
		//we can change the sprite size to match the image
		//by using a default width and height of -1. This will
		//set the sprite to have the same width and height as the image.
		SetSpriteSize(bangit[usethis].sprite,-1,-1)
				
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
