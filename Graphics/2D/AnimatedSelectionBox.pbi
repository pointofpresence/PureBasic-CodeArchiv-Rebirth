;    Description: 
;         Author: walbus (improved by NicTheQuick)
;           Date: 2013-07-29
;     PB-Version: 5.50 beta 1
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=314707
; -----------------------------------------------------------------------------

Procedure Linie(x.i, y.i, xx.i, yy.i, maske.a, color.l, lr.i)
  
  ; Angepasster Linienalgorithmus den Udo Kessler 2006 hier im Board postete
  ; ( Lineare Interpolation )
  ; Danke dafür !
  
  ; Achtung Plot unterstützt kein Clipping
  
  Protected a.i, dx.i, dy.i, addval.i = 1, shift.i = maske
  Protected *plotX.Integer = @xx, *plotY.Integer = @yy
  
  If Abs(x - xx) <= Abs(y - yy) ; Winkel größer 45°
    Swap x, y
    Swap xx, yy
    *plotX = @yy
    *plotY = @xx
  EndIf
  
  If x < xx
    Swap x, xx
    Swap y, yy
  EndIf
  
  If y < yy
    y = 2 * yy - y
    addval = -1
  EndIf
  
  dy = 2 * (y - yy)
  a  = x - xx
  dx = 2 * a
  
  While xx <= x
    
    If shift & 1
      Plot(*plotX\i, *plotY\i, color)
    EndIf
    
    If lr
      shift = (shift << 1) | ((shift >> 7) & $7f)
    Else
      shift = ((shift >> 1) & $7F) | (shift << 7)
    EndIf
    
    xx + 1
    a - dy
    If a <= 0
      a + dx
      yy + addval
    EndIf
  Wend
  
EndProcedure

;-------------------------------------------

Procedure Liniego(x.i, y.i, xx.i, yy.i, color.l, move.i, lr.i)
  
  Select move
    Case 0
      Linie(x, y, xx, yy, %11100111, color, lr)
    Case 1
      Linie(x, y, xx, yy, %11111001, color, lr)
    Case 2
      Linie(x, y, xx, yy, %10011111, color, lr)
  EndSelect
  
EndProcedure

;-------------------------------------------

Procedure Boxgo(x.i, y.i, xx.i, yy.i, color.l, move.i)
  
  xx - 1 : yy - 1
  Liniego(x, y, x + xx, y, color, move, 1)
  Liniego(x + xx, y, x + xx, y + yy, color, move, 1)
  Liniego(x, y + yy, x + xx, y + yy, color, move, 0)
  Liniego(x, y + yy, x, y, color, move, 0)
  
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  Define.i move = 0
  
  ExamineDesktops()
  
  If OpenWindow (0, DesktopWidth(0) / 2 - 200, DesktopHeight(0) / 2 - 250, 500, 250, "")
    
    CanvasGadget(0, 0, 0, 500 , 400)
    AddWindowTimer(0, 0, 100)
    
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow:
          Break
          
        Case #PB_Event_Timer
          If EventTimer() = 0
            If StartDrawing(CanvasOutput(0))
              DrawingMode(#PB_2DDrawing_Outlined) ; Zeichnen von Flächen erfolgt nicht ausgefüllt
              Box   (150, 70, 200, 100, $FFFFFF)
              Box   (149, 69, 202, 102, $FFFFFF)
              Box   (144, 64, 212, 112, $FFFFFF)
              Boxgo (150, 70, 200, 100, $FF, move)
              Boxgo (149, 69, 202, 102, $FF, move)
              Boxgo (144, 64, 212, 112, $0 , move)
              
              StopDrawing()
            EndIf
            
            move + 1 ; Animations Counter für bewegte Linien
            If move > 2
              move = 0
            EndIf
          EndIf
          
      EndSelect
      
    ForEver
    
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
