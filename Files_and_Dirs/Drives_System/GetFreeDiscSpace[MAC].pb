;    Description: Get free disc space
;         Author: wilbert
;           Date: 03-03-2013
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=406839#p406839
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Define FreeSize.q
Define FileManager = CocoaMessage(0, 0, "NSFileManager defaultManager")
Define Attributes = CocoaMessage(0, FileManager, "attributesOfFileSystemForPath:$", @"/", "error:", #nil)
CocoaMessage(@FreeSize, CocoaMessage(0, Attributes, "objectForKey:$", @"NSFileSystemFreeSize"), "longLongValue")

Debug FreeSize
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
