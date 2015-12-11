;    Description: Handle 64 Bit unix timestamp with Windows API
;         Author: es_91
;           Date: 13-12-2014
;     PB-Version: 5.40
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28592
;-----------------------------------------------------------------------------
CompilerIf #PB_Compiler_OS<>#PB_OS_Windows
  CompilerError "Windows Only!"
CompilerEndIf
; DateAndTimeA - erweiterte Datumsfunktionalität   - WIN only
; http://www.purebasic.fr/german/viewtopic.php?f=8&t=28592
; es_91   12.12.2014 / Updated: 2014-12-13

; **************************************************
; **               DateAndTimeA.pbi               **
; **                                              **
; **        (c) Enrico 'es_91' Seidel, 2014       **
; **                                              **
; **       Note: Make sure to keep XP-style       **
; **   enabled to support full DateGadget range!  **
; **                                              **
; **************************************************

Structure DATEA_RANGE
  Minimum. q
  Maximum. q
EndStructure

Structure DATEANDTIMEA_KNOWNDATES
  Value. q
  SystemTime. SYSTEMTIME
EndStructure

Structure DATEANDTIMEA_FOUNDTOKENS
  Index. l
  Text$
EndStructure

Enumeration
  #DateA_Year
  #DateA_Month
  #DateA_Week
  #DateA_Day
  #DateA_Hour
  #DateA_Minute
  #DateA_Second
  #DateA_DayOfWeek
EndEnumeration

Enumeration 1
  #DateA_Minimum
  #DateA_Maximum
EndEnumeration

#DateA_ErroneousDate = -9223372036854775808

#DATEANDTIMEA_BoolParseDateYearInterpretation = #True ; Set this value to #False to disable the two-number year interpretation in ParseDateA ()
#DATEANDTIMEA_MinimumDate = -11644473600
#DATEANDTIMEA_MaximumDate = 253402300799
#DATEANDTIMEA_ParseDateInterpretationRangeMaximum = 2147483647
#DATEANDTIMEA_StringLeapYear$ = "0001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010000000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000000010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100000001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001"

#GDTR_MIN = 1
#GDTR_MAX = 2

Macro SystemUnixDateA ()
  Date ()
EndMacro

