;    Description: Calculate the width (or Height) when you resize a box
;         Author: Tommy
;           Date: 27-01-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28693
;-----------------------------------------------------------------------------
;Programmierer: Tommy
;Geeignet: Für Anfänger
;Lizenz: Code kann frei benutzt, verändert, verteilt werden, keine Namensnennung notwendig

; Übergebene Breite und Hoehe werden proportional vergroessert oder verkleinert
; Entweder newWidth oder newHeight als neue Groesse angeben
; das andere #PB_Any
Procedure PropSize(oldWidth, oldHeight, newWidth, newHeight = #PB_Any)
  If newHeight = #PB_Any
    ProcedureReturn newWidth * oldHeight / oldWidth
  Else
    ProcedureReturn newHeight * oldWidth / oldHeight
  EndIf
EndProcedure


;-Example
CompilerIf #PB_Compiler_IsMainFile
  CompilerSelect 1;2 Examples
      ;-Example 1
    CompilerCase 1;Height
                  ; - Beispiel als Bild -
      CreateImage(0, 200, 100, 24, RGB(0, 0, 255))
      
      Define event
      
      OpenWindow(0, 0, 0, 700, 400, "", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      
      TextGadget(#PB_Any, 50, 50, 200, 20, "Alte Größe")
      TextGadget(#PB_Any, 300, 50, 200, 20, "Neue Größe")
      
      ImageGadget(0, 50, 100, ImageWidth(0), ImageHeight(0), ImageID(0))
      ImageGadget(1, 300, 100, 0, 0, 0)
      
      ResizeImage(0, 350, PropSize(ImageWidth(0), ImageHeight(0), 350))
      SetGadgetState(1, ImageID(0))
      
      Repeat
        event = WaitWindowEvent()
      Until event = #PB_Event_CloseWindow
      ;-Example 2
    CompilerCase 2;Width      
                  ; - Beispiel als Bild -
      CreateImage(0, 200, 100, 24, RGB(0, 0, 255))
      
      Define event
      
      OpenWindow(0, 0, 0, 700, 400, "", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      
      TextGadget(#PB_Any, 50, 50, 200, 20, "Alte Größe")
      TextGadget(#PB_Any, 300, 50, 200, 20, "Neue Größe")
      
      ImageGadget(0, 50, 100, ImageWidth(0), ImageHeight(0), ImageID(0))
      ImageGadget(1, 300, 100, 0, 0, 0)
      
      ResizeImage(0, PropSize(ImageWidth(0), ImageHeight(0), #PB_Any, 50), 50)
      SetGadgetState(1, ImageID(0))
      
      Repeat
        event = WaitWindowEvent()
      Until event = #PB_Event_CloseWindow
  CompilerEndSelect
  
CompilerEndIf


; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 28
; Folding = -
; EnableUnicode
; EnableXP
; EnableCompileCount = 1
; EnableBuildCount = 0
; EnableExeConstant