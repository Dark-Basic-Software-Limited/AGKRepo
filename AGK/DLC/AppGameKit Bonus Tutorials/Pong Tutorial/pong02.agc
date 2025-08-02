// Project: pong 
// An AppGameKit tutorial
// Created: 2017-04-04


// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "pong" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//define 3 variables
// Global variables can be used by any part of your code.
// Local (or variables that aren't defined as Global) are treated as one off and aren't shared by your 
//game code. For now we'll only be looking at Globals.
Global MyString as String
//once defined, let's give each one a value
MyString="Hello" // String variables contain text. To define something as text enclose it between ""
Global MyInteger as Integer
MyInteger=12345 // Numeric values don't need "" and are entered normally
Global MyFloat as Float
MyFloat=1.2345 // Floats accept floating point numbers.


do
    
	Print(MyString)
	Print(MyInteger)
	Print(MyFloat)
    Print( ScreenFPS() )
    Sync()
loop
