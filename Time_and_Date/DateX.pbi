;    Description: DateX Time Stamp
;         Author: es_91
;           Date: 2014-02-21
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27760&sid=8e1fe21b5d0d81ef74199fbc5a9f0814
; -----------------------------------------------------------------------------


; Supported dates: 01.01.1900 0:00:00 to 31.01.2699 23:59:59

Enumeration
  #DateX_Year
  #DateX_Month
  #DateX_Day
  #DateX_DayOfWeek
  #DateX_DayOfYear
  #DateX_Hour
  #DateX_Minute
  #DateX_Second
EndEnumeration

Procedure.q DateX(Year = #PB_Any, Month = #PB_Any, Day = #PB_Any, Hour = #PB_Any, Minute = #PB_Any, Second = #PB_Any)
  
  Define DateX, ThisYear, DaysTotal, DayOfYear
  
  If Year = #PB_Any
    ProcedureReturn DateX(1970, 1, 1, 0, 0, 0) + Date()
  Else
    For ThisYear = 1900 To Year
      DayOfYear = 0
      If ThisYear = 1900 Or ThisYear = 2100 Or ThisYear = 2200 Or ThisYear = 2300 Or ThisYear = 2500 Or ThisYear = 2600 Or Not Int(ThisYear/4)*4 = ThisYear
        If ThisYear = Year
          If Month > 1
            DayOfYear + 31
          EndIf
          If Month > 2
            DayOfYear + 28
          EndIf
          If Month > 3
            DayOfYear + 31
          EndIf
          If Month > 4
            DayOfYear + 30
          EndIf
          If Month > 5
            DayOfYear + 31
          EndIf
          If Month > 6
            DayOfYear + 30
          EndIf
          If Month > 7
            DayOfYear + 31
          EndIf
          If Month > 8
            DayOfYear + 31
          EndIf
          If Month > 9
            DayOfYear + 30
          EndIf
          If Month > 10
            DayOfYear + 31
          EndIf
          If Month > 11
            DayOfYear + 30
          EndIf
          If Not ThisYear = Year
            DayOfYear + 31
          Else
            DayOfYear + Day
          EndIf
          DaysTotal + DayOfYear
        Else
          DaysTotal + 365
        EndIf
      Else
        If ThisYear = Year
          If Month > 1
            DayOfYear + 31
          EndIf
          If Month > 2
            DayOfYear + 29
          EndIf
          If Month > 3
            DayOfYear + 31
          EndIf
          If Month > 4
            DayOfYear + 30
          EndIf
          If Month > 5
            DayOfYear + 31
          EndIf
          If Month > 6
            DayOfYear + 30
          EndIf
          If Month > 7
            DayOfYear + 31
          EndIf
          If Month > 8
            DayOfYear + 31
          EndIf
          If Month > 9
            DayOfYear + 30
          EndIf
          If Month > 10
            DayOfYear + 31
          EndIf
          If Month > 11
            DayOfYear + 30
          EndIf
          If Not ThisYear = Year
            DayOfYear + 31
          Else
            DayOfYear + Day
          EndIf
          DaysTotal + DayOfYear
        Else
          DaysTotal + 366
        EndIf
      EndIf
    Next
    
    ProcedureReturn (DaysTotal - 1) * 24 * 60 * 60 + Hour * 60 * 60 + Minute * 60 + Second
    
  EndIf
  
EndProcedure

Procedure GetDateXAttribute(DateX.q, Attribute)
  
  Define Year, Month, Day, DayOfYear, Hour, Minute, Second, Seconds.q
  
  For Year = 1900 To 2699
    
    Month = 0
    
    If Year = 1900 Or Year = 2100 Or Year = 2200 Or Year = 2300 Or Year = 2500 Or Year = 2600 Or Not Int(Year / 4) * 4 = Year
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 28 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 28 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
    Else
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 29 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 29 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
      If Seconds + 30 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 30 * 24 * 60 * 60
      Month + 1
      If Seconds + 31 * 24 * 60 * 60 > DateX
        Break
      EndIf
      Seconds + 31 * 24 * 60 * 60
      Month + 1
    EndIf
  Next
  
  Seconds = DateX - Seconds
  Month + 1
  
  Day = Seconds / (60 * 60 * 24) + 1
  Hour = (Seconds - (Day - 1) * 60 * 60 * 24) / (60 * 60)
  Minute = (Seconds - (Day - 1) * 60 * 60 * 24 - Hour * 60 * 60) / 60
  Second = (Seconds - (Day - 1) * 60 * 60 * 24 - Hour * 60 * 60 - Minute * 60)
  
  Select Attribute
    Case #DateX_Second
      ProcedureReturn Second
    Case #DateX_Minute
      ProcedureReturn Minute
    Case #DateX_Hour
      ProcedureReturn Hour
    Case #DateX_Day
      ProcedureReturn Day
    Case #DateX_DayOfWeek
      ProcedureReturn (DateX / (24 * 60 * 60) - Int((DateX / (24 * 60 * 60)) / 7) * 7 + 1) - Int((DateX / (24 * 60 * 60) - Int((DateX / (24 * 60 * 60)) / 7) * 7 + 1) / 7) * 7
    Case #DateX_DayOfYear
      If Year = 1900 Or Year = 2100 Or Year = 2200 Or Year = 2300 Or Year = 2500 Or Year = 2600 Or Not Int(Year/4)*4 = Year
        If Month > 1
          DayOfYear + 31
        EndIf
        If Month > 2
          DayOfYear + 28
        EndIf
        If Month > 3
          DayOfYear + 31
        EndIf
        If Month > 4
          DayOfYear + 30
        EndIf
        If Month > 5
          DayOfYear + 31
        EndIf
        If Month > 6
          DayOfYear + 30
        EndIf
        If Month > 7
          DayOfYear + 31
        EndIf
        If Month > 8
          DayOfYear + 31
        EndIf
        If Month > 9
          DayOfYear + 30
        EndIf
        If Month > 10
          DayOfYear + 31
        EndIf
        If Month > 11
          DayOfYear + 30
        EndIf
      Else
        If Month > 1
          DayOfYear + 31
        EndIf
        If Month > 2
          DayOfYear + 29
        EndIf
        If Month > 3
          DayOfYear + 31
        EndIf
        If Month > 4
          DayOfYear + 30
        EndIf
        If Month > 5
          DayOfYear + 31
        EndIf
        If Month > 6
          DayOfYear + 30
        EndIf
        If Month > 7
          DayOfYear + 31
        EndIf
        If Month > 8
          DayOfYear + 31
        EndIf
        If Month > 9
          DayOfYear + 30
        EndIf
        If Month > 10
          DayOfYear + 31
        EndIf
        If Month > 11
          DayOfYear + 30
        EndIf
      EndIf
      DayOfYear + Day
      ProcedureReturn DayOfYear
    Case #DateX_Month
      ProcedureReturn Month
    Case #DateX_Year
      ProcedureReturn Year
  EndSelect
EndProcedure

Procedure YearX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Year)
EndProcedure

Procedure MonthX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Month)
EndProcedure

Procedure DayX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Day)
EndProcedure

Procedure DayOfWeekX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_DayOfWeek)
EndProcedure

Procedure DayOfYearX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_DayOfYear)
EndProcedure

Procedure HourX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Hour)
EndProcedure

Procedure MinuteX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Minute)
EndProcedure

Procedure SecondX(DateX.q)
  ProcedureReturn GetDateXAttribute(DateX, #DateX_Second)
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  
  Debug YearX(DateX())
  Debug MonthX(DateX())
  Debug DayX(DateX())
  Debug HourX(DateX())
  Debug MinuteX(DateX())
  Debug SecondX(DateX())
  Debug DayOfWeekX(DateX())
  Debug DayOfYearX(DateX())
  
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; EnableUnicode
; EnableXP
; CompileSourceDirectory
