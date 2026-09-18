
// Project: The 2D Grid
// Created: 2016-05-25

// set window properties
SetWindowTitle( "The 2D Grid Part 1" )
SetWindowSize( 800, 600, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 800,600 )
SetOrientationAllowed( 1, 1, 1, 1 )

Local x
Local y

` the screen is 800x600 , 400,300 is the center:
x = 400
y = 300


Local Col As Integer
` the variable "Col" will store a color value that we can draw with.
` It uses "R,G,B Color", which is a color system that can create millions 
` of colors using values of 0-255, for red, green, and blue.
Col = MakeColor(99,33,255)

 
Do    
    
 ` these commands store the current position of the mouse pointer in x and y:
 x = GetPointerX()
 y = GetPointerY()

 ` this draws a line from the Origin (0,0) to the position of the mouse pointer (x,y), 
 ` in a given color (col) :
 DrawLine(0,0,x,y,Col,Col)

 ` this prints the numerical values of X & Y on the screen:
 Print("X = "+str(x))
 Print("Y = "+str(y))
    

 Sync()
 
Loop
