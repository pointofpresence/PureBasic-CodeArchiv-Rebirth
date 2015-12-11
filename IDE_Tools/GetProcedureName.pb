;    Description: find the name of the procedure of the current cursor position
;      Parameter: "%TEMPFILE%"
;         Author: Kiffi
;           Date: 22-08-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28267
;-----------------------------------------------------------------------------
; GetProcedureName

; #################################################################
; In den Werkzeug-Einstellungen als Argumente "%TEMPFILE" eintragen
; #################################################################

EnableExplicit

Procedure.s RemoveLeadingWhitespaceFromString(InString.s)
  
  While Left(InString, 1) = Chr(32) Or Left(InString, 1) = Chr(9)
    InString = LTrim(InString, Chr(32))
    InString = LTrim(InString, Chr(9))
  Wend
  
  ProcedureReturn InString
  
EndProcedure

Procedure.s GetScintillaText()
  
  ; thx to sicro (http://www.purebasic.fr/german/viewtopic.php?p=324916#p324916)
  
  Protected ReturnValue.s
  Protected FilePath.s
  Protected File, BOM
  
  FilePath = ProgramParameter(0) ; %TEMPFILE (Datei existiert auch, wenn Code nicht gespeichert ist)
  
  File = ReadFile(#PB_Any, FilePath, #PB_File_SharedRead)
  If IsFile(File)
    BOM = ReadStringFormat(File) ; BOM überspringen, wenn vorhanden
    ReturnValue = ReadString(File, #PB_File_IgnoreEOL | BOM)
    CloseFile(File)
  EndIf
  
  ProcedureReturn ReturnValue
  
EndProcedure

Define ScintillaText.s
Define CursorLine = Val(StringField(GetEnvironmentVariable("PB_TOOL_Cursor"), 1, "x"))
Define Line.s
Define LineCounter

ScintillaText = GetScintillaText()

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    #LineFeed = #CRLF$
  CompilerDefault
    #LineFeed = #LF$
CompilerEndSelect

If ScintillaText <> ""
  
  For LineCounter = CursorLine - 1 To 1 Step - 1
    
    Line = RemoveLeadingWhitespaceFromString(StringField(ScintillaText, LineCounter, #LineFeed))
    
    If Left(LCase(Line), Len("endprocedure")) = "endprocedure"
      Break
    EndIf
    
    If Left(LCase(Line), Len("procedure")) = "procedure"
      If Left(LCase(Line), Len("procedurereturn")) <> "procedurereturn"
        MessageRequester("You are here:", Line)
        Break
      EndIf
    EndIf
    
  Next
  
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
