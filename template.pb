;    Description: 
;Parameter (IDE):
;         Author: 
;           Date: 
;     PB-Version: 5.42
;             OS: Mac, Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Windows only!"
CompilerEndIf

CompilerIf #PB_Compiler_Thread = #False
  CompilerError "Threadsafe needed!"
CompilerEndIf

CompilerIf #PB_Compiler_Processor<>#PB_Processor_x86
  CompilerError "X86 only!"
CompilerEndIf

CompilerIf #PB_Compiler_Processor <> #PB_Processor_x86
  CompilerError "X86 only!"
CompilerEndIf

; Put here the code from the forum post.

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ; Put here an example code that shows the use of the code above.
CompilerEndIf

; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; CursorPosition = 3
; Folding = --
; EnableUnicode
; EnableXP
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant