XIncludeFile("./BucketFill_Image.pb")
XIncludeFile("./BucketFill_Canvas.pb")

; - Demo - Texture or photo brush -
;   Left mouse key = normal brush - Right mouse key = fine brush

UsePNGImageDecoder() : UseJPEGImageDecoder()

EnableExplicit

Define window_0, win_event, canvas_ID, image_ID, window_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point
Define x, y, x1, y1, rnd_x, rnd_Y, snap, i, ii, alpha
Define *drawing_buffer_grabed_canvas, *drawing_buffer
Define path$

#SoilWall="./BucketFill_Image_Set/soil_wall.jpg"

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, 650, 500, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, 0, 0, 650, 500)

CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf

; - Call function #1 -
path$=#SoilWall
texture_ID=LoadImage(#PB_Any, path$)

If ImageWidth(texture_ID)>GadgetWidth(canvas_ID)
  ResizeImage(texture_ID, GadgetWidth(canvas_ID), #PB_Ignore)
EndIf

If ImageHeight(texture_ID)>GadgetHeight(canvas_ID)
  ResizeImage(texture_ID, #PB_Ignore, GadgetHeight(canvas_ID))
EndIf

result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID)
BucketFill_Canvas::ErrorCheck_BF(result)

path$=OpenFileRequester("Select a picture", "", "", 0)
If path$="" : End : EndIf

texture_ID=LoadImage(#PB_Any, path$)

If ImageWidth(texture_ID)>GadgetWidth(canvas_ID)
  ResizeImage(texture_ID, GadgetWidth(canvas_ID), #PB_Ignore)
EndIf

If ImageHeight(texture_ID)>GadgetHeight(canvas_ID)
  ResizeImage(texture_ID, #PB_Ignore, GadgetHeight(canvas_ID))
EndIf

image_ID=CreateImage(#PB_Any, GadgetWidth(canvas_ID), GadgetHeight(canvas_ID))

; - Call function #2 -
result=BucketFill_Image::BF(-2, image_ID, texture_ID)
BucketFill_Image::ErrorCheck_BF(result) 
HideWindow(window_ID, 0)

StartDrawing(CanvasOutput(canvas_ID))
DrawingMode(#PB_2DDrawing_Transparent)
DrawText(20, 20, "A VERY COOL FUNCTION !", -1)
DrawText(20, 40, "BUCKET FILL ADVANCED", -1)
DrawText(20, 60, "www.quick-aes-256.de", -1)
DrawText(20, 80, "www.nachtoptik.de", -1)
DrawText(220, 20, "Sprites simple for Canvas", -1)
DrawText(220, 40, "Also FloodFill with texture support", -1)
StopDrawing()

i=0 : ii=0
Repeat
  win_event=WaitWindowEvent(1)
  If snap And (EventType()=#PB_EventType_LeftButtonUp Or EventType()=#PB_EventType_RightButtonUp) : snap=0 : EndIf
  If snap
    If snap=1
      Select i
        Case 0 To 50
          rnd_x=40-Random(80)
        Case 0 To 100
          rnd_x=50-Random(100)
      EndSelect
      Select ii
        Case 0 To 50
          rnd_y=40-Random(80)
        Case 0 To 100
          rnd_y=50-Random(100)
      EndSelect
      alpha=200+Abs((rnd_x+rnd_y)/2) : If alpha=>255: alpha=255 : EndIf
    Else
      rnd_x=-5
      rnd_y=-5
      alpha=200
    EndIf
    i+1 : ii+1 : If i>100 : i=0 : EndIf : If ii>100 : ii=0 : EndIf
    
    ; - Call function #3 -
    result=BucketFill_Canvas::BF(alpha,
                                 canvas_ID, window_ID, image_ID, ; Sprite mode                            
                                 -1,                             ; Set to -1
                                 -1,                             ; 
                                 x+rnd_x,                        ; x Startposition texture output
                                 y+rnd_y,                        ; y
                                 Random(10, 1),                  ; x Endposition texture output
                                 Random(10, 1),                  ; y
                                 x+rnd_x,                        ; x Startposition texture output inside the texture
                                 y+rnd_y,                        ; y
                                 0,                              ; x Endposition texture output inside the texture
                                 0)                              ; y
    BucketFill_Canvas::ErrorCheck_BF(result)
  EndIf
  
  If win_event=#PB_Event_Gadget And EventGadget()=canvas_ID
    If snap Or EventType()=#PB_EventType_LeftButtonDown Or EventType()=#PB_EventType_RightButtonDown
      x=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseX)
      y=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseY)
      If Not snap 
        If EventType()=#PB_EventType_LeftButtonDown
          snap=1
        Else
          snap=2
          x1=x : y1=y
        EndIf
      EndIf
    EndIf
  ElseIf win_event=#PB_Event_CloseWindow
    Break
  EndIf
ForEver
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 16
; Folding = -
; EnableXP
; DisableDebugger
; EnableUnicode