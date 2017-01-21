;    Description: Load / catch image (all OS X supported image types) & save image
;         Author: wilbert
;           Date: 2012-09-29
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=392073#p392073
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure LoadImageEx(Image, Filename.s)
  Protected.i Result, Rep, Width, Height
  Protected Size.NSSize, Point.NSPoint
  CocoaMessage(@Rep, 0, "NSImageRep imageRepWithContentsOfFile:$", @Filename)
  If Rep
    CocoaMessage(@Width, Rep, "pixelsWide")
    CocoaMessage(@Height, Rep, "pixelsHigh")
    If Width And Height
      Size\width = Width
      Size\height = Height
      CocoaMessage(0, Rep, "setSize:@", @Size)
      Result = CreateImage(Image, Width, Height, 32, #PB_Image_Transparent)
      If Result
        If Image = #PB_Any : Image = Result : EndIf
        CocoaMessage(0, ImageID(Image), "lockFocus")
        CocoaMessage(0, Rep, "drawAtPoint:@", @Point)
        CocoaMessage(0, ImageID(Image), "unlockFocus")
      EndIf
    EndIf 
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure CatchImageEx(Image, *MemoryAddress, MemorySize)
  Protected.i Result, DataObj, Class, Rep, Width, Height
  Protected Size.NSSize, Point.NSPoint
  CocoaMessage(@DataObj, 0, "NSData dataWithBytesNoCopy:", *MemoryAddress, "length:", MemorySize, "freeWhenDone:", #NO)
  CocoaMessage(@Class, 0, "NSImageRep imageRepClassForData:", DataObj)
  If Class
    CocoaMessage(@Rep, Class, "imageRepWithData:", DataObj)
    If Rep
      CocoaMessage(@Width, Rep, "pixelsWide")
      CocoaMessage(@Height, Rep, "pixelsHigh")
      If Width And Height
        Size\width = Width
        Size\height = Height
        CocoaMessage(0, Rep, "setSize:@", @Size)
        Result = CreateImage(Image, Width, Height, 32, #PB_Image_Transparent)
        If Result
          If Image = #PB_Any : Image = Result : EndIf
          CocoaMessage(0, ImageID(Image), "lockFocus")
          CocoaMessage(0, Rep, "drawAtPoint:@", @Point)
          CocoaMessage(0, ImageID(Image), "unlockFocus")
        EndIf
      EndIf 
    EndIf
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure SaveImageEx(Image, FileName.s, Type = #NSPNGFileType, Compression.f = 0.8)
  Protected c.i = CocoaMessage(0, 0, "NSNumber numberWithFloat:@", @Compression)
  Protected p.i = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", c, "forKey:$", @"NSImageCompressionFactor")
  Protected imageReps.i = CocoaMessage(0, ImageID(Image), "representations")
  Protected imageData.i = CocoaMessage(0, 0, "NSBitmapImageRep representationOfImageRepsInArray:", imageReps, "usingType:", Type, "properties:", p)
  CocoaMessage(0, imageData, "writeToFile:$", @FileName, "atomically:", #NO)
EndProcedure
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
