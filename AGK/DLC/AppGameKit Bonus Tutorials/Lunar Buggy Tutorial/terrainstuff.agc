


Function checkterrainhit(movefire)
	
	//run through the terrain
	For checkhit=1 to 50
		//has the bullet sprite (movefire) hit a rock?
		If terrain[checkhit].active=1 and terrain[checkhit].image=rock
			If GetSpriteCollision(terrain[checkhit].sprite,pfire[movefire].sprite)
				//if so, make the terrain (rock) inactive,
				terrain[checkhit].active=0
				//make an explosion
				makebang(terrain[checkhit].x,terrain[checkhit].y,2)
				//increase the player score
				inc player.score,50
				//move the rock off screen
				SetSpritePosition(terrain[checkhit].sprite,-10000,-10000)
				//make the player bullet inactive
				pfire[movefire].active=0
				//move it offscreen
				SetSpritePosition(pfire[movefire].sprite,-1000,-1000)
			Endif
		EndIf
		//keep checking if needed
	Next checkhit
	
EndFunction

Function drawterrain()
	
	//run through all the terrain pieces
	For moveterrain=1 to 50
		//if one is active
		if terrain[moveterrain].active=1
			//move it to the left
			Dec terrain[moveterrain].x,4*frameadjust
			//set it's new position
				SetSpritePosition(terrain[moveterrain].sprite,terrain[moveterrain].x,terrain[moveterrain].y)
				//has it left the screen
					If terrain[moveterrain].x<-64
						//if so make it inactive
						terrain[moveterrain].active=0
						//and make a new piece of terrain off the right hand side of the screen
						maketerrain()
					Endif
		EndIf
		//keep checking
	Next moveterrain
	
EndFunction

Function maketerrain()
	
	//find a space
	space=findspare()
	
	//if there is a free space, which there always should be
	If space<>0
		//make it active
		terrain[space].active=1
		//set it off screen to the right
		terrain[space].x=1084
		terrain[space].y=656
		//make it solid ground for now
		terrain[space].image=ground
		//set the image
		SetSpriteImage(terrain[space].sprite,terrain[space].image)
		
		If random(1,100)>95
			//5% change we'll change it to a crater
			terrain[space].image=hole
			//set the image
			SetSpriteImage(terrain[space].sprite,terrain[space].image)
		Endif
		
		If random(1,100)>95 and terrain[space].image=ground
			//further 5% chance of making
			//a rock, but only over solid terrain
			space=findspare()
			terrain[space].active=1
			//rocks appear higher than the terrain
			terrain[space].x=1084
			terrain[space].y=600
			//set the image
			terrain[space].image=rock
			SetSpriteImage(terrain[space].sprite,terrain[space].image)
				
		Endif

			
	Endif
			
EndFunction

Function findspare()
	
	//this rountine works exactly like the findfreealienfire() 
	//function found in alienstuff.agc
	//refer to the comments there if need be
	space=0
	
	For search=1 to 50
		if terrain[search].active=0
			space=search
			search=51
		EndIf
	Next search
	
EndFunction space

Function moveterrain()
	
	//we have a backdrop that move slower
	//in the background
	//take a look at the image in the media folder
	//it is mirrored half way across the image
	//at 1280 pixels in
	//this allow us to appear to have
	//a seemless continious scrolling 
	//background by repositioning the image back to 0
	//at the point where there is an exact overlap
	
	//move the background
	dec backgroundx,1*frameadjust
	
	//as mentioned above, reset if the background is at point -1280
	//halfway through the image
	If backgroundx=-1280
		backgroundx=0
	EndIf
	
	//set the background position to it's new cordinate.s
	SetSpritePosition(background3,backgroundx,410)
	
	//reward the player for making progress.
	inc player.score,1
	
EndFunction
