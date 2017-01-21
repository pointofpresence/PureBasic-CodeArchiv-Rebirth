;    Description: Detect left click on column header and row
;         Author: Shardik
;           Date: 2014-03-18
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=440806#p440806
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

    EnableExplicit

    ImportC ""
      sel_registerName(MethodName.S)
      class_addMethod(Class.I, Selector.I, Implementation.I, Types.S)
    EndImport

    Define CallbackListIconID.I
    Define CallbackWindowID.I

    Procedure.S ConvertToUTF8(String.S)
      Protected UTF8String.S = Space(StringByteLength(String))
      PokeS(@UTF8String, String, -1, #PB_UTF8)
      ProcedureReturn UTF8String
    EndProcedure

    ProcedureC ColumnHeaderClickCallback(Object.I, Selector.I, TableView.I,
      TableColumn.I)
      Shared CallbackListIconID.I
      Shared CallbackWindowID.I

      Protected ClickedHeaderColumn.I

      ClickedHeaderColumn = Val(PeekS(CocoaMessage(0,
        CocoaMessage(0, TableColumn, "identifier"),
        "UTF8String"), -1, #PB_UTF8))
      PostEvent(#PB_Event_Gadget, CallbackWindowID, CallbackListIconID,
        #PB_EventType_LeftClick, ClickedHeaderColumn + 1)
    EndProcedure

    Procedure SetGadgetCallback(WindowID.I, ListIconID.I)
      Shared CallbackListIconID.I
      Shared CallbackWindowID.I

      Protected AppDelegate.I
      Protected DelegateClass.I
      Protected Selector.I = sel_registerName(ConvertToUTF8("tableView:didClickTableColumn:"))
      Protected Types.S = ConvertToUTF8("v@:@@")

      CallbackWindowID = WindowID
      CallbackListIconID = ListIconID
      AppDelegate = CocoaMessage(0,
        CocoaMessage(0, 0, "NSApplication sharedApplication"), "delegate")
      DelegateClass = CocoaMessage(0, AppDelegate, "class")
      class_addMethod(DelegateClass, Selector, @ColumnHeaderClickCallback(),
        Types)
      CocoaMessage(0, GadgetID(CallbackListIconID), "setDelegate:", AppDelegate)
    EndProcedure

    OpenWindow(0, 200, 100, 430, 95, "Detect left click on header cell")
    ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20, "Name", 110)
    AddGadgetColumn(0, 1, "Address",
      GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
    AddGadgetItem(0, -1, "Harry Rannit" + #LF$ +
      "12 Parliament Way, Battle Street, By the Bay")
    AddGadgetItem(0, -1, "Ginger Brokeit"+ #LF$ +
      "130 PureBasic Road, BigTown, CodeCity")
    AddGadgetItem(0, -1, "Didi Foundit"+ #LF$ +
      "321 Logo Drive, Mouse House, Downtown")

    SetGadgetCallback(0, 0)

    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Break
        Case #PB_Event_Gadget
          If EventGadget() = 0 And EventType() = #PB_EventType_LeftClick
            If EventData()
              Debug "Left click on header of column " + Str(EventData() - 1)
            Else
              Debug "Left click on row " + Str(GetGadgetState(0))
            EndIf
          EndIf
      EndSelect
    ForEver

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
