;    Description: Call Apple Script
;         Author: wilbert
;           Date:2012-10-16
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393553#p393553
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure.s AppleScript(Script.s)
  Protected retVal.s, strVal, numItems, i
  Protected aScript = CocoaMessage(0, CocoaMessage(0, CocoaMessage(0, 0, "NSAppleScript alloc"), "initWithSource:$", @Script), "autorelease")
  Protected eventDesc = CocoaMessage(0, aScript, "executeAndReturnError:", #nil)
  If eventDesc
    numItems = CocoaMessage(0, eventDesc, "numberOfItems")
    If numItems
      For i = 1 To numItems
        strVal = CocoaMessage(0, CocoaMessage(0, eventDesc, "descriptorAtIndex:", i), "stringValue")
        If strVal
          retVal + PeekS(CocoaMessage(0, strVal, "UTF8String"), -1, #PB_UTF8)
          If i <> numItems : retVal + #LF$ : EndIf
        EndIf
      Next
    Else
      strVal = CocoaMessage(0, eventDesc, "stringValue")
      If strVal : retVal = PeekS(CocoaMessage(0, strVal, "UTF8String"), -1, #PB_UTF8) : EndIf
    EndIf
  EndIf
  ProcedureReturn retVal
EndProcedure


;-Example
CompilerIf #PB_Compiler_IsMainFile
  MessageRequester("", AppleScript("tell application " + Chr(34) + "Finder" + Chr(34) + " To get the name of every item in the desktop"))
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
