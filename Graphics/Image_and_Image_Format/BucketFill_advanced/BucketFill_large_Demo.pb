XIncludeFile("./BucketFill_Image.pb")
XIncludeFile("./BucketFill_Canvas.pb")

;- Demo - large

CompilerIf #PB_Compiler_IsMainFile
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  
  EnableExplicit
  
  Define window_0, win_event, canvas_ID, window_ID, texture_ID, result
  Define canvas_x, canvas_y, canvas_width, canvas_height, point
  Define path$
  
CompilerEndIf
Define GeeBee$=     "./Bucket_fill_image_set/Geebee2.bmp"
Define Clouds$=     "./Bucket_fill_image_set/Clouds.jpg"
Define SoilWall$=   "./Bucket_fill_image_set/soil_wall.jpg"
Define RustySteel$= "./Bucket_fill_image_set/RustySteel.jpg"
Define Caisse$=     "./Bucket_fill_image_set/Caisse.png"
Define Dirt$=       "./Bucket_fill_image_set/Dirt.jpg"
Define Background$= "./Bucket_fill_image_set/Background.bmp"
Define Hubble$=     "./Bucket_fill_image_set/Hubble.jpg"
Define Alpha$=      "./Bucket_fill_image_set/Alpha.png"
Define Cat_03$=     "./Bucket_fill_image_set/Cat_03.jpg"
Define Cat_02$=     "./Bucket_fill_image_set/Cat_02.jpg"

; Presets
canvas_x=50
canvas_y=50
canvas_width=900
canvas_height=400

window_ID=OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, canvas_width+100, canvas_height+100, "Bucket Fill Advanced - For Canvas",
                     #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)

canvas_ID=CanvasGadget(#PB_Any, canvas_x, canvas_y, canvas_width, canvas_height)

StartDrawing(CanvasOutput(canvas_ID))
Box(0, 0, canvas_width, canvas_height, 0) ; Black preset for the canvas
Circle(100, 100, 125, $A1AAAA)
DrawingMode(#PB_2DDrawing_Transparent)
  CompilerIf #PB_Compiler_OS=#PB_OS_Linux
    Define font_1=LoadFont(1, "Arial", 11)
    DrawingFont(font_1)
  CompilerEndIf
DrawText(20, 5, "A VERY COOL FUNCTION", $FF00)
DrawText(20, 25, "BUCKET FILL ADVANCED", $FF00)
DrawText(20, 45, "WITH FLOOD FILL FUNCTION", $FF00)
DrawText(20, 65, "www.quick-aes-256.de", $FF00)
DrawText(20, 85, "www.nachtoptik.de", $FF00)
RoundBox (185, 80, 100 , 310 , 20, 20, $A2AAAA)
Box (300, 50, 150 , 150, $A3AAAA)
Box (30, 200, 128 , 128, $A4AAAA)
Box (460, 10, 128 , 128, $A5AAAA)
Circle(780, 80, 160, $A6AAAA)
Circle(880, 200, 80, $FE)
Circle(730, 205, 60, $FFF)
StopDrawing()

If StartVectorDrawing(CanvasVectorOutput(canvas_ID))
  VectorSourceColor($FF000001)
  MovePathCursor (470 , 250)
  AddPathCircle (470 , 250 , 160, 0, 235 , #PB_Path_Connected)
  FillPath()
  StopVectorDrawing()
EndIf
StopDrawing()

; BucketFill_Canvas::SetColorDistanceFill_BF(30) ; percent
; BucketFill_Canvas::SetColorDistanceSpriteMask_BF(30) ; percent
; BucketFill_Canvas::GetTextureColor_BF(texture_ID, x, y)
; BucketFill_Canvas::SetTextureColor_BF($FF00FF) ; -1 deactivate the function
; BucketFill_Canvas::SearchUnusedCanvasColor_BF(canvas_ID, x, y, xx, yy, search_deep=10) - Preset = 10 search loops 

; - Call function #1 -
path$=SoilWall$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID)
BucketFill_Canvas::ErrorCheck_BF(result) 

; - Call function #2 -
path$=RustySteel$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             0,
                             35)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #3 -
path$=Dirt$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             310,
                             110)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #4 -
