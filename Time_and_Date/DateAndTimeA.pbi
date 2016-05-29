;    Description: Alternative date functions with extended date range
;         Author: es_91 (Added support for Linux and Mac by Sicro)
;           Date: 2016-04-24
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=336378#p336378
; -----------------------------------------------------------------------------

; DateAndTimeA - erweiterte Datumsfunktionalität
; http://www.purebasic.fr/german/viewtopic.php?f=8&t=28592
; es_91   12.12.2014 / Updated: 2014-12-13
; Sicro   Updated: 24.04.2016

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

; https://msdn.microsoft.com/de-de/library/windows/desktop/ms724950%28v=vs.85%29.aspx
; typedef struct _SYSTEMTIME {
;   WORD wYear;
;   WORD wMonth;
;   WORD wDayOfWeek;
;   WORD wDay;
;   WORD wHour;
;   WORD wMinute;
;   WORD wSecond;
;   WORD wMilliseconds;
; } SYSTEMTIME, *PSYSTEMTIME;
CompilerIf Not Defined(SYSTEMTIME, #PB_Structure)
  Structure SYSTEMTIME
    wYear.w
    wMonth.w
    wDayOfWeek.w
    wDay.w
    wHour.w
    wMinute.w
    wSecond.w
    wMilliseconds.w
  EndStructure
CompilerEndIf

Structure DATEANDTIMEA_KNOWNDATES
  Value. q
  SystemTime. SYSTEMTIME
EndStructure

Structure DATEANDTIMEA_FOUNDTOKENS
  Index. i
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
#DATEANDTIMEA_StringLeapYear$ = "000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000000010001000" +
                                "100010001000100010001000100010001000100010001000100010001000100010001000100010001000100000001000100010001000100" +
                                "010001000100010001000100010001000100010001000100010001000100010001000100010000000100010001000100010001000100010" +
                                "0010001000100010001000100010001000100010001000100010001000100010001"

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

Procedure DATEANDTIMEA_DaysInMonth (Month, Year = #Null)

  Select Month
    Case 2
      ProcedureReturn 28 + Bool (Mod (Year, 4) = #Null) - Bool (Mod (Year, 100) = #Null) + Bool (Mod (Year, 400) = #Null)

    Case 4, 6, 9, 11
      ProcedureReturn 30

    Case 1, 3, 5, 7, 8, 10, 12
      ProcedureReturn 31

  EndSelect
EndProcedure

Procedure DATEANDTIMEA_AccessDate (Date. q, Type = -1)

  Protected BoolFoundDate
  Protected Index

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

Procedure. q AddDateA (DateA. q, Type, Value. q)

  Protected BoolLeapDay
  Protected Day
  Protected Index
  Protected Month
  Protected ThisMonth
  Protected ThisYear
  Protected Year

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

Procedure. q DateA (Year = #Null, Month = #Null, Day = #Null, Hour = -1, Minute = -1, Second = -1)

  Protected UnixSeconds. q
  Protected ThisYear
  Protected ThisMonth

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

Procedure DayA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Day)
EndProcedure

Procedure DayOfWeekA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_DayOfWeek)
EndProcedure

Procedure DayOfYearA (DateA. q)

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

  Protected BoolNeedYear
  Protected BoolNeedMonth
  Protected BoolNeedDay
  Protected BoolNeedHour
  Protected BoolNeedMinute
  Protected BoolNeedSecond
  Protected Day
  Protected Day$
  Protected Hour
  Protected Hour$
  Protected Index
  Protected Minute
  Protected Minute$
  Protected Month
  Protected Month$
  Protected Second
  Protected Second$
  Protected Shift
  Protected Year
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

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
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
      *GadgetRange\ Minimum = DateA (SystemTimes (#Null)\ wYear, SystemTimes (#Null)\ wMonth, SystemTimes (#Null)\ wDay, SystemTimes (#Null)\ wHour,
                                     SystemTimes (#Null)\ wMinute, SystemTimes (#Null)\ wSecond)
    Else
      *GadgetRange\ Minimum = #DateA_ErroneousDate
    EndIf

    If DWORD & #GDTR_MAX
      *GadgetRange\ Maximum = DateA (SystemTimes (1)\ wYear, SystemTimes (1)\ wMonth, SystemTimes (1)\ wDay, SystemTimes (1)\ wHour,
                                     SystemTimes (1)\ wMinute, SystemTimes (1)\ wSecond)
    Else
      *GadgetRange\ Maximum = #DateA_ErroneousDate
    EndIf

  EndProcedure
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
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
CompilerEndIf

Procedure HourA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Hour)
EndProcedure

Procedure MinuteA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Minute)
EndProcedure

Procedure MonthA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Month)
EndProcedure

Procedure ParseDateA (Mask$, Date$)

  Protected NewList FoundTokens. DATEANDTIMEA_FOUNDTOKENS ()
  Protected BoolYearInterpretation
  Protected Date. q
  Protected Day
  Protected Hour
  Protected Index
  Protected Minute
  Protected Month
  Protected Second
  Protected Shift
  Protected Year

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

Procedure SecondA (DateA. q)
  ProcedureReturn DATEANDTIMEA_AccessDate (DateA, #DateA_Second)
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure SetDateGadgetRangeA (DateGadget, *GadgetRange. DATEA_RANGE)

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
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure SetDateGadgetStateA (DateGadget, State. q)

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
CompilerEndIf

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define.q Date = DateA()
  
    Debug FormatDateA(Date, "%dd.%mm.%yyyy")
  
    Date = AddDateA(Date, #PB_Date_Day, 1)
    Debug FormatDateA(Date, "%dd.%mm.%yyyy")
  
    Date = AddDateA(Date, #PB_Date_Day, -1)
    Debug FormatDateA(Date, "%dd.%mm.%yyyy")
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
