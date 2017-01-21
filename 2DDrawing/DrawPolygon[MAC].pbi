;    Description: Drawing a polygon using Cocoa
;         Author: wilbert
;           Date: 2012-07-10
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=417520#p417520
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

    Procedure DrawPolygon(Array Points.NSPoint(1), x.CGFloat, y.CGFloat, LineColor.l, LineWidth.CGFloat = 1.0, FillColor.l = 0)
     
      Protected.CGFloat R,G,B,A, M = 1 / 255, SX = 1, SY = -1
      Protected Path, Transform
     
      R = Red(LineColor)*M : G = Green(LineColor)*M : B = Blue(LineColor)*M : A = Alpha(LineColor)*M
      CocoaMessage(0, CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @R, "green:@", @G, "blue:@", @B, "alpha:@", @A), "setStroke")
      R = Red(FillColor)*M : G = Green(FillColor)*M : B = Blue(FillColor)*M : A = Alpha(FillColor)*M
      CocoaMessage(0, CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @R, "green:@", @G, "blue:@", @B, "alpha:@", @A), "setFill")
     
      y - OutputHeight()
      Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
      CocoaMessage(0, Transform, "scaleXBy:@", @SX, "yBy:@", @SY)
      CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
     
      Path = CocoaMessage(0, 0, "NSBezierPath bezierPath")
      CocoaMessage(0, Path, "appendBezierPathWithPoints:", @Points(), "count:", ArraySize(Points()) + 1)
      CocoaMessage(0, Path, "closePath")
      CocoaMessage(0, Path, "transformUsingAffineTransform:", Transform)
      CocoaMessage(0, Path, "setLineWidth:@", @LineWidth)
      CocoaMessage(0, Path, "fill")
      CocoaMessage(0, Path, "stroke")
     
    EndProcedure



   
;-Example
    CompilerIf #PB_Compiler_IsMainFile
       Dim PP.NSPoint(2)
    PP(0)\x = 20 : PP(0)\y = 10
    PP(1)\x = 30 : PP(1)\y = 30
    PP(2)\x = 10 : PP(2)\y = 30

    If OpenWindow(0, 0, 0, 200, 200, "Polygon Drawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      If CreateImage(0, 200, 200) And StartDrawing(ImageOutput(0))
        DrawPolygon(PP(), 10, 10, 0, 0, $ff0000ff)
        DrawPolygon(PP(), 20, 20, $ff00ff00, 2.0, $ff00ffff)
        StopDrawing()
        ImageGadget(0, 0, 0, 200, 200, ImageID(0))
      EndIf
     
      Repeat
        Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
    EndIf

CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