path$=Background$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             376,
                             121)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Manipulate the BucketFill output color -
Define x, y, color, new_color
Define *array=BucketFill_Canvas::GetBucketArray_Adress_BF()
Define gadget_width=GadgetWidth(canvas_ID)-1
Define gadget_height=GadgetHeight(canvas_ID)-1
Define gadget_width_1=GadgetWidth(canvas_ID)
Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID)) 
color=Point(370, 120) ; As sample
new_color=$0FFF00     ; As sample
For y=BucketFill_Canvas::GetBucket_Y_BF() To BucketFill_Canvas::GetBucket_YY_BF()-123
  For x=BucketFill_Canvas::GetBucket_X_BF() To BucketFill_Canvas::GetBucket_XX_BF()
    If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array
      Point(x, y)
      If BucketFill_Canvas::ColorDistance_BF(point, color)<30 ; Percent color distance
        Plot(x, y, BucketFill_Canvas::AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

BucketFill_Canvas::SetColorDistanceFill_BF(20)
BucketFill_Canvas::SetColor_BF($FF00FF)

; - Call function #5 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             30,
                             200,
                             30,
                             200,
                             128,
                             128)
BucketFill_Canvas::ErrorCheck_BF(result)
BucketFill_Canvas::SetColorDistanceFill_BF(0)

; - Call function #6 -
path$=Clouds$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 80, 80)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             30,
                             202,
                             30,
                             200)
BucketFill_Canvas::ErrorCheck_BF(result)

BucketFill_Canvas::SetColorDistanceFill_BF(30)
BucketFill_Canvas::SetColor_BF($FF00FF)
; - Call function #7 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$) ; Texture mode
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             460, ; Get the color for repalcing with a texture x
                             11,  ; Get the color for repalcing with a texture y
                             460, ; Startposition texture output x
                             10,
                             128,
                             128)  ; Startposition texture output y
BucketFill_Canvas::ErrorCheck_BF(result)

BucketFill_Canvas::SetColorDistanceFill_BF(0)
BucketFill_Canvas::SetColor_BF(-1)
; - Call function #8 -
path$=SoilWall$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             462,
                             11)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #9 -
path$=Alpha$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 80) ; Sprite mode
result=BucketFill_Canvas::BF(1, canvas_ID, window_ID, texture_ID,
                             0,                                   
                             0,                                 
                             450,                           
                             160,                             
                             100,                           
                             80)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #10 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 50, 50) ; Sprite mode
BucketFill_Canvas::SetColorDistanceSpriteMask_BF(30)
result=BucketFill_Canvas::BF(1, canvas_ID, window_ID, texture_ID,
                             0,                                   
                             0,                                 
                             340,                           
                             230,                             
                             250,                           
                             150)
BucketFill_Canvas::ErrorCheck_BF(result)
BucketFill_Canvas::SetColorDistanceSpriteMask_BF(0)

; - Call function #11 -
path$=Clouds$
texture_ID=LoadImage(#PB_Any, path$)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             750,                                   
                             302,                                 
                             600,                           
                             50,                             
                             300,                           
                             400)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #12 -
path$=Cat_02$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 470, 700)
result=BucketFill_Canvas::BF(-2, canvas_ID, window_ID, texture_ID,
                             750,                                   
                             10,                                 
                             590,                           
                             -10,                             
                             3000,                           
                             3000,
                             -120,
                             150)
BucketFill_Canvas::ErrorCheck_BF(result)

StartDrawing(CanvasOutput(canvas_ID))
RoundBox (185, 60, 140 , 290 , 20, 20, $A2AAAA)
RoundBox (800, 250, 100 , 150 , 20, 20, $FF)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1)
CompilerEndIf
DrawText(630, 124, "All features combinable", 0)
StopDrawing()

; - Call function #13 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 280, 330)
result=BucketFill_Canvas::BF(0, canvas_ID, window_ID, texture_ID,
                             185,
                             200,
                             110,
                             60)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #14 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 140, 200)
