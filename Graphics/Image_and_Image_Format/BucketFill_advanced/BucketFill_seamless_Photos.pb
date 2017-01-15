
XIncludeFile("./BucketFill_Image.pb")
XIncludeFile("./BucketFill_Canvas.pb")

;- Demo - Seamless photos -

CompilerIf #PB_Compiler_IsMainFile
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  
  EnableExplicit
  
  Define window_0, win_event, canvas_ID, window_ID, texture_ID, result
  Define canvas_x, canvas_y, canvas_width, canvas_height, point
  Define path$, path_1$
  
  Define SoilWall$="./Bucket_fill_image_set/soil_wall.jpg"
  
  ; Presets
  canvas_x=50
  canvas_y=50
  canvas_width=1100
  canvas_height=750
  
  path$=OpenFileRequester("Select a picture", "", "", 0)
  If path$="" : End : EndIf
  
  window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                       #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)
  
  StartDrawing(CanvasOutput(canvas_ID))
  Box(0, 0, canvas_width, canvas_height, 0) ; Black preset for the canvas
  DrawingMode(#PB_2DDrawing_Transparent)
  DrawText(20, 5, "A VERY COOL FUNCTION", -1)
  DrawText(20, 25, "BUCKET FILL ADVANCED", -1)
  DrawText(20, 45, "WITH FLOOD FILL FUNCTION", -1)
  DrawText(20, 65, "www.quick-aes-256.de", -1)
  DrawText(20, 85, "www.nachtoptik.de", -1)
  StopDrawing()
  
  path_1$=SoilWall$
  texture_ID=LoadImage(#PB_Any, path_1$)
  ; - Call function #1 
  result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID)
  BucketFill_Canvas::ErrorCheck_BF(result)
  
  texture_ID=LoadImage(#PB_Any, path$)
  
  ; - Call function #2 
  BucketFill_Canvas::PhotoBrush_BF(1, canvas_ID, window_ID, texture_ID, ; For canvas
                                   10,                                  ; Output pos x
                                   250,                                 ; Output pos y
                                   250,                                 ; Texture or image width
                                   220,                                 ; Texture or image height
                                   50,                                  ; Percent visibility
                                   50)                                  ; Delay for animation)                                 
  
  ; - Call function #3
  BucketFill_Canvas::PhotoBrush_BF(2, canvas_ID, window_ID, texture_ID,
                                   180,                                
                                   0,                                
                                   300,                               
                                   230)                                
  
  
  ; - Call function #4
  BucketFill_Canvas::PhotoBrush_BF(3, canvas_ID, window_ID, texture_ID,
                                   300,                                 
                                   250,                                 
                                   300,                               
                                   250)
  
  ; - Call function #5
  BucketFill_Canvas::PhotoBrush_BF(3, canvas_ID, window_ID, texture_ID,
                                   600,                                 
                                   20,                                 
                                   500,                               
                                   450,
                                   40,
                                   50)
  
  ; - Call function #6
  BucketFill_Canvas::PhotoBrush_BF(0, canvas_ID, window_ID, texture_ID,
                                   20,                                 
                                   550,                                 
                                   200,                               
                                   180) 
  
  ; - Call function #7
  BucketFill_Canvas::PhotoBrush_BF(-1, canvas_ID, window_ID, texture_ID,
                                   300,                                 
                                   550,                                 
                                   200,                               
                                   180,
                                   40,
                                   50)
  
  ; - Call function #8
  BucketFill_Canvas::PhotoBrush_BF(3, canvas_ID, window_ID, texture_ID,
                                   560,                                 
                                   550,                                 
                                   500,                               
                                   200,
                                   70,
                                   50)  
  
  Repeat
    win_event=WaitWindowEvent(1)
    If win_event=#PB_Event_CloseWindow
      Break
    EndIf
  ForEver
CompilerEndIf

; - Demo - Native using BF for seamless photos -
; 
; UsePNGImageDecoder() : UseJPEGImageDecoder()
; 
; EnableExplicit
; 
; Define window_ID, win_event, image_ID, texture_ID, result, i, ii
; Define path_0$, path_1$
; 
; image_ID=CreateImage(#PB_Any, 600, 400)
; path_1$=OpenFileRequester("Select a picture", "", "", 0)
; If path_1$="" : End : EndIf
; path_0$="./Bucket_fill_image_set/soil_wall.jpg"
; 
; window_ID=OpenWindow(#PB_Any, 0, 0,
;                      ImageWidth(image_ID), ImageHeight(image_ID), "Bucket Fill advanced - For Images",
;                      #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
; 
; StartDrawing(ImageOutput(image_ID))
; DrawingMode(#PB_2DDrawing_Transparent)
; DrawText(20, 20, "A VERY COOL FUNCTION !", -1)
; DrawText(20, 40, "BUCKET FILL ADVANCED", -1)
; DrawText(20, 60, "www.quick-aes-256.de", -1)
; DrawText(20, 80, "www.nachtoptik.de", -1)
; DrawText(220, 5, "Sprites simple for Images", 0)
; DrawText(220, 20, "Also FloodFill with texture support", -1)
; StopDrawing()
; 
; CompilerIf #PB_Compiler_Debugger : MessageRequester("Debugger", "Please deactivate firstly the debugger !") : End : CompilerEndIf
; 
; ; ============== Use BucketFill advanced ===============
; 
; ; - Call BF function #1 - Make a background
; texture_ID=LoadImage(#PB_Any, path_0$)
; result=BucketFill_Image::BF(-2, image_ID, texture_ID)
; BucketFill_Image::ErrorCheck_BF(result)
; 
; ; - Call BF function #2 - Embedding a photo in the background
; texture_ID=LoadImage(#PB_Any, path_1$)
; ResizeImage(texture_ID, 400, 320)
; 
; ii=0
; For i=0 To 23
;   Delay(25)
;   result=BucketFill_Image::BF(256-ii, image_ID, texture_ID, ; Sprite mode
;                               -1,                           ; Set to -1
;                               -1,                           ; 
;                               180+ii,                       ; x Startposition texture output
;                               60+ii,                        ; y
;                               400-ii-ii,                    ; x Endposition texture output
;                               320-ii-ii,                    ; y
;                               ii,                           ; x Startposition texture output inside the texture
;                               ii,                           ; y
;                               400-ii,                       ; x Endposition texture output inside the texture
;                               320-ii)                       ; y
;   BucketFill_Image::ErrorCheck_BF(result)
;   
;   CompilerIf #PB_Compiler_OS=#PB_OS_Windows
;     StartDrawing(WindowOutput(window_ID))
;     DrawImage(ImageID(image_ID), 0, 0)
;     StopDrawing()
;   CompilerElse
;     ImageGadget(0, 0, 0, 600, 400, ImageID(image_ID))
;   CompilerEndIf
;   
;   ii+3
; Next i
; 
; Repeat
;   If WaitWindowEvent()=#PB_Event_CloseWindow : Break : EndIf
; ForEver
; IDE Options = PureBasic 5.44 LTS (Linux - x64)
; Markers = 4
; EnableUnicode
; EnableXP
; DisableDebugger
