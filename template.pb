;    Description: 
;         Author: 
;           Date: 
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
  CompilerError "Windows only!"
CompilerEndIf

CompilerIf #PB_Compiler_Thread=#False
  CompilerError "Threadsafe needed!"
CompilerEndIf

CompilerIf #PB_Compiler_Processor=#PB_Processor_x86
  CompilerError "X86 only!"
CompilerEndIf

;-Example
CompilerIf #PB_Compiler_IsMainFile
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; CursorPosition = 28
; Folding = -
; EnableUnicode
; EnableXP
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant