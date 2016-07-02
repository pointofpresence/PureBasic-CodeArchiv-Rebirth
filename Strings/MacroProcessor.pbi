;    Description: Macro Processor
;         Author: cxAlex
;           Date: 2013-03-10
;     PB-Version: 5.50 beta 1
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=26494
; -----------------------------------------------------------------------------

; Macro Processor

; EnableExplicit

; Holder for 1 Macro
Structure _Macro
  Body$
  List Params$()
EndStructure

; Control Structure
Structure __MacroProcessor
  Map Macros._Macro()
  ParamLimiter$
  *tester.__ValidTester
EndStructure

; Parmater Validator
Prototype __ValidTester(Name$)

; Converts String to Parameter List
Procedure __MP_StringToParamList(String$, List Params$(), *tester.__ValidTester = #Null)
  ClearList(Params$())
  Protected i, tcmd$, tcnt = CountString(String$, ",")
  If tcnt
    For i = 1 To tcnt+1
      tcmd$ = Trim(StringField(String$, i, ","))
      If tcmd$
        If *tester And Not *tester(tcmd$)
          ProcedureReturn #Null
        EndIf
        AddElement(Params$()) : Params$() = tcmd$
      Else
        ProcedureReturn #False
      EndIf
    Next
  Else
    If Bool(String$) And *tester And (Not *tester(String$))
      ProcedureReturn #Null
    EndIf
    AddElement(Params$()) : Params$() = String$
  EndIf
  ProcedureReturn #True
EndProcedure

; Creates New Macro Processor
Procedure MP_new(*tester.__ValidTester = #Null, ParamLimiter$ = "%")
  Protected *mp.__MacroProcessor = AllocateMemory(SizeOf(__MacroProcessor))
  InitializeStructure(*mp, __MacroProcessor)
  *mp\ParamLimiter$ = ParamLimiter$
  *mp\tester = *tester
  ProcedureReturn *mp
EndProcedure

; Frees Macro Processor
Procedure MP_free(*mp.__MacroProcessor)
  ClearStructure(*mp, __MacroProcessor)
  FreeMemory(*mp)
EndProcedure

; Adds Macro to Macro Processor
Procedure MP_addMacro(*mp.__MacroProcessor, MacroName$, Params$, Body$)
  NewList Params$()
  Protected RtVar = #False
  If (Not FindMapElement(*mp\Macros(), MacroName$)) And __MP_StringToParamList(Params$, Params$(), *mp\tester)
    CopyList(Params$(), *mp\Macros(MacroName$)\Params$())
    *mp\Macros()\Body$ = Body$
    RtVar = #True
  EndIf
  ProcedureReturn RtVar
EndProcedure

; Removes Macro from Processor
Procedure MP_removeMacro(*mp.__MacroProcessor, MacroName$)
  Protected RtVar = #False
  If FindMapElement(*mp\Macros(), MacroName$)
    DeleteMapElement(*mp\Macros())
    RtVar = #True
  EndIf
  ProcedureReturn RtVar
EndProcedure

; Checks if Macro exists
Procedure MP_macroExists(*mp.__MacroProcessor, MacroName$)
  ProcedureReturn Bool(FindMapElement(*mp\Macros(), MacroName$))
EndProcedure

; Parses Macro
Procedure$ MP_parseMacro(*mp.__MacroProcessor, MacroName$, Params$ = "")
  NewList Params$()
  Protected tBody$
  If FindMapElement(*mp\Macros(), MacroName$) And __MP_StringToParamList(Params$, Params$()) And (ListSize(Params$()) = ListSize(*mp\Macros()\Params$()))
    tBody$ = *mp\Macros()\Body$
    ResetList(Params$())
    ForEach *mp\Macros()\Params$()
      NextElement(Params$())
      tBody$ = ReplaceString(tBody$, *mp\ParamLimiter$+*mp\Macros()\Params$()+*mp\ParamLimiter$, Params$())
    Next
    ProcedureReturn tBody$
  EndIf
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ; Variablen-Name prüfen (A-Z/a-z/0-9/_ , darf nicht mit einer Zahl beginnen)
  Procedure IsValidVariableName(Var$)
    Protected *Var.Character = @Var$
    If Var$ = "" Or Len(Var$) > 255
      ProcedureReturn #False
    EndIf
    Select *Var\c  ; Keine Zahl am Anfang!
      Case 'a' To 'z', 'A' To 'Z', '_'
      Default : ProcedureReturn #False
    EndSelect
    *Var + SizeOf(Character)
    While *Var\c
      Select *Var\c
        Case '0' To '9', 'a' To 'z', 'A' To 'Z', '_'
        Default : ProcedureReturn #False
      EndSelect
      *Var + SizeOf(Character)
    Wend
    ProcedureReturn #True
  EndProcedure
  
  ; New MacroProcessor
  Define mp = MP_new(@IsValidVariableName())
  
  
  ; Adds Macro
  Define Entry$
  Entry$ = "<!DOCTYPE HTML PUBLIC " + #DQUOTE$ + "-//W3C//DTD HTML 4.01//EN" + #DQUOTE$ + #LF$ +
           #DQUOTE$ + "http://www.w3.org/TR/html4/strict.dtd" + #DQUOTE$ + ">" + #LF$ +
           "<html>" + #LF$ + "<head>" + #LF$ +
           "<title> %title% </title>" + #LF$ + "</head>" + #LF$ + "<body>"
  
  MP_addMacro(mp, "head", "title", Entry$)
  
  Entry$ = "<h2>%name%</h2>" + #LF$ +
           "<ul><li>Geboren: %birth%</li>" + #LF$ +
           "<li>Geschlecht: %gender%</li>" + #LF$ +
           "<li>eMail: %mail%</li></ul>"
  
  MP_addMacro(mp, "entry", "name, birth, gender, mail", Entry$)
  
  MP_addMacro(mp, "border", "", "</body>" + #LF$ + "</html>")
  
  Define myHTML$
  
  ; Compose HTML
  myHTML$ = MP_parseMacro(mp, "head", "Personen") + #LF$
  myHTML$ + MP_parseMacro(mp, "entry", "Freddy Müller, 12.12.1980, männlich, freddy.m@gvt.net") + #LF$
  myHTML$ + MP_parseMacro(mp, "entry", "Barbara Mayr, 10.07.1950, weiblich, bm@lobo.cn") + #LF$
  myHTML$ + MP_parseMacro(mp, "entry", "Robert Rosenstolz, 15.08.1972, männlich, rob.rs@stolz.to") + #LF$
  myHTML$ + MP_parseMacro(mp, "entry", "Max Mustermann, 01.03.2000, männlich, mustermax@testdomaen.at") + #LF$
  myHTML$ + MP_parseMacro(mp, "border")
  
  ; Frees Macro Processor
  MP_free(mp)
  
  OpenWindow(1, 0, 0, 400, 600, "test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
  WebGadget(0, 0, 0, 400, 600, "")
  SetGadgetItemText(0, #PB_Web_HtmlCode ,myHTML$)
  HideWindow(1, #False)
  
  Repeat
    If WaitWindowEvent() = #PB_Event_CloseWindow
      End
    EndIf
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
