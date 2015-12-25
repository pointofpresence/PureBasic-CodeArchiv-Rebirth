;    Description: Open finder and preselect diffrent files
;         Author: Shardik
;           Date: 2013-03-09
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=407396#p407396
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

;when you only want to preselect one file:
;  RunProgram("open", "-R " + "/Applications/TextEdit.app", "")

; Needs at least MacOS X 10.6 to work!

EnableExplicit

Procedure CreateFileArray(List Filename.S())
  Protected FileArray.I
  Protected Filename.S
  Protected FileURL.I
  
  FileArray = CocoaMessage(0, 0, "NSMutableArray arrayWithCapacity:", ListSize(Filename()))
  
  If FileArray
    ForEach Filename()
      Filename = Filename()
      FileURL = CocoaMessage(0, 0, "NSURL fileURLWithPath:$", @Filename, "isDirectory:", #False)
      CocoaMessage(0, FileArray, "addObject:", FileURL)
    Next
  EndIf
  
  ProcedureReturn FileArray
EndProcedure

Define FileArray.I
Define Workspace.I

NewList Filename.S()

AddElement(Filename())
Filename() = "/Applications/Safari.app"
AddElement(Filename())
Filename() = "/Applications/TextEdit.app"
AddElement(Filename())
Filename() = "/Applications/Time Machine.app"

FileArray = CreateFileArray(Filename())

If FileArray
  Workspace = CocoaMessage(0, 0, "NSWorkspace sharedWorkspace")
  CocoaMessage(0, Workspace, "activateFileViewerSelectingURLs:", FileArray)
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
