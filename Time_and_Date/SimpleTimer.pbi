;    Description: Simple Timer Routine
;         Author: True29
;           Date:2015-05-24
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28436&p=333223#p333223
;-----------------------------------------------------------------------------
;******************************************************************************************************
;- ***  Include Timer  ***
;******************************************************************************************************
;// Include Timer
;// Johannes Meyer
;// version 1.1
;// PB 5.11
;// 24.5.2015
;// forum http://www.purebasic.fr/german/viewtopic.php?f=8&t=28436
;******************************************************************************************************
;- ***  ***
;******************************************************************************************************

Structure Struct_Timer
  StartTime.i
  Time.i
  TimerID.i
  TimeToCheck.i
EndStructure

Enumeration
  #TIME_NONE
  #TIMER_SEC
  #TIMER_MIN
  #TIMER_HOURS
  #TIMER_DAY
EndEnumeration
Global NewList Timer.Struct_Timer()
Global TimerIncludeDebug.i = #False

Procedure DEBUG_TIMER(IncludeDebug = #True)
  TimerIncludeDebug = IncludeDebug
EndProcedure

Procedure UPDATE_TIMER(TimerID.i,Time.i,StartTime.i = #PB_Ignore)
  ForEach Timer()   
    With Timer()
      If TimerID = \TimerID                   
        If StartTime <> #PB_Ignore
          \StartTime = StartTime
        EndIf 
        \TimeToCheck = Time
        If TimerIncludeDebug
          Debug "Timer Update ID "+ TimerID +" OK"
        EndIf
      EndIf                     
    EndWith 
  Next 
EndProcedure

Procedure CONV_TIME_TO_(time.i,Einheit.i = #TIMER_SEC) 
  Select Einheit   
    Case #TIMER_SEC
      ProcedureReturn Int(time/1000) % 60     
    Case #TIMER_MIN
      ProcedureReturn Int(time/60000) % 60     
    Case #TIMER_HOURS
      ProcedureReturn Int(time/3600000) % 24     
    Case #TIMER_DAY 
  EndSelect
  
EndProcedure

Procedure GET_TIMER_TIME_PAST(TimerID)
  Protected TimeNow.i = ElapsedMilliseconds() 
  
  ForEach Timer()   
    With Timer()
      If TimerID = \TimerID                               
        If TimerIncludeDebug
          Debug "Timer PAST "+TimerID+" OK"
        EndIf
        ProcedureReturn (TimeNow - \StartTime)       
      EndIf                     
    EndWith 
  Next
  
EndProcedure

Procedure GET_TIMER_TIME(TimerID.i)
  Protected TimeNow.i = ElapsedMilliseconds() 
  
  ForEach Timer()   
    With Timer()
      If TimerID = \TimerID                               
        If TimerIncludeDebug
          Debug "Timer Time "+TimerID+" OK"
        EndIf
        ProcedureReturn \TimeToCheck - (TimeNow - \StartTime)
      EndIf                     
    EndWith 
  Next 
EndProcedure


Procedure ADD_TIMER(StartTime.i,TimeToCheck.i,TimerID.i = #PB_Any)
  AddElement(Timer())
  
  
  If TimerID = #PB_Any
    TimerID = @Timer()
  EndIf
  
  With Timer()   
    \StartTime.i    = StartTime.i
    \TimeToCheck.i  = TimeToCheck.i
    \TimerID.i      = TimerID.i
  EndWith     
  If TimerIncludeDebug
    Debug "Timer ADD "+TimerID+" OK"
  EndIf
  
  ProcedureReturn TimerID
  
EndProcedure

Procedure DELETE_TIMER(TimerID.i)
  
  ForEach Timer()   
    With Timer()     
      If \TimerID = TimerID   
        DeleteElement(Timer())
        If TimerIncludeDebug
          Debug "Timer DELETE "+TimerID+" OK"
        EndIf
        ProcedureReturn #True         
      EndIf               
    EndWith   
  Next
  ProcedureReturn #False
  
EndProcedure

Procedure TIMER_EXIST(TimerID.i)
  
  ForEach Timer()   
    With Timer()     
      If \TimerID = TimerID       
        If TimerIncludeDebug
          Debug "Timer EXIST "+TimerID+" OK"
        EndIf
        ProcedureReturn #True
      EndIf               
    EndWith   
  Next
  
  ProcedureReturn #False   
EndProcedure



Procedure CHECK_TIMER(TimerID.i)   
  Protected TimeNow.i = ElapsedMilliseconds()
  
  ForEach Timer()   
    With Timer()
      \Time = \TimeToCheck - (TimeNow - \StartTime)
      
      If \TimerID = TimerID
        If TimeNow - \StartTime >= \TimeToCheck.i
          If TimerIncludeDebug
            Debug "Timer CHECK "+TimerID+" OK"
          EndIf
          ProcedureReturn #True
        EndIf
      EndIf
      
    EndWith
  Next
  
  ProcedureReturn #False
EndProcedure
;-Example
CompilerIf #PB_Compiler_IsMainFile
  #Timer2_SystemWait = 1
  
  Debug "--AddTimer"
  ADD_TIMER(ElapsedMilliseconds(),1000,#Timer2_SystemWait) 
  Debug "--Delay 100"
  Delay(100)
  Debug "--DebugTimer"
  DEBUG_TIMER()
  Debug "--Delay 100"
  Delay(100)
  Debug "--Check_Timer"
  Debug CHECK_TIMER(#Timer2_SystemWait)
  Debug "--Get_Timer_Time_Past"
  Debug GET_TIMER_TIME_PAST(#Timer2_SystemWait)
  Debug "--Delay 900"
  Delay(900)
  Debug "--Check_Timer"
  Debug CHECK_TIMER(#Timer2_SystemWait)
  Debug "--Get_Timer_Time_Past"
  Debug GET_TIMER_TIME_PAST(#Timer2_SystemWait)
  ;//so hatte ich es eingesetzt.
  Debug "-- Test"
  Debug LSet("",GET_TIMER_TIME_PAST(#Timer2_SystemWait)/100,".")  + CONV_TIME_TO_(GET_TIMER_TIME(#Timer2_SystemWait))
  
  
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
