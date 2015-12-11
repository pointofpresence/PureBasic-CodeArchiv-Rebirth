;    Description: 
;         Author: 
;           Date: 
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

; CompilerIf #PB_Compiler_Thread=#False
;   CompilerError "Threadsafe needed!"
; CompilerEndIf

; CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
;  CompilerError "Windows Only!"
; CompilerEndIf

;-Example
CompilerIf #PB_Compiler_IsMainFile
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP
