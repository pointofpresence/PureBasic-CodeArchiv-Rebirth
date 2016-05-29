;    Description: Returns the string in addition back as hexadecimal codes
;         Author: mk-soft
;           Date: 2016-04-22
;     PB-Version: 5.42
;             OS: Mac, Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=334262#p334262
; -----------------------------------------------------------------------------

Procedure.s DebugHex(text.s, spalten.i = 8)
  Protected *pString.character
  Protected spalte.i
  Protected hex.s, ausgabe.s, result.s
  *pString = @text
  While *pString\c <> 0
    CompilerIf #PB_Compiler_Unicode = 1
      hex + RSet(Hex(*pString\c, #PB_Unicode), 4, "0") + " "
    CompilerElse
      hex + RSet(Hex(*pString\c, #PB_Ascii), 2, "0") + " "
    CompilerEndIf
    If *pString\c >= 32
      ausgabe + Chr(*pString\c)
    Else
      ausgabe + "."
    EndIf
    *pString + SizeOf(character)
    spalte + 1
    If spalte > spalten
      spalte = 0
      hex + " | " + ausgabe + #LF$
      ausgabe = ""
    EndIf
  Wend
  If ausgabe
    hex + " | " + ausgabe
  EndIf
 
  ProcedureReturn hex
 
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  t1.s = "aB© äöüſßÄÖÜ"+#LF$+#CR$+"()[]"
  Debug DebugHex(t1)
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
