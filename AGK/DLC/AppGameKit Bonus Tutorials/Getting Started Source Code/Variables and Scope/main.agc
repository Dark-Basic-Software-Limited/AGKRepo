
// Project: Variables and Scope 
// Created: 2016-05-24

// set window properties
SetWindowTitle( "Variables and Scope" )
SetWindowSize( 1024, 768, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )


// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 1, 1 )


Global Name As String
Local Health As Integer
Global Distance As Float

Name = "Finn"
Health = 25
Distance = 0.0

Do

 ` now that you know about variables and types, look at these print statements:    
 Print(name)
 Print( "Health: " + Str(Health) )
 Print( "Distance: " + Str(distance,2) )
 ` the "Print()" statement can only handle one type of variable at a time,
 ` so in any case where you want to represent strings and values,
 ` you must first convert the values into temporary strings,
 ` using the "str()" command.

 ` notice the ",2" after distance. That limits the printing of a float variable to
 ` a certain number of places after the decimal point.
 ` Try changing or removing it, and observe the results. 


 Print("")

 Print("Press 'W' to walk")

 ` Print("Press 'R' to reset the character")


 If GetRawKeyPressed(87)=1	
	 ` 'Walk()' is a function that increases the distance walked, and decreases health:
	 Walk()		
 Endif


 If GetRawKeyPressed(82)=1
  ` this is where you would call the "ResetCharacter()" function.
	 
 Endif



 Sync()
 
Loop

` this program will never actually reach this point:
End


` user functions begin here:


Function Walk()
	
	` This decreses health by 1 for every step taken:
	Health = Health - 1
	
	` This increases the distance walked:
	Distance = Distance + 1.5	
	
	` since there is no "loop" or "exit condition" here,
	` this function returns immediately to where it was called from
	
Endfunction


Function ResetCharacter(NewName$,NewHealth)
 ` fill in this function to rename the character,
 ` and assign them a new value to Health.
 ` Distance should be reset to 0.0
 

Endfunction 

