;    Description: Removes Options of the pb and pbi source
;         Author: GPI
;           Date: 22-12-2015
;     PB-Version: 5.40
;             OS: Windows, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29323
; -----------------------------------------------------------------------------
EnableExplicit

CompilerIf  #PB_Compiler_OS=#PB_OS_MacOS
  SetCurrentDirectory(#PB_Compiler_FilePath)
CompilerEndIf

CompilerIf #PB_Compiler_OS=#PB_OS_Windows
  #slash="\"
CompilerElse
  #slash="/"
CompilerEndIf

Global NewMap KillMask()
KillMask("CURRENTDIRECTORY")=#True
KillMask("CURSORPOSITION")=#True
KillMask("FIRSTLINE")=#True
KillMask("FOLDING")=#True
KillMask("COMPILER")=#True
KillMask("ENABLECOMPILECOUNT")=#True
KillMask("ENABLEBUILDCOUNT")=#True
KillMask("ENABLEEXECONSTANT")=#True
KillMask("EXECUTABLE")=#True
KillMask("CONSTANT")=#True
KillMask("COMPILESOURCEDIRECTORY")=#True

Global NewMap NeedMask()
NeedMask("ENABLEUNICODE")
NeedMask("ENABLEXP")

Global sum

OpenConsole("CodeCleaner")

Procedure.s CheckSyntax(file.s,EnableThread)
  Protected compiler
  Protected Output$
  Protected do
  Protected ret.s
  Protected a$
  Protected sfile.s=file
  If Left(file,2)="."+#slash
    file=GetCurrentDirectory()+Mid(file,3)
  EndIf  
  If EnableThread
    a$="--thread "
  Else
    a$=""
  EndIf
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows 
    Compiler = RunProgram(#PB_Compiler_Home+"Compilers"+#slash+"pbcompiler.exe", a$+"--check "+Chr(34)+file+Chr(34), #PB_Compiler_Home+"Compilers", #PB_Program_Open | #PB_Program_Read)
  CompilerElse
    Compiler = RunProgram(#PB_Compiler_Home+"Compilers"+#slash+"pbcompiler", a$+"--check "+Chr(34)+file+Chr(34), #PB_Compiler_Home+"Compilers", #PB_Program_Open | #PB_Program_Read)
  CompilerEndIf  
  ;Debug compiler
  Output$ = ""
  do=#False
  If Compiler
    While ProgramRunning(Compiler)
      If AvailableProgramOutput(Compiler)
        a$=ReadProgramString(Compiler)
        If a$="Starting syntax check..." Or a$="Starting compilation..."
          do=#True
        ElseIf do And a$<>""         
          Output$ + a$ 
        EndIf
      EndIf
    Wend
    If ProgramExitCode(Compiler)      
      If LCase(Right(output$,6))<>" only!"
        ret=output$+ " : "+sfile
      EndIf
    EndIf
    CloseProgram(Compiler) ; Close the connection to the program
  EndIf
  ProcedureReturn ret
EndProcedure
Procedure CheckFile(file.s)
  Protected in
  Protected check.s
  Protected do
  Protected out
  Protected Format
  Protected Syncheck.s
  Protected EnableThread=#False
  Protected pos
  
  ConsoleTitle("Check "+file)
  sum+1
  
  NewList FLine.s()
  in=ReadFile(#PB_Any,file )
  If in
    Format=ReadStringFormat(in)
    
    While Not Eof(in)
      AddElement(FLine())
      FLine()=ReadString(in,Format)
      If Asc(Left(fline(),1))=65279 ;BOM entfernen!
        fline()=Mid(FLine(),2)
      EndIf
    Wend
    CloseFile(in)
    
    ;ProcedureReturn 0
  EndIf
  
  If format=#PB_Ascii
    PrintN("Convert to UTF8 "+file)
    do=#True
  EndIf
  
  FirstElement(fline())
  While Left(Fline(),1)=";"
    If FindString(fline(),"-Forum") 
      pos=FindString(fline(),"&sid=")
      If pos
        fline()=Left(fline(),pos-1)
        PrintN("Remove SID from URL "+file)
        do=#True
      EndIf
    EndIf
    If NextElement(fline())=#False
      Break
    EndIf    
  Wend
  
  
  If LastElement(FLine())
    While Left(FLine(),1)=";" And Left(FLine(),15)<>"; IDE Options =" And PreviousElement(FLine())
    Wend
    
    ForEach NeedMask()
      NeedMask()=0
    Next
        
    While NextElement(FLine())
      check=UCase(Trim(Mid(StringField(FLine(),1,"="),2)))
      If KillMask(check)
        DeleteElement(fline())
        do=#True
      EndIf
      If FindMapElement(NeedMask(),check)
        NeedMask()=#True
      EndIf
      If check="ENABLETHREAD"
        EnableThread=#True
      EndIf
    Wend
    
    ForEach NeedMask()
      If NeedMask()=0
        PrintN("Missing "+MapKey(NeedMask())+" "+file)
      EndIf
    Next
    
  EndIf
  
  If do; And #False ;-------
    PrintN( "ReCreate "+file)
    out=CreateFile(#PB_Any,file,#PB_UTF8)
    
    If out
      WriteStringFormat(out,#PB_UTF8)
      ForEach FLine()
        WriteStringN(out,FLine(),#PB_UTF8)
      Next
    EndIf
    CloseFile(out)
  EndIf
  
  Syncheck=CheckSyntax(file,EnableThread)
  If Syncheck
    PrintN(Syncheck)
  EndIf
  
  
EndProcedure

Procedure dir(Start.s="."+#slash)
  ;Debug start
  Protected dir
  Protected name.s,ext.s
  Protected placeholder.s
  Protected count
  dir=ExamineDirectory(#PB_Any,Start,"*.*")
  If dir
    While NextDirectoryEntry(dir)
      name.s=DirectoryEntryName(dir)
      If DirectoryEntryType(dir)=#PB_DirectoryEntry_Directory
        If Left(name,1)<>"."
          dir(start+name+#slash)
        EndIf
      Else;If #False ;----
        If UCase(name)="PLACEHOLDER.TXT"
          placeholder=name
        Else
          count +1          
          ext=UCase(GetExtensionPart(name))
          If (ext="PB" Or ext="PBI") And name<>"CodeCleaner.pb"
            CheckFile(start+name)            
          EndIf          
          
        EndIf   
        
      EndIf
    Wend
    
    If count And placeholder<>""
      DeleteFile(start+placeholder)
      PrintN( "delete "+start+placeholder)
    EndIf          
    
    FinishDirectory(dir)
  EndIf
EndProcedure


dir()
PrintN("")
PrintN("Code Count:"+sum)
PrintN("")
PrintN("Press return")
Input()
CloseConsole()
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; ExecutableFormat = Console
; Folding = 8-
; EnableUnicode
; EnableXP
; Executable = CodeCleaner.exe
; DisableCompileCount = 61
; DisableBuildCount = 5
; EnableExeConstant