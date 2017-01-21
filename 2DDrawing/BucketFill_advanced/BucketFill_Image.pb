;- BF Image -
DeclareModule BucketFill_Image
  Declare ErrorCheck_BF(result.q) ; Rudimentary error checks
  Declare ErrorCheck_GrabImage_BF(drawing_buffer_grabed_image.q)
  Declare ErrorCheck_DrawingBuffer_BF(drawing_buffer.q)
  Declare Delay_BF(timer, time) ; Timer - 100 pieces available - 0 to 99
  Declare GetFloodArray_Adress_BF()     ; Dim array.q(ImageWidth(image_ID)-1, ImageHeight(image_ID)-1)
  Declare GetBucketArray_Adress_BF()    ; -1=used , 0=unused point
  Declare GetFloodArray_Point_BF(x, y)  ; This arrays is free manipulable - Manipulation do not damage things
  Declare GetBucketArray_Point_BF(x, y) ; The array length is ever ImageWidth*ImageHeight*8
  Declare PutFloodArray_Point_BF(point, x, y) ; Write in the arrays
  Declare PutBucketArray_Point_BF(point, x, y)
  Declare GetFlood_X_BF() ; Min output coordinate FloodFill
  Declare GetFlood_Y_BF()
  Declare GetFlood_XX_BF() ; Max
  Declare GetFlood_YY_BF()
  Declare GetBucket_X_BF() ; Min output coordinate BucketFill
  Declare GetBucket_Y_BF()
  Declare GetBucket_XX_BF() ; Max
  Declare GetBucket_YY_BF()
  Declare GetImageColor_BF(image_ID, x, y) ; Get a color from a image or a texture
  Declare GetColor_BF()                    ; Get a placed color for replacing with a BucketFill texture
  Declare SetColor_BF(color)               ; Set a color for replacing with a BucketFill texture
                                           ;  You must deactivate this again with -1 - For white set $FFFFFF
                                           ;  For using this presetted color set in each BucketFill call 
                                           ;  the parameter(s) .._get_color_x Or .._get_color_y to -1
  Declare.q SearchUnusedImageColor_BF(image_ID, x, y, xx, yy, search_deep=100) ; Usable for images and textures
  Declare SetColorDistanceFill_BF(percent_)                                    ; Set color distance for all fill functions
  Declare SetColorDistanceSpriteMask_BF(percent_)
  Declare GetColorDistanceFill_BF() ; Get placed color distance for all fill functions
  Declare GetColorDistanceSpriteMask_BF()
  Declare.f ColorDistance_BF(c1, c2) ; Rudimentary
  Declare AlphaBlend_BF(c1, c2, alpha) ; Rudimentary
  Declare FreeTextures_BF()            ; BF cache all used textures, give free again
  Declare.q GrabImage_BF(image_ID)     ; Create a buffer and grab - You become a pointer, give free again this memory
  Declare.q DrawingBuffer_BF(image_ID) ; Get the drawing buffer adress
  Declare FloodFill(mode, image_ID, texture_ID,
                    x, ; Output coordinates
                    y,
                    texture_x=0, ; Further down you find the description for all texture parameters
                    texture_y=0, 
                    texture_width=0,
                    texture_height=0,
                    texture_clip_x=0,
                    texture_clip_y=0,
                    texture_clip_width=0,
                    texture_clip_height=0)
  ; mode=-1 - Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00
  ; mode=-2 - Standard preset texture mode
  ; mode=-3 - Texture mode with alpha blending 
  Declare BF(mode, image_ID, texture_ID,
             image_get_color_x=0, ; Get a color from this coordinates for replacing with a texture
             image_get_color_y=0,
             texture_x=0,
             texture_y=0, 
             texture_width=0,
             texture_height=0,
             texture_clip_x=0,
             texture_clip_y=0,
             texture_clip_width=0,
             texture_clip_height=0)
  Declare AlphaChannelSprite_BF(image_ID, texture_ID, ; Function for using any images with alpha channel as sprites
                                texture_x,            ;  Use this function only for pictures with alpha channel, or you see nothing
                                texture_y,
                                texture_width=0,          
                                texture_height=0,
                                texture_clip_x=0,
                                texture_clip_y=0,
                                texture_clip_width=0,
                                texture_clip_height=0)
  Declare SpriteSimple_BF(mode, image_ID, texture_ID, ; Function for simple using any images as sprites                                                               
                          x,                          ; Output pos x
                          y,                          ; Output pos y
                          output_width=0,             ; You can here resize the output x  - With resizing it is slower
                          output_height=0,            ; You can here resize the output y
                          alpha=1)                    ; Set alpha blending from 1 to 256 - BF set 1=full visible - 256=invisible
                                                      ; Use not sprite mask mode=0
                                                      ; Use sprite mask mode=1
                                                      ;  For using pictures with alpha channel use only mode=2, or you see nothing 
                                                      ;  You want higher speed output, resize textures before using this function
                                                      ;  For high speed output use the native BF function or AlphaChannelSprite_BF
                                                      ;  For using JPG based masked sprites, pre use SetColorDistanceSpriteMask_BF(percent) 
  Declare CreateSprite_from_AlphaImage_BF(mode, image_ID,
                                          mask_color, ; Set here a suitable color for the sprite mask (Different from the picture content color)
                                          percent_color_distance) ; You can set a color distance for the mask color in percent
                                                                  ;  mode=0 = Create mask with BucketFill - mode=1 = create mask with FloodFill
                                                                  ;  The FloodFill mode works from the corners inward - the BucketFill mode over all
  Declare CreateAlphaImage_from_Sprite_BF(image_ID,
                                          percent_color_distance) ; You can set a color distance for the mask color in percent
  Declare PhotoBrush_BF(mode, image_ID, texture_ID, 
                        x, ; Output coordinates
                        y, 
                        texture_width, 
                        texture_height, 
                        percent_visibility.f=100) 
  ; mode=-1 and 0  - Without seamless embedding - Fast
  ; mode=0         - Without seamless embedding - Fast (mode -1 and mode 0 equal for parameter compatibility to BF canvas)
  ; mode=1 to 3    - With seamless embedding
  ; percent_visibility - Visibility in percent
  
  Structure textures
    texture_ID.i
    *texture_buffer
    texture_clip_width.i
    texture_clip_height.i
    texture_percent_transparent.i
  EndStructure
EndDeclareModule

