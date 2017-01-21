;    Description: Support for enlarged date range (64 bit unix timestamp)
;         Author: mk-soft (Windows); Sicro (Windows, Linux, Mac; converted to module; and more); ts-soft (fixed structures for Windows, Linux and Mac)
;           Date: 2016-05-27
;     PB-Version: 5.42
;             OS: Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=335727#p335727
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows And #PB_Compiler_OS <> #PB_OS_Linux
  CompilerError "Supported OS are only: Windows, Linux"
CompilerEndIf

DeclareModule Date64
  Declare.i IsLeapYear64(Year.i)
  Declare.i DaysInMonth64(Year.i, Month.i)
  Declare.q Date64(Year.i=-1, Month.i=1, Day.i=1, Hour.i=0, Minute.i=0, Second.i=0)
  Declare.i Year64(Date.q)
  Declare.i Month64(Date.q)
  Declare.i Day64(Date.q)
  Declare.i Hour64(Date.q)
  Declare.i Minute64(Date.q)
  Declare.i Second64(Date.q)
  Declare.i DayOfWeek64(Date.q)
  Declare.i DayOfYear64(Date.q)
  Declare.q AddDate64(Date.q, Type.i, Value.i)
  Declare.s FormatDate64(Mask$, Date.q)
  Declare.q ParseDate64(Mask$, Date$)
EndDeclareModule

