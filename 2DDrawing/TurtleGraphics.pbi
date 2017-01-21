;    Description: Functions to generate turtle graphics
;         Author: Lothar Schirm
;           Date: 2013-08-06
;     PB-Version: 5.50 beta 1
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27083
; -----------------------------------------------------------------------------

;==============================================================================
; Turtle.pbi
; Turtle-Grafik
; Erstellt am 02.05.2013
; Letzte Bearbeitung am 05.08.13
;==============================================================================

; Diese Variablen müssen zu Anfang initialisiert werden (TurtleAngle in Grad),
; TurtleX, TurtleY = Pixelkoordinaten (ganzzahlig)
Global.d TurtleAngle
Global TurtleX, TurtleY

Procedure TurtleMove(distance, PenDown = #True)
  ; Bewegt die Schildkröte um die angegebene Distanz.
  ; Falls PenDown = #True, wird eine Linie gezeichnet.

  Protected dx, dy

  dx = distance * Cos(Radian(TurtleAngle))
  dy = -distance * Sin(Radian(TurtleAngle))
  If PenDown = #True
    LineXY(TurtleX, TurtleY, TurtleX + dx, TurtleY + dy)
  EndIf
  TurtleX = TurtleX + dx
  TurtleY = TurtleY + dy

EndProcedure

Procedure TurtleMoveTo(x, y, PenDown = #True)
  ; Bewegt die Schildkröte zur Position (x, y).
  ; Falls PenDown = #True, wird eine Linie gezeichnet.

  If PenDown = #True
    LineXY(TurtleX, TurtleY, x, y)
  EndIf
  TurtleX = x
  TurtleY = y

EndProcedure

Procedure TurtleTurn(angle.d)
  ; Dreht die Richtung am den angegebenen Winkel in Grad.
  ; angle > 0: Linksdrehung
  ; angle < 0: Rechtsdrehung

  TurtleAngle = TurtleAngle + angle

EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  Enumeration
    #Window_0
  EndEnumeration
  
  Enumeration
    #Canvas_0
    #Canvas_1
    #Canvas_2
    #Canvas_3
  EndEnumeration
  
  Define i, j, d, phi, event
  
  ; Mach ein Fenster mit vier CanvasGadgets auf:
  OpenWindow(0, 0, 0, 800, 800, "Turtelei", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(#Canvas_0, 0, 0, 400, 400, #PB_Canvas_Border)
  CanvasGadget(#Canvas_1, 400, 0, 400, 400, #PB_Canvas_Border)
  CanvasGadget(#Canvas_2, 0, 400, 400, 400, #PB_Canvas_Border)
  CanvasGadget(#Canvas_3, 400, 400, 400, 400, #PB_Canvas_Border)
  
  ; Rechteckige Spirale:
  StartDrawing(CanvasOutput(#Canvas_0))
  d = 1
  TurtleAngle = 0
  TurtleX = 200
  TurtleY = 200
  For i = 1 To 255
    FrontColor(RGB(255 - i, 0, i))
    TurtleMove(d)
    TurtleTurn(-90)
    d = d + 1
  Next
  StopDrawing()
  
  ; Jetzt dreht sich die Spirale:
  StartDrawing(CanvasOutput(#Canvas_1))
  d = 1
  TurtleAngle = 0
  TurtleX = 200
  TurtleY = 200
  For i = 1 To 255
    FrontColor(RGB(255 - i, 0, i))
    TurtleMove(d)
    ;das ist der Dreheffekt:
    TurtleTurn(-91)
    d = d + 1
  Next
  StopDrawing()
  
  ; Polygone:
  StartDrawing(CanvasOutput(#Canvas_2))
  d = 1
  TurtleAngle = 0
  For i = 1 To 180 Step 5
    FrontColor(RGB(i, 255 - i, 0))
    TurtleX = 200 - d / 2
    TurtleY = 200 - 0.9 * d
    For j = 1 To 6
      TurtleMove(d)
      TurtleTurn(-60)
    Next
    d = d + 5
  Next
  StopDrawing()
  
  ; Kreiselnde Kreise:
  StartDrawing(CanvasOutput(#Canvas_3))
  d = 7
  FrontColor(RGB(0, 0, 255))
  For phi = 0 To 360 Step 12
    TurtleAngle = phi
    TurtleX = 200
    TurtleY = 200
    For i = 1 To 72
      TurtleMove(d)
      TurtleTurn(5)
    Next
  Next
  StopDrawing()
  
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  
  End
  
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