Macro YearA (DateA)
  DATEANDTIMEA_AccessDate (DateA, #DateA_Year)
EndMacro


Procedure. q DATEANDTIMEA_NarrowDateToDateGadgetRange (Date. q)
  
  If Date < #DATEANDTIMEA_MinimumDate
    ProcedureReturn #DATEANDTIMEA_MinimumDate
    
  ElseIf Date > #DATEANDTIMEA_MaximumDate
    ProcedureReturn #DATEANDTIMEA_MaximumDate
    
  EndIf
  
  ProcedureReturn Date
EndProcedure



Procedure. b DATEANDTIMEA_DaysInMonth (Month. b, Year = #Null)
  
  Select Month
    Case 2
      ProcedureReturn 28 + Bool (Mod (Year, 4) = #Null) - Bool (Mod (Year, 100) = #Null) + Bool (Mod (Year, 400) = #Null)
      
    Case 4, 6, 9, 11
      ProcedureReturn 30
      
    Case 1, 3, 5, 7, 8, 10, 12
      ProcedureReturn 31
      
  EndSelect
EndProcedure



Procedure. w DATEANDTIMEA_AccessDate (Date. q, Type. b = -1)
  
  Protected BoolFoundDate. b
  Protected Index. w
  
  Static NewList KnownDates. DATEANDTIMEA_KNOWNDATES ()
  
  If Date = #DateA_ErroneousDate
    ProcedureReturn #Null
  EndIf
  
  Date = DATEANDTIMEA_NarrowDateToDateGadgetRange (Date)
  
  
  If ListIndex (KnownDates ()) > -1
    
    If KnownDates ()\ Value = Date
      BoolFoundDate = #True
    EndIf
    
  EndIf
  
  
  If Not BoolFoundDate
    ForEach KnownDates ()
      
      If KnownDates ()\ Value = Date
        BoolFoundDate = #True
        Break
      EndIf
      
    Next
  EndIf
  
  If Not BoolFoundDate
    
    AddElement (KnownDates ())
    
    KnownDates ()\ Value = Date
    
    KnownDates ()\ SystemTime\ wDay = 1
    KnownDates ()\ SystemTime\ wDayOfWeek = 4
    KnownDates ()\ SystemTime\ wMonth = 1
    KnownDates ()\ SystemTime\ wYear = 1970
    
    Index = KnownDates ()\ SystemTime\ wYear % Len (#DATEANDTIMEA_StringLeapYear$)
    
    If Index = 0
      Index = Len (#DATEANDTIMEA_StringLeapYear$)
    EndIf
    
    If Date > #Null
      
      While Not Date - 60 * 60 * 24 * (365 + Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index, 1))) < #Null
        
        Date = Date - 60 * 60 * 24 * (365 + Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index, 1)))
        
        KnownDates ()\ SystemTime\ wYear = KnownDates ()\ SystemTime\ wYear + 1
        KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek + 1 + Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index, 1))
        
        If KnownDates ()\ SystemTime\ wDayOfWeek > 6
          KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek - 7
        EndIf
        
        Index = Index + 1
        
        If Index > Len (#DATEANDTIMEA_StringLeapYear$)
          Index = 1
        EndIf
      Wend
      
      
      While Not Date - 60 * 60 * 24 < #Null
        
        KnownDates ()\ SystemTime\ wDay = KnownDates ()\ SystemTime\ wDay + 1
        
        If KnownDates ()\ SystemTime\ wDay > DATEANDTIMEA_DaysInMonth (KnownDates ()\ SystemTime\ wMonth, KnownDates ()\ SystemTime\ wYear)
          KnownDates ()\ SystemTime\ wMonth = KnownDates ()\ SystemTime\ wMonth + 1
          KnownDates ()\ SystemTime\ wDay = 1
          
          If KnownDates ()\ SystemTime\ wMonth > 12
            KnownDates ()\ SystemTime\ wMonth = 1
            KnownDates ()\ SystemTime\ wYear = KnownDates ()\ SystemTime\ wYear + 1
          EndIf
          
        EndIf
        
        KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek + 1
        
        If KnownDates ()\ SystemTime\ wDayOfWeek = 7
          KnownDates ()\ SystemTime\ wDayOfWeek = #Null
        EndIf
        
        Date = Date - 60 * 60 * 24
      Wend
      
      KnownDates ()\ SystemTime\ wHour = Int (Date / 60 / 60)
      KnownDates ()\ SystemTime\ wMinute = Int ((Date - KnownDates ()\ SystemTime\ wHour * 60 * 60) / 60)
      KnownDates ()\ SystemTime\ wSecond = Date - KnownDates ()\ SystemTime\ wHour * 60 * 60 - KnownDates ()\ SystemTime\ wMinute * 60
      
    ElseIf Date < #Null
      
      While Not Date + 60 * 60 * 24 * (365 + Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index - 1, 1))) > #Null
        
        Index = Index - 1
        
        Date = Date + 60 * 60 * 24 * (365 + Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index, 1)))
        
        KnownDates ()\ SystemTime\ wYear = KnownDates ()\ SystemTime\ wYear - 1
        KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek - 1 - Val (Mid (#DATEANDTIMEA_StringLeapYear$, Index, 1))
        
        If KnownDates ()\ SystemTime\ wDayOfWeek < #Null
          KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek + 7
        EndIf
        
        If Index = 1
          Index = Len (#DATEANDTIMEA_StringLeapYear$) + 1
        EndIf
      Wend
      
      While Not (Date + 1) > #Null
        
        KnownDates ()\ SystemTime\ wDay = KnownDates ()\ SystemTime\ wDay - 1
        
        If Not KnownDates ()\ SystemTime\ wDay > #Null
          KnownDates ()\ SystemTime\ wMonth = KnownDates ()\ SystemTime\ wMonth - 1
          
          If Not KnownDates ()\ SystemTime\ wMonth > #Null
            KnownDates ()\ SystemTime\ wMonth = 12
            KnownDates ()\ SystemTime\ wYear = KnownDates ()\ SystemTime\ wYear - 1
          EndIf
          
          KnownDates ()\ SystemTime\ wDay = DATEANDTIMEA_DaysInMonth (KnownDates ()\ SystemTime\ wMonth, KnownDates ()\ SystemTime\ wYear)
        EndIf
        
        KnownDates ()\ SystemTime\ wDayOfWeek = KnownDates ()\ SystemTime\ wDayOfWeek - 1
        
        If KnownDates ()\ SystemTime\ wDayOfWeek < #Null
          KnownDates ()\ SystemTime\ wDayOfWeek = 6
        EndIf
        
        Date = Date + 60 * 60 * 24
      Wend
      
      KnownDates ()\ SystemTime\ wHour = Int (Date / 60 / 60)
      KnownDates ()\ SystemTime\ wMinute = Int ((Date - KnownDates ()\ SystemTime\ wHour * 60 * 60) / 60)
      KnownDates ()\ SystemTime\ wSecond = Date - KnownDates ()\ SystemTime\ wHour * 60 * 60 - KnownDates ()\ SystemTime\ wMinute * 60
      
    EndIf
    
  EndIf
  
  
  Select Type
      
    Case #DateA_Day
      ProcedureReturn KnownDates ()\ SystemTime\ wDay
      
    Case #DateA_DayOfWeek
      ProcedureReturn KnownDates ()\ SystemTime\ wDayOfWeek
      
    Case #DateA_Hour
      ProcedureReturn KnownDates ()\ SystemTime\ wHour
      
    Case #DateA_Minute
      ProcedureReturn KnownDates ()\ SystemTime\ wMinute
      
    Case #DateA_Month
      ProcedureReturn KnownDates ()\ SystemTime\ wMonth
      
    Case #DateA_Second
      ProcedureReturn KnownDates ()\ SystemTime\ wSecond
      
    Case #DateA_Year
      ProcedureReturn KnownDates ()\ SystemTime\ wYear
      
  EndSelect
EndProcedure



Procedure. q AddDateA (DateA. q, Type. b, Value. q)
  
  Protected BoolLeapDay. b
  Protected Day. b
  Protected Index. w
  Protected Month. b
  Protected ThisMonth. l
  Protected ThisYear. w
  Protected Year. w
  
  If DateA = #DateA_ErroneousDate
    ProcedureReturn #DateA_ErroneousDate
  EndIf
  
  DateA = DATEANDTIMEA_NarrowDateToDateGadgetRange (DateA)
  
  Select Type
      
    Case #DateA_Day
      DateA = DateA + Value * 24 * 60 * 60
      
    Case #DateA_Hour
      DateA = DateA + Value * 60 * 60
      
    Case #DateA_Minute
      DateA = DateA + Value * 60
      
    Case #DateA_Second
      DateA = DateA + Value
      
    Case #DateA_Week
      DateA = DateA + Value * 7 * 24 * 60 * 60
      
    Case #DateA_Month, #DateA_Year
      Day = DATEANDTIMEA_AccessDate (DateA, #DateA_Day)
      Month = DATEANDTIMEA_AccessDate (DateA, #DateA_Month)
      Year = DATEANDTIMEA_AccessDate (DateA, #DateA_Year)
      
      If Type = #PB_Date_Year
        
        Index = Mod (Year, Len (#DATEANDTIMEA_StringLeapYear$))
        
        If Index = 0
          Index = Len (#DATEANDTIMEA_StringLeapYear$)
        EndIf
        
        If Value > #Null
          
          For ThisYear = Year To Year + Value
            
            If ThisYear = Year
              DateA = DateA + (DATEANDTIMEA_DaysInMonth (Month, ThisYear) - Day) * 24 * 60 * 60
              
              For ThisMonth = Month + 1 To 12
                DateA = DateA + DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) * 24 * 60 * 60
              Next
              
            ElseIf ThisYear = Year + Value
              For ThisMonth = 1 To Month - 1
                DateA = DateA + DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) * 24 * 60 * 60
              Next
              
              BoolLeapDay = Bool (Day = 29 And Month = 2) * (1 - Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null))
              DateA = DateA + (Day - BoolLeapDay) * 24 * 60 * 60
              
            Else
              DateA = DateA + (365 + Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null)) * 24 * 60 * 60
              
            EndIf
          Next
          
        ElseIf Value < #Null
          
          For ThisYear = Year To Year + Value Step -1
            
            If ThisYear = Year
              
              DateA = DateA - Day * 24 * 60 * 60
              
              For ThisMonth = Month - 1 To 1 Step -1
                DateA = DateA - DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) * 24 * 60 * 60
              Next
              
            ElseIf ThisYear = Year + Value
              
              For ThisMonth = 12 To Month + 1 Step -1
                DateA = DateA - DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) * 24 * 60 * 60
              Next
              
              BoolLeapDay = Bool (Day = 29 And Month = 2) * (1 - Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null))
              DateA = DateA - (DATEANDTIMEA_DaysInMonth (Month, ThisYear) - Day + BoolLeapDay) * 24 * 60 * 60
              
            Else
              DateA = DateA - (365 + Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null)) * 24 * 60 * 60
              
            EndIf
          Next
        EndIf
        
      Else
        
        ThisMonth = Month
        ThisYear = Year
        
        If Abs (Value) > 11
          DateA = AddDateA (DateA, #DateA_Year, Int (Value / 12))
          
          ThisMonth = ThisMonth + Int (Value / 12) * 12
          ThisYear = ThisYear + Int (Value / 12)
        EndIf
        
        If Value > #Null
          
          Repeat
            DateA = DateA + DATEANDTIMEA_DaysInMonth (ThisMonth - (ThisYear - Year) * 12, ThisYear) * 24 * 60 * 60
            
            ThisMonth = ThisMonth + 1
            
            If ThisMonth = Month + Value
              Break
            EndIf
            
            If Int ((ThisMonth - 1) / 12) > (ThisYear - Year)
              ThisYear = ThisYear + 1
            EndIf
          ForEver
          
          ThisMonth = ThisMonth - (ThisYear - Year) * 12
          
          If Day > DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear)
            DateA = DateA - (Day - DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear)) * 24 * 60 * 60
          EndIf
          
        ElseIf Value < #Null
          
          Repeat
            If ThisMonth = Month + Value
              Break
            EndIf
            
            ThisMonth = ThisMonth - 1
            
            If Int ((ThisMonth - 12) / 12) < (ThisYear - Year)
              ThisYear = ThisYear - 1
            EndIf
            
            DateA = DateA - DATEANDTIMEA_DaysInMonth (ThisMonth + (Year - ThisYear) * 12, ThisYear) * 24 * 60 * 60
          ForEver
          
          ThisMonth = ThisMonth - (ThisYear - Year) * 12
          
          If Day > DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear)
            DateA = DateA - (Day - DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear)) * 24 * 60 * 60
          EndIf
          
        EndIf
      EndIf
  EndSelect
  
  DateA = DATEANDTIMEA_NarrowDateToDateGadgetRange (DateA)
  
  ProcedureReturn DateA
