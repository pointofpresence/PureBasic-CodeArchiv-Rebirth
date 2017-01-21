;    Description: Capture the main display into an image
;         Author: wilbert
;           Date: 2012-02-01
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=402758#p402758
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

ImportC ""
  CGDisplayCreateImage(displayID)
  CGImageGetHeight(image)
  CGImageGetWidth(image)
  CGImageRelease(image)
  CGMainDisplayID()
EndImport

Define CGImage, NSImage, ImageSize.NSSize

CGImage = CGDisplayCreateImage(CGMainDisplayID()); get CGImage from main display
ImageSize\width = CGImageGetWidth(CGImage)
ImageSize\height = CGImageGetHeight(CGImage)
NSImage = CocoaMessage(0, CocoaMessage(0, 0, "NSImage alloc"), "initWithCGImage:", CGImage, "size:@", @ImageSize); convert CGImage into NSImage
CGImageRelease(CGImage)

CreateImage(0, ImageSize\width, ImageSize\height); Create a PureBasic image
StartDrawing(ImageOutput(0))
DrawImage(NSImage, 0, 0); draw the NSImage object
StopDrawing()

CocoaMessage(0, NSImage, "release"); release the NSImage

If OpenWindow(0, 0, 0, 320, 220, "Image from display", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ImageGadget(0,  10, 10, 300, 200, ImageID(0))
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
