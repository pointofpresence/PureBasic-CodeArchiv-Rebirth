;    Description: Find all selected items 
;         Author: wilbert
;           Date: 2012-09-22
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=391395#p391395
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf


EnableExplicit

Procedure ListSelectedItems(ListViewID.i)
  
  Protected.i SelectedIndexes = CocoaMessage(0, GadgetID(ListViewID), "selectedRowIndexes")
  Protected.i RowIndex = CocoaMessage(0, SelectedIndexes, "firstIndex")
  
  If RowIndex = #NSNotFound
    Debug "No items are currently selected!"
  Else
    Repeat
      Debug GetGadgetItemText(ListViewID, RowIndex)
      RowIndex = CocoaMessage(0, SelectedIndexes, "indexGreaterThanIndex:", RowIndex)
    Until RowIndex = #NSNotFound
  EndIf
  Debug ""
  
EndProcedure

Define.i i

OpenWindow(0, 270, 100, 210, 284, "Multi-selection demo")
ListViewGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 50, #PB_ListView_MultiSelect)
ButtonGadget(1, (WindowWidth(0) - 140) / 2, WindowHeight(0) - 31, 140, 20, "List selected items")

For i = 1 To 12
  AddGadgetItem (0, -1, "Item " + Str(i) )
Next

SetGadgetState(0, 6)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 1
        If EventType() = #PB_EventType_LeftClick
          ListSelectedItems(0)
        EndIf
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
