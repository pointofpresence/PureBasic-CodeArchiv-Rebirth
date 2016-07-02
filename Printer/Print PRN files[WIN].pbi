;    Description: Adds support for printing PRN files
;         Author: shadow (Sicro: updated for PB5.50 beta 1)
;           Date: 2016-07-02
;     PB-Version: 5.50 beta 1
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=12905
; -----------------------------------------------------------------------------

;TODO: Prüfen, ob Code auch mit 64-Bit-OS funktioniert

;TODO: Prüfen, ob Code auch mit Unicode funktioniert

;TODO: Neuer Code im Forum posten

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

; Sending data directly to a printer (printing raw data).
; This code is a port of the following MSDN sample:
; http://msdn2.microsoft.com/en-us/library/ms535786(d=printer).aspx
;
; Author:    A.R.
; Compiler: PureBasic 4.02

EnableExplicit

; PrinterName$      Name of the registered printer.
; DocName$          This name will be used for printer job description.
; *rawdata          Pointer to a memory block containing the data to send.
; size.l            The size of the memory block. Perhaps could be replaced by MemorySize(...).
; *written          Amount of bytes written to the printer. Check this to see if all data was sent.
Procedure RawDataToPrinter(PrinterName$, DocName$, *rawdata, size, *written)
  Protected hPrinter, DocInfo.DOC_INFO_1, Job
  Protected DataType$ = "RAW"
  
  ; Need a handle to the printer.
  If Not OpenPrinter_(PrinterName$, @hPrinter, #Null)
    ProcedureReturn GetLastError_()
  EndIf
  
  ; Fill in the structure with info about this "document".
  DocInfo\pDocName = @DocName$
  DocInfo\pOutputFile = #Null
  DocInfo\pDataType = @DataType$
  ; Inform the spooler the document is beginning.
  Job = StartDocPrinter_(hPrinter, 1, @DocInfo)
  If Not Job
    ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  ; Start a page.
  If Not StartPagePrinter_(hPrinter)
    EndDocPrinter_(hPrinter)
    ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  ; Send the data to the printer.
  If Not WritePrinter_(hPrinter, *rawdata, size, *written)
    EndPagePrinter_(hPrinter)
    EndDocPrinter_(hPrinter)
    ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  ; End the page.
  If Not EndPagePrinter_(hPrinter)
    EndDocPrinter_(hPrinter)
    ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  ; Inform the spooler that the document is ending.
  If Not EndDocPrinter_(hPrinter)
    ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  ; Tidy up the printer handle.
  If Not ClosePrinter_(hPrinter)
    ProcedureReturn GetLastError_()
  EndIf
  
  ProcedureReturn #ERROR_SUCCESS
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ;- for testing purpose
  Define *rawdata, size, written, file$
  
  file$ = OpenFileRequester("Open PRN file", "", "*.prn", 1)
  If ReadFile(0, file$)
    size = Lof(0)
    *rawdata = AllocateMemory(size)
    ReadData(0, *rawdata, size)
    CloseFile(0)
    
    If RawDataToPrinter("Brother HL-1030 series", "myDocument", *rawdata, size, @written) <> #ERROR_SUCCESS
      MessageRequester("", "Error!", #MB_OK | #MB_ICONSTOP)
    Else
      MessageRequester("", "OK!", #MB_OK | #MB_ICONINFORMATION)
    EndIf
    
    FreeMemory(*rawdata)
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
