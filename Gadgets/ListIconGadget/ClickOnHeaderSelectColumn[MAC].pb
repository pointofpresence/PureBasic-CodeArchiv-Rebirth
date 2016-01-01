;    Description: Select entire column in ListIconGadget by clicking on column header and get index of selected column
;         Author: Shardik
;           Date: 2012-12-01
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=397048#p397048
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

OpenWindow(0, 200, 100, 430, 125, "Select entire column by clicking on column header")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 50, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")
ButtonGadget(1, WindowWidth(0) / 2 - 90, WindowHeight(0) - 30, 180, 25, "Display selected column")

; ----- Allow selection of entire column by clicking on column header
CocoaMessage(0, GadgetID(0), "setAllowsColumnSelection:", #YES)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 1 And EventType() = #PB_EventType_LeftClick
        ; ----- Get selected column
        SelectedColumn = CocoaMessage(0, GadgetID(0), "selectedColumn")
        
        If SelectedColumn = -1
          Debug "No column is currently selected!"
        Else
          Debug "Column " + Str(SelectedColumn) + " is currently selected!"
        EndIf
      EndIf
  EndSelect
ForEver

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
