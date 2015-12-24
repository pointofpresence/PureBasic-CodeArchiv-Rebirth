;    Description: Set the text color of specific areas
;         Author: wilbert
;           Date: 2013-04-02
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=409758#p409758
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

Procedure SetTextColorABGR(TextGadget, Color, StartPosition, Length = -1, BackColor = #NO)
  Protected.CGFloat r,g,b,a
  Protected range.NSRange, MAString.i
  If StartPosition > 0
    
    MAString = CocoaMessage(0, CocoaMessage(0, 0, "NSMutableAttributedString alloc"), "initWithAttributedString:",
                            CocoaMessage(0, GadgetID(TextGadget), "attributedStringValue"))
    
    range\location = StartPosition - 1
    range\length = CocoaMessage(0, MAString, "length") - range\location
    If range\length > 0
      If Length >= 0 And Length < range\length
        range\length = Length
      EndIf
      r = Red(Color) / 255
      g = Green(Color) / 255
      b = Blue(Color) / 255
      a = Alpha(Color) / 255
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      If BackColor
        CocoaMessage(0, MAString, "addAttribute:$", @"NSBackgroundColor", "value:", Color, "range:@", @range)
      Else
        CocoaMessage(0, MAString, "addAttribute:$", @"NSColor", "value:", Color, "range:@", @range)
      EndIf
    EndIf
    CocoaMessage(0, GadgetID(TextGadget), "setAttributedStringValue:", MAString)
  EndIf
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  
  If OpenWindow(0, 0, 0, 322, 150, "TextGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget(0, 8, 8, 306, 133, "")
    SetGadgetText(0, "This is a test string to test if coloring" + #CRLF$ + "specific areas will work")
    
    SetTextColorABGR(0, $ff008000, 1); make entire text green
    SetTextColorABGR(0, $ff000080, 1, 7); make first seven characters red
    SetTextColorABGR(0, $ff00f0ff, 1, 4, #YES); set background color of first four characters
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
  
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
