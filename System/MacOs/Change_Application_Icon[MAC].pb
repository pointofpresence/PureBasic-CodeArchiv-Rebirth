;    Description: Change Application Icon on runtime
;         Author: wilbert
;           Date: 2012-10-02
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=392372#p392372
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

CreateImage(0, 64, 64, 32 | #PB_Image_Transparent)
StartDrawing(ImageOutput(0))
DrawingMode(#PB_2DDrawing_AlphaBlend)
Circle(32, 32, 30, $ffd0f080)
StopDrawing()

Application = CocoaMessage(0, 0, "NSApplication sharedApplication")
CocoaMessage(0, Application, "setApplicationIconImage:", ImageID(0))

MessageRequester("", "Icon set")

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
