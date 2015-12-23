;    Description: Recolor a button gadget using a Core Image Filter
;         Author: wilbert
;           Date: 02-10-2012
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=392371#p392371
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

If OpenWindow(0, 0, 0, 220, 200, "CIFilter example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ButtonGadget(0, 10, 10, 200, 30, "Button")
  
  Filter  = CocoaMessage(0, 0, "CIFilter filterWithName:$", @"CIColorMonochrome") ; create a CIColorMonochrome filter
  CocoaMessage(0, Filter, "setDefaults")                                          ; set the default values for the filter
  Color = CocoaMessage(0, 0, "CIColor colorWithString:$", @"1.0 0.7 0.3 1.0")     ; create a CIColor object from a RGBA string
  CocoaMessage(0, Filter, "setValue:", Color, "forKey:$", @"inputColor")          ; assign the color to the filter
  FilterArray = CocoaMessage(0, 0, "NSArray arrayWithObject:", Filter)            ; create an array with only the filter
  
  Button = GadgetID(0)
  CocoaMessage(0, Button, "setWantsLayer:", #YES)                                 ; the gadget needs a layer for the filter to work
  CocoaMessage(0, Button, "setContentFilters:", FilterArray)                      ; set the filter Array
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
