;    Description: InputRequester with cancel button and ability to set default text
;         Author: wilbert
;           Date: 2015-05-15
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=465129#p465129
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure.s InputRequesterEx(Title.s, Info.s, DefaultInput.s = "")
  Protected.i Alert, InputField, Frame.NSRect
  Frame\size\width = 300
  Frame\size\height = 24
  InputField = CocoaMessage(0, CocoaMessage(0, CocoaMessage(0, 0, "NSTextField alloc"), "initWithFrame:@", Frame), "autorelease")
  CocoaMessage(0, InputField, "setStringValue:$", @DefaultInput)
  Alert = CocoaMessage(0, CocoaMessage(0, 0, "NSAlert new"), "autorelease")
  CocoaMessage(0, Alert, "setMessageText:$", @Title)
  CocoaMessage(0, Alert, "setInformativeText:$", @Info)
  CocoaMessage(0, Alert, "addButtonWithTitle:$", @"OK")   
  CocoaMessage(0, Alert, "addButtonWithTitle:$", @"Cancel")
  CocoaMessage(0, Alert, "setAccessoryView:", InputField)
  If CocoaMessage(0, Alert, "runModal") = 1000
    ProcedureReturn PeekS(CocoaMessage(0, CocoaMessage(0, InputField, "stringValue"), "UTF8String"), -1, #PB_UTF8)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure



;-Example
CompilerIf #PB_Compiler_IsMainFile
  Debug InputRequesterEx("Title", "Informative text", "Default input")
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
