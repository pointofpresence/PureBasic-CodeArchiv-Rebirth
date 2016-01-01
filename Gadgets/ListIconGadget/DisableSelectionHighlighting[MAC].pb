;    Description: Disable selection highlighting (OS X 10.6+)
;         Author: wilbert
;           Date: 2013-03-14
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=407838#p407838
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

OpenWindow(0, 200, 100, 430, 100, "Disable highlight example")

ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20, "Name", 110)
CocoaMessage(0, GadgetID(0), "setSelectionHighlightStyle:", -1); ** don't highlight selection **

AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth) - 8)
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit" + #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit" + #LF$ + "321 Logo Drive, Mouse House, Downtown")

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow


; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
