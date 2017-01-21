;    Description: Semi-transparent window
;         Author: Shardik
;           Date: 2012-10-13
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=393352#p393352
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Define Alpha.CGFloat = 0.8

OpenWindow(0, 200, 100, 430, 95, "ListIcon Example")
ListIconGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth))
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit"+ #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit"+ #LF$ + "321 Logo Drive, Mouse House, Downtown")

CocoaMessage(0, WindowID(0), "setOpaque:", #NO)
CocoaMessage(0, WindowID(0), "setAlphaValue:@", @Alpha)
Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
