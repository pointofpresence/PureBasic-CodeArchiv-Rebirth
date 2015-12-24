;    Description: Timestamp with 64Bit Values
;         Author: Sicro / ts-soft
;           Date: 2014-03-24
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=26001#p321299
; -----------------------------------------------------------------------------

DeclareModule Date64
  Declare.q Date64(Year.i = -1, Month.i = 1, Day.i = 1, Hour.i = 0, Minute.i = 0, Second.i = 0)
  Declare.i Year64(Date.q)
  Declare.i Month64(Date.q)
  Declare.i Day64(Date.q)
  Declare.i Hour64(Date.q)
  Declare.i Minute64(Date.q)
  Declare.i Second64(Date.q)
  Declare.i DayOfWeek64(Date.q)
  Declare.i DayOfYear64(Date.q)
  Declare.q AddDate64(Date.q, Type.i, Value.i)
  Declare.s FormatDate64(Mask.s, Date.q)
  Declare.q ParseDate64(Mask.s, Date.s)
EndDeclareModule

Module Date64
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      CompilerError "32-Bit not supported on MacOS"
    CompilerEndIf
  CompilerEndIf
  
  EnableExplicit
  
  ; == Windows ==
  ; >> Minimum: 01.01. 1601 00:00:00
  ; >> Maximum: 31.12.30827 23:59:59
  
  ; == Linux ==
  ; 32-Bit:
  ; >> Minimum: 01.01.1902 00:00:00
  ; >> Maximum: 18.01.2038 23:59:59
  ; 64-Bit:
  ; >> Minimum: 01.01.     0000 00:00:00
  ; >> Maximum: 31.12.999999999 23:59:59
  
  ; == MacOS ==
  ; wie bei Linux?
  
  #SecondsInOneHour = 60 * 60
  #SecondsInOneDay  = #SecondsInOneHour * 24
  
  #HundredNanosecondsInOneSecond               = 10000000
  #HundredNanosecondsFrom_1Jan1601_To_1Jan1970 = 116444736000000000
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
    CompilerDefault
      If Not Defined(tm, #PB_Structure)
        Structure tm Align #PB_Structure_AlignC
          tm_sec.l    ; 0 bis 59 oder bis 60 bei Schaltsekunde
          tm_min.l    ; 0 bis 59
          tm_hour.l   ; 0 bis 23
          tm_mday.l   ; Tag des Monats: 1 bis 31
          tm_mon.l    ; Monat: 0 bis 11 (Monate seit Januar)
          tm_year.l   ; Anzahl der Jahre seit dem Jahr 1900
          tm_wday.l   ; Wochentag: 0 bis 6, 0 = Sonntag
          tm_yday.l   ; Tage seit Jahresanfang: 0 bis 365 (365 ist also 366, da nach 1. Januar gezählt wird)
          tm_isdst.l  ; Ist Sommerzeit? tm_isdst > 0 = Ja
                      ;                             tm_isdst = 0 = Nein
                      ;                             tm_isdst < 0 = Unbekannt
          *tm_zone    ; Abkürzungsname der Zeitzone
          tm_gmtoff.l ; Offset von UTC in Sekunden
        EndStructure
      EndIf
  CompilerEndSelect
  
  Procedure.i IsLeapYear(Year)
    If Year < 1600
      ; vor dem Jahr 1600 sind alle Jahre Schaltjahre, die durch 4 restlos teilbar sind
      ProcedureReturn Bool(Year % 4 = 0)
    Else
      ; ab dem Jahr 1600 sind alle Jahre Schaltjahre, die folgende Bedingungen erfüllen:
      ; => restlos durch 4 teilbar, jedoch nicht restlos durch 100 teilbar
      ; => restlos durch 400 teilbar
      ProcedureReturn Bool((Year % 4 = 0 And Year % 100 <> 0) Or Year % 400 = 0)
    EndIf
  EndProcedure
  
  Procedure.i DaysInMonth(Year, Month)
    While Month > 12
      Month - 12
    Wend
    
    Select Month
      Case 1, 3, 5, 7, 8, 10, 12: ProcedureReturn 31
      Case 4, 6, 9, 11:           ProcedureReturn 30
      Case 2:                     ProcedureReturn 28 + IsLeapYear(Year) ; Februar hat im Schaltjahr ein Tag mehr
    EndSelect
  EndProcedure
  
  Procedure.q Date64(Year.i = -1, Month.i = 1, Day.i = 1, Hour.i = 0, Minute.i = 0, Second.i = 0)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        Protected.FILETIME   ft
        
        If Year > -1 ; Gültiges Datum
                     ; Angaben evtl. korrigieren
          
          ; >>> Positive Angaben
          
          While Second > 59
            Minute + 1
            Second - 60
          Wend
          
          While Minute > 59
            Hour   + 1
            Minute - 60
          Wend
          
          While Hour > 23
            Day  + 1
            Hour - 24
          Wend
          
          While Day > DaysInMonth(Year, Month)
            Day - DaysInMonth(Year, Month)
            Month + 1
          Wend
          
          While Month > 12
            Year  + 1
            Month - 12
          Wend
          
          ; >>> Negative Angaben
          
          While Second < 0
            Minute - 1
            Second + 59
          Wend
          
          While Minute < 0
            Hour   - 1
            Minute + 59
          Wend
          
          While Hour < 0
            Day  - 1
            Hour + 23
          Wend
          
          While Day < 0
            Day + DaysInMonth(Year, Month)
            Month - 1
          Wend
          
          While Month < 0
            Year  - 1
            Month + 12
          Wend
          
          st\wYear   = Year
          st\wMonth  = Month
          st\wDay    = Day
          st\wHour   = Hour
          st\wMinute = Minute
          st\wSecond = Second
          
          SystemTimeToFileTime_(@st, @ft)
          
          ; Zeit in Sekunden umrechnen
          ProcedureReturn (PeekQ(@ft) - #HundredNanosecondsFrom_1Jan1601_To_1Jan1970) / #HundredNanosecondsInOneSecond
        Else ; Kein gültiges Datum. Systemzeit wird ermittelt
          GetLocalTime_(@st)
          SystemTimeToFileTime_(@st, @ft)
          
          ; Zeit in Sekunden umrechnen
          ProcedureReturn (PeekQ(@ft) - #HundredNanosecondsFrom_1Jan1601_To_1Jan1970) / #HundredNanosecondsInOneSecond
        EndIf
      CompilerCase #PB_OS_Linux
        Protected.tm tm
        Protected.q time
        Protected *Memory_localtime
        
        If Year > -1 ; Gültiges Datum
          tm\tm_year  = Year - 1900 ; Jahre ab 1900
          tm\tm_mon   = Month - 1   ; Monate ab Januar
          tm\tm_mday  = Day
          tm\tm_hour  = Hour
          tm\tm_min   = Minute
          tm\tm_sec   = Second
          
          ; mktime korrigiert die Angaben selber und liefert bereits Sekunden
          ProcedureReturn mktime_(@tm) + #SecondsInOneHour ; Rückgabewert von mktime ist eine Stunde zu wenig
        Else                                               ; Kein gültiges Datum. Systemzeit wird ermittelt
          time = time_(0)
          If time > -1
            *Memory_localtime = AllocateMemory(SizeOf(tm))
            
            If *Memory_localtime
              localtime_r_(@time, *Memory_localtime) ; Per Memory ist es thread-sicher
              time = mktime_(*Memory_localtime)
              FreeMemory(*Memory_localtime)
              If time > -1
                ProcedureReturn time
              EndIf
            EndIf
          EndIf
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm tm
        Protected.q time
        Protected *Memory_localtime
        
        If Year > -1 ; Gültiges Datum
          tm\tm_year  = Year - 1900 ; Jahre ab 1900
          tm\tm_mon   = Month - 1   ; Monate ab Januar
          tm\tm_mday  = Day
          tm\tm_hour  = Hour
          tm\tm_min   = Minute
          tm\tm_sec   = Second
          
          ; mktime korrigiert die Angaben selber und liefert bereits Sekunden
          ProcedureReturn mktime_(@tm) + #SecondsInOneHour ; Rückgabewert von mktime ist eine Stunde zu wenig
        Else                                               ; Kein gültiges Datum. Systemzeit wird ermittelt
          time = time_(0)
          If time > -1
            *Memory_localtime = AllocateMemory(SizeOf(tm))
            If *Memory_localtime
              localtime_r_(@time, *Memory_localtime) ; Per Memory ist es thread-sicher
              time = mktime_(*Memory_localtime)
              FreeMemory(*Memory_localtime)
              If time > -1
                ProcedureReturn time
              EndIf
            EndIf
          EndIf
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Year64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wYear
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Year
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Year = *Memory_localtime\tm_year + 1900
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Year
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Year
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Year = *Memory_localtime\tm_year + 1900
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Year
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Month64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wMonth
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Month
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Month = *Memory_localtime\tm_mon + 1
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Month
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Month
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Month = *Memory_localtime\tm_mon + 1
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Month
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Day64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wDay
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Day
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Day = *Memory_localtime\tm_mday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Day
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Day
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Day = *Memory_localtime\tm_mday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Day
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Hour64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wHour
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Hour
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Hour = *Memory_localtime\tm_hour
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Hour
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Hour
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Hour = *Memory_localtime\tm_hour
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Hour
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Minute64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wMinute
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Minute
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Minute = *Memory_localtime\tm_min
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Minute
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Minute
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Minute = *Memory_localtime\tm_min
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Minute
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i Second64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wSecond
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  Second
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Second = *Memory_localtime\tm_sec
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Second
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  Second
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          Second = *Memory_localtime\tm_sec
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn Second
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i DayOfWeek64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.SYSTEMTIME st
        
        Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
        FileTimeToSystemTime_(@Date, @st)
        
        ProcedureReturn st\wDayOfWeek
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  DayOfWeek
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          DayOfWeek = *Memory_localtime\tm_wday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn DayOfWeek
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  DayOfWeek
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          DayOfWeek = *Memory_localtime\tm_wday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn DayOfWeek
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i DayOfYear64(Date.q)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected.q TempDate
        
        TempDate = Date64(Year64(Date))
        
        ProcedureReturn (Date - TempDate) / #SecondsInOneDay + 1
      CompilerCase #PB_OS_Linux
        Protected.tm *Memory_localtime
        Protected.i  DayOfYear
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          DayOfYear = *Memory_localtime\tm_yday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn DayOfYear + 1
        Else
          ProcedureReturn -1
        EndIf
      CompilerCase #PB_OS_MacOS
        Protected.tm *Memory_localtime
        Protected.i  DayOfYear
        
        Date - #SecondsInOneHour ; Hinzugerechnete Stunde wieder abziehen
        
        *Memory_localtime = AllocateMemory(SizeOf(tm))
        If *Memory_localtime
          localtime_r_(@Date, *Memory_localtime)
          DayOfYear = *Memory_localtime\tm_yday
          FreeMemory(*Memory_localtime)
          
          ProcedureReturn DayOfYear + 1
        Else
          ProcedureReturn -1
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.q AddDate64(Date.q, Type.i, Value.i)
    Protected.i Day, Month, Year
    
    Select Type
      Case #PB_Date_Year:   ProcedureReturn Date64(Year64(Date) + Value, Month64(Date), Day64(Date), Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Month
        Day   = Day64(Date)
        Month = Month64(Date) + Value
        Year  = Year64(Date)
        
        If Day > DaysInMonth(Year, Month)
          ; mktime_() korrigiert das zwar auch, wendet dabei aber eine andere Methode als PB-AddDate() an:
          ; >> mktime_():    31.03.2004 => 1 Monat später => 01.05.2004
          ; >> PB-AddDate(): 31.03.2004 => 1 Monat später => 30.04.2004
          
          ; setzte Tag auf das Maximum des neuen Monats
          Day = DaysInMonth(Year, Month)
        EndIf
        
        ProcedureReturn Date64(Year64(Date), Month, Day, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Week:   ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date) + Value * 7, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Day:    ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date) + Value, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Hour:   ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date) + Value, Minute64(Date), Second64(Date))
      Case #PB_Date_Minute: ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date), Minute64(Date) + Value, Second64(Date))
      Case #PB_Date_Second: ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date), Minute64(Date), Second64(Date) + Value)
    EndSelect
  EndProcedure
  
  Procedure.s FormatDate64(Mask.s, Date.q)
    Protected.s Retval
    
    Retval = ReplaceString(Mask,   "%yyyy", RSet(Str(Year64(Date)),   4, "0"))
    Retval = ReplaceString(Retval, "%yy",   RSet(Right(Str(Year64(Date)), 2), 2, "0"))
    Retval = ReplaceString(Retval, "%mm",   RSet(Str(Month64(Date)),  2, "0"))
    Retval = ReplaceString(Retval, "%dd",   RSet(Str(Day64(Date)),    2, "0"))
    Retval = ReplaceString(Retval, "%hh",   RSet(Str(Hour64(Date)),   2, "0"))
    Retval = ReplaceString(Retval, "%ii",   RSet(Str(Minute64(Date)), 2, "0"))
    Retval = ReplaceString(Retval, "%ss",   RSet(Str(Second64(Date)), 2, "0"))
    
    ProcedureReturn Retval
  EndProcedure
  
  Procedure.q ParseDate64(Mask.s, Date.s)
    Protected.i i, DatePos = 1, IsVariableFound, Year, Month = 1, Day = 1, Hour, Minute, Second
    Protected.s MaskChar, DateChar
    
    For i = 1 To Len(Mask)
      MaskChar = Mid(Mask, i, 1)
      DateChar = Mid(Date, DatePos, 1)
      
      If MaskChar <> DateChar
        If MaskChar = "%" ; Vielleicht eine Variable?
          If Mid(Mask, i, 5) = "%yyyy"
            IsVariableFound = #True
            Year = Val(Mid(Date, DatePos, 4))
            DatePos + 4 ; Die 4 Nummern der Jahreszahl überspringen
            i + 4       ; Die 5 Zeichen der Variable "%yyyy" überspringen
            Debug "Year: " + Str(Year)
            Continue
          ElseIf Mid(Mask, i, 3) = "%yy"
            IsVariableFound = #True
            Year = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Jahreszahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%yy" überspringen
            Debug "Year: " + Str(Year)
            Continue
          EndIf
          
          If Mid(Mask, i, 3) = "%mm"
            IsVariableFound = #True
            Month = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Monatszahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%mm" überspringen
            Debug "Month: " + Str(Month)
            Continue
          EndIf
          
          If Mid(Mask, i, 3) = "%dd"
            IsVariableFound = #True
            Day = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Tageszahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%dd" überspringen
            Debug "Day: " + Str(Day)
            Continue
          EndIf
          
          If Mid(Mask, i, 3) = "%hh"
            IsVariableFound = #True
            Hour = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Stundenzahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%hh" überspringen
            Debug "Hour: " + Str(Hour)
            Continue
          EndIf
          
          If Mid(Mask, i, 3) = "%ii"
            IsVariableFound = #True
            Minute = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Minutenzahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%ii" überspringen
            Debug "Minute: " + Str(Minute)
            Continue
          EndIf
          
          If Mid(Mask, i, 3) = "%ss"
            IsVariableFound = #True
            Second = Val(Mid(Date, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Sekundenzahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%ss" überspringen
            Debug "Second: " + Str(Second)
            Continue
          EndIf
          
          If Not IsVariableFound
            ProcedureReturn 0
          EndIf
        Else
          ProcedureReturn 0
        EndIf
      EndIf
      
      DatePos + 1
    Next
    
    ProcedureReturn Date64(Year, Month, Day, Hour, Minute, Second)
  EndProcedure
EndModule

;- Example
CompilerIf #PB_Compiler_IsMainFile
  
  
  UseModule Date64
  
  For jahr = 1970 To 2038 Step 1
    d1.s = FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date(jahr,3,1,0,0,0))
    d2.s = FormatDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64(jahr,3,1,0,0,0))
    If d1 <> d2
      Debug "32:"+d1
      Debug "64:"+d2
      Debug "--"
    EndIf
  Next
  
  Debug DayOfWeek(Date())
  Debug DayOfWeek64(Date64())
  Debug ""
  Debug FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date(1600,1,1,0,0,0))
  Debug FormatDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64(2300,1,1,0,0,0))
  Debug FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date(1971,8,20,0,0,0))
  Debug FormatDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64(1971,8,20))
  Debug FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date())
  Debug FormatDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64())
CompilerEndIf 
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
