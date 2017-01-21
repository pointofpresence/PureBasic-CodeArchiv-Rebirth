;    Description: Find out the what class is behind a gadget
;         Author: wilbert
;           Date: 2012-09-24
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=391571#p391571
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure.s ObjectInheritance(Object)
  
  Protected.i Result
  Protected.i MutableArray = CocoaMessage(0, 0, "NSMutableArray arrayWithCapacity:", 10)
  
  Repeat
    CocoaMessage(0, MutableArray, "addObject:", CocoaMessage(0, Object, "className"))
    CocoaMessage(@Object, Object, "superclass")
  Until Object = 0
  
  CocoaMessage(@Result, MutableArray, "componentsJoinedByString:$", @"  -->  ")
  CocoaMessage(@Result, Result, "UTF8String")
  
  ProcedureReturn PeekS(Result, -1, #PB_UTF8)
  
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  
  If OpenWindow(0, 0, 0, 220, 200, "Object Inheritance", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    ButtonGadget(0, 10, 10, 200, 20, "Button")
    
    Debug ObjectInheritance(GadgetID(0))
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    
  EndIf;-Example
  
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