EndProcedure



Procedure. q DateA (Year. w = #Null, Month. b = #Null, Day. b = #Null, Hour. b = -1, Minute. b = -1, Second. b = -1)
  
  Protected UnixSeconds. q
  Protected ThisYear. w
  Protected ThisMonth. b
  
  If Year = #Null And Month = #Null And Day = #Null And Hour = -1 And Minute = -1 And Second = -1
    
    ProcedureReturn SystemUnixDateA ()
    
  Else
    
    If Not (Year = 1970 And Month = 1 And Day = 1 And Hour = #Null And Minute = #Null And Second = #Null)
      
      If Month > 12 Or Month < 1 Or Day > 31 Or Day < 1 Or Hour > 23 Or Hour < #Null Or Minute > 59 Or Minute < #Null Or Second > 59 Or Second < #Null
        
        ProcedureReturn #DateA_ErroneousDate
        
      EndIf
      
      If Year > 1969
        
        For ThisYear = 1970 To Year
          
          If ThisYear = Year
            
            For ThisMonth = 1 To Month
              
              If ThisMonth = Month
                
                If Day > DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) Or Day < 1
                  
                  ProcedureReturn #DateA_ErroneousDate
                  
                EndIf
                
                UnixSeconds = UnixSeconds + (Day - 1) * 60 * 60 * 24 + Hour * 60 * 60 + Minute * 60 + Second
                
              Else
                
                UnixSeconds = UnixSeconds + 60 * 60 * 24 * DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear)
                
              EndIf
              
            Next
            
          Else
            
            UnixSeconds = UnixSeconds + 60 * 60 * 24 * (365 + Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null))
            
          EndIf
          
        Next
        
      Else
        
        For ThisYear = 1969 To Year Step -1
          
          If ThisYear = Year
            
            For ThisMonth = 12 To Month Step -1
              
              If ThisMonth = Month
                
                If Day > DATEANDTIMEA_DaysInMonth (ThisMonth, ThisYear) Or Day < 1
                  
                  ProcedureReturn #DateA_ErroneousDate
                  
                EndIf
                
                UnixSeconds = UnixSeconds - (DATEANDTIMEA_DaysInMonth (ThisMonth, Year) - Day) * 60 * 60 * 24 - (23 - Hour) * 60 * 60 - (59 - Minute) * 60 - (60 - Second)
                
              Else
                
                UnixSeconds = UnixSeconds - 60 * 60 * 24 * DATEANDTIMEA_DaysInMonth (ThisMonth, Year)
                
              EndIf
              
            Next
            
          Else
            
            UnixSeconds = UnixSeconds - 60 * 60 * 24 * (365 + Bool (Mod (ThisYear, 4) = #Null) - Bool (Mod (ThisYear, 100) = #Null) + Bool (Mod (ThisYear, 400) = #Null))
            
          EndIf
          
        Next
        
      EndIf
      
    EndIf
    
    DATEANDTIMEA_AccessDate (UnixSeconds)
    
    ProcedureReturn UnixSeconds
    
  EndIf
EndProcedure



Procedure. b DayA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Day)
EndProcedure

Procedure. b DayOfWeekA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_DayOfWeek)
EndProcedure



