;    Description: ABS for integer
;         Author: Sicro
;           Date: 2014-03-16
;     PB-Version: 5.42
;             OS: Mac, Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27835
; -----------------------------------------------------------------------------

Procedure.i AbsI(Number.i)
  If number<0
    ProcedureReturn -Number
  EndIf
  ProcedureReturn Number
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  x=ElapsedMilliseconds()
  For i=-100000000 To 100000000
    result=AbsI(i)
  Next
  
  a$+"AbsI:"+Str(x-ElapsedMilliseconds())+Chr(10)
  x=ElapsedMilliseconds()
  
  Macro mAbsI(intValue)
    intValue!(intValue>>63)+((intValue>>63)&1)
  EndMacro
  
  For i=-100000000 To 100000000
    result=mAbsI(i)
  Next
  a$+"mAbsI:"+Str(x-ElapsedMilliseconds())+Chr(10)
  x=ElapsedMilliseconds()
  
  MessageRequester("Results",a$)
CompilerEndIf

; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; EnableUnicode
; EnableXP
; DisableDebugger
