;    Description: Default Button
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
#NSRoundedBezelStyle = 1 ; for default button

If OpenWindow(0, 0, 0, 270, 260, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ButtonGadget(1, 10, 200, 80, 30, "Button")
  
  ; set default button cell
  ButtonCell = CocoaMessage(0,GadgetID(1),"cell")
  CocoaMessage(0,GadgetID(1),"setBezelStyle:", #NSRoundedBezelStyle)
  CocoaMessage(0,WindowID(0),"setDefaultButtonCell:", ButtonCell)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
