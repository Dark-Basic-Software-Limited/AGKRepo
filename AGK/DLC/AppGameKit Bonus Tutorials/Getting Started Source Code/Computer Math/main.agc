
// Project: Computer Math 
// Created: 2016-06-06

// set window properties
SetWindowTitle( "Computer Math" )
SetWindowSize( 1024, 768, 0 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 1, 1 )

//Use new fonts
UseNewDefaultFonts( 1 )


` Main Loop (which in this case does not actually "loop") :

DemonstratePrecedence()

DecimalNumbers()

Algebra()

End



Function DemonstratePrecedence()

 ` EXAMPLE:
 ` Perform a calculation on a variable several times consecutively.
 ` This demonstrates the use of parentheses in determining precedence.
    
 Local x
 
 Do

 Print("")

 x = 0

 ` show the starting value, and the form of the equation:
	Print("x = 0 , x = 5 * x + 10")    
	
 For t = 1 To 4
		x = 5 * x + 10
		print(x)
 Next t
    
 Print("")
    
 x = 0
    
 ` show the starting value, and the form of the equation:
 Print("x = 0 , x = 5 * ( x + 10 )")
    
 For t = 1 To 4
  x = 5 * ( x + 10 )
  Print(x)
 Next t

 Print("")
 Print("Press Space To Exit")

 Sync()
    
 If GetRawKeyPressed(32)=1 Then EXIT
    
 Loop

` NOTICE how the parentheses greatly change the results of the calculations,
` even though everything else is the same.

` follow these calculations in your head or on paper

Endfunction 



Function DecimalNumbers()

` Math Example 2: Decimal Numbers

 Local a As Float

 a = 1.0

 AddVirtualButton(1,100,110,80)
 AddVirtualButton(2,100,220,80)
 AddVirtualButton(3,100,330,80)
 AddVirtualButton(4,100,440,80)
 AddVirtualButton(5,100,550,80)

 SetVirtualButtonText(1,"+ 1.1")
 SetVirtualButtonText(2,"* 2.3")
 SetVirtualButtonText(3,"/ 3.7")
 SetVirtualButtonText(4,"- 5.9")
 SetVirtualButtonText(5,"TRUNC")

` to "Truncate" is to remove everything to the right of the decimal,
` leaving only the integer part.
` The command Trunc() can accomplish this

 Do
	
	 Print(a)
	 Print("Press Space To Exit")
		
	 If GetVirtualButtonPressed(1)=1 Then a = a + 1.1
	 If GetVirtualButtonPressed(2)=1 Then a = a * 2.3
	 If GetVirtualButtonPressed(3)=1 Then a = a / 3.7
	 If GetVirtualButtonPressed(4)=1 Then a = a - 5.9
	 If GetVirtualButtonPressed(5)=1 Then a = trunc(a)

  Sync()
    
  If GetRawKeyPressed(32)=1 Then EXIT

 Loop

` for any sequential operation of more than 3 steps, it is more efficient to use
` a "for loop":
 For t=1 To 5
  DeleteVirtualButton(t)
 Next t

Endfunction 


Function Algebra()

` now lets show an equation that will solve for x:
` ax - b = c
` => 
` ax = b + c
` =>
` x = (b + c) / a

 Local x As Float

 Local a As Float
 Local b As Float
 Local c As Float

 Do

 ` this is an example of a "nested loop":
 ` the outer loop sets up the equation's variables,
 ` and the inner loop displays them.

 ` the "random" function returns a number between the low and high limits you set:
 a=random(2,9)
 b=random(2,9)
 c=random(2,9)

 x = (b+c)/a

  Do 

   Print("")

   Print(str(a,0)+"x - "+str(b,0)+" = "+str(c,0))
   Print("")

   Print("x="+str(x))
   Print("")

   Print("Press ENTER for another equation")
   Print("")

   Print("Press SPACE to exit")

   Sync()

   ` code 32 is the space key, and 13 is the enter key:
   If GetRawKeyPressed(13)=1 Then exit
   If GetRawKeyPressed(32)=1 Then exit

  Loop

 ` we need to detect the state of the space key again,
 ` to break from the second loop.

 ` Notice that in this case "GetRawKeyState" is the correct choice,
 ` because the space key has already been "pressed",
 ` and it would be impossible to detect another "press" event
 ` during the same cycle.

 If GetRawKeyState(32)=1 Then Exit

 Loop

Endfunction 
