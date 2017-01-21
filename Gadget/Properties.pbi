;    Description: Adds support for properties (alternative for SetGadgetData() )
;         Author: Alexi
;           Date: 2013-05-12
;     PB-Version: 5.50 beta 1
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=26761
; -----------------------------------------------------------------------------

;======================================================================
; File:            Properties.pbi
;
; Author:          Alex Wiese (Mevedia)
; Date:            May 14, 2013
; Version:         1.1
; Demo:            No
; Target Compiler: PureBasic 5.1+
; Processor        x32/x64
; Target OS:       Windows, Linux, MacOS
; Website:         http://www.mevedia.de
;======================================================================

; More extensive (internal) Surrogate for SetGadgetData()/GetGadgetData().
; Can be used for anything Gadget, Item, Menu, StatusBar, Images and so on, or
; custom Types.


; Set to #False to use System Calls.
#PB_ProperiesInternal = #True






CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux
    ImportC "-gtk"
      g_object_set_property_(*Widget, Property.p-utf8, *val) As "g_object_set_property"
      g_object_get_property_(*Widget, Property.p-utf8) As "g_object_get_property"
    EndImport
CompilerEndSelect


Structure _PROPERTY
  Map *Prop(32)
EndStructure
Structure _PROPERTYSTOCK
  Map ID._PROPERTY(4096)
EndStructure

Global _PropertyStock._PROPERTYSTOCK



Macro ptDefine(Symbol)
  CompilerIf Defined(Symbol, #PB_Constant) = #False
    #Symbol = MacroExpandedCount
  CompilerEndIf
EndMacro

;[- Property Types

  ptDefine(PB_File)
  ptDefine(PB_Pack)
  ptDefine(PB_Preference)
  ptDefine(PB_Image)
  ptDefine(PB_Movie)
  ptDefine(PB_Font)
  ptDefine(PB_Sound)
  ptDefine(PB_Sound3D)
  ptDefine(PB_Sprite)
  ptDefine(PB_Sprite3D)
  ptDefine(PB_Texture)
  ptDefine(PB_Mesh)
  ptDefine(PB_StaticGeometry)
  ptDefine(PB_Entity)
  ptDefine(PB_Spline)
  ptDefine(PB_Material)
  ptDefine(PB_Light)
  ptDefine(PB_Joint)
  ptDefine(PB_Node)
  ptDefine(PB_NodeAnimation)
  ptDefine(PB_Effect)
  ptDefine(PB_Billboard)
  ptDefine(PB_Terrain)
  ptDefine(PB_Particle)
  ptDefine(PB_Expression)
  ptDefine(PB_Module)
  ptDefine(PB_Network)
  ptDefine(PB_Thread)
  ptDefine(PB_Process)
  ptDefine(PB_Printer)

  ptDefine(PB_XML)
  ptDefine(PB_Palette)
  ptDefine(PB_Mail)
  ptDefine(PB_Joystick)
  ptDefine(PB_Keyboard)
  ptDefine(PB_Mouse)

  ptDefine(PB_Gadget3D)
  ptDefine(PB_GadgetItem3D)
  ptDefine(PB_Window3D)
  ptDefine(PB_Control) ; Canvas based Controls
  ptDefine(PB_Gadget)
  ptDefine(PB_GadgetItem)
  ptDefine(PB_Window)
  ptDefine(PB_Menu)
  ptDefine(PB_MenuItem)
  ptDefine(PB_ToolBar)
  ptDefine(PB_ToolBarItem)
  ptDefine(PB_Popup)
  ptDefine(PB_StatusBar)
  ptDefine(PB_StatusBarField)
  ptDefine(PB_SysTray)

  ; User defined


;]-



Procedure SetProp(ID, Name.s, *Data, Type = #Null)
  CompilerIf #PB_ProperiesInternal = #True
    _PropertyStock\ID(Str(ID))\Prop(Str(Type)+"\"+Name) = *Data
  CompilerElse
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        SetProp_(ID, Name, *Data)
      CompilerCase #PB_OS_Linux
        g_object_set_property_(Handle, Property, *Data)
      CompilerCase #PB_OS_MacOS
    CompilerEndSelect
  CompilerEndIf
EndProcedure

Procedure GetProp(ID, Name.s, Type = #Null)
  CompilerIf #PB_ProperiesInternal = #True
    ProcedureReturn _PropertyStock\ID(Str(ID))\Prop(Str(Type)+"\"+Name)
  CompilerElse
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetProp_(ID, Name)
      CompilerCase #PB_OS_Linux
        ProcedureReturn g_object_get_property_(ID, Name)
      CompilerCase #PB_OS_MacOS
    CompilerEndSelect
  CompilerEndIf
EndProcedure

Procedure RemoveProp(Type, ID, Name)
CompilerIf #PB_ProperiesInternal = #True
  DeleteMapElement( _PropertyStock\ID(Str(ID))\Prop(), Str(Type)+"\"+Name )
CompilerElse
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      RemoveProp_(ID, Name)
    CompilerCase #PB_OS_Linux
      ; Unknown
    CompilerCase #PB_OS_MacOS
  CompilerEndSelect
CompilerEndIf
EndProcedure


;- Extra
CompilerIf #PB_ProperiesInternal = #True
  Procedure IsProp(Type, ID, Name)

    If FindMapElement( _PropertyStock\ID(Str(ID))\Prop(), Str(Type)+"\"+Name )
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf

  EndProcedure

  Procedure CollectProp(ID, List pData(), Type)
    ClearList(pData())
    ForEach _PropertyStock\ID(Str(ID))\Prop()
      AddElement(pData())
      pData() = _PropertyStock\ID(Str(ID))\Prop()
    Next
    ResetList(pData())
  EndProcedure
CompilerEndIf

;-Example
CompilerIf #PB_Compiler_IsMainFile
  OpenWindow(0, 0, 0, 200, 200, "Internal Properties", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    CanvasGadget(0, 10, 10, 180, 180)
  
    SetProp(0, "MyData", 16, #PB_Control)
    SetProp(0, "OtherData", 32, #PB_Control)
  
    Define NewList All()
  
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          End
  
        Case #PB_Event_Gadget
          If EventType() = #PB_EventType_LeftButtonDown
  
            CollectProp(0, All(), #PB_Control)
  
            ForEach All()
              Debug All()
            Next
          EndIf
  
      EndSelect
    ForEver
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
