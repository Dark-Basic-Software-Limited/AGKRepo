
// Project: Images and Sprites 
// Created: 2016-06-10

// set window properties
SetWindowTitle( "Images and Sprites" )
SetWindowSize( 1024, 768, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 0, 0, 1, 0 )

Local BKGImage

LoadImage(1,"WhiteStar.png")
LoadImage(2,"WhiteDiamond.png")
BKGImage = LoadImage("GradientBack.png")
 ` BKG is the "handle" for the background gradient image.
 ` If you prefer to let AppGameKit generate ID numbers for your
 ` images and sprites, this is the way to do it.
 
 
` Create Sprites from the images:
` These are the 2 "active" sprites that will be manipulated: 
Sprite(1,1,40,700,10) 
Sprite(2,2,975,22,20)
` Inspect the user function "sprite()" to better understand what is happening here.
 
` These sprites have "depth" relatively close to the "camera".

` Larger numbers of depth are further away, and sprites with 
` smaller numbers will appear on top of them.

` In this case, sprite 1 will overlap sprite 2,
` and both will be in front of the background.

` this is the background, and once set up, it will not change.
Sprite(3,BKGImage,0,0,90) 
SetSpriteSize(3,1024,768)
` The background sprite is far away, and set to the size of the screen.

 
Do
    
 MovePlayerSprite()
    
 MoveChaser()

 DetectCollision()

 Sync()
    
Loop


End


Function Sprite(n,i,x,y,d)
 ` another user function that performs several repetitive tasks:
 ` n is the sprite number, i is the image number, x & y are coordinates, and d is depth	
	CreateSprite(n,i)
	SetSpritePosition(n,x,y)
	SetSpriteDepth(n,d)
Endfunction 

    
Function MovePlayerSprite()
	` the player is sprite #1.
	` This function will get input from the player,
	` and move them accordingly.
	` Notice how the sprite stores its own x & y coordinates,
	` meaning there is no need to track them seperately as variables,
	` for such a simple exercise.
		
	Local x 
	Local y
	
	` Get the sprite's current position:
	x = GetSpriteX(1)
	y = GetSpriteY(1)
	
	` adjust the x & y position variables by the player's input:
	` This style of input uses the arrow keys or accelerometer, depending on platform:
	x = x + GetDirectionX() * 4
	y = y + GetDirectionY() * 4
	
	` This code keeps the player's sprite within the screen bounds:
	If x < 0 Then x = 0
	If x > 992 Then x = 992
	If y < 0 Then y = 0
	If y > 736 Then y=736

	` Re-position the sprite based on the new x & y:	
	SetSpritePosition(1,x,y)

Endfunction 
	
    
Function MoveChaser()

	Local x1
	Local y1
	Local x2
	Local y2

	` this is a very simple example of "Artificial Intelligence".	
	` The chaser moves directly towards the player at all times.
	
	` It uses the following sort of logic:
	` "If the player is to my left, then I should move left", or:
	` "if the player's X is less than my X, then i should decrease my X"
	
	` the chaser is sprite #2, and the player is sprite #1:

	x1 = GetSpriteX(2)
	y1 = GetSpriteY(2)
		
	x2 = GetSpriteX(1)
	y2 = GetSpriteY(1)

	If x2 < x1 Then x1 = x1 - 1
	If x2 > x1 Then x1 = x1 + 1
	
	If y2 < y1 Then y1 = y1 - 1
	If y2 > y1 Then y1 = y1 + 1

	SetSpritePosition( 2 , x1 , y1 )
	
Endfunction 


Function DetectCollision()
	If GetSpriteCollision( 1 , 2 ) = 1
		Print("It's Getting you!")
	Endif		
Endfunction 
	
