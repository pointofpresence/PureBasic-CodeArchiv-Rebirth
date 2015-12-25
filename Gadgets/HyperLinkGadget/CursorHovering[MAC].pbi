;    Description: Change cursor hovering over HyperLinkGadget
;         Author: Shardik
;           Date: 2013-09-17
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=425502#p425502
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

EnableExplicit

Procedure ChangeHoverCursor(HyperLinkID.I, CursorName.S)
  Protected AttributeDictionary.I
  Protected MutableAttributeDictionary.I
  Protected NewCursor.I
  
  AttributeDictionary = CocoaMessage(0, GadgetID(HyperLinkID),
                                     "linkTextAttributes")
  
  If AttributeDictionary
    If CocoaMessage(0, AttributeDictionary, "valueForKey:$", @"NSCursor")
      NewCursor = CocoaMessage(0, 0, "NSCursor " + CursorName)
      
      If NewCursor
        MutableAttributeDictionary = CocoaMessage(0, AttributeDictionary,
                                                  "mutableCopyWithZone:", 0)
        
        If MutableAttributeDictionary
          CocoaMessage(0, MutableAttributeDictionary, "setValue:", NewCursor,
                       "forKey:$", @"NSCursor")
          CocoaMessage(0, GadgetID(HyperLinkID), "setLinkTextAttributes:",
                       MutableAttributeDictionary)
          CocoaMessage(0, MutableAttributeDictionary, "release")
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure


;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  OpenWindow(0, 270, 100, 200, 80, "HyperlinkGadgets")
  HyperLinkGadget(0, 25, 20, 160, 15, "Default HyperLink cursor", $FF0000, #PB_HyperLink_Underline)
  HyperLinkGadget(1, 20, 45, 160, 15, "Modified HyperLink cursor", $FF0000, #PB_HyperLink_Underline)
  
  ChangeHoverCursor(1, "dragLinkCursor")
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
