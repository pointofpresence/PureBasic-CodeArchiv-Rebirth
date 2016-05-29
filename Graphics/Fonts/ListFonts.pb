;    Description: List all available fonts
;         Author: wilbert / GPI
;           Date: 2013-04-11
;     PB-Version: 5.42
;             OS: Mac, Windos
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=410574#p410574
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  CompilerError "MacOs&Win only!"
CompilerEndIf


CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
  FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
  AvailableFontFamilies = CocoaMessage(0, FontManager, "availableFontFamilies")
  FontCount = CocoaMessage(0, AvailableFontFamilies, "count")
  
  i = 0
  While i < FontCount
    FontName.s = PeekS(CocoaMessage(0, CocoaMessage(0, AvailableFontFamilies, "objectAtIndex:", i), "UTF8String"), -1, #PB_UTF8)
    Debug FontName
    i + 1
  Wend
  
CompilerElseIf #PB_Compiler_OS=#PB_OS_Windows
  
  Procedure EnumFontFamProc(*lpelf.ENUMLOGFONT, *lpntm.NEWTEXTMETRIC, FontType, lParam) ; GetFonts and trans. to List
                                                                                        ;Debug PeekS(@*lpelf\elfLogFont\lfFaceName[0])
    Debug PeekS(@*lpelf\elfLogFont\lfFaceName[0],-1)
    ProcedureReturn 1
  EndProcedure
  hWnd = GetDesktopWindow_()
  hDC = GetDC_(hWnd)
  EnumFontFamilies_(hDC, 0, @EnumFontFamProc(), 0)
  ReleaseDC_ (hWnd, hDC)
  
CompilerEndIf

  
  
; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; CursorPosition = 31
; Folding = -
; EnableUnicode
; EnableXP
; EnableCompileCount = 1
; EnableBuildCount = 0
; EnableExeConstant