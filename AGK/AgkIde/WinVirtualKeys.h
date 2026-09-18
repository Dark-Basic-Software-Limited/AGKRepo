#ifndef _H_AGK_WINVIRTUALKEYS_
#define _H_AGK_WINVIRTUALKEYS_

// The IDE stores keyboard shortcut preferences as Win32 virtual-key codes.
// On Windows these come from windows.h; on other platforms we define the
// subset the IDE actually uses so the shared shortcut code compiles.

#ifndef AGK_WINDOWS

#define VK_BACK			0x08
#define VK_TAB			0x09
#define VK_RETURN		0x0D
#define VK_ESCAPE		0x1B
#define VK_SPACE		0x20
#define VK_PRIOR		0x21
#define VK_NEXT			0x22
#define VK_END			0x23
#define VK_HOME			0x24
#define VK_LEFT			0x25
#define VK_UP			0x26
#define VK_RIGHT		0x27
#define VK_DOWN			0x28
#define VK_INSERT		0x2D
#define VK_DELETE		0x2E
#define VK_ADD			0x6B
#define VK_SUBTRACT		0x6D
#define VK_F1			0x70
#define VK_F2			0x71
#define VK_F3			0x72
#define VK_F4			0x73
#define VK_F5			0x74
#define VK_F6			0x75
#define VK_F7			0x76
#define VK_F8			0x77
#define VK_F9			0x78
#define VK_F10			0x79
#define VK_F11			0x7A
#define VK_F12			0x7B
#define VK_OEM_1		0xBA
#define VK_OEM_PLUS		0xBB
#define VK_OEM_COMMA	0xBC
#define VK_OEM_MINUS	0xBD
#define VK_OEM_PERIOD	0xBE
#define VK_OEM_2		0xBF
#define VK_OEM_3		0xC0
#define VK_OEM_4		0xDB
#define VK_OEM_5		0xDC
#define VK_OEM_6		0xDD
#define VK_OEM_7		0xDE

#endif // AGK_WINDOWS

#endif // _H_AGK_WINVIRTUALKEYS_
