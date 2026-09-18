
// Project: The 2D Grid
// Created: 2016-05-25

// set window properties
SetWindowTitle( "The 2D Grid Part 2" )
SetWindowSize( 800, 600, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 800,600 )
SetOrientationAllowed( 1, 1, 1, 1 )


Local x As Integer
Local y As Integer

` the screen is 800x600 , 400,300 is the center:
x = 400
y = 300


Local Col As Integer
` the variable "Col" will store a color value that we can draw with.
` It uses "R,G,B Color", which is a color system that can create millions 
` of colors using values of 0-255, for red, green, and blue.
Col = MakeColor(99,33,255)

Local OriginX
Local OriginY
    
OriginX = 0
OriginY = 0

Local d As Float

Do    
    
 ` these commands store the current position of the mouse pointer in x and y:
 x = GetPointerX()
 y = GetPointerY()

 ` this draws a line from the Origin (0,0) to the position of the mouse pointer:
 DrawLine(OriginX,OriginY,x,y,Col,Col)

 ` this function will calculate and return the 
 ` straight line distance between the origin and the current position:
 d = Distance(OriginX,OriginY,x,y)

 ` this prints the numerical values of X & Y on the screen:
 Print("X = "+str(x))
 Print("Y = "+str(y))
 Print("")
 Print("Distance: "+str(d))

 ` detect the mouse-click:
 If GetPointerPressed()=1
	 ` reset the origin to the current location of the mouse:
		OriginX = x
		OriginY = y
	Endif

 Sync()
 
Loop


Function Distance(x,y,a,b)
` this function will use the pythagorean theorem to calculate
` distance between 2 points. a squared plus b squared equals c squared
	
	` Notice that the variables that come into the function
	` can have different names:
	` the "origin" variables are called x & y here,
	` and the x & y that were sent are now held in a & b.
	
	Local Dist As Float
	Local xd As Integer 
	Local yd As Integer
	
	` "xd" is the distance between the 2 points along the x axis,
	` and "yd" is the y distance.
	xd = ( x - a ) * ( x - a )
	yd = ( y - b ) * ( y - b )
	
	` this takes the square root of the sum of the other 2 "sides":
	Dist = Sqrt( (xd + yd) )
	
	` putting the variable "Dist" after "Endfunction"
	` will cause this function to return the calculated distance
	` as a variable.
	` Try taking it out, and see what happens:
	
Endfunction Dist
