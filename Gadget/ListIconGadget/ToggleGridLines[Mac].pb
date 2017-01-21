;    Description: Toggle grid lines in ListIconGadget between vertical, horizontal, combined vertical + horizontal And none
;         Author: Shardik
;           Date: 2012-10-13
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393334#p393334
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

#NSTableViewGridNone                     = 0
#NSTableViewSolidVerticalGridLineMask    = 1 << 0
#NSTableViewSolidHorizontalGridLineMask  = 1 << 1

Define GridLineStyle.I

OpenWindow(0, 200, 100, 430, 220, "ListIcon Example")

ListIconGadget(0, 10, 10, WindowWidth(0) - 20, 75, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth))
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit"+ #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit"+ #LF$ + "321 Logo Drive, Mouse House, Downtown")
Frame3DGadget(1, 90, 100, 250, 108, "Grid line style:")
OptionGadget(2, 100, 120, 240, 20, "No grid lines")
OptionGadget(3, 100, 140, 240, 20, "Solid vertical")
OptionGadget(4, 100, 160, 240, 20, "Solid horizontal")
OptionGadget(5, 100, 180, 240, 20, "Solid horizontal and vertical")
SetGadgetState(2, #True)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 2
          GridLineStyle = #NSTableViewGridNone
        Case 3
          GridLineStyle = #NSTableViewSolidVerticalGridLineMask
        Case 4
          GridLineStyle = #NSTableViewSolidHorizontalGridLineMask
        Case 5
          GridLineStyle = #NSTableViewSolidHorizontalGridLineMask | #NSTableViewSolidVerticalGridLineMask
      EndSelect
      
      CocoaMessage(0, GadgetID(0), "setGridStyleMask:", GridLineStyle)
  EndSelect
ForEver
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