Module BucketFill_Image
  ; BucketFill advanced for PureBasic(R) is a multi tool
  ; It supporting bucket fill, flood fill, pictures and sprite functions for images and canvas
  ; With texture and photo support
  
  ; Author : W. Albus © 2016 - 2017 - www.nachtoptik.de - www.quick-aes-256.de
  
  ; All rights reserved.
  ; Redistribution and use in source and binary forms, with or without
  ; modification, are permitted provided that the following conditions
  ; are met:
  ; 1. Redistributions of source code must retain the above copyright
  ;    notice, this List of conditions and the following disclaimer.
  ; 2. Redistributions in binary form must reproduce the above copyright
  ;    notice, this List of conditions and the following disclaimer in the
  ;    documentation and/or other materials provided with the distribution.
  
  ; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS And CONTRIBUTORS 'AS IS'
  ; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  ; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ; ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  ; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  ; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  ; SUBSTITUTE GOODS Or SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  ; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  ; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  ; POSSIBILITY OF SUCH DAMAGE.
  
  ; mode :  0 - BucketFill  - Texture mode - Enable the little black color positioning helper box output for texture mode
  ;      :  1 - Sprite mode - Without alpha blending - Standard preset sprite mode
  ;      :  2   to 256      - Sprite mode - With alpha blending
  ;      : -1 - BucketFill  - Ignore a texture and use a color - Set as texture_ID a color, as sample $FFFF00
  ;      : -2   BucketFill  - Standard preset texture mode
  ;      : -3   to -256     - BucketFill - Texture mode with alpha blending
  
  ; FloodFill use the modes -1 to -256
  
  ; BF set the parameter for transparence (alpha) so :
  ; 1 = without transparence  256 = full transparence
  
  ; image_get_color_x   : Get a color from the image for replacing with a texture - x pos  - Preset = 0
  ; image_get_color_y   : Get a color from the image for replacing with a texture - y pos  - Preset = 0
  ; image_get_color_x   : Get a color from a sprite for using the invisible color - x pos  - Preset = 0
  ; image_get_color_y   : Get a color from a sprite for using the invisible color - y pos  - Preset = 0
  ; texture_x           : Startposition texture output     - Preset 0
  ; texture_y           : Startposition texture output     - Preset 0
  ; texture_width       : Endposition texture output       - Preset 0 = Clipping is automatic to image width 
  ; texture_height      : Endposition texture output       - Preset 0 = Clipping is automatic to image height 
  ; texture_clip_x      : Startposition inside the texture - Preset 0
  ; texture_clip_y      : Startposition inside the texture - Preset 0
  ; texture_clip_width  : Endposition inside the texture   - Preset 0 = full texture width
  ; texture_clip_height : Endposition inside the texture   - Preset 0 = full texture height
  
  ; The tool set a little black box (3x3) as helper for simple getting a color position
  ; For disable the helper box set mode to -2 - Sprite mode use this not !
  
  EnableExplicit
  Global NewList textures.textures(), Dim picture.q(0, 0), Dim picture_1.q(0, 0)
  Global percent, percent_1, texture_get_color=-1, old_texture_get_color=-1, new_color
  Global min_x, min_y, max_x, max_y, min_x_1, min_y_1, max_x_1, max_y_1, alpha_sprite
  Macro color_distance
    If c1<>c2
      Protected r1=Red(c1), g1=Green(c1), b1=Blue(c1)
      Protected r2=Red(c2), g2=Green(c2), b2=Blue(c2)
      Protected diff_red=Abs(r1-r2), diff_green=Abs(g1-g2), diff_blue=Abs(b1-b2)
      Protected r.f=diff_red/255, g.f=diff_green/255, b.f=diff_blue/255
      ProcedureReturn (r+g+b)/3*100
    Else
      ProcedureReturn 0
    EndIf
  EndMacro
  
  Macro RGB(red, green, blue) : (((blue<<8+green)<<8)+red) : EndMacro
  Macro Red(color)   : (color&16777215>>16) : EndMacro ; Macro by eesau
  Macro Green(color) : ((color&65535)>>8)   : EndMacro
  Macro Blue(color)  : (color>>16)          : EndMacro
  Macro AlphaBlend(c1, c2, alpha)
    RGB(((Red(c2)*alpha+Red(c1)*(256-alpha))>>8),
        ((Green(c2)*alpha+Green(c1)*(256-alpha))>>8),
        ((Blue(c2)*alpha+Blue(c1)*(256-alpha))>>8))
  EndMacro
  
  Procedure ErrorCheck_BF(result_.q)
    Protected result
    Select result_ 
      Case -1
        MessageRequester("  ERROR", "Bucket fill image - Image not found"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##01BC")
      Case -2
        MessageRequester("  ERROR", "Bucket fill image - Texture not found"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##02BI")
        
        ; Case -3 is not used on BucketFill image
        
      Case -4
        MessageRequester("  ERROR", "Bucket fill image - Texture - Start drawing fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##04BI")
      Case -5
        MessageRequester("  ERROR", "Bucket fill image - Image - Start drawing fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##05BI")
      Case -6
        MessageRequester("  ERROR", "Bucket fill image - Creating image fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##06BI")
        
        ; Case -7 is not used on BucketFill image
        
      Case -8
        MessageRequester("  ERROR", "Bucket fill image - Parameter wrong"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##08BC")
      Case -9
        MessageRequester("  ERROR", "Bucket fill image - Function result fails"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##09BC") 
        
      Default
        result=1
    EndSelect
    ; ProcedureReturn result ; Handle errors how you want 
    If Not result : End : EndIf
  EndProcedure
  
  Procedure ErrorCheck_GrabImage_BF(drawing_buffer_grabed_image.q)
    Protected result
    Select drawing_buffer_grabed_image
      Case -1
        MessageRequester("  ERROR", "Bucket fill - Grab image - Start drawing fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##10BI")
      Case -2
        MessageRequester("  ERROR", "Bucket fill - Grab image - Allocate memory fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##11BI")
      Default
        result=1
    EndSelect
    ; ProcedureReturn result ; Handle errors how you want 
    If Not result : End : EndIf
  EndProcedure
  
  Procedure ErrorCheck_DrawingBuffer_BF(drawing_buffer.q)
    Protected result
    Select drawing_buffer
      Case -1
        MessageRequester("  ERROR", "Bucket fill - DrawingBuffer - Start drawing fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##08BC")
      Case -2
        MessageRequester("  ERROR", "Bucket fill - DrawingBuffer - Drawing buffer fail"+#LF$+#LF$+
                                    "The function is terminated !"+#LF$+#LF$+"##09BC")
      Default
        result=1
    EndSelect
    ; ProcedureReturn result ; Handle errors how you want 
    If Not result : End : EndIf
  EndProcedure
  
  Procedure Delay_BF(timer, time)
    If Not time Or timer>99: ProcedureReturn 1 : EndIf
    Static Dim time_1.q(99) ; 100 timer available 0 - 99 - preset - you can change
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86 ; Based on x86 timer code by Danilo
      Static ElapsedMilliseconds_64_oldValue.q=0
      Static ElapsedMilliseconds_64_overflow.q=0
      Static time_result.q
      Protected current_ms.q=ElapsedMilliseconds()&$FFFFFFFF
      If ElapsedMilliseconds_64_oldValue>current_ms
        ElapsedMilliseconds_64_overflow+1
      EndIf  
      ElapsedMilliseconds_64_oldValue=current_ms
      time_result=current_ms+ElapsedMilliseconds_64_overflow*$FFFFFFFF
      If time_result>time_1(timer)+time
        time_1(timer)=time_result
        ProcedureReturn 1
      Else
        ProcedureReturn 0
      EndIf
    CompilerElse
      If ElapsedMilliseconds()>time_1(timer)+time
        time_1(timer)=ElapsedMilliseconds()
        ProcedureReturn 1
      Else
        ProcedureReturn 0
      EndIf
    CompilerEndIf
  EndProcedure
  
  Procedure.f ColorDistance_BF(c1, c2)
    color_distance
  EndProcedure
  
  Procedure AlphaBlend_BF(c1, c2, alpha)
    ProcedureReturn AlphaBlend(c1, c2, alpha)
  EndProcedure
  
  Procedure FreeTextures_BF()
    ForEach(textures())
      FreeMemory(textures()\texture_buffer)
    Next
    FreeList(textures())
  EndProcedure
  
  Procedure GetFloodArray_Adress_BF()
    ProcedureReturn @picture()
  EndProcedure
  
  Procedure GetBucketArray_Adress_BF()
    ProcedureReturn @picture_1()
  EndProcedure
  
  Procedure GetFloodArray_Point_BF(x, y)
    ProcedureReturn picture(x, y)
  EndProcedure
  
  Procedure GetBucketArray_Point_BF(x, y)
    ProcedureReturn picture_1(x, y)
  EndProcedure
  
  Procedure PutFloodArray_Point_BF(point, x, y)
    picture(x, y)=point
  EndProcedure
  
  Procedure PutBucketArray_Point_BF(point, x, y)
    picture_1(x, y)=point
  EndProcedure
  
  Procedure GetFlood_X_BF()
    ProcedureReturn min_x
  EndProcedure
  
  Procedure GetFlood_Y_BF()
    ProcedureReturn min_y
  EndProcedure
  
  Procedure GetFlood_XX_BF()
    ProcedureReturn max_x
  EndProcedure
  
  Procedure GetFlood_YY_BF()
    ProcedureReturn max_y
  EndProcedure
  
  Procedure GetBucket_X_BF()
    ProcedureReturn min_x_1
  EndProcedure
  
  Procedure GetBucket_Y_BF()
    ProcedureReturn min_y_1
  EndProcedure
  
  Procedure GetBucket_XX_BF()
    ProcedureReturn max_x_1
  EndProcedure
  
  Procedure GetBucket_YY_BF()
    ProcedureReturn max_y_1
  EndProcedure
  
  Procedure GetImageColor_BF(image_ID, x, y)
    Protected point
    If Not IsImage(image_ID) : ProcedureReturn -2 : EndIf
    If StartDrawing(ImageOutput(image_ID))
      If x>-1 And x<ImageWidth(image_ID) And y>-1 And y<ImageHeight(image_ID)
        point=Point(x, y)
      EndIf
      StopDrawing()
    Else
      ProcedureReturn -4
    EndIf
    ProcedureReturn point
  EndProcedure 
  
  Procedure GetColor_BF()
    ProcedureReturn texture_get_color
  EndProcedure
  
  Procedure SetColor_BF(color)
    texture_get_color=color
  EndProcedure
  
  Procedure SetColorDistanceFill_BF(percent_)
    percent_1=percent_
  EndProcedure
  
  Procedure SetColorDistanceSpriteMask_BF(percent_)
    percent=percent_
  EndProcedure
  
  Procedure GetColorDistanceFill_BF()
    ProcedureReturn percent_1
  EndProcedure
  
  Procedure GetColorDistanceSpriteMask_BF()
    ProcedureReturn percent
  EndProcedure
  
  Procedure.q SearchUnusedImageColor_BF(image_ID, x, y, xx, yy, search_deep=100)
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1  
    Protected test_color.q, i, ii, iii
    
    If x<0 : x=0 : EndIf
    If y<0 : y=0 : EndIf
    If x>image_width : x=image_width : EndIf
    If y>image_height : y=image_height : EndIf
    If xx>image_width : xx=image_width : EndIf
    If yy>image_height : yy=image_height : EndIf
    If x>xx : x=xx : EndIf
    If y>yy : y=yy : EndIf
    
    search_deep-2 : If search_deep<0 : search_deep=0 : EndIf
    If StartDrawing(ImageOutput(image_ID))
      search_again:
      test_color=Random($FFFFFF)
      For i=y To yy
        For ii=x To xx
          If iii>search_deep
            StopDrawing()
            ProcedureReturn -9
          EndIf
          If test_color=Point(ii, i)
            iii+1
            Goto search_again
          EndIf
        Next ii
      Next i
      StopDrawing()
    Else
      ProcedureReturn -5
    EndIf
    ProcedureReturn test_color
  EndProcedure
  
  Procedure.f ColorDistanceFill(c1, c2)
    color_distance
  EndProcedure
  
  Procedure.f ColorDistanceSpriteMask(c1, c2)
    color_distance
  EndProcedure
  
  Procedure.q GrabImage_BF(image_ID)
    Protected *drawing_buffer_grabed_image, drawing_buffer_len
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -1
    EndIf
    drawing_buffer_len=DrawingBufferPitch()*ImageHeight(image_ID)
    *drawing_buffer_grabed_image=AllocateMemory(drawing_buffer_len)
    If Not *drawing_buffer_grabed_image
      StopDrawing()
      ProcedureReturn -2
    EndIf
    CopyMemory(DrawingBuffer(), *drawing_buffer_grabed_image, drawing_buffer_len)
    StopDrawing()
    ProcedureReturn *drawing_buffer_grabed_image
  EndProcedure
  
  Procedure.q DrawingBuffer_BF(image_ID)
    Protected *drawing_buffer
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    If Not StartDrawing(ImageOutput(image_ID))
      ProcedureReturn -1
    EndIf
    *drawing_buffer=DrawingBuffer()
    If Not *drawing_buffer
      StopDrawing()
      ProcedureReturn -2
    EndIf
    StopDrawing()
    ProcedureReturn *drawing_buffer
  EndProcedure
  
  Procedure BF(mode, image_ID, texture_ID,
               image_get_color_x=0,
               image_get_color_y=0,
               texture_x=0,
               texture_y=0, 
               texture_width=0,
               texture_height=0,
               texture_clip_x=0,
               texture_clip_y=0,
               texture_clip_width=0,
               texture_clip_height=0)
    
    Protected temp_pos_s_x, temp_pos_s_y, temp_s_y, i, ii, x, y, mode_1
    Protected image_width, image_height, used_image_color, texture_height_offset
    Protected texture_width_, texture_height_, point, refresh_texture
    Protected *texture_buffer
    
    If Not IsImage(image_ID)
      ProcedureReturn -1
    EndIf
    
    If Not IsImage(texture_ID) And mode<>-1
      ProcedureReturn -2
    EndIf
    
    If mode<-256 Or mode>256
      mode=0
    EndIf
    
    If mode=-1
      texture_width_=0
      texture_height_=0
    Else
      texture_width_=ImageWidth(texture_ID)-1
      texture_height_=ImageHeight(texture_ID)-1
    EndIf
    
    image_width=ImageWidth(image_ID)-1
    image_height=ImageHeight(image_ID)-1
    
    If mode<1
      Dim picture_1(image_width , image_height)
    EndIf
    
    texture_clip_width-1
    texture_clip_height-1
    
    If texture_clip_width>texture_width_ Or texture_clip_width<0
      texture_clip_width=texture_width_
    EndIf
    If texture_clip_height>texture_height_ Or texture_clip_height<1
      texture_clip_height=texture_height_
    EndIf
    
    If texture_clip_x<0 Or texture_clip_x>texture_clip_width
      texture_clip_x=0
    EndIf
    If texture_clip_y<0 Or texture_clip_y>texture_clip_height
      texture_clip_y=0
    EndIf
    
    If texture_width>ImageWidth(image_ID)-texture_x Or texture_width<1
      texture_width=ImageWidth(image_ID)-texture_x
    EndIf
    If texture_height>ImageHeight(image_ID)-texture_y Or texture_height<1
      texture_height=ImageHeight(image_ID)-texture_y
    EndIf
    
    If mode>0
      If image_get_color_x<0 Or image_get_color_y<0
        image_get_color_x=-1
        image_get_color_y=-1
      EndIf
      
      If image_get_color_x>texture_clip_width-texture_clip_x
        image_get_color_x=0
      EndIf
      If image_get_color_y>texture_clip_height-texture_clip_y
        image_get_color_y=0
      EndIf
    Else
      If image_get_color_x>image_width
        image_get_color_x=0
      EndIf
      If image_get_color_y>image_height
        image_get_color_y=0
      EndIf
    EndIf
    
    texture_clip_width-texture_clip_x
    texture_clip_height-texture_clip_y
    
    Protected Dim texture(texture_clip_width, texture_clip_height)
    
    If  mode>0 And image_get_color_x>-1
      If StartDrawing(ImageOutput(texture_ID))
        used_image_color=Point(image_get_color_x+texture_clip_x, image_get_color_y+texture_clip_y)
        StopDrawing()
      Else
        ProcedureReturn -4
      EndIf
    Else
      If texture_get_color<>-1
        used_image_color=texture_get_color
        If old_texture_get_color<>texture_get_color
          old_texture_get_color=texture_get_color
          refresh_texture=1
        EndIf
        used_image_color=texture_get_color
      EndIf
    EndIf
    
    Macro get_texture
      If StartDrawing(ImageOutput(texture_ID))
        If alpha_sprite
          DrawingMode(#PB_2DDrawing_AlphaBlend)
        EndIf
        For i=0 To texture_clip_height
          For ii=0 To texture_clip_width
            point=Point(ii+texture_clip_x, i+texture_clip_y)
            If image_get_color_x>-1 And ColorDistanceSpriteMask(point, used_image_color)<=percent
              texture(ii, i)=used_image_color
            Else
              texture(ii, i)=Point(ii+texture_clip_x, i+texture_clip_y)
            EndIf
          Next ii
        Next i
      Else
        ProcedureReturn -4
      EndIf
      StopDrawing()
    EndMacro
    
    Macro add_element
      get_texture
      *texture_buffer=AllocateMemory((texture_clip_width+1)*(texture_clip_height+1)*SizeOf(integer))
      CopyMemory(@texture(), *texture_buffer, MemorySize(*texture_buffer))
      AddElement(textures())
      textures()\texture_ID=texture_ID
      textures()\texture_buffer=*texture_buffer
      textures()\texture_clip_width=texture_clip_width
      textures()\texture_clip_height=texture_clip_height
      textures()\texture_percent_transparent=percent
    EndMacro
    
    If mode=-1
      texture(0, 0)=texture_ID
    Else
      If Not ListSize(textures())
        add_element
      Else
        i=0
        ForEach(textures())
          If textures()\texture_ID=texture_ID
            If textures()\texture_clip_width<>texture_clip_width Or
               textures()\texture_clip_height<>texture_clip_height Or
               textures()\texture_percent_transparent<>percent Or
               refresh_texture
              textures()\texture_clip_width=texture_clip_width
              textures()\texture_clip_height=texture_clip_height
              textures()\texture_percent_transparent=percent
              FreeMemory(textures()\texture_buffer)
              Dim texture(texture_clip_width, texture_clip_height)
              get_texture
              *texture_buffer=AllocateMemory((texture_clip_width+1)*(texture_clip_height+1)*SizeOf(integer))
              textures()\texture_buffer=*texture_buffer
              CopyMemory(@texture(), *texture_buffer, MemorySize(*texture_buffer))
            Else
              *texture_buffer=textures()\texture_buffer
              CopyMemory(*texture_buffer, @texture(), MemorySize(*texture_buffer))
            EndIf
            i=1
            Break
          EndIf
        Next
      EndIf
      refresh_texture=0
      If Not i
        add_element
      EndIf
    EndIf
    
    texture_width+texture_x
    temp_pos_s_x=texture_x
    temp_pos_s_y=texture_y
    texture_height_offset=texture_height+texture_y-1
    
    If StartDrawing(ImageOutput(image_ID))
      If alpha_sprite
        DrawingMode(#PB_2DDrawing_AlphaBlend)
      EndIf
      If image_get_color_x>-1
        If mode>0 ; Get a color
          used_image_color=texture(image_get_color_x, image_get_color_y)
        Else
          used_image_color=Point(image_get_color_x, image_get_color_y)
        EndIf
      EndIf
      
      i=0 : ii=0 : mode_1=-mode
      If texture_y<=image_height And texture_x<=image_width And texture_width>-1 And texture_height>-1
        Repeat
          If temp_pos_s_x<texture_width
            If temp_pos_s_x>-1 And temp_pos_s_y>-1
              If mode=1
                If texture(i, ii)<>used_image_color Or image_get_color_x<0
                  Plot(temp_pos_s_x, temp_pos_s_y, texture(i, ii))
                EndIf
              ElseIf mode>1
                If texture(i, ii)<>used_image_color Or image_get_color_x<0
                  Plot(temp_pos_s_x, temp_pos_s_y, AlphaBlend(texture(i, ii), Point(temp_pos_s_x, temp_pos_s_y), mode))
                EndIf
              ElseIf mode<-2
                If ColorDistanceFill(Point(temp_pos_s_x, temp_pos_s_y), used_image_color)<=percent_1
                  Plot(temp_pos_s_x, temp_pos_s_y, AlphaBlend(texture(i, ii), Point(temp_pos_s_x, temp_pos_s_y), mode_1))
                  picture_1(temp_pos_s_x, temp_pos_s_y)=-1
                EndIf
              Else
                If ColorDistanceFill(Point(temp_pos_s_x, temp_pos_s_y), used_image_color)<=percent_1
                  Plot(temp_pos_s_x, temp_pos_s_y, texture(i, ii))
                  picture_1(temp_pos_s_x, temp_pos_s_y)=-1
                EndIf
              EndIf
            EndIf
            If Not temp_s_y
              temp_s_y=temp_pos_s_y+1
            EndIf
            temp_pos_s_x+1
          Else
            ii+1
            If ii>texture_clip_height
              ii=0
            EndIf
            i+texture_clip_width
            temp_pos_s_y=temp_s_y
            temp_pos_s_x=texture_x
            temp_s_y=0
            If temp_pos_s_y>image_height Or temp_pos_s_y>texture_height_offset
              Break
            EndIf
          EndIf
          i+1
          If i>texture_clip_width
            i=0
          EndIf
        ForEver
        If mode<1
          min_x_1=image_width
          min_y_1=image_height
          For y=0 To image_height
            For x=0 To image_width
              If picture_1(x, y)
                If x<min_x_1
                  min_x_1=x
                EndIf
                If y<min_y_1
                  min_y_1=y
                EndIf
                If x>max_x_1
                  max_x_1=x
                EndIf
                If y>max_y_1
                  max_y_1=y
                EndIf
              EndIf
            Next x
          Next y
        EndIf
      EndIf
    Else
      ProcedureReturn -5
    EndIf
    If Not mode
      Box(image_get_color_x-1, image_get_color_y-1, 3, 3, 0)
    EndIf
    StopDrawing()
    ProcedureReturn 1
  EndProcedure 
  
  Procedure AlphaChannelSprite_BF(image_ID, texture_ID,
                                  texture_x,
                                  texture_y, 
                                  texture_width=0,
                                  texture_height=0,
                                  texture_clip_x=0,
                                  texture_clip_y=0,
                                  texture_clip_width=0,
                                  texture_clip_height=0)
    
    Protected result
    alpha_sprite=1
    
    result=BF(1, image_ID, texture_ID,
              0,
              0,
              texture_x,
              texture_y, 
              texture_width,
              texture_height,
              texture_clip_x,
              texture_clip_y,
              texture_clip_width,
              texture_clip_height)
    
    alpha_sprite=0
    ProcedureReturn result
  EndProcedure
  
  Procedure SpriteSimple_BF(mode, image_ID, texture_ID,                                                          
                            x,
                            y,
                            output_width=0,
                            output_height=0,
                            alpha=1)         
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    Protected result, temporary_texture_ID, texture_size_changed, using_sprite_mask
    Protected image_width=ImageWidth(texture_ID)
    Protected image_height=ImageHeight(texture_ID)
    
    If alpha<1 : alpha=1 : EndIf
    
    If mode<0 Or mode>2 : mode=0 : EndIf
    
    If Not mode : using_sprite_mask=-1 : EndIf
    
    If output_width<1 Or output_height<1
      output_width=image_width
      output_height=image_height
    Else
      If output_width<>image_width Or output_height<>image_height
        temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
        If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
        
        If Not ResizeImage(temporary_texture_ID, output_width, output_height)
          FreeImage(temporary_texture_ID)
          ProcedureReturn -6
        EndIf
        
        texture_ID=temporary_texture_ID
        texture_size_changed=1
      EndIf
    EndIf
    
    If mode=2 : alpha_sprite=1 : alpha=1 : EndIf
    
    result=BF(alpha, image_ID, texture_ID,
              using_sprite_mask,
              0,
              x,
              y, 
              output_width,
              output_height)
    
    If texture_size_changed
      FreeImage(texture_ID)
    EndIf
    
    alpha_sprite=0
    ProcedureReturn result
  EndProcedure
  
  Procedure CreateSprite_from_AlphaImage_BF(mode, image_ID,
                                            mask_color,
                                            percent_color_distance)
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1
    Protected image_width_1=image_width+1
    Protected image_height_1=image_height+1
    Protected point_, i, ii, old_percent_color_distance, result
    
    Protected texture_ID=CreateImage(#PB_Any, image_width_1 ,image_height_1, 24, mask_color)
    If Not texture_ID : ProcedureReturn -6 : EndIf
    
    result=AlphaChannelSprite_BF(texture_ID, image_ID,
                                 0,
                                 0, 
                                 image_width_1,
                                 image_height_1)
    If mode<1
      If StartDrawing(ImageOutput(texture_ID))
        For i=0 To image_height
          For ii=0 To image_width
            point_=Point(ii, i)
            If ColorDistance_BF(point_, mask_color)<=percent_color_distance
              Plot(ii, i, mask_color)
            EndIf
          Next ii
        Next i
        StopDrawing()
      Else
        ProcedureReturn -4
      EndIf   
    Else 
      old_percent_color_distance=percent_1
      percent_1=percent_color_distance
      result=FloodFill(-1, texture_ID, mask_color,
                       0,
                       0)
      If result<0 : ProcedureReturn result : EndIf
      result=FloodFill(-1, texture_ID, mask_color,
                       image_width,
                       0)
      If result<0 : ProcedureReturn result : EndIf
      FloodFill(-1, texture_ID, mask_color,
                0,
                image_height)
      If result<0 : ProcedureReturn result : EndIf
      FloodFill(-1, texture_ID, mask_color,
                image_width,
                image_height)
      If result<0 : ProcedureReturn result : EndIf
      percent_1=old_percent_color_distance
    EndIf
    ProcedureReturn texture_ID
  EndProcedure
  
  Procedure CreateAlphaImage_from_Sprite_BF(image_ID,
                                            percent_color_distance)
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1
    Protected image_width_1=image_width+1
    Protected image_height_1=image_height+1
    Protected point, i, ii, old_percent_color_distance, alpha_image_ID
    
    Protected Dim image.q(image_width, image_height)
    
    If StartDrawing(ImageOutput(image_ID)) ; Put image in array
      
      point=Point(0, 0)
      
      For i=0 To image_height
        For ii=0 To image_width
          If ColorDistance_BF(point, Point(ii,i))>=percent_color_distance 
            image(ii, i)=Point(ii, i)
          Else
            image(ii, i)=-1
          EndIf
        Next ii
      Next i
    Else
      ProcedureReturn -5
    EndIf
    
    StopDrawing()
    
    alpha_image_ID=CreateImage(#PB_Any, image_width_1, image_height_1, 32, #PB_Image_Transparent)
    If Not alpha_image_ID : ProcedureReturn -1 : EndIf
    
    old_percent_color_distance=percent_1
    percent_1=percent_color_distance
    
    If StartDrawing(ImageOutput(alpha_image_ID)) ; Put array in image
      
      DrawingMode(#PB_2DDrawing_AllChannels)
      For i=0 To image_height
        For ii=0 To image_width
          point=image(ii,i)
          If point<>-1
            Plot(ii, i, RGBA (Red(point), Green(point), Blue(point), $FF))
          EndIf
        Next ii
      Next i
    Else
      ProcedureReturn -5
    EndIf
    
    StopDrawing()
    
    percent_1=old_percent_color_distance
    
    ProcedureReturn alpha_image_ID
  EndProcedure
  
  Procedure Texture_FloodFill(x, y, image_ID, texture_ID)
    Protected texture_width_=ImageWidth(texture_ID)-1
    Protected texture_height_=ImageHeight(texture_ID)-1
    Protected image_width=ImageWidth(image_ID)-1
    Protected image_height=ImageHeight(image_ID)-1
    Protected image_width_1=image_width+1, image_height_1=image_height+1 
    Protected texture_width__1=texture_width_+1, texture_height__1=texture_height_+1 
    Protected x1, y1, old_color, point
    Dim picture(image_width , image_height)
    
    Structure point_
      x.i
      y.i
    EndStructure
    
    If x<0 Or x>image_width Or y<0 Or y>image_height
      ProcedureReturn -8
    EndIf
    
    If StartDrawing(ImageOutput(image_ID))
      old_color=Point(x,y)
      NewList stack.point_()
      AddElement(stack()) : stack()\x=x : stack()\y=y
      While(LastElement(stack()))
        x=stack()\x : y=stack()\y
        DeleteElement(stack())
        If x>-1 And x<image_width_1 And y>-1 And y<image_height_1 And Not picture(x, y)
          point=Point(x, y)
        Else
          point=-1
          If x<0 : x= 0 : EndIf
        EndIf
        
        Macro add_stack
          picture(x, y)=-1
          AddElement(stack()) : stack()\x=x   : stack()\y=y+1
          AddElement(stack()) : stack()\x=x   : stack()\y=y-1
          AddElement(stack()) : stack()\x=x+1 : stack()\y=y
          AddElement(stack()) : stack()\x=x-1 : stack()\y=y
        EndMacro
        
        If point=-1
          If point=old_color
            add_stack
          EndIf
        Else
          If ColorDistanceFill(point, old_color)<=percent_1 ; percent
            add_stack
          EndIf
        EndIf
      Wend
      
      min_x=image_width
      min_y=image_height
      For y=0 To image_height
        For x=0 To image_width
          If picture(x, y)
            If x<min_x
              min_x=x
            EndIf
            If y<min_y
              min_y=y
            EndIf
            If x>max_x
              max_x=x
            EndIf
            If y>max_y
              max_y=y
            EndIf
          EndIf
        Next x
      Next y
      
    Else
      ProcedureReturn -5
    EndIf
    StopDrawing()
    
    Protected Dim texture(image_width, image_height)
    
    If StartDrawing(ImageOutput(texture_ID))
      For y=0 To texture_height_
        For x=0 To texture_width_
          If x>-1 And y>-1 And x<image_width_1 And y<image_height_1
            texture(x, y)=Point(x, y)
          EndIf
        Next x
      Next y
    Else
      ProcedureReturn -4
    EndIf
    StopDrawing()
    
    If StartDrawing(ImageOutput(image_ID))
      For y=0 To image_height
        For x=0 To image_width
          If picture(x, y)=-1
            Plot(x, y, texture(x, y))
          EndIf
        Next x
      Next y
    Else
      ProcedureReturn -5
    EndIf
    StopDrawing()
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure FloodFill(mode, image_ID, texture_ID,
                      x,
                      y,
                      texture_x=0,
                      texture_y=0, 
                      texture_width=0,
                      texture_height=0,
                      texture_clip_x=0,
                      texture_clip_y=0,
                      texture_clip_width=0,
                      texture_clip_height=0) 
    
    If mode>-1 : mode=-2 : EndIf
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    If mode<>-1 And Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    
    Protected temporary_texture_ID, result, color
    
    If StartDrawing(ImageOutput(image_ID))
      If x<0 Or x>ImageWidth(image_ID)-1 : x=0 : EndIf
      If y<0 Or y>ImageHeight(image_ID)-1 : y=0 : EndIf
      color=Point(x, y)
      StopDrawing()
    Else
      ProcedureReturn -5
    EndIf
    
    temporary_texture_ID=CreateImage(#PB_Any, ImageWidth(image_ID), ImageHeight(image_ID)) 
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If mode=-1 : color=texture_ID : EndIf
    
    If StartDrawing(ImageOutput(temporary_texture_ID))
      Box(0, 0, ImageWidth(image_ID), ImageHeight(image_ID), color)
      StopDrawing()
    Else
      FreeImage(temporary_texture_ID)
      ProcedureReturn -5
    EndIf
    
    If mode<>-1
      result=BF(mode, temporary_texture_ID, texture_ID,
                0,
                0,
                texture_x,
                texture_y, 
                texture_width,
                texture_height,
                texture_clip_x,
                texture_clip_y,
                texture_clip_width,
                texture_clip_height)
      If result<1 : FreeImage(temporary_texture_ID) : ProcedureReturn result : EndIf
    EndIf
    
    result=Texture_FloodFill(x, y, image_ID, temporary_texture_ID)
    
    FreeImage(temporary_texture_ID)
    
    BucketFill_Image::ErrorCheck_BF(result)
    
    ProcedureReturn result
    
  EndProcedure
  
  Procedure PhotoBrush_BF(mode, image_ID, texture_ID,
                          x,
                          y,
                          texture_width,
                          texture_height,
                          percent_visibility.f=100)
    If Not IsImage(image_ID) : ProcedureReturn -1 : EndIf
    If Not IsImage(texture_ID) : ProcedureReturn -2 : EndIf
    Protected i, ii, result, max_repeats, temporary_texture_ID
    Protected repeats.f, divisor.f=250
    
    If texture_width<2 : texture_width=2 : EndIf
    If texture_height<2 : texture_height=2 : EndIf
    
    If mode>3 : mode=0 : EndIf
    
    If mode<-1 : mode=-1 : EndIf
    
    If percent_visibility<1 : percent_visibility=1 : EndIf
    
    If percent_visibility>100 : percent_visibility=100 : EndIf
    
    If texture_height>texture_width
      max_repeats=texture_width>>1
    Else
      max_repeats=texture_height>>1
    EndIf 
    
    If max_repeats>100 : max_repeats=100 : EndIf
    
    temporary_texture_ID=CopyImage(texture_ID, #PB_Any)
    
    If Not temporary_texture_ID : ProcedureReturn -6 : EndIf
    
    If ImageWidth(temporary_texture_ID)<>texture_width Or ImageHeight(temporary_texture_ID)<>texture_height
      If Not ResizeImage(temporary_texture_ID, texture_width, texture_height)
        FreeImage(temporary_texture_ID)
        ProcedureReturn -6
      EndIf
    EndIf
    
    percent_visibility-1
    
    If mode<1
      
      divisor=250-divisor/(65)*percent_visibility
      If divisor<1 : divisor=1 : EndIf
      
      result=BF(divisor, image_ID, temporary_texture_ID,
                -1,
                -1, 
                x, 
                y,  
                texture_width,
                texture_height)
      
    Else
      
      If mode=1
        repeats=max_repeats/(230*mode)*percent_visibility
      ElseIf mode=2
        repeats=max_repeats/(140*mode)*percent_visibility
      ElseIf mode=3
        repeats=max_repeats/(120*mode)*percent_visibility
      EndIf
      
      If repeats>max_repeats : repeats=max_repeats : EndIf
      
      If repeats<1 : repeats=1 : EndIf
      
      For i=0 To repeats
        
        result=BF(250-ii, image_ID, temporary_texture_ID,
                  -1,
                  -1,
                  x+ii,
                  y+ii,
                  texture_width-ii-ii,
                  texture_height-ii-ii,
                  ii,
                  ii,
                  texture_width-ii,
                  texture_height-ii) 
        
        ii+mode
        
      Next i
      
    EndIf
    
    FreeImage(temporary_texture_ID)
    ProcedureReturn result
  EndProcedure
  
EndModule

; - Demo part -

CompilerIf #PB_Compiler_IsMainFile
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  
  EnableExplicit
  
  Define window_ID, win_event, image_ID, texture_ID, result
  Define image_x, image_y, image_width, image_height, point
  Define path$
  
  CompilerIf #PB_Compiler_OS=#PB_OS_Linux
    Define font_1=LoadFont(1, "Arial", 11)
    #GeeBee="./BucketFill_Image_Set/Geebee2.bmp"
    #Clouds="./BucketFill_Image_Set/Clouds.jpg"
    #SoilWall="./BucketFill_Image_Set/soil_wall.jpg"
    #RustySteel="./BucketFill_Image_Set/RustySteel.jpg"
    #Caisse="./BucketFill_Image_Set/Caisse.png"
    #Dirt="./BucketFill_Image_Set/Dirt.jpg"
    #Background="./BucketFill_Image_Set/Background.bmp"
  CompilerElse
    ; Linux/Mac can not load examples from the Compiler_Home path
    #GeeBee=#PB_Compiler_Home+"Examples/Sources/Data/Geebee2.bmp"
    #Clouds=#PB_Compiler_Home+"Examples/3D/Data/Textures/Clouds.jpg"
    #SoilWall=#PB_Compiler_Home+"Examples/3D/Data/Textures/soil_wall.jpg"
    #RustySteel=#PB_Compiler_Home+"Examples/3D/Data/Textures/RustySteel.jpg"
    #Caisse=#PB_Compiler_Home+"Examples/3D/Data/Textures/Caisse.png"
    #Dirt=#PB_Compiler_Home+"Examples/3D/Data/Textures/Dirt.jpg"
    #Background=#PB_Compiler_Home+"Examples/Sources/Data/Background.bmp"
  CompilerEndIf
  
  ; Presets
  image_x=50
  image_y=50
  image_width=600
  image_height=400
  
  image_ID=CreateImage(#PB_Any, image_width, image_height)
  
  window_ID=OpenWindow(#PB_Any, 0, 0,
                       ImageWidth(image_ID)+100, ImageHeight(image_ID)+100, "Bucket Fill advanced - For Images",
                       #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_Invisible)
  
  StartDrawing(ImageOutput(image_ID))
  Circle(100, 100, 125, $A1AAAA)
  DrawingMode(#PB_2DDrawing_Transparent)
  CompilerIf #PB_Compiler_OS=#PB_OS_Linux
    DrawingFont(font_1)
  CompilerEndIf
  DrawText(20, 20, "A VERY COOL FUNCTION !", $FF00)
  DrawText(20, 40, "BUCKET FILL ADVANCED", $FF00)
  DrawText(20, 60, "www.quick-aes-256.de", $FF00)
  DrawText(20, 80, "www.nachtoptik.de", $FF00)
  DrawText(220, 5, "Sprites simple for Images", $FFFF)
  DrawText(220, 25, "Also FloodFill with texture support", -1)
  RoundBox (185, 80, 100 , 290 , 20, 20, $A2AAAA)
  Box (300, 50, 150 , 150, $A3AAAA)
  Box (30, 200, 128 , 128, $A4AAAA)
  Box (460, 10, 128 , 128, $A5AAAA)
  Circle(580, 110, 125, $A6AAAA)
  Circle(590, 180, 100, $FE)
  DrawText(469, 230, "Texture FLOODFILL")
  StopDrawing()
  
  If StartVectorDrawing(ImageVectorOutput(image_ID))
    VectorSourceColor($FF000001)
    MovePathCursor (470 , 250)
    AddPathCircle (470 , 250 , 160, 0, 235 , #PB_Path_Connected)
    FillPath()
    StopVectorDrawing()
  EndIf
  StopDrawing()
  
  ; - Call function #1 -
  path$=#SoilWall
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #2 -
  path$=#RustySteel
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              0,
                              35)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #3 -
  path$=#Caisse
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              185,
                              210,
                              185,
                              80,
                              0,
                              0,
                              15,
                              10,
                              55,
                              50)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #4 -
  path$=#Dirt
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              310,
                              110)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #5 -
  path$=#Background
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              376,
                              121)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Manipulate the BucketFill output color -
  Define x, y, color, new_color
  Define *array=BucketFill_Image::GetBucketArray_Adress_BF()
  Define image_width=ImageWidth(image_ID)-1
  Define image_height=ImageHeight(image_ID)-1
  Define image_width_1=ImageWidth(image_ID)
  Define image_height_1=ImageHeight(image_ID)
  StartDrawing(ImageOutput(image_ID))
  color=Point(0, 180) ; As sample - This point you can get how ever you want
  new_color=$0FFF00   ; As sample
  For y=BucketFill_Image::GetBucket_Y_BF() To BucketFill_Image::GetBucket_YY_BF()-102
    For x=BucketFill_Image::GetBucket_X_BF() To BucketFill_Image::GetBucket_XX_BF()
      ; If PeekI(*array+(image_height_1*x+y)*8) ; Read the array
      If BucketFill_Image::GetBucketArray_Point_BF(x, y) ; Read the array
        point=Point(x, y)
        If point And BucketFill_Image::ColorDistance_BF(point, color)<30 ; Percent color distance
          Plot(x, y, BucketFill_Image::AlphaBlend_BF(point, new_color, 50)) ; Alpha blend
        EndIf
      EndIf
    Next x
  Next y
  StopDrawing()
  
  ; - Call function #6 -
  path$=#Clouds
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              30,
                              202,
                              30,
                              200)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #7 -
  path$=#SoilWall
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              462,
                              11)
  BucketFill_Image::ErrorCheck_BF(result)
  
  BucketFill_Image::SetColorDistanceSpriteMask_BF(20) ; Enable color distance
  
  ; - Call function #8 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(1, image_ID, texture_ID,
                              0,
                              0,
                              30,
                              200,
                              128,
                              128)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #9 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(1, image_ID, texture_ID,
                              0,   
                              0,  
                              320, 
                              50, 
                              128, 
                              128)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #10 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
  ResizeImage(texture_ID, 80, 60)
  result=BucketFill_Image::BF(150, image_ID, texture_ID,
                              0,   ; Get the sprite mask color from the sprite x pos ( -1 ignore the mask )
                              0,   ; Get the sprite mask color from the sprite y pos ( -1 ignore the mask )
                              60,  ; x  coordinate sprite output
                              110, ; y  coordinate sprite output
                              80,  ; xx coordinate sprite output - More results more sprites in a row - horizontal
                              60)  ; yy coordinate sprite output - More results more sprites in a row - vertical
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #11 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
  ResizeImage(texture_ID, 50, 50)
  result=BucketFill_Image::BF(1, image_ID, texture_ID,
                              0,                                   
                              0,                                 
                              340,                           
                              250,                             
                              250,                           
                              150)
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Call function #12 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$) ; Sprite mode
  ResizeImage(texture_ID, 30, 30)
  result=BucketFill_Image::BF(1, image_ID, texture_ID,
                              0,                                   
                              0,                                 
                              20,                           
                              372,                             
                              300,                           
                              30)
  BucketFill_Image::ErrorCheck_BF(result)
  
  BucketFill_Image::SetColorDistanceSpriteMask_BF(0) ; Disable color distance
  
  ; - Call function #13 -
  path$=#Geebee
  texture_ID=LoadImage(#PB_Any, path$)
  ResizeImage(texture_ID, 30, 30)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              500, ; Get the color for repalcing with a texture x                               
                              50,  ; Get the color for repalcing with a texture y                            
                              425, ; Startposition texture output x                     
                              0,   ; Startposition texture output y                    
                              200, ; Endposition texture output xx                    
                              250) ; Endposition texture output yy
  BucketFill_Image::ErrorCheck_BF(result)
  
  BucketFill_Image::SetColorDistanceFill_BF(23) ; Enable color distance
  
  ; - Call function #14 -
  path$=#Clouds
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::BF(-2, image_ID, texture_ID,
                              590,                                   
                              30,                                 
                              440)
  BucketFill_Image::ErrorCheck_BF(result)
  
  BucketFill_Image::SetColorDistanceSpriteMask_BF(0) ; Disable color distance
  
  ; - FloodFill #1 -
  path$=#Caisse
  texture_ID=LoadImage(#PB_Any, path$)
  result=BucketFill_Image::FloodFill(-2, image_ID, texture_ID, ; mode<-2 = with alpha blending
                                     550,                      ; x pos
                                     180,                      ; y pos
                                     10,                       ; Startposition texture output x
                                     10,                       ; Startposition texture output y
                                     0,                        ; Endposition texture output xx
                                     0,                        ; Endposition texture output yy
                                     0,                        ; Startposition inside the texture x
                                     0,                        ; Startposition inside the texture y
                                     30,                       ; Endposition inside the texture xx
                                     30)                       ; Endposition inside the texture yy
                                                               ;  For using FloodFill without a texture set mode to -1
                                                               ;  and use the texture_ID parameter as color,
                                                               ;  as sample so - texture_ID=$FFFF
  BucketFill_Image::ErrorCheck_BF(result)
  
  ; - Manipulate the FloodFill output color -
  Define x, y, x1, y1, color, new_color
  Define *array=BucketFill_Image::GetFloodArray_Adress_BF()
  Define image_width=ImageWidth(image_ID)-1
  Define image_height=ImageHeight(image_ID)-1
  Define image_width_1=ImageWidth(image_ID)
  Define image_height_1=ImageHeight(image_ID)
  StartDrawing(ImageOutput(image_ID))
  color=Point(73, 180) ; As sample - This point you can get how ever you want
  new_color=$0FFF00    ; As sample
  For y=BucketFill_Image::GetFlood_Y_BF() To BucketFill_Image::GetFlood_YY_BF()-120
    For x=BucketFill_Image::GetFlood_X_BF() To BucketFill_Image::GetFlood_XX_BF()
      ; If PeekI(*array+(image_height_1*x+y)*8) ; Read te array
      If BucketFill_Image::GetFloodArray_Point_BF(x, y) ; Read the array
        point=Point(x, y)
        If BucketFill_Image::ColorDistance_BF(point, color)<20 ; Percent color distance
          Plot(x, y, BucketFill_Image::AlphaBlend_BF(point, new_color, 80)) ; Alpha blend
        EndIf
      EndIf
    Next x
  Next y
  For y=BucketFill_Image::GetFlood_Y_BF()+80 To BucketFill_Image::GetFlood_YY_BF()
    For x=BucketFill_Image::GetFlood_X_BF()+70 To BucketFill_Image::GetFlood_XX_BF()
      ; If PeekI(*array+(image_height_1*x+y)*8) ; Read the array
      If BucketFill_Image::GetFloodArray_Point_BF(x, y) ; Read the array
        point=Point(x, y)
        If BucketFill_Image::ColorDistance_BF(point, color)<20 ; Percent color distance
          Plot(x, y, BucketFill_Image::AlphaBlend_BF(point, $008CFF, 80)) ; Alpha blend
        EndIf
      EndIf
    Next x
  Next y
  For y=BucketFill_Image::GetFlood_Y_BF()+50 To BucketFill_Image::GetFlood_YY_BF()-60
    For x=BucketFill_Image::GetFlood_X_BF() To BucketFill_Image::GetFlood_XX_BF()
      ; If PeekI(*array+(image_height_1*x+y)*8) ; Read the array
      If BucketFill_Image::GetFloodArray_Point_BF(x, y) ; Read the array
        point=Point(x, y)
        If BucketFill_Image::ColorDistance_BF(point, color)<20 ; Percent color distance
          Plot(x, y, BucketFill_Image::AlphaBlend_BF(point, $FFFF, 80)) ; Alpha blend
        EndIf
      EndIf
    Next x
  Next y
  StopDrawing()
  
  HideWindow(window_ID, 0)
  
  ; - Sprite animation #1 -
  Define x, y, arc, flip
  Define *drawing_buffer_grabed_image, *drawing_buffer
  
  path$=#GeeBee
  texture_ID=LoadImage(#PB_Any, path$)
  
  ResizeImage(texture_ID, 100, 100)
  
  *drawing_buffer_grabed_image=BucketFill_Image::GrabImage_BF(image_ID) ; Grab image
  BucketFill_Image::ErrorCheck_GrabImage_BF(*drawing_buffer_grabed_image)
  
  BucketFill_Image::SetColorDistanceSpriteMask_BF(20) ; percent
  
  Define canvas_ID=CanvasGadget(#PB_Any, image_x, image_y , ImageWidth(image_ID), ImageHeight(image_ID))
  
  Repeat
    win_event=WaitWindowEvent(1)
    If win_event=#PB_Event_CloseWindow
      FreeMemory(*drawing_buffer_grabed_image) ; Free grabed image
      BucketFill_Image::FreeTextures_BF()      ; Free grabed textures
      Break
    EndIf
    
    If BucketFill_Image::Delay_BF(0, 10) ; Timer 0, Time 10 ms - 100 timer available 0 - 99 - you can change
      *drawing_buffer=BucketFill_Image::DrawingBuffer_BF(image_ID)
      BucketFill_Image::ErrorCheck_DrawingBuffer_BF(*drawing_buffer)
      CopyMemory(*drawing_buffer_grabed_image, *drawing_buffer,
                 MemorySize(*drawing_buffer_grabed_image)) ; Refresh image
      x+1 : y-1
      If x>ImageWidth(image_ID)
        x=-ImageWidth(texture_ID)
      EndIf
      If y<-ImageHeight(texture_ID)
        y=ImageHeight(image_ID)
      EndIf
      
      result=BucketFill_Image::BF(80, image_ID, texture_ID, ; Sprite mode - write sprite 
                                  0,                                  
                                  0,                                
                                  x,                           
                                  y,                             
                                  ImageWidth(texture_ID),                           
                                  ImageHeight(texture_ID))
      BucketFill_Image::ErrorCheck_BF(result)
      
      ; Graphic output #1
      If arc>360 : arc=0 : EndIf
      x1-1 :y1+1 : arc+1
      If x1<-ImageWidth(texture_ID)+20
        x1=ImageWidth(image_ID)+20
      EndIf
      If y1>ImageHeight(image_ID)+20
        y1=-ImageHeight(texture_ID)-20
      EndIf
      
      If StartVectorDrawing(ImageVectorOutput(image_ID))
        VectorSourceColor($FF20A5DA)
        MovePathCursor (x1 , y1)
        AddPathCircle (x1 , y1 , 30, 270, arc , #PB_Path_Connected)
        FillPath()
        StopVectorDrawing()
      EndIf
      StopDrawing()
      
      StartDrawing(CanvasOutput(canvas_ID)) ; Get the result
      DrawImage(ImageID(image_ID), 0, 0)
      StopDrawing() 
      
    EndIf
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 1615
; FirstLine = 1578
; Folding = ----------
; Markers = 1090,1473
; EnableXP
; DisableDebugger
; EnableUnicode