Module Date64
  EnableExplicit
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS And #PB_Compiler_Processor = #PB_Processor_x86
    CompilerError "32-Bit not supported on MacOS"
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
    ImportC ""
      gmtime_r_(*timep, *result) As "gmtime_r"
    EndImport
  CompilerEndIf
  
  ; == Windows ==
  ; >> Minimum: 01.01.1601 00:00:00
  ; >> Maximum: 31.12.9999 23:59:59
  
  ; == Linux ==
  ; 32-Bit:
  ; >> Minimum: 01.01.1902 00:00:00
  ; >> Maximum: 18.01.2038 23:59:59
  ; 64-Bit:
  ; >> Minimum: 01.01.0000 00:00:00
  ; >> Maximum: 31.12.9999 23:59:59
  
  ; == MacOS ==
  ; wie bei Linux?
  
  #SecondsInOneHour = 60 * 60
  #SecondsInOneDay  = #SecondsInOneHour * 24
  
  #HundredNanosecondsInOneSecond               = 10000000
  #HundredNanosecondsFrom_1Jan1601_To_1Jan1970 = 116444736000000000
  
  ;{ Struktur-Definition für "tm"
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
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
          CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
            tm_gmtoff.l ; Offset von UTC in Sekunden
            *tm_zone    ; Abkürzungsname der Zeitzone
          CompilerElse
            tm_zone.l   ; Platzhalter
            tm_gmtoff.l ; Offset von UTC in Sekunden
            *tm_zone64  ; Abkürzungsname der Zeitzone
          CompilerEndIf
          
        EndStructure
      EndIf
    CompilerCase #PB_OS_MacOS
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
          tm_zone.l   ; Abkürzungsname der Zeitzone (Auch bei 64bit ein 32bit Wert)
          tm_gmtoff.l ; Offset von UTC in Sekunden
          *tm_zone64  ; Abkürzungsname der Zeitzone
        EndStructure
      EndIf
  CompilerEndSelect
  ;}
  
  Procedure.i IsLeapYear64(Year.i)
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
  
  Procedure.i DaysInMonth64(Year.i, Month.i)
    While Month > 12
      Year  + 1
      Month - 12
    Wend
    While Month < 0
      Year  - 1
      Month + 13
    Wend
    If Month = 0
      Month = 1
    EndIf
    
    Select Month
      Case 1, 3, 5, 7, 8, 10, 12: ProcedureReturn 31
      Case 4, 6, 9, 11:           ProcedureReturn 30
      Case 2:                     ProcedureReturn 28 + IsLeapYear64(Year) ; Februar hat im Schaltjahr ein Tag mehr
    EndSelect
  EndProcedure
  
  Procedure.q Date64(Year.i=-1, Month.i=1, Day.i=1, Hour.i=0, Minute.i=0, Second.i=0)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected.SYSTEMTIME st
      Protected.FILETIME   ft, ft2
      Protected.i          DaysInMonth
      
      If Year > -1 ; Gültiges Datum
        
        ; Angaben evtl. korrigieren
        
        Minute + Second/60
        Second % 60
        If Second < 0
          Minute - 1
          Second + 60
        EndIf
        
        Hour + Minute/60
        Minute % 60
        If Minute < 0
          Hour   - 1
          Minute + 60
        EndIf
        
        Day + Hour/24
        Hour % 24
        If Hour < 0
          Day  - 1
          Hour + 24
        EndIf
        
        While Month > 12
          Year  + 1
          Month - 12
        Wend
        If Month = 0
          Month = 1
        EndIf
        
        DaysInMonth = DaysInMonth(Year, Month)
        While Day > DaysInMonth
          Day - DaysInMonth
          Month + 1
          If Month > 12
            Year  + 1
            Month - 12
          EndIf
          DaysInMonth = DaysInMonth(Year, Month)
        Wend
        
        If Day < 0
          Month - 1
          If Month = 0
            Year  - 1
            Month = 12
          EndIf
          Day + DaysInMonth(Year, Month)
        EndIf
        
        st\wYear   = Year
        st\wMonth  = Month
        st\wDay    = Day
        st\wHour   = Hour
        st\wMinute = Minute
        st\wSecond = Second
        
        ; Konvertiert Systemzeit (UTC) zu Dateizeit (UTC)
        SystemTimeToFileTime_(@st, @ft)
        
        ; UTC-Zeit in Sekunden umrechnen
        ProcedureReturn (PeekQ(@ft) - #HundredNanosecondsFrom_1Jan1601_To_1Jan1970) / #HundredNanosecondsInOneSecond
      Else
        ; Kein gültiges Datum. Lokale Systemzeit wird ermittelt
        GetLocalTime_(@st)
        SystemTimeToFileTime_(@st, @ft) ; "st" wird als UTC gelesen und zu Dateizeit konvertiert
        
        ; UTC-Zeit in Sekunden umrechnen
        ProcedureReturn (PeekQ(@ft) - #HundredNanosecondsFrom_1Jan1601_To_1Jan1970) / #HundredNanosecondsInOneSecond
      EndIf
    CompilerElse ; Linux oder Mac
      Protected.tm tm
      Protected.q time
      
      If Year > -1 ; Gültiges Datum
        tm\tm_year  = Year - 1900 ; Jahre ab 1900
        tm\tm_mon   = Month - 1   ; Monate ab Januar
        tm\tm_mday  = Day
        tm\tm_hour  = Hour
        tm\tm_min   = Minute
        tm\tm_sec   = Second
        
        ; mktime korrigiert die Angaben selber und liefert bereits Sekunden
        time = timegm_(@tm) ; Konvertiert UTC-Zeit zu UTC-Zeit
        
        ProcedureReturn time ; UTC-Zeit in Sekunden
      Else
        ; Kein gültiges Datum. Systemzeit wird ermittelt
        time = time_(0)
        If localtime_r_(@time, @tm) <> 0
          time = timegm_(@tm)
        EndIf
        
        ProcedureReturn time  ; UTC-Zeit in Sekunden
      EndIf
    CompilerEndIf
  EndProcedure
  
  Macro Windows_ReturnDatePart(Type)
    Protected.SYSTEMTIME st
    
    Date = Date * #HundredNanosecondsInOneSecond + #HundredNanosecondsFrom_1Jan1601_To_1Jan1970
    FileTimeToSystemTime_(@Date, @st)
    
    ProcedureReturn st\Type
  EndMacro
  
  Macro LinuxMac_ReturnDatePart(Type, ReturnCode)
    Protected.tm tm
    Protected.i  Value
    
    If gmtime_r_(@Date, @tm) <> 0 ; Per Memory ist es thread-sicher
      Value = tm\Type
      ProcedureReturn ReturnCode
    EndIf
  EndMacro
  
  Procedure.i Year64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wYear)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_year, Value + 1900)
    CompilerEndIf
  EndProcedure
  
  Procedure.i Month64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wMonth)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_mon, Value + 1)
    CompilerEndIf
  EndProcedure
  
  Procedure.i Day64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wDay)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_mday, Value)
    CompilerEndIf
  EndProcedure
  
  Procedure.i Hour64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wHour)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_hour, Value)
    CompilerEndIf
  EndProcedure
  
  Procedure.i Minute64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wMinute)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_min, Value)
    CompilerEndIf
  EndProcedure
  
  Procedure.i Second64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wSecond)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_sec, Value)
    CompilerEndIf
  EndProcedure
  
  Procedure.i DayOfWeek64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Windows_ReturnDatePart(wDayOfWeek)
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_wday, Value)
    CompilerEndIf
  EndProcedure
  
  Procedure.i DayOfYear64(Date.q)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected.q TempDate
      
      TempDate = Date64(Year64(Date))
      ProcedureReturn (Date - TempDate) / #SecondsInOneDay + 1
    CompilerElse ; Linux oder Mac
      LinuxMac_ReturnDatePart(tm_yday, Value + 1)
    CompilerEndIf
  EndProcedure
  
  Procedure.q AddDate64(Date.q, Type.i, Value.i)
    Protected.i Day, Month, Year
    
    Select Type
      Case #PB_Date_Year:   ProcedureReturn Date64(Year64(Date) + Value, Month64(Date), Day64(Date), Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Month
        Day   = Day64(Date)
        Month = Month64(Date) + Value
        Year  = Year64(Date)
        
        If Day > DaysInMonth64(Year, Month)
          ; mktime korrigiert das zwar auch, wendet dabei aber eine andere Methode als PB-AddDate an:
          ; >> mktime:     31.03.2004 => 1 Monat später => 01.05.2004
          ; >> PB-AddDate: 31.03.2004 => 1 Monat später => 30.04.2004
          
          ; Setzte Tag auf das Maximum des neuen Monats
          Day = DaysInMonth64(Year, Month)
        EndIf
        
        ProcedureReturn Date64(Year64(Date), Month, Day, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Week:   ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date) + Value * 7, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Day:    ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date) + Value, Hour64(Date), Minute64(Date), Second64(Date))
      Case #PB_Date_Hour:   ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date) + Value, Minute64(Date), Second64(Date))
      Case #PB_Date_Minute: ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date), Minute64(Date) + Value, Second64(Date))
      Case #PB_Date_Second: ProcedureReturn Date64(Year64(Date), Month64(Date), Day64(Date), Hour64(Date), Minute64(Date), Second64(Date) + Value)
    EndSelect
  EndProcedure
  
  Procedure.s FormatDate64(Mask$, Date.q)
    Protected Result$
    
    Result$ = ReplaceString(Mask$,   "%yyyy", RSet(Str(Year64(Date)),           4, "0"))
    Result$ = ReplaceString(Result$, "%yy",   RSet(Right(Str(Year64(Date)), 2), 2, "0"))
    Result$ = ReplaceString(Result$, "%mm",   RSet(Str(Month64(Date)),          2, "0"))
    Result$ = ReplaceString(Result$, "%dd",   RSet(Str(Day64(Date)),            2, "0"))
    Result$ = ReplaceString(Result$, "%hh",   RSet(Str(Hour64(Date)),           2, "0"))
    Result$ = ReplaceString(Result$, "%ii",   RSet(Str(Minute64(Date)),         2, "0"))
    Result$ = ReplaceString(Result$, "%ss",   RSet(Str(Second64(Date)),         2, "0"))
    
    ProcedureReturn Result$
  EndProcedure
  
  Macro ReadMaskVariable(MaskVariable, ReturnVariable)
    If Mid(Mask$, i, 3) = MaskVariable
      IsVariableFound = #True
      ReturnVariable = Val(Mid(Date$, DatePos, 2))
      DatePos + 2 ; Die 2 Nummern der Zahl überspringen
      i + 2       ; Die 3 Zeichen der Variable überspringen
      Continue
    EndIf
  EndMacro
  
  Procedure.q ParseDate64(Mask$, Date$)
    Protected.i i, DatePos = 1, IsVariableFound, Year, Month = 1, Day = 1, Hour, Minute, Second
    Protected MaskChar$, DateChar$
    
    For i = 1 To Len(Mask$)
      MaskChar$ = Mid(Mask$, i, 1)
      DateChar$ = Mid(Date$, DatePos, 1)
      
      If MaskChar$ <> DateChar$
        If MaskChar$ = "%" ; Vielleicht eine Variable?
          If Mid(Mask$, i, 5) = "%yyyy"
            IsVariableFound = #True
            Year = Val(Mid(Date$, DatePos, 4))
            DatePos + 4 ; Die 4 Nummern der Jahreszahl überspringen
            i + 4       ; Die 5 Zeichen der Variable "%yyyy" überspringen
            Continue
          ElseIf Mid(Mask$, i, 3) = "%yy"
            IsVariableFound = #True
            Year = Val(Mid(Date$, DatePos, 2))
            DatePos + 2 ; Die 2 Nummern der Jahreszahl überspringen
            i + 2       ; Die 3 Zeichen der Variable "%yy" überspringen
            Continue
          EndIf
          
          ReadMaskVariable("%mm", Month)
          ReadMaskVariable("%dd", Day)
          ReadMaskVariable("%hh", Hour)
          ReadMaskVariable("%ii", Minute)
          ReadMaskVariable("%ss", Second)
          
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

