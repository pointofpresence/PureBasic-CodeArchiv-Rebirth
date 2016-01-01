;    Description: Sorting data by clicking a column header
;         Author: Shardik
;           Date: 2013-04-24
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: 24-04-2013
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

ImportC ""
  sel_registerName(*MethodName)
  class_addMethod(Class.I, Selector.I, Implementation.I, *Types)
EndImport

Structure TableEntry
  Name.S
  Address.S
EndStructure

Enumeration #PB_Event_FirstCustomValue
  #PB_Event_ListIcon_SortAscending
  #PB_Event_ListIcon_SortDescending
EndEnumeration

Define AppDelegate.I
Define AscendingArrow.I
Define ColumnArray.I
Define DelegateClass.I
Define DescendingArrow.I
Define i.I
Define LastSortColumn.I
Define MethodName.S = "tableView:didClickTableColumn:"
Define *MethodNameBuffer
Define SortColumn.I
Define SortIsAscending.I
Define Types.S = "v@:@@"
Define *TypesBuffer

NewList Table.TableEntry()

ProcedureC LeftClickOnHeaderCellCallback(Object.I, Selector.I, View.I, Column.I)
  Shared AscendingArrow.I
  Shared DescendingArrow.I
  Shared SortColumn.I
  Shared SortIsAscending.I
  
  SortColumn = Column
  
  If SortIsAscending
    PostEvent(#PB_Event_ListIcon_SortDescending)
  Else
    PostEvent(#PB_Event_ListIcon_SortAscending)
  EndIf
  
  SortIsAscending ! 1
EndProcedure

Procedure SortListIcon(ListIconID.I, SortColumn.I)
  Shared Table()
  Shared SortIsAscending.I
  
  Protected ColumnIndex.I
  
  ColumnIndex = Val(PeekS(CocoaMessage(0, CocoaMessage(0, SortColumn, "identifier"), "UTF8String"), -1, #PB_UTF8))
  
  If SortIsAscending
    If ColumnIndex = 0
      SortStructuredList(Table(), #PB_Sort_Ascending, OffsetOf(TableEntry\Name), #PB_String)
    Else
      SortStructuredList(Table(), #PB_Sort_Ascending, OffsetOf(TableEntry\Address), #PB_String)
    EndIf
  Else
    If ColumnIndex = 0
      SortStructuredList(Table(), #PB_Sort_Descending, OffsetOf(TableEntry\Name), #PB_String)
    Else
      SortStructuredList(Table(), #PB_Sort_Descending, OffsetOf(TableEntry\Address), #PB_String)
    EndIf
  EndIf
  
  ClearGadgetItems(ListIconID)
  
  ForEach Table()
    AddGadgetItem(ListIconID, -1, Table()\Name + #LF$ + Table()\Address)
  Next
EndProcedure

*MethodNameBuffer = AllocateMemory(StringByteLength(MethodName, #PB_Ascii) + 1)
PokeS(*MethodNameBuffer, MethodName, -1, #PB_Ascii)
*TypesBuffer = AllocateMemory(StringByteLength(Types, #PB_Ascii) + 1)
PokeS(*TypesBuffer, Types, -1, #PB_Ascii)
AppDelegate = CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "delegate")
DelegateClass = CocoaMessage(0, AppDelegate, "class")
class_addMethod(DelegateClass, sel_registerName(*MethodNameBuffer),  @LeftClickOnHeaderCellCallback(), *TypesBuffer)
FreeMemory(*MethodNameBuffer)
FreeMemory(*TypesBuffer)
OpenWindow(0, 200, 100, 430, 95, "Sort ListIcon with column click")

ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)

For i = 1 To 3
  AddElement(Table())
  Read.S Table()\Name
  Read.S Table()\Address
Next i

ForEach Table()
  AddGadgetItem(0, -1, Table()\Name + #LF$ + Table()\Address)
Next

AscendingArrow = CocoaMessage(0, CocoaMessage(0, 0, "NSImage imageNamed:$", @"NSAscendingSortIndicator"), "retain")
DescendingArrow = CocoaMessage(0, CocoaMessage(0, 0, "NSImage imageNamed:$", @"NSDescendingSortIndicator"), "retain")

CocoaMessage(@ColumnArray, GadgetID(0), "tableColumns")
CocoaMessage(@SortColumn, ColumnArray, "objectAtIndex:", 0)
LastSortColumn = SortColumn
SortIsAscending = #True
SortListIcon(0, SortColumn)
CocoaMessage(0, GadgetID(0), "setIndicatorImage:", AscendingArrow, "inTableColumn:", SortColumn)
CocoaMessage(0, GadgetID(0), "setDelegate:", AppDelegate)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_ListIcon_SortAscending
      If SortColumn <> LastSortColumn
        CocoaMessage(0, GadgetID(0), "setIndicatorImage:", 0, "inTableColumn:", LastSortColumn)
        LastSortColumn = SortColumn
      EndIf
      SortListIcon(0, SortColumn)
      CocoaMessage(0, GadgetID(0), "setIndicatorImage:", AscendingArrow, "inTableColumn:", SortColumn)
    Case #PB_Event_ListIcon_SortDescending
      If SortColumn <> LastSortColumn
        CocoaMessage(0, GadgetID(0), "setIndicatorImage:", 0, "inTableColumn:", LastSortColumn)
        LastSortColumn = SortColumn
      EndIf
      
      SortListIcon(0, SortColumn)
      CocoaMessage(0, GadgetID(0), "setIndicatorImage:", DescendingArrow, "inTableColumn:", SortColumn)
  EndSelect
ForEver

End

DataSection
  Data.S "Harry Rannit"
  Data.S "12 Parliament Way, Battle Street, By the Bay"
  Data.S "Ginger Brokeit"
  Data.S "330 PureBasic Road, BigTown, CodeCity"
  Data.S "Didi Foundit"
  Data.S "231 Logo Drive, Mouse House, Downtown"
EndDataSection
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
