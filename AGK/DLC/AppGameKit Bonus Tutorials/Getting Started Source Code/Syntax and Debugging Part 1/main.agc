
// Project: SyntaxDebugExample 
// Created: 2016-05-07
 
// Click on the screen to move the blue square and collect the red squares

// set window properties
SetWindowTitle( "Syntax And Debugging Part 1" )
SetWindowSize( 800, 600, 0 )

// set display properties, same as window size:
SetVirtualResolution( 800, 600 )


` create, color, and position player sprite:
CreateSprite(1,0)
SetSpriteSize(1,32,32)
SetSpriteColor(1,0,0,255,255)
SetSpritePosition(1,512,384)


rem create and randomly place 10 target sprites:
For t=11 To 20
	CreateSprite(t,0)
	SetSpriteSize(t,16,16)
 SetSpriteColor(t,255,0,0,255)
 SetSpritePosition( t , random(0,700) , random(0,500) )
Next t


//begin_main_game_loop:

Do
    
 ` find out If the player is clicking the mouse or tapping the screen:
 If GetPointerState()=1

     
 ` find out the player's 2D coordinates:
  PlayerX = GetSpriteX(1)
  PlayerY = GetSpriteY(1)
     
  ` let's move our player towards the location of the pointer
  MoveToX = GetPointerX()
  MoveToY = GetPointerY()


     
  ` use a series of conditional statements to adjust the player's X and Y:          
  If PlayerX < MoveToX Then PlayerX = PlayerX + 1
  If PlayerX > MoveToX Then PlayerX = PlayerX - 1
     
  If PlayerY < MoveToY Then PlayerY = PlayerY + 1
  If PlayerY > MoveToY Then PlayerY = PlayerY - 1
     
     
  ` re-position the player, using the adjusted variables:
  SetSpritePosition( 1 , PlayerX , PlayerY )
     
 Endif


 ` now we will loop through the 10 target sprites,
 ` and see If the player is touching them.
 
 For i = 11 To 20
	 If GetSpriteCollision(1,i) = 1
	  ` yes, they are colliding!
	   
   ` first increase the player's score:
   score = score + 1
	   
	   ` then, randomly move the target block elsewhere on the screen:
   SetSpritePosition( i , random( 0 , 7000 ) , random( 0 , 500 ) )	   
	Endif
 Next i	 

    Sync()
    
Loop

Print("Score: "+str(score))

//End
