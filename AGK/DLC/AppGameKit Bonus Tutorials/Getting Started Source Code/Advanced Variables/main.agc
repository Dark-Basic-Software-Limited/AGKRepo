
// Project: Advanced Variables 
// Created: 2016-06-13

// set window properties
SetWindowTitle( "Advanced Variables" )
SetWindowSize( 1024, 600, 0 )

// set display properties
SetVirtualResolution( 1024, 600 )
SetOrientationAllowed( 1, 1, 1, 1 )

` NOTE:
` this is not an actual game.
` it is just a demonstration of various advanced data types


` Premise:
` Imagine a game world divided into squares,
` an 8x8 grid, similar to a checkerboard.
` But with a window size of 1024x600 (a common 7" tablet resolution),
` the 'squares' are actually rectangles 128x75 (1024/8=128 , 600/8=75)


` Suppose we need to have 10 randomly-positioned walls in our game world.
` If walls only have one property, which is to be 
` an impassible obstacle of a pre-determined size,
` Then all we need to worry about is their position on the screen.
` Here is one way to do it:


` This "User Defined Type" will help to store the position (x&y)
` of anything in the game world:
Type Position
	x As Float
	y As Float
Endtype

` This will create the array "wall" which will store the x & y position
` of up to 10 "wall objects":
Dim Wall[10] As Position

` This function will randomly place 10 walls. Examine it now:
RandomlyPlaceWalls()


` Now we want to add a "player" to the world,
` and track many different sorts of statistics about that player.
` A user-defined type can hold all this information together:

Type Player
	Name As String
	Health As Integer
	MaxHealth As Integer
	Damage As Integer
	Pos As Position
Endtype

` Notice that "Position", which was a user-defined type from above,
` can now be used within other UDTs, as a type of data.
` See below for proper usage of types-within-types:

` Since we will only have one "player" in this game,
` there is no need to create an array of players.
` Instead, a single global variable will suffice:
Global pl As Player

pl.Name = "Mo"
pl.Health = 50
pl.MaxHealth = 100
pl.Damage = 10
pl.Pos.x = 4
pl.Pos.y = 5


` Note that even though we give many values to our "player" in this example,
` we never actually put them in the game world.

 
Do
    
 Print( "Press space to re-generate walls" )
    
 Sync()
    
 If GetRawKeyPressed(32) = 1 Then RandomlyPlaceWalls()
    
Loop


End


Function RandomlyPlaceWalls()
	
For t=1 To 10
	
	` for each of the 10 walls, give a random x and y coordinate:
	wall[t].x = Random(1,8)	
	wall[t].y = Random(1,8)
	
	` This is necessary if this function is called more than once:
	If GetSpriteExists(t)=1 Then DeleteSprite(t)
	
	` create a sprite for each wall:
	CreateSprite(t,0)
	SetSpriteSize(t,128,75)
	SetSpriteDepth(t,50)
	SetSpritePosition( t, ( wall[t].x - 1 ) * 128 , ( wall[t].y -1 ) * 75 )
    
 ` Different colors are used here to help illustrate each wall segment:
 SetSpriteColor( t , wall[t].x * 31 , wall[t].y * 31 , 64 , 255 )

Next t	
	
Endfunction 

` Let's say that as our player explores the game world,
` he wants to keep a map of the things he finds there.

` For that, we create a UDT that lists all of the things 
` that could possibly be there: wall, treasure, monster, door, stairs, etc.

` Many of these items could be represented simply as 
` 1 meaning "present", and 0 meaning "not present".

` But maybe we want to list the name of the monster,
` and an amount of dollars and cents for the treasure.
` In that case, we use string and float variables respectively.

Type TheMap
 Wall As Integer
 Door As Integer
 Stairs As Integer
 Monster As String
 Treasure As Float
Endtype

` The grid itself is 8x8, so we need a multi-dimensional array to track it:

Dim Map[8,8] As TheMap

` Now that we have a data structure in place,
` we need a function that is called each time the player enters an area,
` that marks the map according to what is found there.

` The function for filling the map could look something like this:

Function UpdateMap( x, y, wall, door, stairs, mon as string, tre as float )

 Map[x,y].Wall = wall
 Map[x,y].Door = door
 Map[x,y].Stairs = stairs
 Map[x,y].Monster = mon
 Map[x,y].Treasure = tre

Endfunction 


` Pretend that we have entered the map tile 2,7
` and found no wall, no doors, a staircase, a dragon, and $13.27 
UpdateMap( 2, 7, 0, 0, 1, "Dragon", 13.27 )

` (end of advanced data types sample program)
