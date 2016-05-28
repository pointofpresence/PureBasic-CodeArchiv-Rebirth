;    Description: Imitation of PHP 'preg_match()'
;         Author: Domino (Code has been improved by Sicro)
;           Date: 2016-04-22
;     PB-Version: 5.42
;             OS: Mac, Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=336344#p336344
; -----------------------------------------------------------------------------

;{ PregMatch()
;PregMatch() ist eine Nachbildung von PHPs preg_match() für die sogenannten regulären Ausdrücke,
;englisch „regular expressions“ oder kurz REGEX. Die Argumente Flags und Offset der PHP-Vorlage
;werden dabei noch nicht unterstützt. PregMatch prüft einen Text per Suchmuster auf Übereinstim-
;mungen und übernimmt diese in ein Feld. Enthält das Suchmuster einen Fehler, wird 0 zurückgegeben.
;Nicht vergessen: Die PCRE-Lizenz in den Quelltext kopieren!
Procedure PregMatch(Pattern$, String$, Array Output$(1))
  Protected RegEx, Count, i
  
  RegEx = CreateRegularExpression(#PB_Any, Pattern$)
  If RegEx
    If ExamineRegularExpression(RegEx, String$)
      NextRegularExpressionMatch(RegEx) ; genau 1x durchlaufen
      Count = CountRegularExpressionGroups(RegEx)
      ReDim Output$(Count - 1)
      For i = 1 To Count
        Output$(i - 1) = RegularExpressionGroup(RegEx, i)
      Next
    EndIf
    FreeRegularExpression(RegEx)
    ProcedureReturn Count - 1
  Else
    ProcedureReturn -1
  EndIf
EndProcedure
;}

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define i, c, Count
  
  Dim Teile$(3)
  Dim Auflosung$(0)
  
  Teile$(0) = "480x360"
  Teile$(1) = "640x480 [SAR 16:11]"
  Teile$(2) = "852x640 [DAR 320:121]"
  Teile$(3) = "1136x852 [SAR 16:11 DAR 320:121]"
  
  For i = 0 To 3
    Count = PregMatch("(\d+)x(\d+)[ ]*(\[(SAR \d+:\d+)?\s?(DAR \d+:\d+)?\])?", Teile$(i), Auflosung$())
    For c = 0 To Count
      Debug Str(i) + ": " + Auflosung$(c)
    Next
  Next
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
