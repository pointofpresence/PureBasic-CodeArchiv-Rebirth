;    Description: Set a key for a button gadget
;         Author: wilbert
;           Date: 19-09-2012
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=391168#p391168
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

If OpenWindow(0, 0, 0, 222, 200, "ButtonGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(0, 10, 10, 200, 30, "Button")
  
  ButtonID = GadgetID(0)
  CocoaMessage(0, ButtonID, "setKeyEquivalent:$", @"b")
  CocoaMessage(0, ButtonID, "setKeyEquivalentModifierMask:", 1 << 19); 1 << 19 = alt
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
