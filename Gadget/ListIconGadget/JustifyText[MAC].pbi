;    Description: Justify text in columns of ListIconGadget
;         Author: Shardik
;           Date: 2012-10-12
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393256#p393256
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

Procedure SetListIconColumnJustification(ListIconID.I, ColumnIndex.I, Alignment.I)
  Protected ColumnHeaderCell.I
  Protected ColumnObject.I
  Protected ColumnObjectArray.I
  
  ; ----- Justify text of column cells
  CocoaMessage(@ColumnObjectArray, GadgetID(ListIconID), "tableColumns")
  CocoaMessage(@ColumnObject, ColumnObjectArray, "objectAtIndex:", ColumnIndex)
  CocoaMessage(0, CocoaMessage(0, ColumnObject, "dataCell"), "setAlignment:", Alignment)
  
  ; ----- Justify text of column header
  CocoaMessage(@ColumnHeaderCell, ColumnObject, "headerCell")
  CocoaMessage(0, ColumnHeaderCell, "setAlignment:", Alignment)
  
  ; ----- Redraw ListIcon contents to see change
  CocoaMessage(0, GadgetID(ListIconID), "reloadData")
EndProcedure



;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define OptionGadgetID.I
  
  OpenWindow(0, 200, 100, 445, 140, "Change column justification")
  ListIconGadget(0, 5, 5, 435, 58, "Name", 110)
  AddGadgetColumn(0, 1, "Address", 300)
  AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
  AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
  Frame3DGadget(1, 10, 75, WindowWidth(0) - 20, 50, "Justification of 2nd column:")
  OptionGadget(2, 20, 95, 70, 20, "Left")
  OptionGadget(3, 330, 95, 70, 20, "Right")
  OptionGadget(4, 180, 95, 70, 20, "Center")
  SetGadgetState(2, #True)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        OptionGadgetID = EventGadget()
        
        Select OptionGadgetID
          Case 2 To 4
            SetListIconColumnJustification(0, 1, OptionGadgetID - 2)
        EndSelect
    EndSelect
  ForEver
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
