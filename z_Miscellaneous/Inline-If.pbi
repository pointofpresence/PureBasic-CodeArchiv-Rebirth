;    Description: Adds support for inline-if
;         Author: Sicro
;           Date: 2016-05-26
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29487
; -----------------------------------------------------------------------------

Macro Iif(Expression, TrueValue, FalseValue)
  FalseValue + Bool(Expression) * (TrueValue - FalseValue)
EndMacro

Macro IifS(Expression, TrueString, FalseString, Separator = "|")
  StringField(FalseString + Separator + TrueString, Bool(Expression) + 1, Separator)
EndMacro

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Debug IifS(1 = 1, "Ja", "Nein")
  Debug IifS(1 = 0, "Ja", "Nein")
  
  Debug Iif(1 = 1, 11, 55)
  Debug Iif(1 = 0, 11, 55)
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
