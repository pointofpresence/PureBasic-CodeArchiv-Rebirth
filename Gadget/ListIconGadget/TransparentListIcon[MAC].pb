;    Description: Window with background image and transparent ListIconGadget
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

UseJPEGImageDecoder()

OpenWindow(0, 200, 100, 430, 300, "Window with background image + transparent ListIcon")
ListIconGadget(0, 10, 100, WindowWidth(0) - 20, 75, "Name", 110)
AddGadgetColumn(0, 1, "Address", GadgetWidth(0) - GetGadgetItemAttribute(0, 0, #PB_ListIcon_ColumnWidth))
AddGadgetItem(0, -1, "Harry Rannit" + #LF$ + "12 Parliament Way, Battle Street, By the Bay")
AddGadgetItem(0, -1, "Ginger Brokeit"+ #LF$ + "130 PureBasic Road, BigTown, CodeCity")
AddGadgetItem(0, -1, "Didi Foundit"+ #LF$ + "321 Logo Drive, Mouse House, Downtown")

If LoadImage(0, #PB_Compiler_Home + "Examples/3D/Data/Textures/Clouds.jpg")
  ContentView = CocoaMessage(0, WindowID(0), "contentView")
  CocoaMessage(0, ContentView, "setWantsLayer:", #YES)
  Layer = CocoaMessage(0, ContentView, "layer")
  CocoaMessage(0, Layer, "setContents:", ImageID(0))
EndIf

CocoaMessage(0, GadgetID(0), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor clearColor"))
CocoaMessage(0, CocoaMessage(0, GadgetID(0), "enclosingScrollView"), "setDrawsBackground:", #NO)

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