Procedure. w DayOfYearA (DateA. q)
  
  Protected YearDate. q
  
  If DateA = #DateA_ErroneousDate
    ProcedureReturn #Null
  EndIf
  
  DateA = DATEANDTIMEA_NarrowDateToDateGadgetRange (DateA)
  YearDate = DateA (YearA (DateA), 1, 1, #Null, #Null, #Null)
  
  ProcedureReturn (DateA - YearDate) / 24 / 60 / 60 + 1
EndProcedure



Procedure$ FormatDateA (DateA. q, Mask$)
  
  Protected NewList FoundTokens. DATEANDTIMEA_FOUNDTOKENS ()
  
  Protected BoolNeedYear. b
  Protected BoolNeedMonth. b
  Protected BoolNeedDay. b
  Protected BoolNeedHour. b
  Protected BoolNeedMinute. b
  Protected BoolNeedSecond. b
  Protected Day. b
  Protected Day$
  Protected Hour. b
  Protected Hour$
  Protected Index. l
  Protected Minute. b
  Protected Minute$
  Protected Month. b
  Protected Month$
  Protected Second. b
  Protected Second$
  Protected Shift. l
  Protected Year. w
  Protected Year$
  
  For Index = 1 To Len (Mask$) - 2
    
    If LCase (Mid (Mask$, Index, 5)) = "%yyyy"
      AddElement (FoundTokens ())
      FoundTokens ()\ Index = Index
      FoundTokens ()\ Text$ = Mid (Mask$, Index, 5)
      
      Index = Index + 4
      BoolNeedYear = #True
      
    Else
      Select LCase (Mid (Mask$, Index, 3))
          
        Case "%yy", "%mm", "%dd", "%hh", "%ii", "%ss"
          
          AddElement (FoundTokens ())
          FoundTokens ()\ Index = Index
          FoundTokens ()\ Text$ = Mid (Mask$, Index, 3)
          
          Select LCase (Mid (Mask$, Index, 3))
              
            Case "%yy"
              BoolNeedYear = #True
              
            Case "%mm"
              BoolNeedMonth = #True
              
            Case "%dd"
              BoolNeedDay = #True
              
            Case "%hh"
              BoolNeedHour = #True
              
            Case "%ii"
              BoolNeedMinute = #True
              
            Case "%ss"
              BoolNeedSecond = #True
              
          EndSelect
          
          Index = Index + 2
          
      EndSelect
    EndIf
  Next
  
  
  If BoolNeedYear
    Year = DATEANDTIMEA_AccessDate (DateA, #DateA_Year)
  EndIf
  
  If BoolNeedMonth
    Month = DATEANDTIMEA_AccessDate (DateA, #DateA_Month)
  EndIf
  
  If BoolNeedDay
    Day = DATEANDTIMEA_AccessDate (DateA, #DateA_Day)
  EndIf
  
  If BoolNeedHour
    Hour = DATEANDTIMEA_AccessDate (DateA, #DateA_Hour)
  EndIf
  
  If BoolNeedMinute
    Minute = DATEANDTIMEA_AccessDate (DateA, #DateA_Minute)
  EndIf
  
  If BoolNeedSecond
    Second = DATEANDTIMEA_AccessDate (DateA, #DateA_Second)
  EndIf
  
  
  ForEach FoundTokens ()
    
    Select LCase (FoundTokens ()\ Text$)
        
      Case "%yyyy", "%yy"
        Year$ = "0000"
        Year$ = Left (InsertString (Year$, Str (Year), 5 - Len (Str (Year))), 4)
        
        If LCase (FoundTokens ()\ Text$) = "%yyyy"
          Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Year$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        Else
          
          Year$ = Right (Year$, 2)
          Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Year$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        EndIf
        
      Case "%mm"
        Month$ = "00"
        Month$ = Left (InsertString (Month$, Str (Month), 3 - Len (Str (Month))), 2)
        
        Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Month$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        
      Case "%dd"
        Day$ = "00"
        Day$ = Left (InsertString (Day$, Str (Day), 3 - Len (Str (Day))), 2)
        
        Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Day$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        
      Case "%hh"
        Hour$ = "00"
        Hour$ = Left (InsertString (Hour$, Str (Hour), 3 - Len (Str (Hour))), 2)
        
        Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Hour$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        
      Case "%ii"
        Minute$ = "00"
        Minute$ = Left (InsertString (Minute$, Str (Minute), 3 - Len (Str (Minute))), 2)
        
        Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Minute$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        
      Case "%ss"
        Second$ = "00"
        Second$ = Left (InsertString (Second$, Str (Second), 3 - Len (Str (Second))), 2)
        
        Mask$ = ReplaceString (Mask$, FoundTokens ()\ Text$, Second$, #PB_String_NoCase, FoundTokens ()\ Index - Shift, 1)
        
    EndSelect
    
    Shift = Shift + 1
  Next
  
  ProcedureReturn Mask$
EndProcedure



Procedure. q GetDateGadgetRangeA (DateGadget, *GadgetRange. DATEA_RANGE)
  
  Protected Dim SystemTimes. SYSTEMTIME (1)
  Protected DWORD. q
  
  If Not IsGadget (DateGadget)
    ProcedureReturn #False
  Else
    
    If Not GadgetType (DateGadget) = #PB_GadgetType_Date
      ProcedureReturn #False
    EndIf
  EndIf
  
  DWORD = SendMessage_ (GadgetID (DateGadget), #DTM_GETRANGE, #Null, SystemTimes ())
  
  If DWORD & #GDTR_MIN
    *GadgetRange\ Minimum = DateA (SystemTimes (#Null)\ wYear, SystemTimes (#Null)\ wMonth, SystemTimes (#Null)\ wDay, SystemTimes (#Null)\ wHour, SystemTimes (#Null)\ wMinute, SystemTimes (#Null)\ wSecond)
  Else
    *GadgetRange\ Minimum = #DateA_ErroneousDate
  EndIf
  
  If DWORD & #GDTR_MAX
    *GadgetRange\ Maximum = DateA (SystemTimes (1)\ wYear, SystemTimes (1)\ wMonth, SystemTimes (1)\ wDay, SystemTimes (1)\ wHour, SystemTimes (1)\ wMinute, SystemTimes (1)\ wSecond)
  Else
    *GadgetRange\ Maximum = #DateA_ErroneousDate
  EndIf
  
EndProcedure



Procedure. q GetDateGadgetStateA (DateGadget)
  
  Protected SystemTime. SYSTEMTIME
  
  If Not IsGadget (DateGadget)
    ProcedureReturn #False
  Else
    
    If Not GadgetType (DateGadget) = #PB_GadgetType_Date
      ProcedureReturn #False
    EndIf
  EndIf
  
  If SendMessage_ (GadgetID (DateGadget), #DTM_GETSYSTEMTIME, #Null, SystemTime) = #GDT_VALID
    
    If SystemTime\ wYear = 1970 And SystemTime\ wMonth = 1 And SystemTime\ wDay = 1 And SystemTime\ wHour = #Null And SystemTime\ wMinute = #Null And SystemTime\ wSecond = #Null
      ProcedureReturn #Null
    Else
      ProcedureReturn DateA (SystemTime\ wYear, SystemTime\ wMonth, SystemTime\ wDay, SystemTime\ wHour, SystemTime\ wMinute, SystemTime\ wSecond)
    EndIf
  EndIf
  
EndProcedure



Procedure. b HourA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Hour)
EndProcedure

Procedure. b MinuteA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Minute)
EndProcedure

Procedure. b MonthA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Month)
EndProcedure



Procedure. q ParseDateA (Mask$, Date$)
  
  Protected NewList FoundTokens. DATEANDTIMEA_FOUNDTOKENS ()
  Protected BoolYearInterpretation. b
  Protected Date. q
  Protected Day. b
  Protected Hour. b
  Protected Index. l
  Protected Minute. b
  Protected Month. b
  Protected Second. b
  Protected Shift. l
  Protected Year. w
  
  Year = 1970
  Month = 1
  Day = 1
  
  For Index = 1 To Len (Mask$)
    
    If LCase (Mid (Mask$, Index, 5)) = "%yyyy"
      
      AddElement (FoundTokens ())
      FoundTokens ()\ Index = Index
      FoundTokens ()\ Text$ = Mid (Mask$, Index, 5)
      
      Index = Index + 4
      Shift = Shift + 1
      
    Else
      
      Select LCase (Mid (Mask$, Index, 3))
        Case "%yy", "%mm", "%dd", "%hh", "%ii", "%ss"
          
          AddElement (FoundTokens ())
          FoundTokens ()\ Index = Index
          FoundTokens ()\ Text$ = Mid (Mask$, Index, 3)
          
          Index = Index + 2
          Shift = Shift + 1
          
        Default
          If Not Mid (Mask$, Index, 1) = Mid (Date$, Index - Shift, 1)
            ProcedureReturn #DateA_ErroneousDate
          EndIf
      EndSelect
      
    EndIf
  Next
  
  Shift = #Null
  
  
  If Len (Mask$) = Len (Date$) + ListSize (FoundTokens ())
    
    ForEach FoundTokens ()
      
      Select LCase (FoundTokens ()\ Text$)
          
        Case "%yyyy"
          Year = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 4))
          BoolYearInterpretation = #False
          
        Case "%yy"
          If #DATEANDTIMEA_BoolParseDateYearInterpretation
            Year = Val ("20" + Mid (Date$, FoundTokens ()\ Index - Shift, 2))
            BoolYearInterpretation = #True
          EndIf
          
        Case "%mm"
          Month = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 2))
          
        Case "%dd"
          Day = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 2))
          
        Case "%hh"
          Hour = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 2))
          
        Case "%ii"
          Minute = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 2))
          
        Case "%ss"
          Second = Val (Mid (Date$, FoundTokens ()\ Index - Shift, 2))
      EndSelect
      
      Shift = Shift + 1
    Next
    
    Date = DateA (Year, Month, Day, Hour, Minute, Second)
    
    If BoolYearInterpretation And Date > #DATEANDTIMEA_ParseDateInterpretationRangeMaximum
      Date = Date - (365 * 75 + 366 * 25) * 24 * 60 * 60
    EndIf
    
    ProcedureReturn Date
    
  Else
    ProcedureReturn #DateA_ErroneousDate
    
  EndIf
