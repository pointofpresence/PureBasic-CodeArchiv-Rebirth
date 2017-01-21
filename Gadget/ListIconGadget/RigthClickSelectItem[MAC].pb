;    Description: Select item using right-click
;         Author: wilbert
;           Date: 2012-12-01
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=397000#p397000
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

Define AllowMultipleSelection = #YES

Define CursorLocation.NSPoint
Define ListIconGadgetID.i, SelectedRow.i, IndexSet.i

OpenWindow(0, 200, 100, 430, 125, "ListIcon Example")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 50, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 0 And EventType() = #PB_EventType_RightClick
        CursorLocation\x = WindowMouseX(0)
        CursorLocation\y = WindowHeight(0) - WindowMouseY(0)
        ListIconGadgetID = GadgetID(0)
        CocoaMessage(@CursorLocation, ListIconGadgetID, "convertPoint:@", @CursorLocation, "fromView:", #nil)
        CocoaMessage(@SelectedRow, ListIconGadgetID, "rowAtPoint:@", @CursorLocation)
        
        SetGadgetState(0, SelectedRow)
        ;or this two lines:
        ;CocoaMessage(@IndexSet, 0, "NSIndexSet indexSetWithIndex:", SelectedRow)
        ;CocoaMessage(0, ListIconGadgetID, "selectRowIndexes:", IndexSet, "byExtendingSelection:", AllowMultipleSelection)
      EndIf
  EndSelect
ForEver

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
