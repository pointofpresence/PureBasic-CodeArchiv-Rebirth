;    Description: List all available fonts
;         Author: wilbert
;           Date: 2013-04-11
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=410574#p410574
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
AvailableFontFamilies = CocoaMessage(0, FontManager, "availableFontFamilies")
FontCount = CocoaMessage(0, AvailableFontFamilies, "count")

i = 0
While i < FontCount
  FontName.s = PeekS(CocoaMessage(0, CocoaMessage(0, AvailableFontFamilies, "objectAtIndex:", i), "UTF8String"), -1, #PB_UTF8)
  Debug FontName
  i + 1
Wend
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
