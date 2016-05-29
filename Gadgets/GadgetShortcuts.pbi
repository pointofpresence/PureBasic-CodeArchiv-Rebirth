;    Description: The module simplifies setting up keyboard shortcuts for gadgets
;         Author: Derren (Code has been improved by Sicro)
;           Date: 2016-05-06
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29410
; -----------------------------------------------------------------------------

;============================================================
;= GadgetShortcuts::    Adds KeyboardShortcuts to Gadgets
;= Version:             0.1a
;= Author:              Derren (german and english purebasic forum)
;= PB Version:          5.31 LTS  x86 (written in)
;= Infothread:          http://purebasic.fr/german/viewtopic.php?f=8&t=29410
;============================================================

;################ Limitation ###########################################
; The module only works with the following gadgets:
; CanvasGadget, ComboBoxGadget, EditorGadget, OpenGLGadget, StringGadget
;#######################################################################

DeclareModule GadgetShortcuts
  EnableExplicit
  Declare Add(Window, Gadget, Key, Event=#PB_Any) ;Returns Event, in case of #PB_Any, or #True or #False
  Declare Remove(Window, Gadget, Key)
  Declare Do(EventWindow, EventGadget, EventType)
EndDeclareModule

;Usage:
;
;  Repeat
;    Event = WaitWindowEvent()
;    Select Event
;      Case #PB_Event_Gadget
;        GadgetShortcuts::Do(EventWindow(), EventGadget(), EventType())
;
;        Select EventGadget()
;          Case #myGadget ;...

Module GadgetShortcuts
  
  Structure shortcutEvent
    Shortcut.i
    Event.i
  EndStructure
  
  Structure MapStructure
    List events.shortcutEvent()
  EndStructure
  
  NewMap shortcuts.MapStructure()
  
  Procedure Add(Window, Gadget, Key, Event=#PB_Any)
    Shared shortcuts()
    Static any_Event
    
    Select GadgetType(Gadget)
      Case #PB_GadgetType_Canvas, #PB_GadgetType_ComboBox, #PB_GadgetType_Editor, #PB_GadgetType_OpenGL, #PB_GadgetType_String
      Default : ProcedureReturn #False
    EndSelect
    
    If Event = #PB_Any
      any_Event = any_Event + 1
      Event = any_Event
    EndIf
    
    If AddElement(shortcuts(Str(Window)+"|"+Str(Gadget))\events())
      shortcuts(Str(Window)+"|"+Str(Gadget))\events()\Event = Event
      shortcuts(Str(Window)+"|"+Str(Gadget))\events()\Shortcut = Key
      If Event = #PB_Any
        ProcedureReturn Event
      Else
        ProcedureReturn #True
      EndIf
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  Procedure Remove(Window, Gadget, Key)
    Shared shortcuts()
    
    ForEach shortcuts(Str(Window)+"|"+Str(Gadget))\events()
      If shortcuts(Str(Window)+"|"+Str(Gadget))\events()\Shortcut = Key
        DeleteElement(shortcuts(Str(Window)+"|"+Str(Gadget))\events(), #True)
      EndIf
    Next
  EndProcedure
  
  Procedure Do(EventWindow, EventGadget, EventType)
    Shared shortcuts()
    
    Select EventType
      Case #PB_EventType_Focus
        ForEach shortcuts(Str(EventWindow)+"|"+Str(EventGadget))\events()
          AddKeyboardShortcut(EventWindow, shortcuts(Str(EventWindow)+"|"+Str(EventGadget))\events()\Shortcut, shortcuts(Str(EventWindow)+"|"+Str(EventGadget))\events()\Event)
        Next
      Case #PB_EventType_LostFocus
        ForEach shortcuts(Str(EventWindow)+"|"+Str(EventGadget))\events()
          RemoveKeyboardShortcut(EventWindow, shortcuts(Str(EventWindow)+"|"+Str(EventGadget))\events()\Shortcut)
        Next
        
    EndSelect
  EndProcedure
EndModule

;-Example
CompilerIf #PB_Compiler_IsMainFile
  If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)
    
    n = 0
    StringGadget(0, 5, 5, 150, 20, Str(n) + " x Strg+P gedrückt")
    StringGadget(1, 5, 80, 150, 20, "String2: Strg+T -> MsgBox")
    IPAddressGadget(2, 5, 155, 150, 20)
    
    GadgetShortcuts::Add(0, 0, #PB_Shortcut_Control|#PB_Shortcut_P, 15)
    myEvent = GadgetShortcuts::Add(0, 1, #PB_Shortcut_Control|#PB_Shortcut_T)
    
    If GadgetShortcuts::Add(0, 2, #PB_Shortcut_Control|#PB_Shortcut_O)
      Debug "IPAdressGadget: OK"
    Else
      Debug "IPAdressGadget: Error"
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          GadgetShortcuts::Do(EventWindow(), EventGadget(), EventType())
          
        Case #PB_Event_Menu
          Select EventMenu()
            Case 15
              n=n+1
              SetGadgetText(0, Str(n) + " x Strg+P gedrückt")
              
            Case myEvent
              MessageRequester("MsgBox", "Strg+T mit Fokus auf String 2 gedrückt")
              
          EndSelect
        Case #PB_Event_CloseWindow
          Quit = 1
      EndSelect
      
    Until Quit = 1
    
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
