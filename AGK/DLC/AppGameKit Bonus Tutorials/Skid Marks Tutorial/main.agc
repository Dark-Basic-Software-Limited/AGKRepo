
// Project: Skidding 
// Created: 2017-08-23

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Skid Row" )
SetWindowSize( 1024, 768, 1 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//set up

//let's load a background

global background=50
loadimage(background,"background.png")

//we firstly need to set up a type for the track

type trackpieces
	
	//is the track in use
	active as integer
	//where will it be on screen
	x as float
	y as float
	//what kind of tile is it
	tracktile as integer
	//which sprite will it use.
	sprite as integer

endtype

//set up the sprites each track will use

dim tracks[225] as trackpieces

//special

dim trackscounted[8,225]

//make track sprites
for makesprites=1 to 225
	tracks[makesprites].sprite=makesprites+99
	createsprite(tracks[makesprites].sprite,0)
next makesprites

//we will store all the tracks in an array
//and build the track from there
//this will allow for custom tracks.

//storage array for tracks, 
//we will allow the track a depth of 15 units, (up/down)
//but it has an unlimited length
//for this demo we'll assume 15 as well as you'll see later
dim trackmap[15] as string

definetrackmedia()

`startwhere=setuptrack()

loadsounds()

setuptext()

type race
	x as float
	y as float
	//0 = not used
	//1 = player
	//>1 = ai
	active as integer
	sprite as integer
	image as integer
	speed as float
	angle as integer
	targetangle as integer
	rotatespeed as integer
	drift as float
	lap as integer
	total as integer
	text as integer
	position as integer
	travelled as integer
	warning as integer
	disqualified as integer
	finished as integer
endtype

dim cars[8] as race

//global varibles
//store currentime
global currenttime:currenttime=GetMilliseconds()
//set up somewhere to store a timer to tidy the 
//changes to the speed, otherwise it's too quick
global speedchange=0
//countdown to start
global startin
//has the race started
global raceon=0
//timer movement
Global frameadjust as float

startwhere=setuptrack()

definecarmedia(startwhere)

Global trafficlight=9997
LoadImage(trafficlight,"light.png")
CreateSprite(trafficlight,trafficlight)
SetSpriteAnimation(trafficlight,27.33,64,3)
SetSpriteVisible(trafficlight,0)
SetSpritePosition(trafficlight,700,300)

global speed=9998
LoadImage(speed,"speed.png")
CreateSprite(speed,speed)
SetSpritePosition(speed,8,8)

global needle=9999
LoadImage(needle,"needle.png")
CreateSprite(needle,needle)
SetSpritePosition(needle,8,8)
SetSpriteAngle(needle,180)

_startagain:

mainmenu()

startin=Timer()

do
	
	frameadjust =60*GetFrameTime()
	currenttime=GetMilliseconds()
	
	timeleft=3-round(timer()-startin)
	
	if getsoundinstanceplaying(engineplaying)=0 and timeleft<1
		engineplaying=playsound(engine)
	endif
	
	
	if timeleft=3
		if GetSoundInstancePlaying(startupplaying)=0
		startupplaying=playsound(startup)
		endif
	endif
	
	if timeleft=2
		if GetSoundInstancePlaying(startoffplaying)=0
		startoffplaying=playsound(startoff)
		endif
	endif
	
	If raceon=0 and timeleft>0
		SetSpriteVisible(trafficlight,1)
		SetSpriteFrame(trafficlight,timeleft)
	else
		SetSpriteVisible(trafficlight,0)
	Endif
	
	if timeleft<1
		raceon=1
	Endif
	
	//special for player.
	
	if cars[1].disqualified<>0
		//set all the cars as having finished the race
		For endrace=1 to 8
			cars[endrace].lap=4
		Next endrace
	endif
	
	//check to see if the race is over
	
	isitdone=checkfinalpositions()
	
	//find out how many cars have been disqualified
	
	howmany=8
	
	For countthem=1 to 8
		if cars[countthem].disqualified<>0
			dec howmany,1
		endif
	next countthem
	
	//if all the cars are flagged as finished that are still in the race or the player has finished
	If isitdone>=howmany or cars[1].finished<>0
		//jump back to the main menu
		goto _startagain
	endif
	
  `  Print( ScreenFPS() )
    
    drawtrack()
    //has the race started?
    if raceon=1
    controlcars()
    if isitdone<>8
    controlplayer()
    endif
    
    //find the cars current position
    findposition()
    
    
    endif
    
    
    playerstats()
    
	
    Sync()
loop

function drawtrack()
	
	For draw=1 to 225
		if tracks[draw].active<>0
			SetSpritePosition(tracks[draw].sprite,tracks[draw].x,tracks[draw].y)
		endif
	next draw
	
	//offset from the player car
	
endfunction

Function definetrackmedia()
	
	global track1=1:loadimage(track1,"track1.png")
	global track2=2:loadimage(track2,"track2.png")
	global track3=3:loadimage(track3,"track3.png")
	global track4=4:loadimage(track4,"track4.png")
	global track5=5:loadimage(track5,"track5.png")
	global track6=6:loadimage(track6,"track6.png")
	global track7=7:loadimage(track7,"track7.png")
	global track8=8:loadimage(track8,"track8.png")
	global track9=9:loadimage(track9,"track9.png")
	global track10=10:loadimage(track10,"track4.png")
	global track11=11:loadimage(track11,"track3.png")
	global track12=12:loadimage(track12,"track2.png")
	global track13=13:loadimage(track13,"track1.png")
	global trees=14:loadimage(trees,"trees.png")

	
	`0 = no track
	`0
	`1 = corner left and down
	`A
	`2 = corner right and down
	`B
	`3 = corner right and up
	`C
	`4 = corner left and up
	`D
	`5 = bottom straight
	`E
	`6 = left straight
	`F
	`7 = right straight
	`G
	`8 = top straight
	`H
	`9 = bottom straight, starting grid
	`I
	`10=corner, left and up
	`J
	`11=Cornet, right and up
	`K
	`12=corner, up and left
	`L
	`13=corner up and right
	`M
	`14=Trees
	`N
	
	
	
EndFunction

Function setuptrack()


	trackmap[1] ="N00N0AHHHB000N0"
	trackmap[2] ="00000F00NG00000"
	trackmap[3] ="00000FN00G0N000"
	trackmap[4] ="0AHHHK000JHHHB0"
	trackmap[5] ="0F0000N000000G0"
	trackmap[6] ="0F0N0000000NMC0"
	trackmap[7] ="0FN00000000NG00"
	trackmap[8] ="0FN000000000GN0"
	trackmap[9] ="0F00000000N0JLN"
	trackmap[10]="0FN0000N00000G0"
	trackmap[11]="0F00N0N0N00N0G0"
	trackmap[12]="0DEEEEIEEEEEEC0"
	trackmap[13]="000N0000NNNN000"
	trackmap[14]="00000N0000N0000"
	trackmap[15]="000000000000000"
	
	
	//this is the start position
	startx=0
	starty=0
	startgrid=0
	
	//build map
	for down=1 to 15
	for across=1 to len(trackmap[down])
		what$=mid(trackmap[down],across,1)
		If what$<>"0"
		tracktype=asc(what$)-64
		endif
		
		if what$="0" then tracktype=99
		
		use=findfreetrack()
		if use<>0
			tracks[use].active=tracktype
			if tracktype=99 then tracktype=background
			SetSpriteImage(tracks[use].sprite,tracktype)
			SetSpriteShape(tracks[use].sprite,3)
			SetSpriteSize(tracks[use].sprite,514,514)
			tracks[use].x=startx
			tracks[use].y=starty
			
			
			//if this is the start grid, make a note of it.
			if tracktype=9
				startgrid=use
			endif
			
		endif
		inc startx,512
	next across
		startx=0
		inc starty,512
	next down
	
	
	//once built, set screen focus on start grid.
	
	//find the first active track
	thefirsttrack=0
	for look=1 to 225
		if tracks[look].active<>0
			thefirsttrack=look
			look=226
		endif
	next look
	
	offsetx=0
	offsety=0
	
	//find the difference between the first track tile with something in and the startgrid
	
	
	if thefirsttrack<>0
		if startgrid<>0
			offsetx=256+(tracks[thefirsttrack].x-tracks[startgrid].x)
			offsety=128+(tracks[thefirsttrack].y-tracks[startgrid].y)
		endif

	endif
	
	//offset all active track tiles but that amount
	//plus
	for doit=1 to 225
		if tracks[doit].active<>0
			tracks[doit].x=tracks[doit].x+offsetx
			tracks[doit].y=tracks[doit].y+offsety
			SetSpritePosition(tracks[doit].sprite,tracks[doit].x,tracks[doit].y)
		endif
	next doit
	
Endfunction startgrid

Function findfreetrack()
	
	thisoneisfree=0
	
	for search=1 to 225
		//hide the sprite just in case it's not going to be used.
		SetSpritePosition(tracks[search].sprite,-100000,-10000)
		if tracks[search].active=0
			thisoneisfree=search
			search=226
		endif
	next search
	
Endfunction thisoneisfree

Function definecarmedia(starttrack)
		
global car1=20:loadimage(car1,"car1.png")
global car2=21:loadimage(car2,"car2.png")
global car3=22:loadimage(car3,"car3.png")
global car4=23:loadimage(car4,"car4.png")
global car5=24:loadimage(car5,"car5.png")
global car6=25:loadimage(car6,"car6.png")
global car7=26:loadimage(car7,"car7.png")
global car8=27:loadimage(car8,"car8.png")

for makecars=1 to 8
	cars[makecars].sprite=999+makecars
	cars[makecars].text=999+makecars
	cars[makecars].angle=90
	CreateSprite(cars[makecars].sprite,19+makecars)
	SetSpriteDepth(cars[makecars].sprite,8)
	SetSpriteAngle(cars[makecars].sprite,cars[makecars].angle)
	CreateText(cars[makecars].text,"")
	SetTextSize(cars[makecars].text,24)
	cars[makecars].active=makecars
	cars[makecars].speed=0
	cars[makecars].position=makecars
	
	positioncars(makecars,starttrack)
	
next makecars

EndFunction

Function positioncars(makecars,starttrack)


	
	//set the car positions based on the position of the starting grid.
	select makecars
		
		case 1
			
		x1=tracks[starttrack].x+256
		y1=tracks[starttrack].y+64
	
		endcase
		
		case 2
			
		x1=tracks[starttrack].x+256
		y1=tracks[starttrack].y+160
	
		endcase
		
		case 3
		
		x1=tracks[starttrack].x+256
		y1=tracks[starttrack].y+256
	
	
		endcase
		
		case 4
			
		x1=tracks[starttrack].x+256
		y1=tracks[starttrack].y+352
	
		endcase
		
		case 5
		
		x1=tracks[starttrack].x+128
		y1=tracks[starttrack].y+64
	
	
		endcase
		
		case 6
			
		x1=tracks[starttrack].x+128
		y1=tracks[starttrack].y+160
	
		endcase
		
		case 7
			
		x1=tracks[starttrack].x+128
		y1=tracks[starttrack].y+256
	
	
		endcase
		
		case 8
			
		x1=tracks[starttrack].x+128
		y1=tracks[starttrack].y+352
	
	
		endcase
		
	endselect

	//pass the postion to the x and y variables
	cars[makecars].x=x1
	cars[makecars].y=y1
	//reset the car stats
	cars[makecars].angle=90
	cars[makecars].disqualified=0
	cars[makecars].warning=0
	cars[makecars].travelled=0
	cars[makecars].lap=0
	cars[makecars].position=makecars
	
	//set the cars sprite position
	SetSpritePosition(cars[makecars].sprite,x1,y1)
	//reset angle
	SetSpriteAngle(cars[makecars].sprite,cars[makecars].angle)
	
EndFunction

Function displaypositions()
	
	for whichcar=1 to 8
		for where=1 to 8
			if cars[whichcar].position=where
			SetTextSize(cars[whichcar].text,32)
			a$=GetTextString(cars[whichcar].text)
			b$="Car "+str(whichcar)+" is "+a$
			SetTextString(cars[whichcar].text,b$)
			SetSpritePosition(cars[whichcar].sprite,400,120+(where*48))
			SetSpriteAngle(cars[whichcar].sprite,90)
			SetTextPosition(cars[whichcar].text,500,130+(where*48))
			endif
		next where
	next whichcar
	
EndFunction

Function checkfinalpositions()
	
	istheraceover=0
	
	For checking=1 to 8
		If cars[checking].lap>=3 and cars[checking].finished=0
			cars[checking].finished=cars[checking].position
		endif
	Next checking
	
	//see if all cars have finished
	For count=1 to 8
		if cars[count].finished<>0
			inc istheraceover,1
		endif
	Next count
	
EndFunction istheraceover

Function controlcars()

	for controlcars=1 to 8
		if cars[controlcars].active<>0
			
			counttracks(controlcars)
			
			//if the car hasn't finished, display position next to the car
			If cars[controlcars].finished=0
			SetTextPosition(cars[controlcars].text,cars[controlcars].x+sin(cars[controlcars].angle)*48,cars[controlcars].y+cos(cars[controlcars].angle)*64)
			endif
			
			cars[controlcars].angle=wrapangle(cars[controlcars].angle)
			SetSpriteAngle(cars[controlcars].sprite,cars[controlcars].angle)	
		
			if controlcars=1
			movecarx#=-sin(cars[1].angle)*cars[1].speed*frameadjust
			movecary#=cos(cars[1].angle)*cars[1].speed*frameadjust
			else
			cars[controlcars].x=cars[controlcars].x+sin(cars[controlcars].angle)*(cars[controlcars].speed*1.2*frameadjust)
			cars[controlcars].y=cars[controlcars].y-cos(cars[controlcars].angle)*(cars[controlcars].speed*1.2*frameadjust)

			SetSpritePosition(cars[controlcars].sprite,cars[controlcars].x,cars[controlcars].y)
			endif
		
			
			whatisthecaron=checktrack(controlcars)
			
			IF whatisthecaron<>0 and controlcars<>1
				whattile=GetSpriteImageID(tracks[whatisthecaron].sprite)
			
				//drift
			if controlcars<>1
				aa=cars[controlcars].angle+RandomSign(90)
				cars[controlcars].x=cars[controlcars].x+sin(aa)*2*frameadjust
				cars[controlcars].y=cars[controlcars].y-cos(aa)*2*frameadjust
				//speed
				
				if whattile>4 and whattile<10 and cars[controlcars].speed<10 and random(1,999)>800
					inc cars[controlcars].speed,.4
				endif
				
				if whattile<5 or whattile>9 and cars[controlcars].speed>7
					dec cars[controlcars].speed,.1
				endif
				
			Endif
			
		`	print(whattile)
				
				Select whattile
					
					Case 1
						cars[controlcars].rotatespeed=CurveAngle(180,cars[controlcars].angle,180/cars[controlcars].speed)	
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 2
						cars[controlcars].rotatespeed=CurveAngle(270,cars[controlcars].angle,180/cars[controlcars].speed)	
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 3
						cars[controlcars].rotatespeed=CurveAngle(0,cars[controlcars].angle,180/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 4
						cars[controlcars].rotatespeed=CurveAngle(90,cars[controlcars].angle,90/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 5
						cars[controlcars].rotatespeed=CurveAngle(90,cars[controlcars].angle,2)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 6
						cars[controlcars].rotatespeed=CurveAngle(180,cars[controlcars].angle,2)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 7
						cars[controlcars].rotatespeed=CurveAngle(0,cars[controlcars].angle,2)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 8
						cars[controlcars].rotatespeed=CurveAngle(270,cars[controlcars].angle,2)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 10
						cars[controlcars].rotatespeed=CurveAngle(0,cars[controlcars].angle,180/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 11
						cars[controlcars].rotatespeed=CurveAngle(270,cars[controlcars].angle,180/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 12
						cars[controlcars].rotatespeed=CurveAngle(270,cars[controlcars].angle,180/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
					
					Case 13
						cars[controlcars].rotatespeed=CurveAngle(90,cars[controlcars].angle,360/cars[controlcars].speed)
						cars[controlcars].angle=cars[controlcars].rotatespeed
					EndCase
						
				EndSelect
				
				
			Endif
			
		
		Endif
		
		updatetrack(movecarx#*frameadjust,movecary#*frameadjust)
		

	next controlcars
	
EndFunction

Function controlplayer()
	
	//jump out
	if GetRawKeyState(27)
		end
	Endif
	
	
	//left
	If GetRawKeyState(37)
		dec cars[1].angle,4
		
		if cars[1].speed>.1
		dec cars[1].speed,.03
		endif
		
	Endif
	
	//right
	If GetRawKeyState(39)
		inc cars[1].angle,4
		
		if cars[1].speed>.1
		dec cars[1].speed,.03
		endif
		
	Endif
	
	//speed up
	If GetRawKeyState(38) and cars[1].speed<1.5
		inc cars[1].speed,.02
	endif
	
	if cars[1].speed>.01 and GetRawKeyState(38)=0
	dec cars[1].speed,.015
	endif
	
	//brake
	If GetRawKeyState(40) and cars[1].speed>0
		dec cars[1].speed,.4
	endif
	
EndFunction

Function playerstats()
	
	//set the MPH
	//delay to give better looking display
	
	ts=cars[1].speed*175
		
	ts=round(ts*5)/5
		
	SetSpriteAngle(needle,180+ts)
	
	SetTextString(2,GetTextString(cars[1].text))
	
	SetTextString(3,"LAP "+str(cars[1].lap)+"/3")
	
EndFunction

Function updatetrack(x as float,y as float)
	
	//scan all tracks
	for updatetrack=1 to 225
		
		//update the position by x and y
		tracks[updatetrack].x=tracks[updatetrack].x+x
		tracks[updatetrack].y=tracks[updatetrack].y+y
		
	next updatetrack
	
	//do the same for all the AI controlled cars
	for updatecars=2 to 8
		
		if updatecars<>1 
		cars[updatecars].x=cars[updatecars].x+x
		cars[updatecars].y=cars[updatecars].y+y
		endif
		
		checkcarcrashes(updatecars)
		
	next updatecars
	
	
EndFunction

Function checkcarcrashes(this)
	
	For check=1 to 8
		if check<>this 
			If GetSpriteCollision(cars[check].sprite,cars[this].sprite)
			adjx#=cars[check].x-cars[this].x
			adjy#=cars[check].y-cars[this].y
			
			tangle=ATanFull(adjx#,adjy#)
			
		
			if check<>1
			cars[check].x=cars[check].x+sin(tangle)*1
			cars[check].y=cars[check].y-cos(tangle)*1
			endif
			
			if this<>1
			cars[this].x=cars[this].x-sin(tangle)*1
			cars[this].y=cars[this].y+cos(tangle)*1
			endif
			
			 endif
		Endif
	
	Next check
	
EndFunction

Function counttracks(use)
	
	//set some variables
	total=0
	laphit=0
	totalactive=0
	
	//loop through all tracks
	For count=1 to 225
	//look at all tracks
	 If tracks[count].active<>0
		 //count all the approprate tracks (not grass or trees)
		 if tracks[count].active<14
		inc totalactive,1
		endif
		
		If GetSpriteCollision(cars[use].sprite,tracks[count].sprite)
			
			//track 9 is the starting grid
			If tracks[count].active=9
				laphit=1
			Endif
			
			//flag the track has driven over
			If trackscounted[use,count]=0
				//is it track?
				if tracks[count].active<14
				trackscounted[use,count]=1
				//increase the tracks the car has travelled.
				inc cars[use].travelled,1
				endif
				
				//is the car off the track?
				if tracks[count].active>=14
					trackscounted[use,count]=2
					//flag the offending car as having left the track
					inc cars[use].warning,1
					//if the car has missed 3 tracks this lap
					//it is out of the race.
					if cars[use].warning>3
						cars[use].disqualified=1
					endif
					
					if cars[use].speed>.1
						dec cars[use].speed,.1
					endif
					SetTextString(1,"Off Track WARNING:"+str(cars[use].warning))
				endif
				
				
			Endif
		Endif
	 Endif
	Next count
	
	//set the total number of tracks hit this race by counting them
	
	For add=1 to 225
		if trackscounted[use,add]=1
			inc total,1
		endif
	Next add
	
	cars[use].total=total
	
	//check if starting grid hit,
	//give the player a change to miss a couple of waypoints.
	if laphit=1
		if cars[use].total>=(totalactive-3)
			total=999
			//if the player has missed more than 3 tracks it's game over
			else
			//flag total as 1000, which means the car loses
			total=1000
		endif
		
	endif
	
	//if the total is 999, the car has completed the lap

	if total=999
			//reset all of the tracks hit to 0
		for reset=1 to 225
			trackscounted[use,reset]=0
			//set the cars warning to 0
			cars[use].warning=0
		next reset
		//make total 0
		//and add to the laps the completed
		total=0
		inc cars[use].lap,1
		
		if GetSoundInstancePlaying(clappingplaying)=0
			clappingplaying=playsound(clapping)
		endif
		
	endif
	
	//only display the warning if it's the player car
	
	if cars[1].warning>0
		SetTextVisible(1,1)
		else
		SetTextVisible(1,0)
	endif

	//jump back, returning the total laps

EndFunction total

Function findposition()
	
	for test=1 to 8
		for check=1 to 8
			
			store1=cars[check].travelled
			store2=cars[test].travelled
			
			if store2>store1 and cars[test].position>cars[check].position`
				
				temp=cars[check].position
				temp2=cars[test].position
				//see if player is near enough to hear
				dist=QuickDistance(cars[1].x,cars[1].y,cars[test].x,cars[test].y)
				if dist<600
				PlaySound(overtake)
				endif
				
				if cars[check].finished=0
				cars[check].position=temp2
				endif
				
				if cars[test].finished=0
				cars[test].position=temp
				endif
				
			endif
			
		next check
	next test
	
	for apply=1 to 8
		t1=cars[apply].position
		a$=str(cars[apply].position)
		b$="th"
		if t1=1 then b$="st"
		if t1=2 then b$="nd"
		if t1=3 then b$="rd"
		
		a$=a$+b$
		
		settextstring(cars[apply].text,a$)
	next apply
		 
	
EndFunction

Function loadsounds()
	
	global engine:engine=loadsound("engine.wav")
	global engineplaying=0
	global overtake:overtake=loadsound("overtake.wav")
	global startoff:startoff=loadsound("startoff.wav")
	global startoffplaying=0
	global startup:startup=loadsound("startup.wav")
	global startupplaying=0
	global clapping:clapping=loadsound("clapping.wav")
	global clappingplaying=0
	
EndFunction

Function checktrack(which)
	
	done=0
	
	For checking=1 to 225
		If tracks[checking].active<>0
			If GetSpriteCollision(tracks[checking].sprite,cars[which].sprite)
				done=checking
				checking=226
			Endif
		EndIf
	Next checking
		
EndFunction done

Function setuptext()
	
	//show warning
	
	CreateText(1,"")
	SetTextSize(1,48)
	SetTextPosition(1,300,600)
	SetTextColor(1,127,0,0,255)
	
	//show position
	CreateText(2,"")
	SetTextSize(2,96)
	SetTextPosition(2,880,16)
	
	//lap
	CreateText(3,"LAP")
	SetTextSize(3,64)
	SetTextPosition(3,400,16)
	
	//title
	CreateText(4,"SKID ROW")
	SetTextSize(4,96)
	SetTextPosition(4,330,80)
	SetTextVisible(4,0)
	
	//start race
	CreateText(5,"PRESS ENTER")
	SetTextSize(5,96)
	SetTextPosition(5,300,650)
	SetTextVisible(5,0)
	
EndFunction


//this command will return a value bewteen 0 and 360 degrees 
//feel free to use this in your own projects.

function wrapangle(angle as float) 
    getout=0
    jumpout=0
    getout=angle
    getout=getout-mod(getout,360)
    angle=angle-getout
	jumpout=9999
	
    while angle<0.0 or angle>=360.0 
        if angle<0.0 then angle=angle+360.0
        if angle >=360.0 then angle=angle-360.0
        dec jumpout,1 
        if  jumpout=0 
			 exit
		endif
		
    endwhile
    if  jumpout=0 then angle=0.0
    
endfunction angle

//This command will return an auto-interpolated angle based on a given speed. 
function CurveAngle( destination as float, current as float,  speed as float)
    local diff as float
    if speed < 1.0 then speed = 1.0
    destination = WrapAngle( destination )
    current = WrapAngle( current )
    diff = destination - current
    if diff <- 180.0 then diff = ( destination + 360.0 ) - current
    if diff > 180.0 then diff = destination - ( current + 360.0 )
    current = current + ( diff / speed )
    current = WrapAngle( current )
endfunction current

Function QuickDistance(X1#,Y1#,X2#,Y2#)
	
  distance#=0
  
  Dist_X# = X1# - X2#
  Dist_Y# = Y1# - Y2#
   
 Distance# = Sqrt(Dist_X# * Dist_X# + Dist_Y# * Dist_Y#)
 
 EndFunction distance#
   
Function mainmenu()
	
	SetTextVisible(2,0)
	SetTextVisible(3,0)
	SetTextVisible(4,1)
	SetTextVisible(5,1)
	
	
	if cars[1].finished<>0
	SetTextString(1,"THE RACE IS OVER")
	endif
	
	raceon=0
	
	if cars[1].finished<>0
	displaypositions()
	endif
	
	do
	
	If GetRawKeyState(13)
		exit
	endif
	
	Sync()
	
	loop
	
	SetTextVisible(2,1)
	SetTextVisible(3,1)
	SetTextVisible(4,0)
	SetTextVisible(5,0)

	clearcars()
	
	cleartrack()

	startwhere=setuptrack()

	For make=1 to 8
		positioncars(make,startwhere)
	next make

	drawtrack()
	
EndFunction

Function cleartrack()
	
	For clearing=1 to 225
		tracks[clearing].active=0
	Next clearing
	
EndFunction

Function clearcars()
	
	for clearcars=1 to 8
		cars[clearcars].disqualified=0
		cars[clearcars].finished=0
		SetTextString(cars[clearcars].text,"")
	next clearcars
	
Endfunction