EndProcedure



Procedure. b SecondA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Second)
EndProcedure



Procedure. b SetDateGadgetRangeA (DateGadget, *GadgetRange. DATEA_RANGE)
  
  Protected Dim SystemTimes. SYSTEMTIME (1)
  
  If Not IsGadget (DateGadget)
    ProcedureReturn #False
  Else
    If Not GadgetType (DateGadget) = #PB_GadgetType_Date
      ProcedureReturn #False
    EndIf
  EndIf
  
  If Not *GadgetRange\ Minimum = #DateA_ErroneousDate
    
    SystemTimes (#Null)\ wYear = YearA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wMonth = MonthA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wDay = DayA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wDayOfWeek = DayOfWeekA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wHour = HourA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wMinute = MinuteA (*GadgetRange\ Minimum)
    SystemTimes (#Null)\ wSecond = SecondA (*GadgetRange\ Minimum)
    
  EndIf
  
  If Not *GadgetRange\ Maximum = #DateA_ErroneousDate
    
    SystemTimes (1)\ wYear = YearA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wMonth = MonthA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wDay = DayA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wDayOfWeek = DayOfWeekA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wHour = HourA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wMinute = MinuteA (*GadgetRange\ Maximum)
    SystemTimes (1)\ wSecond = SecondA (*GadgetRange\ Maximum)
    
  EndIf
  
  ProcedureReturn SendMessage_ (GadgetID (DateGadget), #DTM_SETRANGE, #GDTR_MIN * Bool (Not *GadgetRange\ Minimum = #DateA_ErroneousDate) + #GDTR_MAX * Bool (Not *GadgetRange\ Maximum = #DateA_ErroneousDate), SystemTimes ())
EndProcedure



Procedure. b SetDateGadgetStateA (DateGadget, State. q)
  
  Protected SystemTime. SYSTEMTIME
  
  If Not IsGadget (DateGadget)
    ProcedureReturn #False
  Else
    If Not GadgetType (DateGadget) = #PB_GadgetType_Date
      ProcedureReturn #False
    EndIf
  EndIf
  
  State = DATEANDTIMEA_NarrowDateToDateGadgetRange (State)
  
  DATEANDTIMEA_AccessDate (State)
  
  SystemTime\ wDay = DayA (State)
  SystemTime\ wDayOfWeek = DayOfWeekA (State)
  SystemTime\ wHour = HourA (State)
  SystemTime\ wMinute = MinuteA (State)
  SystemTime\ wMonth = MonthA (State)
  SystemTime\ wSecond = SecondA (State)
  SystemTime\ wYear = YearA (State)
  
  If SendMessage_ (GadgetID (DateGadget), #DTM_SETSYSTEMTIME, #GDT_VALID, SystemTime)
    ProcedureReturn #True
    
  EndIf
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Define Button
  Define Date1
  Define Date2
  Define Date3
  Define Text1
  Define Text2
  Define Text3
  Define Window
  
  Define Date2Range. DATEA_RANGE
  Define OldDate1State. q
  Define OldDate2State. q
  Define OldDate3State. q
  Define ThisDate1State. q
  Define ThisDate2State. q
  Define ThisDate3State. q
  
  Macro DateGadget_StartAskingForChange (DateGadget)
    
    CompilerIf Not Defined (ThisState#DateGadget, #PB_Variable) Or Not Defined (OldState#DateGadget, #PB_Variable)
      
      Define ThisState#DateGadget. q
      Define OldState#DateGadget. q
      
    CompilerEndIf
    
    ThisState#DateGadget = GetDateGadgetStateA (DateGadget)
    
    If Not ThisState#DateGadget = OldState#DateGadget
      
    EndMacro
    
    Macro DateGadget_EndAskingForChange (DateGadget)
      
      OldState#DateGadget = ThisState#DateGadget
      
    EndIf
    
  EndMacro
  
  Window = OpenWindow (#PB_Any, 0, 0, 220, 220, "", #PB_Window_SystemMenu| #PB_Window_ScreenCentered| #PB_Window_Invisible)
  
  Text1 = TextGadget (#PB_Any, 20, 20, 180, 20, "Minimum:")
  
  Date1 = DateGadget (#PB_Any, 20, 40, 180, 20)
  
  SetDateGadgetStateA (Date1, DateA (1601, 1, 1, 0, 0, 0))
  
  Text2 = TextGadget (#PB_Any, 20, 70, 180, 20, "Null-point:")
  
  Date2 = DateGadget (#PB_Any, 20, 90, 180, 20)
  
  SetDateGadgetStateA (Date2, #Null)
  
  Date2Range\ Minimum = DateA (1969, 1, 1, #Null, #Null, #Null)
  Date2Range\ Maximum = DateA (1971, 1, 1, #Null, #Null, #Null)
  
  SetDateGadgetRangeA (Date2, Date2Range)
  
  Text3 = TextGadget (#PB_Any, 20, 120, 180, 20, "Maximum:")
  
  Date3 = DateGadget (#PB_Any, 20, 140, 180, 20)
  
  SetDateGadgetStateA (Date3, DateA (9999, 12, 31, 23, 59, 59))
  
  Button = ButtonGadget (#PB_Any, 70, 180, 80, 20, "OK")
  
  Debug "Date-Gadget 1: state #" + Str (GetDateGadgetStateA (Date1))
  Debug "Date-Gadget 2: state #" + Str (GetDateGadgetStateA (Date2))
  Debug "Date-Gadget 3: state #" + Str (GetDateGadgetStateA (Date3))
  
  Debug "----------"
  
  HideWindow (Window, #False)
  
  Repeat
    
    Select WaitWindowEvent ()
        
      Case #PB_Event_CloseWindow
        
        Break
        
      Case #PB_Event_Gadget
        
        Select EventGadget ()
            
          Case Button
            
            Break
            
        EndSelect
        
    EndSelect
    
    DateGadget_StartAskingForChange (Date1)
    
    Debug "Date1: " + Str (ThisStateDate1)
    
    DateGadget_EndAskingForChange (Date1)
    
    DateGadget_StartAskingForChange (Date2)
    
    Debug "Date2: " + Str (ThisStateDate2)
    
    DateGadget_EndAskingForChange (Date2)
    
    DateGadget_StartAskingForChange (Date3)
    
    Debug "Date3: " + Str (ThisStateDate3)
    
    DateGadget_EndAskingForChange (Date3)
    
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP
