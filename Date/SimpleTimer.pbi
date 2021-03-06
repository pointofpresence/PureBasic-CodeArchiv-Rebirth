﻿;    Description: Timer module for code execution when a specific time has elapsed.
;         Author: True29 (Code has been improved by Sicro)
;           Date: 2016-05-05
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=334679#p334679
; -----------------------------------------------------------------------------

;******************************************************************************************************
;- ***  Include Timer  ***
;******************************************************************************************************
;// Include Timer Module
;// Johannes Meyer
;// version 1.3
;// PB 5.40
;// 1.1.2016
;// forum http://www.purebasic.fr/german/viewtopic.php?f=8&t=28436
;******************************************************************************************************
;- ***  ***
;******************************************************************************************************

EnableExplicit

DeclareModule Timer
  EnableExplicit
  
  #TimerIncludeDebug = #False
  
  Enumeration
    #TIMER_SEC
    #TIMER_MIN
    #TIMER_HOUR
    #TIMER_DAY
  EndEnumeration
  
  Declare.i UPDATE_TIMER(TimerID.i, Time.i, StartTime.i = #PB_Ignore)
  Declare.i CONV_TIME_TO_(Time.i, Type.i = #TIMER_SEC)
  Declare.i GET_TIMER_TIME_PAST(TimerID.i)
  Declare.i GET_TIMER_TIME(TimerID.i)
  Declare.i ADD_TIMER(StartTime.i, TimeToCheck.i, TimerID.i = #PB_Any)
  Declare.i DELETE_TIMER(TimerID.i)
  Declare.i TIMER_EXIST(TimerID.i)
  Declare.i CHECK_TIMER(TimerID.i)
  Declare.i COUNT_TIMER()
EndDeclareModule

Module Timer
    
  Structure Struct_Timer
    StartTime.i
    Time.i
    TimerID.i
    TimeToCheck.i
  EndStructure
  
  Global NewList Timer.Struct_Timer()
  Global TimerIncludeDebug.i = #False
  
  Procedure.i UPDATE_TIMER(TimerID.i, Time.i, StartTime.i = #PB_Ignore)
    ForEach Timer()
      With Timer()
        If TimerID = \TimerID
          If StartTime <> #PB_Ignore
            \StartTime = StartTime
          EndIf
          \TimeToCheck = Time
          
          CompilerIf #TimerIncludeDebug
            Debug "Timer Update ID "+ TimerID +" OK"
          CompilerEndIf
          
        EndIf
      EndWith
    Next
  EndProcedure
  
  Procedure.i CONV_TIME_TO_(Time.i, Type.i = #TIMER_SEC)
    Select Type
      Case #TIMER_SEC
        ProcedureReturn (Time / 1000) % 60     
      Case #TIMER_MIN
        ProcedureReturn (Time / 60000) % 60     
      Case #TIMER_HOUR
        ProcedureReturn (Time / 3600000) % 24     
      Case #TIMER_DAY
        ProcedureReturn Time / 86400000
    EndSelect
  EndProcedure
  
  Procedure.i GET_TIMER_TIME_PAST(TimerID.i)
    Protected TimeNow.i = ElapsedMilliseconds()
    
    ForEach Timer()
      With Timer()
        If TimerID = \TimerID
          CompilerIf #TimerIncludeDebug
            Debug "Timer PAST "+TimerID+" OK"
          CompilerEndIf
          ProcedureReturn (TimeNow - \StartTime)
        EndIf
      EndWith
    Next
  EndProcedure
    
  Procedure.i GET_TIMER_TIME(TimerID.i)
    Protected TimeNow.i = ElapsedMilliseconds()
    
    ForEach Timer()
      With Timer()
        If TimerID = \TimerID
          CompilerIf #TimerIncludeDebug
            Debug "Timer Time "+TimerID+" OK"
          CompilerEndIf
          ProcedureReturn \TimeToCheck - (TimeNow - \StartTime)
        EndIf
      EndWith
    Next
  EndProcedure
    
  Procedure.i ADD_TIMER(StartTime.i, TimeToCheck.i, TimerID.i = #PB_Any)
    AddElement(Timer())
        
    If TimerID = #PB_Any
      TimerID = @Timer()
    EndIf
    
    With Timer()
      \StartTime   = StartTime
      \TimeToCheck = TimeToCheck
      \TimerID     = TimerID
    EndWith
    CompilerIf #TimerIncludeDebug
      Debug "Timer ADD "+TimerID+" OK"
    CompilerEndIf
    
    ProcedureReturn TimerID
  EndProcedure
  
  Procedure.i DELETE_TIMER(TimerID.i)
    ForEach Timer()
      With Timer()
        If \TimerID = TimerID
          DeleteElement(Timer())
          CompilerIf #TimerIncludeDebug
            Debug "Timer DELETE "+TimerID+" OK"
          CompilerEndIf
          ProcedureReturn #True
        EndIf
      EndWith
    Next
    ProcedureReturn #False
  EndProcedure
  
  Procedure.i TIMER_EXIST(TimerID.i)
    ForEach Timer()
      With Timer()
        If \TimerID = TimerID
          CompilerIf #TimerIncludeDebug
            Debug "Timer EXIST "+TimerID+" OK"
          CompilerEndIf
          ProcedureReturn #True
        EndIf
      EndWith
    Next
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure.i CHECK_TIMER(TimerID.i)
    Protected TimeNow.i = ElapsedMilliseconds()
    
    ForEach Timer()
      With Timer()
        \Time = \TimeToCheck - (TimeNow - \StartTime)
        If \TimerID = TimerID And TimeNow - \StartTime >= \TimeToCheck
          CompilerIf #TimerIncludeDebug
            Debug "Timer CHECK "+TimerID+" OK"
          CompilerEndIf
          ProcedureReturn #True
        EndIf
      EndWith
    Next
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure.i COUNT_TIMER()
    Protected Timer.i
    
    ForEach Timer()
      If CHECK_TIMER(Timer()\TimerID) = #True
        Timer + 1
      EndIf
    Next
    
    CompilerIf #TimerIncludeDebug
      Debug "Timer Count " + Str(Timer)
    CompilerEndIf
    
    ProcedureReturn Timer
  EndProcedure
  
EndModule

;-Example
CompilerIf #PB_Compiler_IsMainFile
  #Timer1 = 0
  #WaitTime = 5000
  
  Timer::ADD_TIMER(ElapsedMilliseconds(), #WaitTime, #Timer1)
  
  Repeat
    If Timer::CHECK_TIMER(#Timer1)
      Debug Str(#WaitTime)+" milliseconds have expired!"
      Timer::DELETE_TIMER(#Timer1)
      Break
    EndIf
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
