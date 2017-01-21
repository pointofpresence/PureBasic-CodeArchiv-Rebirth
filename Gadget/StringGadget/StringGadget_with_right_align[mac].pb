;    Description: right align string gadget
;         Author: wilbert
;           Date: 2012-09-06
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=390031#p390031
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

#NSRightTextAlignment = 1 ; for right align string gadget

If OpenWindow(0, 0, 0, 270, 260, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  StringGadget(2, 10,230,120,22,"String gadget")
  
  ;set string gadget to right-justified
  CocoaMessage(0,GadgetID(2),"setAlignment:", #NSRightTextAlignment)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