;-Example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;-Test
  
  UseModule Date64
  
  Define.i Year, Month, Day, Hour, Minute, Second, Result, Result64
  Define.q Date, Date64
  Define   Date$, Date64$, Result64$
  
  Debug "Kleiner Kompatibilitäts-Test - Fehler:"
  For Year = 1970 To 2037
    For Month = 1 To 12
      For Day = 1 To 28
        For Hour = 0 To 23
          ;For Minute = 0 To 59
          ;For Second = 0 To 59
          Date = Date(Year, Month, Day, Hour, Minute, Second)
          Date64 = Date64(Year, Month, Day, Hour, Minute, Second)
          
          If Date <> Date64
            Debug "Date() <> Date64()"
            Debug Date
            Debug Date64
            Debug ""
          EndIf
          
          Date$ = FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date)
          Date64$ = FormatDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64)
          If Date$ <> Date64$
            Debug "FormatDate() <> FormatDate64()"
            Debug Date$
            Debug Date64$
            Debug ""
          EndIf
          
          Result = ParseDate("%yyyy.%mm.%dd %hh:%ii:%ss", Date$)
          Result64 = ParseDate64("%yyyy.%mm.%dd %hh:%ii:%ss", Date64$)
          If Result <> Result64
            Debug "ParseDate() <> ParseDate64()"
            Debug Result
            Debug Result64
            Debug ""
          EndIf
          
          Result = DayOfWeek(Date)
          Result64 = DayOfWeek64(Date64)
          If Result <> Result64
            Debug "DayOfWeek() <> DayOfWeek64()"
            Debug Result
            Debug Result64
            Debug ""
          EndIf
          
          Result = DayOfYear(Date)
          Result64 = DayOfYear64(Date64)
          If Result <> Result64
            Debug "DayOfYear() <> DayOfYear64()"
            Debug Result
            Debug Result64
            Debug ""
          EndIf
          
          ;Next Second
          ;Next Minute
        Next Hour
      Next Day
    Next Month
  Next Year
  
  If Date() <> Date64()
    Debug "Date() <> Date64()"
  EndIf
  
  Macro AddDateTest(Type, TypeS)
    If AddDate(Date(), #PB_Date_#Type, 1) <> AddDate64(Date64(), #PB_Date_#Type, 1)
      Debug "AddDate(Date(), #PB_Date_" + TypeS + ", 1) <> AddDate64(Date64(), #PB_Date_" + TypeS + ", 1)"
    EndIf
    If AddDate(Date(), #PB_Date_#Type, -1) <> AddDate64(Date64(), #PB_Date_#Type, -1)
      Debug "AddDate(Date(), #PB_Date_" + TypeS + ", -1) <> AddDate64(Date64(), #PB_Date_" + TypeS + ", -1)"
    EndIf
  EndMacro
  
  AddDateTest(Year,   "Year")
  AddDateTest(Month,  "Month")
  AddDateTest(Day,    "Day")
  AddDateTest(Hour,   "Hour")
  AddDateTest(Minute, "Minute")
  AddDateTest(Second, "Second")
  AddDateTest(Week,   "Week")
  
  Macro TestDateLimits(Minimum, Maximum)
    Date64$ = Minimum
    Date64 = ParseDate64("%dd.%mm.%yyyy %hh:%ii:%ss", Date64$)
    Result64$ = FormatDate64("%dd.%mm.%yyyy %hh:%ii:%ss", Date64)
    If Date64$ <> Result64$
      Debug "Minimum stimmt nicht:"
      Debug "> Erwartet wurde: " + Date64$
      Debug "> Zurückgegeben wurde: " + Result64$
    EndIf
    
    Date64$ = Maximum
    Date64 = ParseDate64("%dd.%mm.%yyyy %hh:%ii:%ss", Date64$)
    Result64$ = FormatDate64("%dd.%mm.%yyyy %hh:%ii:%ss", Date64)
    If Date64$ <> Result64$
      Debug "Maximum stimmt nicht:"
      Debug "> Erwartet wurde: " + Date64$
      Debug "> Zurückgegeben wurde: " + Result64$
    EndIf
  EndMacro
  
  Debug "---------------------"
  Debug "Test der Datum-Grenzen - Fehler:"
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    TestDateLimits("01.01.1601 00:00:00", "31.12.9999 23:59:59")
  CompilerElse ; Linux oder Mac
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      TestDateLimits("01.01.1902 00:00:00", "18.01.2038 23:59:59")
    CompilerElse
      TestDateLimits("01.01.0000 00:00:00", "31.12.9999 23:59:59")
    CompilerEndIf
  CompilerEndIf
  
  Debug "---------------------"
  Debug "Test wurde durchgeführt"
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 3 (Linux - x64)
; EnableXP
; EnablePurifier
; EnableUnicode
