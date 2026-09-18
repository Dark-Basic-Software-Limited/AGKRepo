
// Project: Reversi 
// Created: 2017-04-13

// Show all errors
SetErrorMode(2)

// Set window properties
SetWindowTitle( "Reversi" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // Allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // Doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // Allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // Use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // Since version 2.0.22 we can use nicer default fonts

//We'll start off by changing the screen background colour from the default black
//This will make it easier to see some of our game details.
SetClearColor(128,128,128)
//Let's set up our sprites.
//As before, we'll set up a global variable to contain the values.
//We only need one for the board

Global playingboard=1
LoadImage(playingboard,"board.png")
CreateSprite(playingboard,playingboard)
//Position our sprite in the middle of the screen
SetSpritePosition(playingboard,128,0)

//Load black and white images

Global black=2
Global white=3
//Indicate whose turn it is and where they might place their piece
Global marker=2
//We also might want to make the game more or less challanging, so we'll add a
//Difficulty flag.
Global howdifficult=1

LoadImage(black,"black.png")
LoadImage(white,"white.png")

//We also need a sprite for the marker
//As Black goes first, we'll make it Black

CreateSprite(marker,black)
SetSpriteColorAlpha(marker,150)

//Set up a new type for the board

type pieces
	//This is where we'll store the sprite position
	x as float
	y as float
	//Is the square in use
	side as integer
	sprite as integer 
	//We use this to decide when to change the colour of the piece
	flagged as integer
endtype

//this is identical to the arrays we used in the first tutorial
dim board[8,8] as pieces

//We're using another muliple dimensional array here.
//This allows use to store information in a very similar way to the board layout
//Apart from using two cordinates to reference the array
//this is identical to the arrays we used in the first tutorial

//We set up the pieces here
nextsprite=100
//Let's store the temporary screen cordinates here
tempx=156
tempy=28

//We'll use 2 For - Next loops to reference our array
for across=1 to 8
	for down=1 to 8
	
		board[across,down].sprite=nextsprite
		board[across,down].x=tempx
		board[across,down].y=tempy
		//For now we'll set all space on the board as empty
		board[across,down].side=0
		//The sprite needs an image, so we'll apply the black piece for now.
		CreateSprite(board[across,down].sprite,black)
		SetSpritePosition(board[across,down].sprite,board[across,down].x,board[across,down].y)
		//We can hide a sprite by setting is to non visible. This allows us to show a blank space simply by
		//hiding the sprite.
		SetSpriteVisible(board[across,down].sprite,0)
		//Move the variable with the sprite to be used value along 1
		inc nextsprite,1
		inc tempy,90
	next down
	
	   tempy=28
	   inc tempx,90
next across

//As we will need to reset the game at some point, we might as well create
//a function to do it for us.
resetgame()

//Now let us set up a type for each player
//This one only needs a couple of different choices.

Type whoseplaying
	iscomputer as integer
	score as integer
EndType

//And create an array
//There are only 2 possible players

Dim player[2] as whoseplaying

//We decide who is being played by a human or a computer
player[1].iscomputer=0
player[2].iscomputer=1

//We'll need to set up someway to display the score, let's add some text objects.
//You should recognise these commands from previous tutorials
CreateText(1,"0")
SetTextSize(1,80)
SetTextPosition(1,45,15)
//The first player uses black pieces
//Let's change the colour of the text for this player to black
//So we know what's going on.
SetTextColor(1,0,0,0,255)
//Text 2 doesn't need a colour set as white is the default.
CreateText(2,"0")
SetTextSize(2,80)
SetTextPosition(2,940,15)

//We will need to store the position of the square under the cursor
//This is used when calculating if the player can go.
Global squareacross
Global squaredown

//Now let's set up another Type
//This one will be used to supply cordinates to scan the board.
//We'll need to scan the board in 8 directions, horizontally, vertically and diagonally

type where
	across as integer
	down as integer
endtype

dim search[8] as where

//1 will be up
search[1].across=0
search[1].down=-1
//2 will be up and right
search[2].across=1
search[2].down=-1
//3 will be right
search[3].across=1
search[3].down=0
//4 will be down and to the right
search[4].across=1
search[4].down=1
//5 will be down
search[5].across=0
search[5].down=1
//6 will be down and left
search[6].across=-1
search[6].down=1
//7 will be left
search[7].across=-1
search[7].down=0
//8 will be up and left
search[8].across=-1
search[8].down=-1



//Main game loop
do
	

	setimages()

	for whoseturn=2 to 3
		
		SetSpriteImage(marker,whoseturn)
		
		if player[whoseturn-1].iscomputer=0
			//Let's see if the player can actually move
			//If not, it's game over
			test=computerplayer(whoseturn,0)
			do
			hasmoved=humanplayer(whoseturn)
			if hasmoved=1 or test=0
				setimages()
				counttiles()
				 Sync()
				Exit
			Endif
			
			Sync()
			
			 loop
		EndIf
		
		//If the player is the computer take it's turn
		if player[whoseturn-1].iscomputer=1
			//Flag the computers turn as 'real'
			//We will also return the pieces captured
			//In case the computer could not go.
			test=computerplayer(whoseturn,1)
			setimages()
			counttiles()
			Sync()
		EndIf
		
		sleep(1000)
		
		//If test=0 (returned from our game loops)
		//No one can go, and the game is over.
		If test=0
			
			If player[1].score>player[2].score
			Print("Black has won!")
			Endif
			
			If player[1].score<player[2].score
			Print("White has won!")
			Endif
			
			If player[1].score=player[2].score
			Print("The game is a draw!")
			Endif
			
		Endif
		
	
	
	Next whoseturn
	
   ` Print( ScreenFPS() )
   

loop

Function resetgame()
	
	for across=1 to 8
	for down=1 to 8
		board[across,down].side=0
		SetSpriteVisible(board[across,down].sprite,0)
	next down
	next across
	
	board[4,4].side=2
	board[5,4].side=3
	board[4,5].side=3
	board[5,5].side=2
	
EndFunction

Function setimages()
	
	for across=1 to 8
	for down=1 to 8
		If board[across,down].side<>0
			SetSpriteImage(board[across,down].sprite,board[across,down].side)
			SetSpriteVisible(board[across,down].sprite,1)
		Endif
	next down
	next across
	
EndFunction

Function findsquare()
	
	//Grab the mouse position but offset it by the position of
	//The board on screen.
	tempx=GetPointerX()-156
	tempy=GetPointerY()-28
	
	//Our mouse position can never be less than 0,
	//But our board starts at position 128 + a border width and depth of 28 for our board 
	//Which comes to a total of 156, 
	//We want to assume that mouse position 0 is the edge of our board, so we use a little maths.
	//All squares are 90 pixels square and the screen is 1024 pixels wide, -156 which equals 896.
	//So divide our temporary position by 90
	//And ROUND the number to remove any decimals.
	//This will produce a board position of between 0-9
	//Of course, our board is numbered between 1-8
	//So we'll add 1 to our result.
	squareacross=Round(tempx/90)+1
	squaredown=Round(tempy/90)+1
	//We now ignore any result that isn't between 1-8
	If squareacross<1 or squareacross>8
		squareacross=0
	EndIf
	
	If squaredown<1 or squaredown>8
		squaredown=0
	EndIf
	
	//Now let's calculate the actual position on the screen based
	//On the squares found
	//But only if it's a valid number (I.e. Not 0)
	//If it's a valid position, we place the marker at that point.
	//If the marker is off the board we hide it.
	
	tempx=156+Round(tempx/90)*90
	tempy=28+Round(tempy/90)*90
	
	If squareacross<>0 and squaredown<>0
		SetSpriteVisible(marker,1)
		SetSpritePosition(marker,tempx,tempy)
		else
		SetSpriteVisible(marker,0)
	EndIf
	
	
EndFunction

Function scansquare(across,down,whichside)
	
	//We enter the Function with the following information.
	//The square across we want to look at
	//The square down we want to look at
	//Which side is taking a turn
	
	//Let's make sure that all our board spaces are unflagged
	//We do this to clear any information retained from the last search
	clearflagged()
	
	//We set a local variable to indicate whether we're looking
	//To capture Black (2) or White (3)
	//We set it to Black at first
	lookingfor=2
	//But if it's Blacks turn
	if whichside=2
		//We set it to White.
		lookingfor=3
	endif
		
	
	//If the search square is outside the board just exit as an invalid move
	if across=0 or down=0
		//We return 0 here as no pieces can be captured
		ExitFunction 0
	Endif

	
	//Is the square empty?
	//Only search if that's the case
	if board[across,down].side=0
	
	//Set a local variable to count the number of 
	//Pieces we might be able to capture
		found=0
		
		//Run through the search loop
		//We will be using our search array
		//Remember we search clockwise
		//Using 8 Directions.
		For look=1 to 8
			
			//Make sure we are using the selected square to
			//Start the search
			//We will also create 3 more Local variables
			//One to store the current search square
			//Across and Down
			//And a temporary variable tfound
			//Which will store the pieces captured in this search
			tacross=across
			tdown=down
			tfound=0
			
			//Start the search
			Do
				
				//Adjust the search position 
				//So we're looking at the next available square
				Inc tacross,search[look].across
				Inc tdown,search[look].down
				
				
				//Exit the seach loop for this direction if the search has left the board
				//As we can't capture pieces if we are outside of the board
				If tacross<1 or tacross>8 or tdown<1 or tdown>8
					//Make 0 found as this is an invalid search
					tfound=0
					//Exit to the command following the Loop
					Exit
				EndIf
				
				//Have we found a piece we can potentially capture?
				If board[tacross,tdown].side=lookingfor
					//If so, increase the number found and flag the piece
					//If so, we increase tfound by 1 indicating we've found another
					//Piece to capture.
					Inc tfound,1
					//And we flag it as one that we might need to change.
					board[tacross,tdown].flagged=1
				Endif
				
				
				//Has the seach run into an empty square
				//If it has this is another invalid search	
				//As we haven't trapped a piece
				If board[tacross,tdown].side=0
				//Make 0 found as this is an invalid search
				tfound=0
					//Exit to the command following the Loop
					Exit
				EndIf
				
				//If we find a piece that is the current 
				//Players we can end our seach as valid
				
				If board[tacross,tdown].side=whichside 
					//Exit to the command following the Loop
					//tfound will contain the value for this search
					Exit
				Endif
				
				
				//Keep searching
			Loop
			
			//If none found ensure that all flagged peices are cleared for this search
			//But only in the last direction checked as the search 
			//Found no valid pieces to capture.
			If tfound=0
				//Reset the search position to the square
				tacross=across
				tdown=down
				//Start a new loop
				Do
					
				//adjust the search position
				 Inc tacross,search[look].across
				 Inc tdown,search[look].down
				//Exit if it leaves the board
				 If tacross<1 or tacross>8 or tdown<1 or tdown>8
					 //Exit to the command following the Loop
					Exit
				EndIf
				
				//Unflag this piece
				board[tacross,tdown].flagged=0
				
				//Exit if the square is empty or it contains one of the current players
				//Pieces as we know the search is over.
				
				If board[tacross,tdown].side=0 or board[tacross,tdown].side=whichside
					//Exit to the command following the Loop
					Exit
				EndIf
				
				
				//Contine with the loop
				Loop
			EndIf
			
			//Add the number of peices found in the search to the total.
			//If this is 0, found won't be increased
			inc found,tfound
				
			//Finish searching in all 8 directions.
		Next look
	//End the search only if square empty If Loop.
	EndIf
	
	//Exit this Function, returning the found value,
	//Found is the maximum number of pieces that can be captured.
EndFunction found

Function changesquares(whichside)
	
	//Scan the entire board
	for across=1 to 8
		for down=1 to 8
			//If a square has been flagged for change
			if board[across,down].flagged<>0
				//Set the sprite image for whichside
				SetSpriteImage(board[across,down].sprite,whichside)
				//Set the array to relect this.
				board[across,down].side=whichside
			endif
		next down
	next across
	
	//That's it.
	
EndFunction

Function humanplayer(turn)
	
	done=0
	//Find the square under the cursor
	findsquare()
	
	//Find out have many pieces the player will win
	howmany=scansquare(squareacross,squaredown,turn)
	
	//It would be useful to let the player know if the 
	//Move is valid, let's change the marker sprite colour to red
	//For in valid moves
	//We can tell this if the howmany search is 0
	If howmany=0
		//Let's set the marker sprite to red
		SetSpriteColor(marker,255,0,0,255)
		//If it's not 0, we'll set it back to it's normal colour
		Else
		SetSpriteColor(marker,255,255,255,255)
	EndIf
	
	If howmany<>0 and GetRawMouseLeftPressed()
		//Change the pieces
		changesquares(turn)
		//Place the players actual move
		board[squareacross,squaredown].side=turn
		//Flag as completed
		done=1
	EndIf
	
	//Retain from function, returning done at the same time so we know
	//If the move is completed
EndFunction done

Function computerplayer(turn,real)

	//Reset some local variables
	//Best move will contain a value
	//Based on the number of pieces that can be captured
	//In addition, stratgic squares will be given more value
	//At higher levels of difficulty.
	bestmove=0
	//The square which provides the best move
	//Will be stored here.
	bestacross=0
	bestdown=0
	
	//So, we search our grid.
	for across=1 to 8
		for down=1 to 8
			//Is the square available for a possible move?
			//I.e. Is it empty.
			If board[across,down].side=0
				//Scan the square
				howmanyfound=scansquare(across,down,turn)
				//Can anything be captured
				If howmanyfound<>0
					
					//The corners are more important as they are harder to capture
					//So, add to howmany found to give them more value.
					//But only if howdifficult=3 and this is a real move
					If (across=1 and down=1) or (across=8 and down=1) or (across=1 and down=8) or (across=8 and down=8) and real=1
						//But only if we are on the highest level of difficulty
						If howdifficult=3
							//We increase howmanyfound by 4
							//Giving the square more importance.
							Inc howmanyfound,4
						Endif
					EndIf
					
					//The edges are also important, but less so,
					//But only if howdifficult is greater than 1
					//And only if this is a real move.
					If (across=1 or across=8 or down=1 or down=8) and real=1
						//But only if not on the default, easy level
						If howdifficult>1
							//We increase howmanyfound by 2
							//Giving the square more importance.
							Inc howmanyfound,2
						EndIf
					EndIf
					
					//Has the number of pieces that can be captured
					//Plus the importance of any stategic square
					//Exceeded the value of bestmove?
					If howmanyfound>bestmove
						//If so, make the new bestmove = howmanyfound
						bestmove=howmanyfound
						//Mark the squares where this move was found
						bestacross=across
						bestdown=down
					EndIf
				EndIf
			EndIf
			//Finish our search
		next down
	next across
	
	//If the search was real and not just a count
	//Make the move.
	If real=1
		If bestmove<>0
			//reflag the peices for the computers chosen move
			howmanyfound=scansquare(bestacross,bestdown,turn)
			//change over all of the squares
			changesquares(turn)
			//place the players actual piece
			board[bestacross,bestdown].side=turn
		EndIf
	EndIf
	
	//Return the value of bestmove so we know this is a good square.
	
EndFunction bestmove


Function clearflagged()
	
	for across=1 to 8
		for down=1 to 8
			board[across,down].flagged=0
		next down
	next across
	
EndFunction

Function counttiles()
	
	player[1].score=0
	player[2].score=0
	
	for across=1 to 8
		for down=1 to 8
			If board[across,down].side<>0
				inc player[board[across,down].side-1].score,1
			EndIf
		next down
	next across
	
	SetTextString(1,str(player[1].score))
	SetTextString(2,str(player[2].score))
	
EndFunction


	
	

