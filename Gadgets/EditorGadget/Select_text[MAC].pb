;    Description: Select text area
;         Author: WilliamL
;           Date: 2013-11-25
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=431543#p431543
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Range.NSRange

If OpenWindow(0, 0, 0, 322, 150, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 8, 8, 306, 133)
  SetGadgetText(0, "This is a test string to test if selecting" + #CRLF$ + "specific areas will work")
  
  Range\location = 5
  Range\length = 10
  CocoaMessage(0, GadgetID(0), "setSelectedRange:@", @Range)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

CompilerIf #False ;second example
  offset=1
  For lne=0 To CountGadgetItems(1)-2
    offset+Len(GetGadgetItemText(1,lne))
  Next
  
  selb=FindString(First$,searchfor$,1) : sele=Len(searchfor$)
  Range\location = selb + offset
  Range\length = sele
  CocoaMessage(0, GadgetID(1), "setSelectedRange:@", @Range)
CompilerEndIf


; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
