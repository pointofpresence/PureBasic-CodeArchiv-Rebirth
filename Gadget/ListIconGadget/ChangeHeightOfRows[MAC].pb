;    Description: Change height of rows in ListIconGadget (works also with ListViewGadget)
;         Author: Shardik
;           Date: 2012-11-24
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=396557#p396557
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Define RowHeight.CGFloat

OpenWindow(0, 200, 100, 420, 220, "Change ListIcon's row height")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, 102, "Name", 100, #PB_ListIcon_GridLines)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")
Frame3DGadget(1, 20, GadgetY(0) + GadgetHeight(0) + 10, WindowWidth(0) - 40, 90, "Row height:")
TrackBarGadget(2, GadgetX(1) + 10, GadgetY(1) + 30, GadgetWidth(1) - 20, 23, 15, 26, #PB_TrackBar_Ticks)
CocoaMessage(0, GadgetID(2), "setAllowsTickMarkValuesOnly:", #YES)
TextGadget(3, GadgetX(1) + 10, GadgetY(2) + GadgetHeight(2) + 5, GadgetWidth(1) - 10, 20, "15     16     17     18     19     20     21     22     23     24     25")

; ----- Read current row height and set TrackBar to that value
CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
SetGadgetState(2, RowHeight)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 2
        RowHeight = GetGadgetState(2)
        ; ----- Set new row height
        CocoaMessage(0, GadgetID(0), "setRowHeight:@", @RowHeight)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
