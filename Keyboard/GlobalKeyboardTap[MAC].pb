;    Description: Global keyboard tap
;         Author: wilbert
;           Date: 2013-10-29
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=428417#p428417
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

#KeyDownMask      = 1 << 10
#FlagsChangedMask = 1 << 12

#kCGKeyboardEventKeycode = 9

ImportC ""
  CGEventTapCreate(tap, place, options, eventsOfInterest.q, callback, refcon)
  CGEventGetFlags.q(event)
  CGEventGetIntegerValueField.q(event, field)
EndImport

Define eventTap


Global SpeechSynthesizer = CocoaMessage(0, CocoaMessage(0, 0, "NSSpeechSynthesizer alloc"), "initWithVoice:", #nil)

ProcedureC eventTapFunction(proxy, type, event, refcon)
  Protected keyCode = CGEventGetIntegerValueField(event, #kCGKeyboardEventKeycode)
  Protected keyFlags = CGEventGetFlags(event) >> 16 & 255
  
  If keyCode = 53 And keyFlags & $80
    ; [fn] + [esc] pressed
    CocoaMessage(0, SpeechSynthesizer, "startSpeakingString:$", @"fn and esc pressed")
  EndIf
  
EndProcedure


If OpenWindow(0, 0, 0, 200, 30, "key tap", #PB_Window_SystemMenu | #PB_Window_Minimize | #PB_Window_NoActivate)
  
  eventTap = CGEventTapCreate(0, 0, 1, #KeyDownMask | #FlagsChangedMask, @eventTapFunction(), 0)
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
