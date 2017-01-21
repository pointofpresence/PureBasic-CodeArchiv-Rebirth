;    Description: Show Alert with SuppressionCheckbox
;         Author: wilbert
;           Date: 2012-10-12
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393221#p393221
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf
Procedure AlertWithSuppression(Title.s, Text.s, SuppressionText.s)
  Protected Alert = CocoaMessage(0, CocoaMessage(0, 0, "NSAlert new"), "autorelease")
  CocoaMessage(0, Alert, "setMessageText:$", @Title)
  CocoaMessage(0, Alert, "setInformativeText:$", @Text)
  CocoaMessage(0, Alert, "setShowsSuppressionButton:", #YES)
  Protected SuppressionButton = CocoaMessage(0, Alert, "suppressionButton")
  CocoaMessage(0, SuppressionButton, "setTitle:$", @SuppressionText)
  CocoaMessage(0, Alert, "runModal")
  ProcedureReturn CocoaMessage(0, SuppressionButton, "state")
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Suppress = #NO
  
  OpenWindow(0, 0, 0, 200, 100, "Alert with suppression", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(0, 10, 10, 180, 30, "Button")
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        If Suppress = #NO
          Suppress = AlertWithSuppression("Message", "You pressed the button", "Do not show this message again please")       
        EndIf
    EndSelect
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