result=BucketFill_Canvas::BF(-100, canvas_ID, window_ID, texture_ID,
                             800,
                             270,
                             90,
                             40)
BucketFill_Canvas::ErrorCheck_BF(result)

BucketFill_Canvas::SetColorDistanceSpriteMask_BF(30)
BucketFill_Canvas::SetColor_BF($FF00FF)

; - Call function #15 -
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
result=BucketFill_Canvas::BF(120, canvas_ID, window_ID, texture_ID,
                             0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                             0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                             530, ; x  coordinate sprite output
                             120, ; y  coordinate sprite output
                             128, ; xx coordinate sprite output - More results more sprites in a row - horizontal
                             128) ; yy coordinate sprite output - More results more sprites in a row - vertical
BucketFill_Canvas::ErrorCheck_BF(result)
BucketFill_Canvas::SetColorDistanceSpriteMask_BF(0)
BucketFill_Canvas::SetColor_BF(-1)

; - Call function #16 -
Define texture_1=CreateImage(#PB_Any, 200, 220)
StartDrawing(ImageOutput(texture_1))
RoundBox (0, 0, 100 , 120 , 20, 20, $A2AAAA)
StopDrawing()
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BucketFill_Image::BF(0, texture_1, texture_ID,
                            0,
                            100,
                            0, 
                            0,
                            100,
                            120)
BucketFill_Canvas::ErrorCheck_BF(result)

result=BucketFill_Canvas::BF(100, canvas_ID, window_ID, texture_1,
                             0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                             0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                             590, ; x  coordinate sprite output
                             0,   ; y  coordinate sprite output
                             100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
                             120) ; yy coordinate sprite output - More results more sprites in a row - vertical
BucketFill_Canvas::ErrorCheck_BF(result)

; - Call function #17 -
Define texture_1=CreateImage(#PB_Any, 200, 220)
StartDrawing(ImageOutput(texture_1))
RoundBox (0, 0, 100 , 140 , 20, 20, $FF00)
StopDrawing()
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BucketFill_Image::BF(-100, texture_1, texture_ID,
                            0,
                            100,
                            0,
                            0,
                            100,
                            120)
BucketFill_Canvas::ErrorCheck_BF(result)

result=BucketFill_Canvas::BF(100, canvas_ID, window_ID, texture_1,
                             0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                             0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                             43,  ; x  coordinate sprite output
                             105, ; y  coordinate sprite output
                             100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
                             90)  ; yy coordinate sprite output - More results more sprites in a row - vertical
BucketFill_Canvas::ErrorCheck_BF(result)
FreeImage(texture_1)

; - Call function #18 -
Define texture_1=CreateImage(#PB_Any, 100, 120)
StartDrawing(ImageOutput(texture_1))
Box (0, 0, 100 , 120, $FF)
StopDrawing()
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 100, 120)
result=BucketFill_Image::BF(-100, texture_1, texture_ID,
                            0,
                            100,
                            0,
                            0,
                            100,
                            120)
BucketFill_Canvas::ErrorCheck_BF(result)

result=BucketFill_Canvas::BF(100, canvas_ID, window_ID, texture_1,
                             0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                             0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                             340, ; x  coordinate sprite output
                             10,  ; y  coordinate sprite output
                             100, ; xx coordinate sprite output - More results more sprites in a row - horizontal
                             120) ; yy coordinate sprite output - More results more sprites in a row - vertical
BucketFill_Canvas::ErrorCheck_BF(result)
FreeImage(texture_1)

; - Call function #19 -
Define texture_1=CreateImage(#PB_Any, 80, 160)
StartDrawing(ImageOutput(texture_1))
Box (0, 0, 80 , 160, $00FF00)
StopDrawing()
path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 80, 160)
result=BucketFill_Image::BF(-120, texture_1, texture_ID,
                            0,
                            100,
                            0,
                            0,
                            80,
                            160)
BucketFill_Canvas::ErrorCheck_BF(result)

result=BucketFill_Canvas::BF(1, canvas_ID, window_ID, texture_1,
                             0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                             0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                             351, ; x  coordinate sprite output
                             140, ; y  coordinate sprite output
                             80,  ; xx coordinate sprite output - More results more sprites in a row - horizontal
                             160) ; yy coordinate sprite output - More results more sprites in a row - vertical
BucketFill_Canvas::ErrorCheck_BF(result)

StartDrawing(CanvasOutput(canvas_ID))
RoundBox (640, 250, 140 , 150 , 20, 20, $A7AAAA)
DrawingMode(#PB_2DDrawing_Transparent)
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  DrawingFont(font_1)
CompilerEndIf
DrawText(295, 0, "Sprites simple for Pictures and Canvas", $FFFF)
DrawText(355, 380, "You can combine Sprites, Textures, Flood Fill and Bucket Fill, how ever you want", -1)
DrawText(760, 232, "Texture FLOODFILL")
StopDrawing()
; - Call function #20 -
path$=Hubble$
texture_ID=LoadImage(#PB_Any, path$)
ResizeImage(texture_ID, 60, 75)
result=BucketFill_Canvas::BF(0, canvas_ID, window_ID, texture_ID,
                             640,
                             300,
                             110,
                             25)
BucketFill_Canvas::ErrorCheck_BF(result)

; - Embedding photo #1
path$=Cat_03$
texture_ID=LoadImage(#PB_Any, path$)
BucketFill_Canvas::PhotoBrush_BF(2, canvas_ID, window_ID, texture_ID, ; For canvas
                                 35,                                  ; Output pos x
                                 325,                                 ; Output pos y
                                 120,                                 ; Texture or image width
                                 190,                                 ; Texture or image height
                                 100,                                 ; Visibility - percent
                                 0)                                   ; Delay for animation)  

; - FloodFill #1 -
path$=Caisse$
texture_ID=LoadImage(#PB_Any, path$)
BucketFill_Canvas::FloodFill(0, canvas_ID, window_ID, texture_ID,
                             850, ; x pos
                             180, ; y pos
                             10,  ; Startposition texture output x
                             10,  ; Startposition texture output y
                             0,   ; Endposition texture output xx
                             0,   ; Endposition texture output yy
                             0,   ; Startposition inside the texture x
                             0,   ; Startposition inside the texture y
                             30,  ; Endposition inside the texture xx
                             30)  ; Endposition inside the textur

; - Manipulate the FloodFill output color -
Define x, y, color, new_color
Define *array=BucketFill_Canvas::GetFloodArray_Adress_BF()
Define gadget_width=GadgetWidth(canvas_ID)-1
Define gadget_height=GadgetHeight(canvas_ID)-1
Define gadget_width_1=GadgetWidth(canvas_ID)
Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID))
color=Point(895, 195) ; As sample
new_color=$FFFF       ; As sample
For y=BucketFill_Canvas::GetFlood_Y_BF() To BucketFill_Canvas::GetFlood_YY_BF()
  For x=BucketFill_Canvas::GetFlood_X_BF() To BucketFill_Canvas::GetFlood_XX_BF()
    If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array
      point=Point(x, y)
      If BucketFill_Canvas::ColorDistance_BF(point, color)<25 ; Percent color distance
        Plot(x, y, BucketFill_Canvas::AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=BucketFill_Canvas::GetFlood_Y_BF() To BucketFill_Canvas::GetFlood_YY_BF()-70
  For x=BucketFill_Canvas::GetFlood_X_BF() To BucketFill_Canvas::GetFlood_XX_BF() ; Also you can reduce the xx coordinate
    If PeekI(*array+(gadget_height_1*x+y)*8)                                      ; Read the array
      point=Point(x, y)
      If BucketFill_Canvas::ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, BucketFill_Canvas::AlphaBlend_BF(point, $FF0000, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

; - FloodFill #2 -
path$=Caisse$
texture_ID=LoadImage(#PB_Any, path$)
BucketFill_Canvas::FloodFill(0, canvas_ID, window_ID, texture_ID,
                             730, ; x pos
                             190, ; y pos
                             10,  ; Startposition texture output x
                             10,  ; Startposition texture output y
                             0,   ; Endposition texture output xx
                             0,   ; Endposition texture output yy
                             0,   ; Startposition inside the texture x
                             0,   ; Startposition inside the texture y
                             30,  ; Endposition inside the texture xx
                             30)  ; Endposition inside the textur

; - Manipulate the FloodFill output color -
Define x, y, color, new_color
Define *array=BucketFill_Canvas::GetFloodArray_Adress_BF()
Define gadget_width=GadgetWidth(canvas_ID)-1
Define gadget_height=GadgetHeight(canvas_ID)-1
Define gadget_width_1=GadgetWidth(canvas_ID)
Define gadget_height_1=GadgetHeight(canvas_ID)
StartDrawing(CanvasOutput(canvas_ID))
color=Point(740, 180) ; As sample
new_color=$0FFF00     ; As sample
For y=BucketFill_Canvas::GetFlood_Y_BF() To BucketFill_Canvas::GetFlood_YY_BF()-70
  For x=BucketFill_Canvas::GetFlood_X_BF() To BucketFill_Canvas::GetFlood_XX_BF()
    If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array
      point=Point(x, y)
      If BucketFill_Canvas::ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, BucketFill_Canvas::AlphaBlend_BF(point, new_color, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
For y=BucketFill_Canvas::GetFlood_Y_BF()+40 To BucketFill_Canvas::GetFlood_YY_BF()
  For x=BucketFill_Canvas::GetFlood_X_BF()+70 To BucketFill_Canvas::GetFlood_XX_BF()
    ; If PeekI(*array+(gadget_height_1*x+y)*8) ; Read the array
    If BucketFill_Canvas::GetFloodArray_Point_BF(x, y) ; Read the array
      point=Point(x, y)
      If BucketFill_Canvas::ColorDistance_BF(point, color)<20 ; Percent color distance
        Plot(x, y, BucketFill_Canvas::AlphaBlend_BF(point, $008CFF, 80)) ; Alpha blend
      EndIf
    EndIf
  Next x
Next y
StopDrawing()

HideWindow(window_ID, 0)

; - Sprite animation #1 -
Define x, y
Define *drawing_buffer_grabed_canvas, *drawing_buffer

path$=Geebee$
texture_ID=LoadImage(#PB_Any, path$)

BucketFill_Canvas::SetColorDistanceSpriteMask_BF(30)

ResizeImage(texture_ID, 100, 100)

*drawing_buffer_grabed_canvas=BucketFill_Canvas::GrabCanvas_BF(canvas_ID) ; Grab canvas
BucketFill_Canvas::ErrorCheck_GrabCanvas_BF(*drawing_buffer_grabed_canvas)

Repeat
  win_event=WaitWindowEvent(1)
  If win_event=#PB_Event_CloseWindow
    FreeMemory(*drawing_buffer_grabed_canvas) ; Free grabed canvas
    Break
  EndIf
  
  If BucketFill_Canvas::Delay_BF(0, 10) ; Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
    *drawing_buffer=BucketFill_Canvas::DrawingBuffer_BF(canvas_ID)
    BucketFill_Canvas::ErrorCheck_DrawingBuffer_BF(*drawing_buffer)
    CopyMemory(*drawing_buffer_grabed_canvas, *drawing_buffer,
               MemorySize(*drawing_buffer_grabed_canvas)) ; Refresh canvas
    
    x+1 : y-1
    If x>GadgetWidth(canvas_ID)
      x=-ImageWidth(texture_ID)
    EndIf
    If y<-ImageHeight(texture_ID)
      y=GadgetHeight(canvas_ID)
    EndIf
    
    result=BucketFill_Canvas::BF(130, canvas_ID, window_ID, texture_ID, ; Sprite mode
                                 0,                                   
                                 0,                                 
                                 x,                           
                                 y,                             
                                 ImageWidth(texture_ID),                           
                                 ImageHeight(texture_ID))
    BucketFill_Canvas::ErrorCheck_BF(result)
  EndIf
ForEver
; IDE Options = PureBasic 5.51 (Windows - x64)
; EnableXP
; DisableDebugger
; EnablePurifier
; EnableUnicode
