
//  Project: Loops and Functions 
//  Created: 2016-05-20
 
Remstart 

 This project will demonstrate many types of loops,
 and the proper use of functions,
 as well as program flow and hierarchy.

 IMPORTANT:
 Be sure to read all of the REMARKS ("comments") throughout this program.

 This area demonstrates the "block comment" style using rem-start & rem-end.
 (Can you think of why rem-start and rem-end are hyphenated here in this explanation?)

Remend

 
` Project Initialization:

 
`  set window properties:
SetWindowTitle( "Loops and Functions" )
SetWindowSize( 1024, 768, 0 )

`  set display properties:
SetVirtualResolution( 1024, 768 )
SetPrintSize(16)

// Use new fonts
UseNewDefaultFonts( 1 )


TitleScreen()

` The Main Loop:

` This is where the entire flow of your program is determined.
` each statement is executed in order,
` and then when it reaches the command "loop" at the bottom,
` it will come back up to "do" and start again.

Do
 ` <- Notice the black line extending down the left side of the editor.	
 ` it starts at "do" and goes the whole way down to "loop".
 ` This helps to illustrate exactly what is contained within a particular block of code.
 ` Try clicking the [-] box next to "do". 
 ` This is called "folding". Click the [+] to "unfold".

 ` This prints the current "frames per second" to the screen.
 Print( "Frames Per Second: "+str(ScreenFPS(),0) )


 ` this tells the user what to do:
 Print("Press the 'control' key to enter a different loop")

    
 Sync()
 ` "sync()" is the command that actually renders everything to the screen.
 ` it should only be called once per loop, because it takes a (relatively) long time.


 ` this command checks for the user pressing the 'control' key.
 ` "GetRawKeyState()" is an input function that will be covered in a later chapter.
 If GetRawKeyPressed(17)=1
  ` This is a user-defined function:
  DoSomethingElse()
 Endif
    
    		
 ` this is called an "exit condition":
 If GetRawKeyState(27)=1
			
		Exit
		` "exit" will break execution from the current loop,
		` in this case going outside the main loop. 
		` What do you think will happen if you press the 'escape' key (code 27)?
		
		` It is also important to note that the "EXIT" command happens immediately,
		` and if you were to write anything directly after it,
		` your program would never get to those lines. For example:
		Print("You will never see this message")
		Sync()
		Sleep(1000)

 Endif
        
    
Loop
` "loop" returns the execution of your program to the command "do"


` this block will only execute if your program goes outside the main loop:
Print("goodbye")
Sync()
Sleep(1000)


` END is a command that stops the execution of your program,
` if the program actually reaches this point.
End

` Beginning of functions:

` To declare (create) a user function,
` start with the command "Function" , a space ,
` then the name of your function,
` followed by an open parenthesis "(", 
` then your "arguments", if there are any,
` followed by a close parenthesis ")".

Function PrintHello()
 ` this function just prints the word "hello".	
	Print("Hello.")
 ` do you think this function is actually necessary?
Endfunction 

Function PrintHelloTimes(times)
  ` this function will print the word hello a specified number of times 

` a "for" loop performs an action a certain number of times.
` the proper form is:
` the command "For" , then the name of a variable to use, 
` followed by an "=" sign, then a number (usually '1'), the command "to",
` and finally another number (but in this case, a variable, which represents a number)

` Then, you write the code for the action you wish to perform.

` finally, the command "Next" and the name of the variable you used for this loop.

 For t = 1 To times
	 Print("Hello?")
 Next t
	
` Each time through the loop, the variable 't' is increased by 1, 
` and when 't' reaches the value of 'times' (in this case, 5),
` the loop ends.
	
` Bonus points: what is the value of 't' after the loop ends?
	
Endfunction 


Function PrintAnythingTimes(a$,times)
	` this function will print any word, any number of times.
	
	For t = 1 To times
		Print(a$)
	Next t
	
Endfunction 


Function DoSomethingElse()
 ` Your program comes here when this function is called,
 ` and it will only return to the main loop when this function is complete.
 
 Repeat
	 ` This "repeat" loop will keep going until you release the CONTROL key.
	 Sync()
 Until GetRawKeyState(17)=0
 
 
 Do
 
  Print("Try pressing 'space', 'enter', 'shift', and 'control'")
 
  ` space key:
  If GetRawKeyState(32)=1
	  PrintHello()
  Endif
 
  ` enter key:
  If GetRawKeyState(13)=1
 	 PrintHelloTimes(5)
  Endif
 
  ` shift key:
  If GetRawKeyState(16)=1
 	  PrintAnythingTimes("HELLO!",10)
  Endif
 
  ` control key:
 If GetRawKeyPressed(17)=1
	 Print("(BYE!)")
	 Exit
 Endif
 
 ` this while loop will tell you what key you are pressing,
 ` *IF* it is not one of the ones you're supposed to be using.

 ` It continues as long as that condition is true,
 ` and exits as soon as the condition is not true (you are pressing one of the designated keys).

 While GetRawLastKey()>32
	 Print("I think you just pressed the " + Chr( GetRawLastKey() ) + " key.")
	 Print("")
	 Print("Seriously, try pressing 'space', 'enter', 'shift', and 'control'")
	 Sync()
 Endwhile
 
 Sync()
 
 Loop

Endfunction 
	

Function TitleScreen()

 ` everything that happens here is explained in other parts of this program.
 
 Do
	 
	 Print("")
	 Print("Welcome to Loops And Functions!")
	 Print("")
	 Print("You will only see this screen once.")
	 Print("")
	 Print("Press 'space' to get started.")
  
  Sync()
 
  If GetRawKeyState(32)=1 Then Exit
 
 Loop	
	
Endfunction 




