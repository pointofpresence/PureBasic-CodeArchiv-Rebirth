;    Description: Dummy Text Generator for testing
;         Author: Tommy
;           Date: 27-01-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28678
;-----------------------------------------------------------------------------
;(c) Tommy
Procedure.s generateText(WordTotal)
  Protected i, j, Text.s, Word.s, WordLength, PhraseLength, PhraseNr, MaxVowelTotal, Uppercase, BCD.s = "bcdfghjklmnpqrstvwxyz", AEI.s = "aeiou", NextUppdercase = 1
  
  PhraseLength = Random(15, 3)
  For j=1 To WordTotal
    WordLength = Random(10, 2)
    Uppercase = Random(1)
    Word = ""
    PhraseNr + 1
    For i=1 To WordLength
      If MaxVowelTotal = 0
        MaxVowelTotal = Random(3, 1)
      EndIf
      MaxVowelTotal - 1
      If MaxVowelTotal = 0
        If Uppercase = 1 And i = 1
          Word = UCase(Mid(BCD, Random(21, 1), 1))
        Else
          Word + Mid(BCD, Random(21, 1), 1)
        EndIf
      Else
        If Uppercase = 1 And i = 1
          Word = UCase(Mid(AEI, Random(5, 1), 1))
        Else
          Word + Mid(AEI, Random(5, 1), 1)
        EndIf
      EndIf
    Next i
    If PhraseLength = PhraseNr
      Text + Word + "." + Chr(13)
      PhraseNr = 0
      NextUppdercase = 1
      PhraseLength = Random(15, 3)
    Else
      If NextUppdercase = 1
        Text + UCase(Left(Word, 1)) + Mid(Word, 2) + " "
        NextUppdercase = 0
      Else
        Text + Word + " "
      EndIf
    EndIf
  Next j
  ProcedureReturn Text
EndProcedure

Define event
OpenWindow(0, 0, 0, 600, 600, "", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
EditorGadget(0, 0, 0, 600, 600)
SetGadgetText(0, generateText(500))

Repeat
  event = WaitWindowEvent()
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
