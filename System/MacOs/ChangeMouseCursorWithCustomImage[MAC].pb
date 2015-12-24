;    Description: Change Mouse Cursor
;         Author: Shardik
;           Date: 2012-11-14
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=395785#p395785
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Define Hotspot.NSPoint

OpenWindow(0, 200, 100, 290, 100, "Display custom cursor")
ButtonGadget(0, WindowWidth(0) / 2 - 120, 40, 240, 25, "Change cursor to custom image")

UsePNGImageDecoder()

If LoadImage(0, #PB_Compiler_Home + "Examples/Sources/Data/World.png")
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        If EventGadget() = 0 And EventType() = #PB_EventType_LeftClick
          Hotspot\x = 4
          Hotspot\y = 4
          NewCursor = CocoaMessage(0, 0, "NSCursor alloc")
          CocoaMessage(0, NewCursor, "initWithImage:", ImageID(0), "hotSpot:@", @Hotspot)
          CocoaMessage(0, NewCursor, "set")
        EndIf
    EndSelect
  ForEver
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
