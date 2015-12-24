;    Description: Cycle through button bezel styles
;         Author: gwhuntoon
;           Date: 2013-03-10
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=407476#p407476
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Global cmd_1, lbl_1, spn_1, wnd_1

Dim ButtonStyle.s(15)                                                                 ;Array to store bezel styles

;Instantiate bezel style array
ButtonStyle(1) = "NSRoundedBezelStyle"
Buttonstyle(2) = "NSRegularSquareBezelStyle"
Buttonstyle(3) = "NSThickSquareBezelStyle"
Buttonstyle(4) = "NSThickerSquareBezelStyle"
Buttonstyle(5) = "NSDisclosureBezelStyle"
Buttonstyle(6) = "NSShadowlessSquareBezelStyle"
Buttonstyle(7) = "NSCircularBezelStyle"
Buttonstyle(8) = "NSTexturedSquareBezelStyle"
Buttonstyle(9) = "NSHelpButtonBezelStyle"
Buttonstyle(10) = "NSSmallSquareBezelStyle"
Buttonstyle(11) = "NSTexturedRoundedBezelStyle"
Buttonstyle(12) = "NSRoundRectBezelStyle"
Buttonstyle(13) = "NSRecessedBezelStyle"
Buttonstyle(14) = "NSRoundedDisclosureBezelStyle"
Buttonstyle(15) = "NSInlineBezelStyle"

If OpenWindow(0, 0, 0, 320, 150, "Button Bezel Styles", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  spn_1 = SpinGadget (#PB_Any, 290, 51, 18, 25, 1, 15, #PB_Spin_Numeric)                ;Create a spin gadget
  cmd_1 = ButtonGadget(#PB_Any, 35, 50, 250, 28, "")                                    ;Create a button gadget
  lbl_1 = TextGadget(#PB_Any, 35, 90, 250, 20, "NSRoundedBezelStyle", #PB_Text_Center)  ;Create a label gadget
  SetGadgetState (spn_1, 1): SetGadgetText(spn_1, "1")                                  ;Set the initial state of the spin gadget
  Repeat
    Event = WaitWindowEvent()
    If Event = #PB_Event_Gadget
      If EventGadget() = spn_1                                                        ;Was the spin gadget clicked?
        CocoaMessage(0, GadgetID(cmd_1), "setBezelStyle:", GetGadgetState(spn_1))     ;Cycle through the button bezel styles
        SetGadgetText(lbl_1, ButtonStyle(GetGadgetState(spn_1)))                      ;Display the style in the label
      EndIf
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf


; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
