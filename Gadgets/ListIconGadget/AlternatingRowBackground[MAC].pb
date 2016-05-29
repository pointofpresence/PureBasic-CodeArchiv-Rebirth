﻿;    Description: ListIcon with alternating row background colors
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
If OpenWindow(0, 0, 0, 270, 260, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ListIconGadet(0, 10, 10, 250, 180)
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the ListIcon")
  Next
  
  ; alternating colors
  CocoaMessage(0,GadgetID(0),"setUsesAlternatingRowBackgroundColors:",#True)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP