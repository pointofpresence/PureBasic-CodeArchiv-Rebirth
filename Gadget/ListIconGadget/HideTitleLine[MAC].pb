;    Description: Hide title line
;         Author: Shardik
;           Date: 2012-11-25
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=396597#p396597
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

OpenWindow(0, 200, 100, 430, 125, "ListIcon Example")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 50, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")
ButtonGadget(1, WindowWidth(0) / 2 - 70, WindowHeight(0) - 30, 140, 25, "Hide title header")

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 1 And EventType() = #PB_EventType_LeftClick
        CocoaMessage(0, GadgetID(0), "setHeaderView:", 0)
        DisableGadget(1, #True)
      EndIf
  EndSelect
ForEver

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
