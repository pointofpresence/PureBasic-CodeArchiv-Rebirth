;    Description: Adds support for if-set
;         Author: mhs
;           Date: 2016-05-26
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=335540#p335540
; -----------------------------------------------------------------------------

Macro If_set(Result, Expression, TrueValue, FalseValue)

  If Expression
    Result = TrueValue
  Else
    Result = FalseValue
  EndIf

EndMacro

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define a.s, b.i
  
  If_set(a, 1 = 1, "Ja", "Nein") : Debug a
  If_set(a, 1 = 0, "Ja", "Nein") : Debug a
  
  If_set(b, 1 = 1, 11, 55) : Debug b
  If_set(b, 1 = 0, 11, 55) : Debug b
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
