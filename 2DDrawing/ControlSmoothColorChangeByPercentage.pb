;    Description: Control smooth color change by percentage
;         Author: Derren
;           Date: 2016-05-08
;     PB-Version: 4.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29465
; -----------------------------------------------------------------------------

Enumeration
   #Trackbar
   #Text
   #Canvas
EndEnumeration

OpenWindow(0, 0, 0, 400, 300, "Rot -> Grün", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)

TrackBarGadget(#Trackbar, 5, 5, 300, 40, 0, 100)
TextGadget(#Text, 315, 10, 80, 20, "0%")
CanvasGadget(#Canvas, 5, 50, 390, 245)

Define percentage, color

Repeat

   Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
         End
      Case #PB_Event_Gadget
         If EventGadget()=#Trackbar

            percentage = GetGadgetState(#Trackbar)
            SetGadgetText(#Text, Str(percentage) +"%")

            color = ($FF-percentage) + Int(($FF*(percentage/100.0)))<<8

            StartDrawing(CanvasOutput(#Canvas))
            Box(0, 0, 390, 245, color)
            DrawText(5, 5, "$" + RSet(Hex(color), 6, "0"))
            StopDrawing()

         EndIf
   EndSelect
ForEver
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
