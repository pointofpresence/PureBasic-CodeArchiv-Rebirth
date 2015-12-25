;    Description: Get all file names from a directory including all files in all of its subdirectories.
;         Author: wilbert
;           Date: 2013-04-09
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=410298#p410298
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Dir.s = #PB_Compiler_Home + "purelibraries"

FileManager = CocoaMessage(0, 0, "NSFileManager defaultManager")
DirEnum = CocoaMessage(0, FileManager, "enumeratorAtPath:$", @Dir)

File = CocoaMessage(0, DirEnum, "nextObject")
While File
  
  FileName.s = PeekS(CocoaMessage(0, File, "UTF8String"), -1, #PB_UTF8)
  Debug FileName
  
  File = CocoaMessage(0, DirEnum, "nextObject")
Wend
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
