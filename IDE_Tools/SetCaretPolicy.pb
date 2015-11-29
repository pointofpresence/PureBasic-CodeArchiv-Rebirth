;   Description: Enable scrolling befor the cursor reach the border
;                Select as "Event to trigger the tool": "Sourcecode loaded" and "New Sourcecode created"
;        Author: GPI
;          Date: 04-10-2015
;    PB-Version: 5.40
;            OS: Windows
; English-Forum: 
;  French-Forum: 
;  German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29179
;-----------------------------------------------------------------------------
;MessageRequester("test",GetEnvironmentVariable("PB_TOOL_Scintilla" ))
handle=Val(GetEnvironmentVariable("PB_TOOL_Scintilla" ))
If handle
  SendMessage_(handle,#SCI_SETXCARETPOLICY,#CARET_SLOP|#CARET_EVEN|#CARET_STRICT    ,100);100 Pixel in x-Richtung
  SendMessage_(handle,#SCI_SETYCARETPOLICY,#CARET_SLOP|#CARET_EVEN|#CARET_STRICT    ,3)  ;3 Zeilen
EndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 10
; EnableUnicode
; EnableXP
; Executable = SetCaretPolicy.exe
; EnableCompileCount = 1
; EnableBuildCount = 1
; EnableExeConstant