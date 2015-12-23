;    Description: ContainerGadget with background image
;         Author: Shardik
;           Date: 30-01-2014
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=436415#p436415
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

#NSBoxCustom = 4
#NSLineBorder = 1

UseJPEGImageDecoder()

If LoadImage(0, #PB_Compiler_Home + "Examples/3D/Data/Textures/Clouds.jpg")
  OpenWindow(0, 270, 100, 300, 300, "Container with background image")
  ContainerGadget(0, 10, 10, 280, 280)
  
  ; ----- When setting a background image for an NSBox (ContainerGadget) the
  ;       BoxType has to be #NSBoxCustom and the BorderType #NSLineBorder !
  CocoaMessage(0, GadgetID(0), "setBoxType:", #NSBoxCustom)
  CocoaMessage(0, GadgetID(0), "setBorderType:", #NSLineBorder)
  ; ----- Set image as background image of ContainerGadget
  CocoaMessage(0, GadgetID(0), "setFillColor:",
               CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
