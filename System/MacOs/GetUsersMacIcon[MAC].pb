;    Description: Display icon of the current user's Mac
;         Author: Shardik
;           Date: 2014-03-24
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=441215#p441215
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

OpenWindow(0, 270, 100, 200, 60, "Icon of user's Mac")

Image = CocoaMessage(0, 0, "NSImage imageNamed:$", @"NSComputer")
ImageGadget(0, 80, 10, 32, 32, Image)

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
