
// Project: Input Examples 
// Created: 2016-06-09

// set window properties
SetWindowTitle( "Input Examples" )
SetWindowSize( 1024, 768, 0 )

// Use new fonts
UseNewDefaultFonts( 1 )

// set display properties
SetVirtualResolution( 1024, 768 )
SetOrientationAllowed( 1, 1, 0, 0 )

` this project controls several objects with different types of input.

Local PointerX
Local PointerY
PointerX=100
PointerY=100
NewText(1,"Pointer",PointerX,PointerY)

Local KeyX
Local KeyY
KeyX=300
KeyY=300
NewText(2,"Keyboard",KeyX,KeyY)

Local JoyX
Local JoyY
JoyX=500
JoyY=500
NewText(3,"Joystick",JoyX,JoyY)

Local TiltX
Local TiltY
TiltX=700
TiltY=700
NewText(4,"Tilt",TiltX,TiltY)


` This command is useful when designing a PC game that uses joysticks:
CompleteRawJoystickDetection()


Do
    
 ` now we will look at each input type in turn,
 ` and move the approporiate text object around the screen:
    
 ` POINTER (mouse)
 PointerX = GetPointerX()
 PointerY = GetPointerY()
 SetTextPosition(1 , PointerX , PointerY)


 ` Keyboard (arrow keys)
 KeyX = KeyX + GetRawKeyState(39) - GetRawKeyState(37)
 KeyY = KeyY + GetRawKeyState(40) - GetRawKeyState(38)
 SetTextPosition(2 , KeyX , KeyY)

	` JOYSTICK:
	` This is actually a bit tricky.
	` If there is no joystick connected, and you try to detect it anyway,
	` the program will generate an error and stop.
	` So first, check to see if a joystick exists!
	If GetRawJoystickExists(1) = 1
		JoyX = JoyX + GetRawJoystickX(1) * 5
		JoyY = JoyY + GetRawJoystickY(1) * 5
		SetTextPosition(3,JoyX,JoyY)
	Else
		SetTextString(3,"No Joystick")	
	Endif

 ` tilt controls (mobile devices only)
 a$ = Lower( GetDeviceBaseName() )
 If a$ = "windows" Or a$ = "mac"
		
		` this is not a mobile device, so this won't work here.
		SetTextString(4,"No Tilt")
		
	Else
		
		TiltX = TiltX + GetDirectionX()
		TiltY = TiltY + GetDirectionY()
		
		SetTextPosition(4,TiltX,TiltY)
		
	Endif

 Sync()
    
Loop


Function NewText(n,a$,x,y)
	` this is an example of a user function that combines several commands
	` for something that is done repeatedly. 
	` In the end, it saves a lot of typing.
 CreateText(n,a$)
 SetTextSize(n,16)
 SetTextPosition(n,x,y)
 SetTextAlignment(n,1)
Endfunction 


