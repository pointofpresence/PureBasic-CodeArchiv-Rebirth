;    Description: enable wordwrap in EditorGadget
;         Author: Shardik
;           Date: 2012-10-15
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393497#p393497
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure EditorGadget_SetWordWrap(EditorGadgetID, wrap)
  Protected Size.NSSize
  Protected Container.i = CocoaMessage(0, EditorGadgetID, "textContainer")
  CocoaMessage(@Size, Container, "containerSize")
  If wrap
    Size\width = GadgetWidth(0) - 2
  Else
    Size\width = $FFFF
  EndIf
  CocoaMessage(0, Container, "setContainerSize:@", @Size)
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  OpenWindow(0, 270, 100, 250, 110, "Word Wrap Test", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 230, 60)
  ButtonGadget(1, 60, 80, 140, 25, "Toggle Word Wrap")
  
  For i = 1 To 5
    Text$ = Text$ + "This is a word wrap test - "
  Next i
  
  SetGadgetText(0, Text$)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        If EventGadget() = 1
          WordWrap ! 1
          EditorGadget_SetWordWrap(GadgetID(0), WordWrap)
        EndIf
    EndSelect
  ForEver
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
