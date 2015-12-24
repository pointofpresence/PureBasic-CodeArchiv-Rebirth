;    Description: ListIcon with alternating row background colors and enable/disable scrollers
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
  
  ListViewGadget(0, 10, 10, 250, 180)
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview")
  Next
  
  ; alternating colors
  CocoaMessage(0,GadgetID(0),"setUsesAlternatingRowBackgroundColors:",#True)
  ; enable/disable scrollers
  ScrollView = CocoaMessage(0,GadgetID(0),"enclosingScrollView")
  CocoaMessage(0,ScrollView,"setHasVerticalScroller:", #False) ; "setHasHorizontalScroller:"
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
