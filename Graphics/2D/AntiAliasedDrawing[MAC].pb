;    Description: Anti-aliased drawing onto an image using the NSColor, NSGradient and NSBezierPath classes. (This also works on CanvasGadget when CanvasOutput(#Gadget) is used)
;         Author: wilbert
;           Date: 2012-09-29
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=392072#p392072
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

; *** Create image and draw onto it ***

CreateImage(0, 300, 200, 32, #PB_Image_Transparent)

StartDrawing(ImageOutput(0))

Crayons = CocoaMessage(0, CocoaMessage(0, 0, "NSColorList colorListNamed:$", @"Crayons"), "retain")

ColorGreen = CocoaMessage(0, 0, "NSColor greenColor")
ColorBrown = CocoaMessage(0, 0, "NSColor brownColor")
ColorMocha = CocoaMessage(0, Crayons, "colorWithKey:$", @"Mocha")
CocoaMessage(0, ColorMocha, "setStroke"); set stroke color to Mocha

Gradient = CocoaMessage(0, 0, "NSGradient alloc"); create gradient from green to brown
CocoaMessage(@Gradient, Gradient, "initWithStartingColor:", ColorGreen, "endingColor:", ColorBrown)
CocoaMessage(0, Gradient, "autorelease")
GradientAngle.CGFloat = 315

Rect.NSRect
Rect\origin\x = 5
Rect\origin\y = 5
Rect\size\width = 290
Rect\size\height = 190

RadiusX.CGFloat = 20
RadiusY.CGFloat = 20

Path = CocoaMessage(0, 0, "NSBezierPath bezierPathWithRoundedRect:@", @Rect, "xRadius:@", @RadiusX, "yRadius:@", @RadiusY)
CocoaMessage(0, Gradient, "drawInBezierPath:", Path, "angle:@", @GradientAngle)
CocoaMessage(0, Path, "stroke")

StopDrawing()


; *** Show the result ***

If OpenWindow(0, 0, 0, 320, 220, "Drawing", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ImageGadget(0, 10, 10, 300, 200, ImageID(0))
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
