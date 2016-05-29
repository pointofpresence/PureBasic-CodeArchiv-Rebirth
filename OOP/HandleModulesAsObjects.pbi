;    Description: Add support to handle modules as OOP-Objects
;         Author: mk-soft
;           Date: 2016-05-06
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?f=12&t=64305
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29343
; -----------------------------------------------------------------------------

; Comment : Module as Object
; Author  : mk-soft
; Version : v1.16
; Created : 13.12.2015
; Updated : 24.01.2016
; Link GE : http://www.purebasic.fr/german/viewtopic.php?f=8&t=29343
; Link EN : http://www.purebasic.fr/english/viewtopic.php?f=12&t=64305

DeclareModule BaseClass

  ; ---------------------------------------------------------------------------

  ; Internal Class Manager
  Global MethodeID

  Prototype ProtoInvoke(*this)

  Structure udtInvoke
    *Invoke.ProtoInvoke
  EndStructure

  Structure udtClass
    Array *vTable(10)
    vEntrys.i
    Map vMethode.i()
    List Initalize.udtInvoke()
    List Dispose.udtInvoke()
  EndStructure

  Global NewMap Class.udtClass()

  ; ---------------------------------------------------------------------------

  Macro dq
    "
  EndMacro

  ; ---------------------------------------------------------------------------

  ; Added New Class
  Declare AddClass(ClassName.s, Extends.s) ; Internal

  Macro NewClass(Extends=BaseClass)
    If FindMapElement(Class(), dq#Extends#dq)
      AddClass(#PB_Compiler_Module, dq#Extends#dq)
    Else
      Debug "Error: Extends Class '" + dq#Extends#dq + "' not exists!"
      CallDebugger : End
    EndIf
  EndMacro

  ; ---------------------------------------------------------------------------

  ; Macro for init object (small)
  Macro InitObject(sProperty)
    Protected *Object.sProperty
    *Object = AllocateStructure(sProperty)
    If *Object
      *Object\system\vt = Class(#PB_Compiler_Module)\vTable()
      *Object\system\self = @Class(#PB_Compiler_Module)
      *Object\system\refcount = 1
      ForEach *Object\system\self\Initalize()
        *Object\system\self\Initalize()\Invoke(*Object)
      Next
    EndIf
    ProcedureReturn *Object
  EndMacro

  ; ---------------------------------------------------------------------------

  ; Macros for init object (advanced)
  Macro AllocateObject(Object, sProperty)
    Object = AllocateStructure(sProperty)
    If Object
      Object\system\vt = Class(#PB_Compiler_Module)\vTable()
      Object\system\self = @Class(#PB_Compiler_Module)
      Object\system\refcount = 1
    EndIf
  EndMacro

  Macro InitalizeObject(Object, sProperty=)
    If Object
      ForEach Object\system\self\Initalize()
        Object\system\self\Initalize()\Invoke(Object)
      Next
    EndIf
  EndMacro

  ; ---------------------------------------------------------------------------

  ; Macros to defined Initalize, Dispose, Methods

  ; Add Procedure as Initalize
  Macro AsInitalizeObject(Name)
    If FindMapElement(Class(), #PB_Compiler_Module)
      AddElement(Class()\Initalize())
      Class()\Initalize()\Invoke = @Name()
    Else
      Debug "Error: Class is not initialized. NewClass is missing!"
      CallDebugger : End
    EndIf
  EndMacro

  ; Add Procedure as Dispose
  Macro AsDisposeObject(Name)
    If FindMapElement(Class(), #PB_Compiler_Module)
      AddElement(Class()\Dispose())
      Class()\Dispose()\Invoke = @Name()
    Else
      Debug "Error: Class is not initialized. NewClass is missing!"
      CallDebugger : End
    EndIf
  EndMacro

  ; Add Procedure as Methode
  Macro AsMethode(Name)
    If FindMapElement(Class(), #PB_Compiler_Module)
      MethodeID = Class()\vEntrys
      If ArraySize(Class()\vTable()) <= MethodeID
        ReDim Class()\vTable(MethodeID + 10)
      EndIf
      Class()\vTable(MethodeID) = @Name()
      Class()\vMethode(dq#Name#dq) = MethodeID
      Class()\vEntrys + 1
    Else
      Debug "Error: Class is not initialized. NewClass is missing!"
      CallDebugger : End
    EndIf
  EndMacro

  ; Overwrite inheritance methode
  Macro AsNewMethode(Name)
    If FindMapElement(Class(#PB_Compiler_Module)\vMethode(), dq#Name#dq)
      MethodeID = Class()\vMethode()
      Class()\vTable(MethodeID) = @Name()
    Else
      Debug "Error: Method in the inherited class not found. [" + dq#name#dq + "()]"
      CallDebugger : End
    EndIf
  EndMacro

  ; ---------------------------------------------------------------------------

  ; Debugger functions
  Macro ShowInterface(ClassName=#PB_Compiler_Module)
    CompilerIf #PB_Compiler_Debugger
      Define __index
      Debug "List Of Methods " + ClassName
      If FindMapElement(BaseClass::Class(), ClassName)
        For __index = 0 To MapSize(BaseClass::Class()\vMethode()) - 1
          ForEach BaseClass::Class()\vMethode()
            If BaseClass::Class()\vMethode() = __index
              Debug "MethodeID " + BaseClass::Class()\vMethode() + " - " + MapKey(BaseClass::Class()\vMethode()) + "()"
              Break
            EndIf
          Next
        Next
      Else
        Debug "Interface not found."
      EndIf
      Debug "End."
    CompilerEndIf
  EndMacro

  Macro CheckInterface(InterfaceName)
    CompilerIf #PB_Compiler_Debugger
      CompilerIf Defined(InterfaceName, #PB_Interface)
        Define __SizeOfInterface = SizeOf(InterfaceName) / SizeOf(Integer)
        If __SizeofInterface <> Class(#PB_Compiler_Module)\vEntrys
          Debug "Error: Invalid Interface " + dq#InterfaceName#dq + ". Check ..."
          ShowInterface()
          CallDebugger
        EndIf
      CompilerElse
        Debug "Error: Interface not exists"
        CallDebugger
      CompilerEndIf
    CompilerEndIf
  EndMacro

  ; ---------------------------------------------------------------------------

  ; BaseClass Properties
  Structure sBaseSystem
    *vt
    *self.udtClass
    refcount.i
  EndStructure

  ; Public BaseClass
  Structure sBaseClass
    system.sBaseSystem
  EndStructure

  ; Public Interface
  Interface iBaseClass
    AddRef()
    Release()
  EndInterface

  ; ---------------------------------------------------------------------------

EndDeclareModule

Module BaseClass

  EnableExplicit

  ; ---------------------------------------------------------------------------

  Procedure AddClass(ClassName.s, Extends.s)

    Protected r1

    r1 = AddMapElement(Class(), ClassName)
    If r1
      CopyStructure(Class(Extends), Class(ClassName), udtClass)
    EndIf
    ProcedureReturn r1

  EndProcedure

  ; ---------------------------------------------------------------------------

  Procedure Release(*this.sBaseClass)

    With *this\system
      \refcount - 1
      If \refcount <= 0
        ForEach \self\Dispose()
          \self\Dispose()\Invoke(*this)
        Next
        FreeStructure(*this)
      EndIf

      ProcedureReturn \refcount
    EndWith

  EndProcedure

  ; ---------------------------------------------------------------------------

  Procedure AddRef(*this.sBaseClass)
    *this\system\refcount + 1
    ProcedureReturn *this\system\refcount
  EndProcedure

  ; ---------------------------------------------------------------------------

  Procedure InitBaseClass()
    AddMapElement(Class(), "BaseClass")
    With Class("BaseClass")
      \vTable(0) = @AddRef()
      \vTable(1) = @Release()
      \vEntrys = 2
      \vMethode("AddRef") = 0
      \vMethode("Release") = 1
    EndWith
  EndProcedure : InitBaseClass()

  ; ---------------------------------------------------------------------------

EndModule

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ; Example 1
  
  DeclareModule Mitglied
  
    UseModule BaseClass
  
    Structure sMitglied Extends sBaseClass ; Immer hinzufügen
      Nachname.s
      Vorname.s
    EndStructure
  
    Interface iMitglied Extends iBaseClass ; Immer hinzufügen
      SetName(NachName.s, Vorname.s)
      GetName.s()
    EndInterface
  
    Declare NewMitglied()
  
  EndDeclareModule
  
  Module Mitglied
  
    UseModule BaseClass ; Immer hinzufügen
  
    NewClass()
  
    ; ---------------------------------------------------------------------------
  
    Procedure Init(*this.sMitglied)
      Debug "Initialize Mitglied"
    EndProcedure : AsInitalizeObject(Init)
  
    ; ---------------------------------------------------------------------------
  
    Procedure Dispose(*this.sMitglied)
      Debug "Dispose Mitglied"
    EndProcedure : AsDisposeObject(Dispose)
  
    ; ---------------------------------------------------------------------------
  
    Procedure SetName(*this.sMitglied, Nachname.s, Vorname.s)
  
      With *this
        \Nachname = Nachname
        \Vorname = Vorname
      EndWith
  
    EndProcedure : AsMethode(SetName)
  
    ; ---------------------------------------------------------------------------
  
    Procedure.s GetName(*this.sMitglied)
  
      Protected result.s
  
      With *this
        result = \Nachname + ", " + \Vorname
      EndWith
  
      ProcedureReturn result
  
    EndProcedure : AsMethode(GetName)
  
    ; ---------------------------------------------------------------------------
  
    Procedure NewMitglied()
      InitObject(sMitglied)
    EndProcedure
  
    ; ---------------------------------------------------------------------------
  
  EndModule
  
  ; Test Mitglied
  
  UseModule Mitglied
  
  Define.iMitglied *obj1, *obj2
  
  *obj1 = NewMitglied()
  *obj2 = NewMitglied()
  
  *obj1\SetName("Mustermann", "Udo")
  *obj2\SetName("Mustermann", "Sabine")
  
  Debug *obj1\GetName()
  Debug *obj2\GetName()
  
  *obj1\Release()
  *obj2\Release()
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
