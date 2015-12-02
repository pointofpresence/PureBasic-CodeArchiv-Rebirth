;    Description: Return the Program Data directory of the diffrent os
;         Author: -
;           Date: 02-12-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29316
; -----------------------------------------------------------------------------
; based on this code: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27741

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    #Slash = "\"
  CompilerCase #PB_OS_MacOS
    #Slash = "/"
  CompilerCase #PB_OS_Linux
    #Slash = "/"
CompilerEndSelect

Procedure.s GetProgramDataDirectory()
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      ProcedureReturn GetEnvironmentVariable("APPDATA") + "\"
    CompilerCase #PB_OS_MacOS
      ProcedureReturn GetHomeDirectory() + "Library/Application Support/"
    CompilerCase #PB_OS_Linux
      ProcedureReturn GetHomeDirectory() 
  CompilerEndSelect
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  path$=GetProgramDataDirectory()
  Debug path$
  Debug FileSize(path$)
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (MacOS X - x64)
; CursorPosition = 20
; Folding = -
; EnableUnicode
; EnableXP