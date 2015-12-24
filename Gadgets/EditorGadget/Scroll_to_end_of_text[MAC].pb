;    Description: Scroll to end of text
;         Author: WilliamL
;           Date: 2012-11-02
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=395075#p395075
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

;run and you will see the items are listed but the last items are not visible
If OpenWindow(0, 0, 0, 322, 150, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 8, 8, 306, 133)
  For a = 0 To 15
    AddGadgetItem(0, a, "Line "+Str(a))
  Next
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
