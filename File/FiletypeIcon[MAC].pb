;    Description: Get an icon image (32 x 32 px) for a specific file type.
;         Author: wilbert
;           Date: 2013-02-15
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=404657#p404657
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

If OpenWindow(0, 0, 0, 64, 64, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ImageID = CocoaMessage(0, CocoaMessage(0, 0, "NSWorkspace sharedWorkspace"), "iconForFileType:$", @"txt")
  ImageGadget(0, 16, 16, 32, 32, ImageID)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
