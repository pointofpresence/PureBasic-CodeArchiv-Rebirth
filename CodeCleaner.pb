;    Description: Removes Options of the pb and pbi source
;         Author: GPI
;           Date: 05-12-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------
EnableExplicit

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
KillMask("CONSTANT")

Global NewMap NeedMask()
NeedMask("ENABLEUNICODE")
NeedMask("ENABLEXP")

OpenConsole("CodeCleaner")

Procedure CheckFile(file.s)
  Protected in
  Protected check.s
  Protected do
  Protected out
  Protected Format
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
    Wend
    
    ForEach NeedMask()
      If NeedMask()=0
        PrintN("Missing "+MapKey(NeedMask())+" "+file)
      EndIf
    Next
    
  EndIf
  
  If do
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
  
EndProcedure

Procedure dir(Start.s=".\")
  Protected dir
  Protected name.s,ext.s
  Protected placeholder.s
  dir=ExamineDirectory(#PB_Any,Start,"*.*")
  If dir
    While NextDirectoryEntry(dir)
      name.s=DirectoryEntryName(dir)
      If DirectoryEntryType(dir)=#PB_DirectoryEntry_Directory
        If Left(name,1)<>"."
          dir(start+name+"\")
        EndIf
      Else
        If UCase(name)="PLACEHOLDER.TXT"
          placeholder=name
        Else
          If placeholder
            DeleteFile(start+name)
            PrintN( "delete "+start+name)
            placeholder=""
          EndIf
          
          ext=UCase(GetExtensionPart(name))
          If (ext="PB" Or ext="PBI") And name<>"CodeCleaner.pb"
            CheckFile(start+name)
            
          EndIf          
          
        EndIf   
        
      EndIf
    Wend
    FinishDirectory(dir)
  EndIf
EndProcedure


dir()

PrintN("")
PrintN("Press return")
Input()
CloseConsole()
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 18
; Folding = -
; EnableUnicode
; EnableXP
; Executable = CodeCleaner.exe
; EnableCompileCount = 6
; EnableBuildCount = 1
; EnableExeConstant
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20
; Constant = Test=20