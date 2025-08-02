
Function displayplayer()
	
	//set the player position
	//you'll recall the command RandomSign(1) from our pong tutorial and if you remember,
	//this takes the number in the () and has a 50 - 50 chance of making it negative.
	SetSpritePosition(player.sprite,player.x+RandomSign(1),player.y+RandomSign(1))
	
	//set the start position of the wheels with a slight random offset.
	wheelposx=player.x+16+RandomSign(1)
	
	//we place the wheels at a slight offset from the Lunar Buggy
	//adding a little randomness to make the buggy appear to rattle around.
	For placewheels=player.wheel1 to player.wheel3
		SetSpriteAngle(placewheels,player.wheelangle)
		SetSpritePosition(placewheels,wheelposx,player.y+(16+RandomSign(1)))
		//move the next wheel up
		inc wheelposx,48
		//finish the loop
	Next placewheels
	
	//inc the wheel angle, 
	//when displaying the wheel we will rotate it to this angle
	//making it appear that the wheels are rotating
	inc player.wheelangle,4
	
	//we also check to see if the wheels have hit an obstacle
	//and obstacle in this case is a piece of terrain that isn't flat ground
	//and is therefore a rock or a crater.
	bang=0
	
	//loop though all 50 possible terrain sprites.
	For collision=1 to 50
		//if the terrain is being used (on screen in this case) and isn't a ground
		//terrain type, check for a collision.
		If terrain[collision].active=1 and terrain[collision].image<>ground		
			//check all 3 wheels
			For checkwheels=player.wheel1 to player.wheel3
			//see if the sprites collide,
			  If GetSpriteCollision(checkwheels,terrain[collision].sprite)
				  //flag that a collision has happened
				  bang=1
				  //jump out of both loops as we don't
				  //need to check anymore.
				  checkwheels=player.wheel3+1
				  collision=51
				EndIf
				//check next wheel
			Next checkwheels
		EndIf
		//check next terrain
	Next collision
	
	//if we've had a collision 
	//and the player isn't dead
	If bang=1 and player.dead=0
		//explode the buggy
		explodebuggy()
	endif
	
EndFunction

Function controlplayer()
	
	//backwards
	//A or left arrow
	If (GetRawKeyState(65) or GetRawKeyState(37)) and player.x>64
		dec player.x,6*frameadjust
	EndIf
	
	//forwards
	//D or right arrow
	If (GetRawKeyState(68) or GetRawKeyState(39)) and player.x<800
		inc player.x,6*frameadjust
	EndIf
	
	//jump
	//enter or up arrow
	If (GetRawKeyState(13) or GetRawKeyState(38)) and player.jumping=0
		player.jumping=1
		player.jumpdirection=-2
	Endif
	
	//fire
	//space or ctrl
	If (GetRawKeyState(32) or GetRawKeyState(17)) and currenttime-playerlastfire>500
		playerlastfire=currenttime
		playsound(playerzap)
		makeplayerfire()
	EndIf


	
EndFunction

Function moveplayer()
	
	//is the player jumping?
	If player.jumping<>0
		//move the buggy in the direction of the jump
		player.y=player.y+player.jumpdirection*frameadjust
		//don't let the buggy go too far up the screen
		//if the buggy is lower that postion 480 on the screen make the 
		//buggy fall
		If player.y<480
			player.jumpdirection=2
		Endif
		
		//if the buggy is higher than position 600, which is where the terrain is
		//stop it jumping as we know it's landed.
		//we also force it's position to be 600 to stop it falling lower
		//than the terrain
		If player.y>=600
			player.y=600
			player.jumping=0
		EndIf
	Endif
	
EndFunction

Function makeplayerfire()
	
	//find a bullet that's not being used.
	spare=0
	
	//we can fire forward and upwards,
	//so we use a loop to create 2 bullets
	//one for each direction
	For loopit=1 to 2
	
		For search=1 to 40
			if pfire[search].active=0
			spare=search
			search=41
			Endif
		Next search
		
		//if we are in the first loop 
		//create the up bullet
		if loopit=1
			pfire[spare].active=1
			pfire[spare].x=player.x+36
			pfire[spare].y=player.y+12
			pfire[spare].direction=1
			//if we're not in the first loop, we must be in the second loop
			//so create the forward bullet.
			else
			pfire[spare].active=1
			pfire[spare].x=player.x+96
			pfire[spare].y=player.y+24
			pfire[spare].direction=2
		Endif
		
		//Set the sprite position
		SetSpritePosition(pfire[spare].sprite,pfire[spare].x,pfire[spare].y)
	
	Next loopit
	
EndFunction

Function movefire()
	
	//now we've created our bullets, let's move them
	//loop through them
	
	For movefire=1 to 40
		//is it active?
		If pfire[movefire].active=1
			
			//direction 1 means the bullet is moving upwards
			If pfire[movefire].direction=1
				dec pfire[movefire].y,6*frameadjust
			EndIf
			
			//direction 2 means the bullet is moving forward
			If pfire[movefire].direction=2
				inc pfire[movefire].x,6*frameadjust
			EndIf
			
			//update the screen position
			SetSpritePosition(pfire[movefire].sprite,pfire[movefire].x,pfire[movefire].y)
			
			//call a special routine to see if our bullet has hit some terrain
			checkterrainhit(movefire)
			
			//we also want to know if it's left the screen
			//if so, make it inactive, so we can use it again
			if pfire[movefire].x>1080 or pfire[movefire].y<-80
				pfire[movefire].active=0
			Endif
			
			//now we check each alien to see if we've shot it down
			For isalienhit=1 to 20
				//but only if it's active
				If aliens[isalienhit].active<>0
					//have the sprites collided
					If GetSpriteCollision(aliens[isalienhit].sprite,pfire[movefire].sprite)
						//if so, make the alien inactive
						aliens[isalienhit].active=0
						//call the special makebang function
						//this will generate 3 different types of explosion
						//1 if the bullet hits the ground
						//2 if it hits a rock
						//3 if it hits a ship
						makebang(aliens[isalienhit].x,aliens[isalienhit].y,3)
						//increase the player score
						inc player.score,100
						//move the alien offscreen
						aliens[isalienhit].x=-10000
						aliens[isalienhit].y=-10000
						SetSpritePosition(aliens[isalienhit].sprite,aliens[isalienhit].x,aliens[isalienhit].y)
						//make the bullet inactive and hide the bullet offscreen
						pfire[movefire].active=0
						SetSpritePosition(pfire[movefire].sprite,-10000,-10000)
						//jump out of the loop
						isalienhit=21
					EndIf
				EndIf
				//carry on with the loop if needed
			Next isalienhit
			
		Endif
		//check the next bullet
	Next movefire
	
EndFunction
