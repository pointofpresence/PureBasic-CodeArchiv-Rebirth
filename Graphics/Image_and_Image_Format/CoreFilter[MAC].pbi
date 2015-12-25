﻿;    Description: Apply a core image filter
;         Author: wilbert
;           Date: 2012-10-17
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393686#p393686
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure ApplyImageFilter(Image, Filter)
  If IsImage(Image)
    Protected CIImage, Rep = CocoaMessage(0, CocoaMessage(0, ImageID(Image), "representations"), "objectAtIndex:", 0)
    If CocoaMessage(0, Rep, "isKindOfClass:", CocoaMessage(0, 0, "NSBitmapImageRep class"))
      CIImage = CocoaMessage(0, CocoaMessage(0, CocoaMessage(0, 0, "CIImage alloc"), "initWithBitmapImageRep:", Rep), "autorelease")
    Else
      CIImage = CocoaMessage(0, 0, "CIImage imageWithData:", CocoaMessage(0, ImageID(Image), "TIFFRepresentation"))
    EndIf
    Protected ImageRect.NSRect\size\width = ImageWidth(Image) : imageRect\size\height = ImageHeight(Image)
    Protected Delta.CGFloat = 1
    CocoaMessage(0, Filter, "setValue:", CIImage, "forKey:$", @"inputImage")
    CocoaMessage(@CIImage, Filter, "valueForKey:$", @"outputImage")
    StartDrawing(ImageOutput(Image))
    CocoaMessage(0, CIImage, "drawInRect:@", @ImageRect, "fromRect:@", @ImageRect, "operation:", #NSCompositeCopy, "fraction:@", @Delta)
    StopDrawing()
  EndIf
EndProcedure

Procedure ColorControlsFilter(Saturation.f = 1.0, Brightness.f = 0.0, Contrast.f = 1.0)
  Protected Filter = CocoaMessage(0, 0, "CIFilter filterWithName:$", @"CIColorControls")
  CocoaMessage(0, Filter, "setDefaults")
  CocoaMessage(0, Filter, "setValue:", CocoaMessage(0, 0, "NSNumber numberWithFloat:@", @Saturation), "forKey:$", @"inputSaturation")
  CocoaMessage(0, Filter, "setValue:", CocoaMessage(0, 0, "NSNumber numberWithFloat:@", @Brightness), "forKey:$", @"inputBrightness")
  CocoaMessage(0, Filter, "setValue:", CocoaMessage(0, 0, "NSNumber numberWithFloat:@", @Contrast), "forKey:$", @"inputContrast")
  ProcedureReturn Filter
EndProcedure

Procedure GaussianBlurFilter(Radius.f = 2.0)
  Protected Filter = CocoaMessage(0, 0, "CIFilter filterWithName:$", @"CIGaussianBlur")
  CocoaMessage(0, Filter, "setDefaults")
  CocoaMessage(0, Filter, "setValue:", CocoaMessage(0, 0, "NSNumber numberWithFloat:@", @Radius), "forKey:$", @"inputRadius")
  ProcedureReturn Filter
EndProcedure

Procedure MonochromeFilter(Red.CGFloat, Green.CGFloat, Blue.CGFloat)
  Protected Filter = CocoaMessage(0, 0, "CIFilter filterWithName:$", @"CIColorMonochrome")
  CocoaMessage(0, Filter, "setDefaults")
  Color = CocoaMessage(0, 0, "CIColor colorWithRed:@", @Red, "green:@", @Green, "blue:@", @Blue)
  CocoaMessage(0, Filter, "setValue:", Color, "forKey:$", @"inputColor")
  ProcedureReturn Filter
EndProcedure


;-Example
CompilerIf #PB_Compiler_IsMainFile
  UsePNGImageDecoder()
  
  If OpenWindow(0, 0, 0, 180, 100, "CIFilter example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    If LoadImage(0, #PB_Compiler_Home + "Examples/3D/Data/Textures/Caisse.png")
      ApplyImageFilter(0, MonochromeFilter(1.0, 0.7, 0.3))
      ApplyImageFilter(0, GaussianBlurFilter(1.0))
      ImageGadget(0,  10, 10, 64, 64, ImageID(0))
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
