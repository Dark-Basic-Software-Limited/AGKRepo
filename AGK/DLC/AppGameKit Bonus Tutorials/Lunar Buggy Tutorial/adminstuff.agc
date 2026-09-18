Function resetlevel()
	
	landstart=0
		For maketerrain=1 to 50
			terrain[maketerrain].x=landstart
			terrain[maketerrain].y=656	
			terrain[maketerrain].image=ground
			terrain[maketerrain].active=0
				if maketerrain<19
					terrain[maketerrain].active=1
				endif
			
			SetSpriteImage(terrain[maketerrain].sprite,terrain[maketerrain].image)
			SetSpritePosition(terrain[maketerrain].sprite,terrain[maketerrain].x,terrain[maketerrain].y)
			
			inc landstart,64
			
			Next maketerrain
			
			player.jumpdirection=0
			player.jumping=0
	
EndFunction

Function stats()
	
	//we've kept this simple
	//so we'll just change text objects 1 and 2 
	//to contain the current score and lives
	//having this information in it's only function allows us
	//to add a lot of other information and keep track of it.
	SetTextString(1,"SCORE:"+str(player.score))
	SetTextString(2,"LIVES:"+str(player.lives))
	
EndFunction

Function mainmenu()
	
	SetTextVisible(3,1)
	SetTextVisible(4,1)
	SetTextVisible(2,0)
	SetTextVisible(1,0)
	
	Do
		
		
	If GetMusicPlayingOgg(music)=0
		PlayMusicOgg(music)
	EndIf

	frameadjust=60*GetFrameTime()
	currenttime=GetMilliseconds()
	
	
	if random(1,1000)>990
		spawnalienship()
	endif
	
	movealienships()
	
	If GetRawKeyState(13)
		exit
	EndIf
	
	sync()
	
	Loop
	
	SetTextVisible(3,0)
	SetTextVisible(4,0)
	SetTextVisible(2,1)
	SetTextVisible(1,1)
	
	player.lives=3
	player.x=300
	player.y=600
	player.lives=3
	player.score=0
	
	for stopit=1 to 40
		afire[stopit].active=0
		SetSpritePosition(afire[Stopit].sprite,-10000,-10000)
		If stopit<21
			aliens[stopit].active=0
			SetSpritePosition(aliens[stopit].sprite,-10000,-10000)
		endif
	next stopit
	
	resetlevel()
	
	
EndFunction

