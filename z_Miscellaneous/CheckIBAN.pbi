;    Description: Check if an IBAN is correct
;         Author: Rudi
;           Date:2014-05-18
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28027#p322617
; -----------------------------------------------------------------------------


Procedure CheckIBAN(IBAN$)
  Protected i, Modulo, LA$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  IBAN$ = UCase(RemoveString(IBAN$, " "))
  IBAN$ = Mid(IBAN$, 5) + Left(IBAN$, 4)
  
  For i=1   To Len(LA$)
    IBAN$ = ReplaceString(IBAN$, Mid(LA$, i, 1), Str(i+9), #PB_String_NoCase) ;Buchstaben in Zahlen tauschen
  Next
  
  For i=1 To Len(IBAN$)
    Modulo = Val(Str(Modulo) + Mid(IBAN$, i, 1)) % 97
  Next
  
  ProcedureReturn Modulo
EndProcedure


;-Example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Debug CheckIBAN("DE08 7009 0100 1234 5678 90")
  
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP
