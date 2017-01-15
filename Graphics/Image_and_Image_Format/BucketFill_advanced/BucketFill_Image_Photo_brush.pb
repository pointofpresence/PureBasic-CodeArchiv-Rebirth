XIncludeFile("./BucketFill_Image.pb")
XIncludeFile("./BucketFill_Canvas.pb")

; - Demo - photo brush -
;   This is a function for fine photo and texture brush, dia shows and softly animations

UsePNGImageDecoder() : UseJPEGImageDecoder()

EnableExplicit

Define window_0, win_event, canvas_ID, image_ID, window_ID, texture_ID, result
Define canvas_x, canvas_y, canvas_width, canvas_height, point, mode
Define  snap, i, ii, transparence
Define *drawing_buffer_grabed_canvas, *drawing_buffer
Define x, y, output_width, output_height
Define path$

#SoilWall="./Bucket_fill_image_set/soil_wall.jpg"

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, 950, 700, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, 0, 0, 950, 700)

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

path$=OpenFileRequester("Select a picture or texture as brush", "", "", 0)
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

output_width=400; Output sze
output_height=320

Repeat
  win_event=WaitWindowEvent ()
  
  If win_event=#PB_Event_Gadget And EventGadget ()=canvas_ID
    If EventType()=#PB_EventType_LeftButtonDown Or
       (EventType()=#PB_EventType_MouseMove And GetGadgetAttribute(canvas_ID, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
      
      x=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseX)
      y=GetGadgetAttribute(canvas_ID, #PB_Canvas_MouseY)
      
      mode=1 ; With seamless embedding
             ; mode=0 ; without seamless embedding, as sample for Dia show
      
      BucketFill_Canvas::PhotoBrush_BF(mode, canvas_ID, window_ID, texture_ID, ; For canvas
                                       x-output_width/2,                       ; Output pos x
                                       y-output_height/2,                      ; Output pos y
                                       output_width,                           ; Texture or image width
                                       output_height,                          ; Texture or image height
                                       100,                                    ; Percent visibility
                                       5)                                      ; Delay for animation         
    EndIf
  EndIf
  
Until win_event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.51 (Windows - x64)
; EnableXP
; DisableDebugger
