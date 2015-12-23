;    Description: Set Badge Label
;         Author: wilbert
;           Date: 19-09-2012
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=391168#p391168
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

App = CocoaMessage(0, 0, "NSApplication sharedApplication")
DockTile = CocoaMessage(0, App, "dockTile")
CocoaMessage(0, DockTile, "setBadgeLabel:$", @"Pure")

MessageRequester("", "Badge label set")
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
