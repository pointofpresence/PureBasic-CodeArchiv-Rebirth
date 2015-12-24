;   Description: Enable #PB_EventType_MouseEnter and #PB_EventType_MouseLeave for all gadgets
;        Author: mk-soft
;          Date: 2015-10-11
;    PB-Version: 5.40
;            OS: Windows, Linux, Mac
; English-Forum: 
;  French-Forum: 
;  German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29047
;-----------------------------------------------------------------------------
;-Begin Module MouseOver
; Comment: Modul MouseOver
; Author : mk-soft
; Version: v1.04
; Created: 27.07.2015
; Updated: 11.10.2015
; Link   : http://www.purebasic.fr/german/viewtopic.php?f=8&t=29047   
;
; Thanks to:
;
; - Wilbert for mac functions get object under mouse
;     http://www.purebasic.fr/english/viewtopic.php?f=19&t=62056
;
; - Shardik for linux functions get object under mouse
;

DeclareModule MouseOver
  Declare Init(timer=999)
  Declare Release(timer=999)
EndDeclareModule

Module MouseOver
  
  ; Import internal function ------------------------------------------------------------
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
    CompilerElse
      ImportC "" ;EndIndent
    CompilerEndIf
    PB_Object_EnumerateStart( PB_Objects )
    PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
    PB_Object_EnumerateAbort( PB_Objects )
    PB_Window_Objects.i
    PB_Gadget_Objects.i
  EndImport
  
  ; -------------------------------------------------------------------------------------
  
  Global window_for_timer = -1
  
  ; -------------------------------------------------------------------------------------
  
  Procedure EventHandler()
    
    Static lasthandle, lastgadget = -1, x, y, last_x, last_y
    
    Protected gadget, handle
    
    x = WindowMouseX(EventWindow())
    y = WindowMouseY(EventWindow())
    If x <> last_x Or y <> last_y
      last_x = x
      last_y = y
      
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          Protected desktop_x, desktop_y
          desktop_x = DesktopMouseX()
          desktop_y = DesktopMouseY()
          handle = WindowFromPoint_(desktop_y << 32 | desktop_x)
        CompilerCase #PB_OS_MacOS
          Protected win_id, win_cv, pt.NSPoint
          win_id = WindowID(EventWindow())
          win_cv = CocoaMessage(0, win_id, "contentView")
          CocoaMessage(@pt, win_id, "mouseLocationOutsideOfEventStream")
          handle = CocoaMessage(0, win_cv, "hitTest:@", @pt)
        CompilerCase #PB_OS_Linux
          Protected desktop_x, desktop_y, *GdkWindow.GdkWindowObject
          *GdkWindow.GdkWindowObject = gdk_window_at_pointer_(@desktop_x,@desktop_y)
          If *GdkWindow
            handle = *GdkWindow\user_data
          Else
            handle = 0
          EndIf
      CompilerEndSelect
      
      If handle <> lasthandle
        If lastgadget >= 0
          If GadgetType(lastgadget) <> #PB_GadgetType_Canvas
            PostEvent(#PB_Event_Gadget, #PB_Ignore, lastgadget, #PB_EventType_MouseLeave)
          EndIf
          lastgadget = -1
        EndIf
        ; Find gadgetid over handle
        PB_Object_EnumerateStart(PB_Gadget_Objects)
        While PB_Object_EnumerateNext(PB_Gadget_Objects, @gadget)
          If handle = GadgetID(gadget)
            lastgadget = gadget
            If GadgetType(lastgadget) <> #PB_GadgetType_Canvas
              PostEvent(#PB_Event_Gadget, #PB_Any, gadget, #PB_EventType_MouseEnter)
            EndIf
            PB_Object_EnumerateAbort(PB_Gadget_Objects)
            Break
          EndIf
        Wend
        lasthandle = handle
      EndIf
    EndIf
    
  EndProcedure
  
  ; -------------------------------------------------------------------------------------
  
  Procedure Init(timer=999)
    Protected window
    PB_Object_EnumerateStart(PB_Window_Objects)
    If PB_Object_EnumerateNext(PB_Window_Objects, @window)
      AddWindowTimer(window, timer, 100)
      BindEvent(#PB_Event_Timer , @EventHandler())
      PB_Object_EnumerateAbort(PB_Window_Objects)
      window_for_timer = window
    EndIf
  EndProcedure
  
  ; -------------------------------------------------------------------------------------
  
  Procedure Release(timer=999)
    If window_for_timer >= 0
      UnbindEvent(#PB_Event_Timer , @EventHandler())
      RemoveWindowTimer(window_for_timer, timer)
      window_for_timer = -1
    EndIf
  EndProcedure
  
  ; -------------------------------------------------------------------------------------
  
EndModule

;-End Module MouseOver

; ***************************************************************************************

;- Example 1

CompilerIf #PB_Compiler_IsMainFile
  
  Enumeration FormWindow
    #Window_0
  EndEnumeration
  
  Enumeration FormGadget
    #Editor_0
    #Canvas_0
    #ExplorerList_0
    #ExplorerTree_0
    #ListView_0
    #ListIcon_0
    #Combo_0
    #Date_0
    #Option_0
    #Option_1
    #Checkbox_0
    #Hyperlink_0
    #IP_0
    #Button_0
    #Button_1
    #Button_2
    #Button_3
  EndEnumeration
  
  
  Procedure OpenWindow_0(x = 0, y = 0, width = 610, height = 400)
    OpenWindow(#Window_0, x, y, width, height, "MouseOver Events", #PB_Window_SystemMenu)
    EditorGadget(#Editor_0, 10, 10, 290, 60)
    CanvasGadget(#Canvas_0, 310, 10, 290, 60)
    ExplorerListGadget(#ExplorerList_0, 310, 80, 290, 100, "")
    ExplorerTreeGadget(#ExplorerTree_0, 10, 80, 290, 100, "")
    ListViewGadget(#ListView_0, 10, 190, 290, 60)
    ListIconGadget(#ListIcon_0, 310, 190, 290, 60, "Column 1", 100)
    ComboBoxGadget(#Combo_0, 10, 260, 290, 30)
    DateGadget(#Date_0, 310, 260, 290, 30, "")
    OptionGadget(#Option_0, 10, 300, 80, 30, "Option 1")
    OptionGadget(#Option_1, 100, 300, 90, 30, "Option 2")
    CheckBoxGadget(#Checkbox_0, 200, 300, 100, 30, "Check")
    HyperLinkGadget(#Hyperlink_0, 310, 300, 140, 30, "www.purebasic.com", 0)
    IPAddressGadget(#IP_0, 460, 300, 140, 30)
    ButtonGadget(#Button_0, 10, 340, 140, 40, "Button 0")
    ButtonGadget(#Button_1, 160, 340, 140, 40, "Button 1")
    ButtonGadget(#Button_2, 310, 340, 140, 40, "Button 2")
    ButtonGadget(#Button_3, 460, 340, 140, 40, "Button 3")
  EndProcedure
  
  OpenWindow_0()
  
  MouseOver::Init()
  
  Repeat
    Event = WaitWindowEvent(10)
    If Event = #PB_Event_Gadget
      
      Select EventType()
        Case #PB_EventType_MouseEnter
          Debug "MouseEnter Gadget " + EventGadget()
        Case #PB_EventType_MouseLeave
          Debug "MouseLeave Gadget " + EventGadget()
          
      EndSelect
    EndIf
    
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
