
Function spawnalienship()
	
	//find a free alien
	find=0
	
	//flag it if it's not actice and jump out of the loop
	For findspare=1 to 20
		If aliens[findspare].active=0
			find=findspare
			findspare=21
		Endif
	Next findspare
	
	//let's make the alien
	If find<>0
		//decide which side of the screen it will start from
			aliens[find].direction=RandomSign(1)	
			
			//and set it's X (across position) as approprate.
			If aliens[find].direction=-1
				aliens[find].x=1080
			Endif
		
			If aliens[find].direction=1
				aliens[find].x=-64
			Endif
			//we will place them at a random position
			//it's worth noting that we also used a random angle for the alien
			//as this is used in the alien ships movement.
			aliens[find].y=random(80,200)
			aliens[find].angle=random(0,360)
			SetSpritePosition(aliens[find].sprite,aliens[find].x,aliens[find].y)
			//set it active
			aliens[find].active=1
			//give it a random speed
			aliens[find].speed=random(2,4)
		
	
		//set it on screen
		SetSpritePosition(aliens[find].sprite,aliens[find].x,aliens[find].y)
		
	Endif
	
Endfunction

Function movealienships()
	
	//run through the active aliens
	For movealiens=1 to 20
		If aliens[movealiens].active=1
			
			//increase the aliens angle by it's movement directon
			inc aliens[movealiens].angle,aliens[movealiens].direction
			
			//move the aliens in an arc using a little math.
			//We multiple speed  to give it some variation
			xmove#=sin(aliens[movealiens].angle)*aliens[movealiens].speed
			ymove#=cos(aliens[movealiens].angle)*aliens[movealiens].speed
			
			//update the variable that hold the alien position
			aliens[movealiens].x=aliens[movealiens].x+xmove#*frameadjust
			aliens[movealiens].y=aliens[movealiens].y+ymove#*frameadjust

			//move them left or right depending on direction
			
			aliens[movealiens].x=aliens[movealiens].x+(aliens[movealiens].direction*aliens[movealiens].speed)*frameadjust
			
			//update the screen position
			
			SetSpritePosition(aliens[movealiens].sprite,aliens[movealiens].x,aliens[movealiens].y)
			
			//if the player is still alive
			//there is a small chance the alien will fire at you.
			If random(1,1000)>998 and player.dead=0
				//find the free alien bullet
				usethisone=findfreealienfire()
				//if one is found create the bullet
				If usethisone<>0
					playsound(alienzap)
					setalienfiredest(aliens[movealiens].x+32,aliens[movealiens].y+32,player.x,player.y,usethisone)
				Endif
			EndIf
			
			//if the alien has left the screen, make it inactive, and therefore available for reuse.
			If aliens[movealiens].direction=-1 and aliens[movealiens].x<-120
				aliens[movealiens].active=0
			EndIf
			
			If aliens[movealiens].direction=1 and aliens[movealiens].x>1080
				aliens[movealiens].active=0
			EndIf

			
		Endif
		//keep trying
	Next movealiens
	
EndFunction

Function findfreealienfire()
	
	//this routime finds a free alien bullet and returns it
	// this is similar to the find a free bullet included
	//in the playerstuff.agc which is part of the makeplayerfire() function
	//we've included this as a separate function to demonstrate how
	//a user function can return a value
	use=0
	
	//find the free (inactive) alien bullet
	//store it in use and end the loop
	for find=1 to 40
		if afire[find].active=0
			use=find
			find=41
		endif
	next find
//return the value from the function
EndFunction use

Function setalienfiredest(x1,y1,x,y,number)
	
	//we pass the 'number' of the alien fire we want to use into the function.
	
	//store the starting cordinates
	originalX# = x1
    originalY# = y1

    // work out the destination
    destinationX# = x
    destinationY# = y
    distanceX# = destinationX# - originalX#
    distanceY# = destinationY# - originalY#
    //apply a litte bit of math
    distanceFromAtoB# = sqrt ( ( distanceX# * distanceX# ) + ( distanceY# * distanceY# ) )

	//if the distance isn't 0 (sitting on top of the target, then adjust the movement
    if ( distanceFromAtoB# <> 0.0 )
		//set the alien bullets position and movement required 
		//reach the bullets target position
       afire[number].dx = distanceX# / distanceFromAtoB#
       afire[number].dy = distanceY# / distanceFromAtoB#
       //make the bullet active
       afire[number].active=1
       afire[number].x=x1
       afire[number].y=y1
    endif
  
 endfunction
 
 Function movealienfire()
	 
	 //this code is very similar to the code to move the player bullets.
	 For movefire=1 to 40
		 If afire[movefire].active<>0
			 //instead of firing in a set direction as we do for the 
			 //player bullet
			 //we adjust the alien bullet by a pre-calculated amount
			 //we created this in setalienfiredest(x1,y1,x,y,number) 
			 //and will move the bullet towards it's target position
			Inc afire[movefire].x,afire[movefire].dx*6
			Inc afire[movefire].y,afire[movefire].dy*6
			
			//has the bullet exceed 656 down the screen
			//if so we can assume it's hit the terrain 
			//and we will reset the bullet and make some dust
			If afire[movefire].y>656
				afire[movefire].active=0
				makebang(afire[movefire].x,afire[movefire].y,1)
				afire[movefire].x=-10000
				afire[movefire].y=-10000
			Endif
			
			//has it hit the buggy?
			//if so, let's make a bang
			If GetSpriteCollision(afire[movefire].sprite,player.sprite)
				afire[movefire].active=0
				makebang(afire[movefire].x,afire[movefire].y,3)
				explodebuggy()
				afire[movefire].x=-10000
				afire[movefire].y=-10000
			EndIf
			
			SetSpritePosition(afire[movefire].sprite,afire[movefire].x,afire[movefire].y)
			
		 Endif
	 Next movefire
 
 EndFunction
 
