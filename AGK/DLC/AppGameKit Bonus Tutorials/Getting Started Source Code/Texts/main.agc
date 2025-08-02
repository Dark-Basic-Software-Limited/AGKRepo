
// Project: Texts
// Created: 2016-06-10

// set window properties
SetWindowTitle( "Texts" )
SetWindowSize( 1024, 768, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 0, 0 )


` a new variable:
Global Counter
Counter = 0


` This project for "texts" is copied and modified from the "input" example.

Local PointerX
Local PointerY

PointerX=100
PointerY=100
NewText(1,"This Text Rolls",PointerX,PointerY)

Local KeyX
Local KeyY

KeyX=400
KeyY=300
NewText(2,"Big Purple Text",KeyX,KeyY)
SetTextSize(2,48)

SetTextSize(1,32)

SetTextColor(2,255,0,255,255)



Do
    
 ` this is the existing code, taken from the "input" example:

 ` POINTER (mouse)
 PointerX = GetPointerX()
 PointerY = GetPointerY()
 SetTextPosition(1 , PointerX , PointerY)


 ` Keyboard (arrow keys)
 KeyX = KeyX + ( GetRawKeyState(39) - GetRawKeyState(37) ) * 7
 KeyY = KeyY + ( GetRawKeyState(40) - GetRawKeyState(38) ) * 7
 SetTextPosition(2 , KeyX , KeyY)

` old code above, new code below

 RotateMouseText()

 ModifyNewTexts()


 Print("The print command is not very useful.")
 Print("Text objects are much more versatile.")


 Sync()

Loop


End


Function NewText(n,a$,x,y)
	` this is an example of a user function that combines several commands
	` for something that is done repeatedly. 
	` In the end, it saves a lot of typing.
 CreateText(n,a$)
 SetTextSize(n,16)
 SetTextPosition(n,x,y)
 SetTextAlignment(n,1)
Endfunction 


Function RotateMouseText()

 ` This will perform a rotation of individual letters of the "pointer" string:

 ` 1. store the text in a variable
 ` 2. get the length of the string
 ` 3. step through each character, using a "for" loop.

 a$ = GetTextString(1)
 L = Len(a$)

 For t=0 To L - 1
 	SetTextCharAngle( 1 , t , GetPointerX() + ( 15 * t ) )
 Next t

 ` Note that the command "setcharangle" designates 
 ` the first character of the string as zero (0), not 1,
 ` that's why the loop goes from 0 to (length-1)

 ` The angle of each character is different (15*t),
 ` and all of the angles are adjusted by the mouse's X coordinate,
 ` allowing you to create a "rolling" effect as it moves across the screen.

Endfunction 


Function ModifyNewTexts()
 ` This function demonstrates more examples of texts.
 
 ` Here is an example of a type of incremental counter.
 ` it has a starting value, it goes up over time,
 ` and when it reaches a certain maximum value, it is reset:
 
 Inc Counter
 If Counter > 255 Then Counter = 0

 If GetTextExists(5) = 1
	 SetTextColorAlpha(5,Counter)
 Else
	 ` this text does not exist yet, so create it:
	 NewText(5,"This text fades in slowly.",512,200)
 Endif
 
  
 If GetTextExists(6) = 1
	 SetTextSpacing(6, (Counter / 15) )
 Else
	 ` this text does not exist yet, so create it:
	 NewText(6,"This text adjusts its spacing.",512,400)
 Endif
 
   
 If GetTextExists(7) = 1
	 
	 Local Alig

	 Alig = (Counter / 85)
	 
	 If Alig = 0 Then SetTextString(7,"Aligned Left")
	 If Alig = 1 Then SetTextString(7,"Aligned Center")
	 If Alig = 2 Then SetTextString(7,"Aligned Right")
	 
	 SetTextAlignment(7, Alig )

	 ` this line shows the X coordinate that this text is aligned to:
	 DrawLine(512,580,512,620,255,255,255)
 
 Else
	 
	 ` this text does not exist yet, so create it:
	 NewText(7,"This text changes its alignment.",512,600)
	 
 Endif
 
 
Endfunction 
