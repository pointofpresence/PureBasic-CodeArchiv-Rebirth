;    Description: Set ToolTip for column header in ListIconGadget 
;         Author: Shardik
;           Date: 2012-10-12
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393304#p393304
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure SetColumnHeaderToolTip(ListIconID.I, ColumnIndex.I, ToolTipText.S)
  Protected ColumnObject.I
  
  CocoaMessage(@ColumnObject, CocoaMessage(0, GadgetID(ListIconID), "tableColumns"), "objectAtIndex:", ColumnIndex)
  CocoaMessage(0, ColumnObject, "setHeaderToolTip:$", @ToolTipText)
EndProcedure



;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  OpenWindow(0, 270, 100, 410, 67, "ListIcon Example")
  ListIconGadget(0, 5, 5, 400, 57, "Name", 110)
  AddGadgetColumn(0, 1, "Address", 285)
  AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
  AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
  
  SetColumnHeaderToolTip(0, 0, "Firstname & Surname")
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
  
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
