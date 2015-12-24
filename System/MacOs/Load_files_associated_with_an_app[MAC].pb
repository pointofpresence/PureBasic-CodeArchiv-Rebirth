;    Description: load files associated with an app
;         Author: WilliamL/Fred
;           Date: 2012-09-22
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=391349#p391349
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

;Here is Fred's code (modified) to load files associated with an app. Remember that you have to set the plist to recognize your extension so the app loads first! See the original code here.
;http://www.purebasic.fr/english/viewtopic.php?f=3&t=51426#p391284
ImportC ""
  PB_Gadget_SetOpenFinderFiles(Callback)
EndImport

IsGadget(0) ; Ensures the gadget lib is linked as this command is in it

ProcedureC OpenFinderFilesCallback(*Utf8Files)
  Protected filecnt,filesin$,filename$
  filesin$ = PeekS(*Utf8Files, -1, #PB_UTF8) ; Each file is separated by a 'tab'
  If Len(filesin$)                           ; Here you have the filename to open
    MessageRequester("Raw Load...",filesin$+" filecount="+Str(CountString(filesin$,Chr(9)))) ; Use StringField() to iterate easily
    For filecnt=1 To CountString(filesin$,Chr(9))+1
      filename$=StringField(filesin$,filecnt,Chr(9))
      filepath$=GetPathPart(filename$)
      filename$=GetFilePart(filename$)
      MessageRequester("Loading file...",filePath$+Chr(13)+filename$)
    Next
  EndIf
EndProcedure

PB_Gadget_SetOpenFinderFiles(@OpenFinderFilesCallback()) ; should be put very early in the code, before any event loop

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
