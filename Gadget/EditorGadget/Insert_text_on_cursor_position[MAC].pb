;    Description: Insert text at the cursor position.
;         Author: J. Baker
;           Date: 2013-03-31
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=409531#p409531
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

If OpenWindow(0, 0, 0, 322, 180, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 8, 8, 306, 133)
  For a = 0 To 5
    AddGadgetItem(0, a, "Line "+Str(a))
  Next
  
  SetActiveGadget(0)
  
  ButtonGadget(1, 115, 150, 100, 25, "Insert Text")
  
  Repeat
    
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      
      Select EventGadget()
          
        Case 1
          CocoaMessage(0, GadgetID(0), "insertText:$", @" My inserted test!")
          
      EndSelect
      
    EndIf
    
  Until Event = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
