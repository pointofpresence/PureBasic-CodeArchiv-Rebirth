;    Description: Splits a string with separators into an array.
;         Author: Domino (Code has been improved by Sicro)
;           Date: 2016-04-22
;     PB-Version: 5.42
;             OS: Mac, Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=336221#p336221
; -----------------------------------------------------------------------------

Procedure ExplodeStringIntoArray(Separator$, String$, Array Output$(1))
  Protected ArrayIndex, StartPos, SeparatorPos
 
  ArrayIndex = -1
  StartPos = 1
 
  Repeat
    ArrayIndex + 1
   
    If ArraySize(Output$()) < ArrayIndex
      ReDim Output$(ArrayIndex + 99) ; Wenn Output-Array zu klein ist, es um 100 Elemente vergrößern
    EndIf
   
    SeparatorPos = FindString(String$, Separator$, StartPos)
    If SeparatorPos = 0
      Output$(ArrayIndex) = Mid(String$, StartPos)
      Break
    EndIf
   
    Output$(ArrayIndex) = Mid(String$, StartPos, SeparatorPos - StartPos)
    StartPos = SeparatorPos + 1
  ForEver
 
  ReDim Output$(ArrayIndex) ; Array auf die wirklich notwendige Größe setzen
 
  ProcedureReturn ArrayIndex
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define CountOfItems, i
  Dim Items$(0) ; Hier kann die Größe auch im Voraus vergrößert werden, z. B.: Dim Items$(100)
  
  CountOfItems = ExplodeStringIntoArray(":", "String1:String2:String3", Items$())
  For i = 0 To CountOfItems
    Debug Items$(i)
  Next
  
  Debug ArraySize(Items$()) 
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
