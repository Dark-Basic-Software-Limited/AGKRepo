
// Project: Conditions and Logic 
// Created: 2016-06-09

// set window properties
SetWindowTitle( "Conditions and Logic" )
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
Temperature = "Average"


` the parentheses below are not necessary,
` but are given to show exactly what conditions are being checked.

If ( Location = "Antarctica" ) Or ( Location = "Freezer" )
			
	If Clothes <> "Coat"
		
		Temperature = "Very Cold"
		
	Else
		
		Temperature = "Chilly"
		
	Endif

Else
	
	If Location = "Beach"
		
		Temperature = "Hot"
		
	Endif
	
Endif


Do
	
	Print("Location: "+Location)
	Print("Clothes: "+Clothes)
	Print("Temperature: "+Temperature)

Sync()

Loop
