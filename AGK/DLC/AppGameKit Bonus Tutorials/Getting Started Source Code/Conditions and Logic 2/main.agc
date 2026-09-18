
// Project: Conditions and Logic 2 
// Created: 2016-06-09

` Instructor Version
` This code shows the solutions to the suggested activities

` 1. Introduce "Swimsuit" as a piece of clothing.
` 2. If the swimsuit is worn in a cold place, set temperature to "Freezing!"
` 3. If the swimsuit is worn on the beach, set temperature to "Just right"
` 4. If the coat is worn on the beach, set temperature to "Roasting"
` 5. create a selection process so that when the program is run,
` the player can choose their location and clothing,
` and they are shown the resulting temperature.

// set window properties
SetWindowTitle( "Conditions and Logic 2" )
SetWindowSize( 1024, 768, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 1, 1 )


Local Location As String
Local Clothes As String
Local Temperature As String

` Assign starting values to the variables:
Location = "Freezer"
Clothes = "Jeans"


` this variable will be used to determine which key has been pressed:
Local a$ As String


Do
	
 ` There are many ways this could be done.
 ` Students have choices when it comes to display options and input methods.
 ` As long as the goal is accomplished, it is a success.
	
 Print("")
	
 Print(" Location: "+Location)
 Print(" Clothes: "+Clothes)
 Print(" Temperature: " + GetTemperature( Location , Clothes ) )

 Print("")
 Print("To make changes, press:")
 Print("")

 Print("1. Antarctica")
 Print("2. Freezer")
 Print("3. Home")
 Print("4. The Beach")

 Print("")

 Print("7. Jeans")
 Print("8. Coat")
 Print("9. Swimsuit")

 ` Here is an alternate method to detecting input, and choosing what to do with it.
 ` First, store the code of the last key pressed in a variable, 'a':

 a = GetRawLastKey()

` Then use the conditional "select" statement to test for many different 
` possible values of a:

 Select a

  Case 49
  	` this is the case where the player pressed the '1' key:
  	location = "Antarctica"
  Endcase

  Case 50
  	location = "Freezer"
  Endcase

  Case 51
  	location = "Home"
  Endcase

  Case 52
	  location = "Beach"
  Endcase

  Case 55
  	Clothes = "Jeans"
  Endcase

  Case 56
  	Clothes = "Coat"
  Endcase

  Case 57
	  Clothes = "Swimsuit"
  Endcase

  Case Default	
  	` If the variable tested does not fall into any of the categories allowed for above,
  	` execution will come here.
	
	  ` It is not necessary to have a default case, but it can be useful.
	
	  ` This is equivalent to telling the user:
  	` "You did not press a key that I recognize".	
  Endcase

 Endselect

 Sync()

Loop
 

Function GetTemperature(Location as string, Clothes as string)

Local Temperature As String

Temperature = "Average"

If ( Location = "Antarctica" ) Or ( Location = "Freezer" )
			
	If Clothes <> "Coat"
		
		Temperature = "Very Cold"
		
		If Clothes = "Swimsuit" Then Temperature = "Freezing!"
		
	Else
		
		Temperature = "Chilly"
		
	Endif

Else
	
	If Location = "Beach"
		
		Temperature = "Hot"
		
		If Clothes = "Swimsuit" Then Temperature = "Just Right"
		
		If Clothes = "Coat" Then Temperature = "Roasting"
		
	Endif
	
Endif

` Notice that this function never tests for the location "Home",
` But since Temperature is given a starting value of "Average",
` we always see "average" as the temperature while at home.

Endfunction Temperature
