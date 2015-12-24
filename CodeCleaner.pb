;    Description: Removes Options of the pb and pbi source and create the content.html
;         Author: GPI
;           Date: 24-12-2015
;     PB-Version: 5.40
;             OS: Windows, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29323
; -----------------------------------------------------------------------------

EnableExplicit

Structure codes
  file.s
  ForMac.i
  ForWindows.i
  ForLinux.i
  Description.s
  GermanURL.s
  FrenchURL.s
  EnglishURL.s
  PBVer.s
  Author.s
  Date.s
  
  fLen.i
  fDate.i
  fNoError.i
EndStructure

Global NewList codes.codes()
Global NewMap cache.codes()
#cacheid=$cacec0de

CompilerIf  #PB_Compiler_OS=#PB_OS_MacOS
  SetCurrentDirectory(#PB_Compiler_FilePath)
CompilerEndIf

CompilerIf #PB_Compiler_OS=#PB_OS_Windows
  #slash="\"
CompilerElse
  #slash="/"
CompilerEndIf

Global CacheFile.s=".dat"+#slash+"CodeCleaner_"+Hex(#PB_Compiler_OS)+".temp.dat"
Global SettingFile.s=".dat"+#slash+"CodeCleaner_"+Hex(#PB_Compiler_OS)+".temp.ini"

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

CompilerIf #PB_Compiler_OS=#PB_OS_Windows
  Global Compiler1.s="C:\Program Files\PureBasic\Compilers\pbcompiler.exe"
  Global Compiler2.s="C:\Program Files (x86)\PureBasic\Compilers\pbcompiler.exe"
  Global Compiler1Pro.s="x64"
  Global Compiler2Pro.s="x32"
CompilerElse
  Global Compiler1.s=#PB_Compiler_Home+#slash+"Compilers\pbcompiler"
  Global Compiler2.s=""
  Global Compiler1Pro.s="x"  
  Global Compiler2Pro.s=""
CompilerEndIf

Procedure.s inString(in)
  Protected l=ReadUnicodeCharacter(in)
  Protected ret.s=ReadString(in,#PB_UTF8,l)
  ProcedureReturn ret
EndProcedure
Procedure.s outString(out,str.s)
  WriteUnicodeCharacter(out,Len(str))
  WriteString(out,str,#PB_UTF8)
EndProcedure
  

Procedure LoadCache()
  Protected in
  Protected str.s
  OpenPreferences(settingFile)
  Compiler1=ReadPreferenceString("Path1",Compiler1)
  Compiler1Pro=ReadPreferenceString("Processor1",Compiler1Pro)
  Compiler2=ReadPreferenceString("Path2",Compiler2)
  Compiler2Pro=ReadPreferenceString("Processor2",Compiler2Pro)
  ClosePreferences()
  
  in=ReadFile(#PB_Any,CacheFile)
  If in And ReadLong(in)=#cacheid
    While Not Eof(in)
      str.s=inString(in)
      If str="":Break:EndIf
      cache(str)
      cache()\ForMac     =ReadWord(in)
      cache()\ForWindows =ReadWord(in)
      cache()\ForLinux   =ReadWord(in)
      cache()\Description=inString(in)
      cache()\GermanURL  =inString(in)
      cache()\FrenchURL  =inString(in)
      cache()\EnglishURL =inString(in)
      cache()\PBVer      =inString(in)
      cache()\Author     =inString(in)
      cache()\Date       =inString(in)
  
      cache()\fLen       =ReadLong(in)
      cache()\fDate      =ReadLong(in)
    Wend
    
    CloseFile(in)
  EndIf
  PrintN("Load Cache: "+MapSize(cache())+" Entries")
  
EndProcedure
Procedure SaveCache()
  Protected out
  CreatePreferences(SettingFile)
  WritePreferenceString("Path1",Compiler1)
  WritePreferenceString("Processor1",Compiler1Pro)
  WritePreferenceString("Path2",Compiler2)
  WritePreferenceString("Processor2",Compiler2Pro)
  ClosePreferences()
  
  out=CreateFile(#PB_Any,CacheFile)
  If out
    WriteLong(out,#cacheid)
    ForEach codes()
      If codes()\fNoError
        outString(out,codes()\file)
        
        WriteWord(out,codes()\ForMac     )
        WriteWord(out,codes()\ForWindows )
        WriteWord(out,codes()\ForLinux   )
        outString(out,codes()\Description)
        outString(out,codes()\GermanURL  )
        outString(out,codes()\FrenchURL  )
        outString(out,codes()\EnglishURL )
        outString(out,codes()\PBVer      )
        outString(out,codes()\Author     )
        outString(out,codes()\Date       )
        
        WriteLong(out,codes()\fLen       )
        WriteLong(out,codes()\fDate      )
      EndIf
    Next
    CloseFile(out)
  EndIf
EndProcedure

Procedure IsNumeric(a$)
  Protected a,i,ret=#True
  For i=1 To Len(a$)
    a= Asc(Mid(a$,i,1))
    ret & Bool(a>='0' And a<='9')
  Next
  ProcedureReturn ret
EndProcedure   

Procedure.s CheckSyntax(file.s,EnableThread)
  Protected compiler
  Protected Output$
  Protected do
  Protected ret.s
  Protected a$
  Protected sfile.s=file
  Protected ext.s=UCase(GetExtensionPart(file))
  Protected exe.s
  Protected pro.s
  Protected i
  Protected thread.s
  
  If ext<>"PB" And ext<>"PBI"
    ProcedureReturn ""
  EndIf
  
  If Left(file,2)="."+#slash
    file=GetCurrentDirectory()+Mid(file,3)
  EndIf  
  If EnableThread
    thread="--thread "
  Else
    thread=""
  EndIf
  
  For i=0 To 1
    If i=0  
      exe=Compiler1
      pro=Compiler1Pro
    Else
      exe=Compiler2
      pro=Compiler2Pro
    EndIf
    
    If exe<>"" And FileSize(exe)>0
      ConsoleTitle(pro+" "+file)
      
      Compiler = RunProgram(exe, thread+"--check "+Chr(34)+file+Chr(34), GetPathPart(exe), #PB_Program_Open | #PB_Program_Read)
      ;Debug compiler
      
      Output$ = ""
      do=#False
      If Compiler
        While ProgramRunning(Compiler)
          If AvailableProgramOutput(Compiler)
            a$=ReadProgramString(Compiler)
            ;Debug a$
            If a$="Starting syntax check..." Or a$="Starting compilation..."
              do=#True
            ElseIf do And a$<>""         
              Output$ + a$ 
            EndIf
          EndIf
        Wend
        If ProgramExitCode(Compiler)      
          If LCase(Right(output$,6))<>" only!"
            If ret<>"":ret+#LFCR$:EndIf
            ret+"("+pro+")"+output$+ " : "+sfile
          EndIf
        EndIf
        CloseProgram(Compiler) ; Close the connection to the program
      Else
        If ret<>"":ret+#LFCR$:EndIf
        ret+"("+pro+") Compiler error! "+exe
      EndIf
    ElseIf exe<>""
      If ret<>"":ret+#LFCR$:EndIf
      ret+"("+pro+") Compiler not found! "+exe
    EndIf
    
  Next

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
  Protected PosLimit
  Protected ext.s=UCase(GetExtensionPart(file))
  
  If ext="PB" Or ext="PBI"
    sum+1
  EndIf  
  
  ConsoleTitle("Check "+file)
    
  NewList FLine.s()
  
  AddElement(codes())
  codes()\file=file
  codes()\fLen=FileSize(file)
  codes()\fDate=GetFileDate(file,#PB_Date_Modified)
  
  If codes()\fLen=cache(file)\fLen And codes()\fDate=cache()\fDate
    ;Bereits überprüft -> übernehmen
    codes()\ForMac      = cache()\ForMac     
    codes()\ForWindows  = cache()\ForWindows 
    codes()\ForLinux    = cache()\ForLinux   
    codes()\Description = cache()\Description
    codes()\GermanURL   = cache()\GermanURL  
    codes()\FrenchURL   = cache()\FrenchURL  
    codes()\EnglishURL  = cache()\EnglishURL 
    codes()\PBVer       = cache()\PBVer      
    codes()\Author      = cache()\Author     
    codes()\Date        = cache()\Date       
    codes()\fNoError    = #True
    
  Else
    
    
    If ext="PB" Or ext="PBI" Or ext="TXT"    
      codes()\fNoError=#True  ; nur Dateien die man auswertet cachen!
      
      ;{ File einlesen
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
        
      EndIf
      ;}
      
      ;{ Muss als UTF8 neu geschrieben werden!
      If format=#PB_Ascii And (ext="PB" Or ext="PBI")
        PrintN("Convert to UTF8 "+file)
        do=#True
      EndIf  
      ;}
            
      ;{ header überprüfen
      If FirstElement(fline())
        While Left(Fline(),1)=";" And Left(fline(),2)<>";-" And Left(fline(),3)<>"; -"
          posLimit=FindString(fline(),":")
          
          pos=FindString(fline(),"Description",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\Description=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
          pos=FindString(fline(),"Author",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\Author=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
          pos=FindString(fline(),"update",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            PrintN("Wrong Tag Update "+file)
            codes()\fNoError=#False
          EndIf
          
          pos=FindString(fline(),"Date",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\Date=Trim(Mid(fline(),PosLimit+1))
            ;Debug codes()\date
            If Len(codes()\date)=10 And IsNumeric(Right(codes()\date,4)) And IsNumeric(Mid(codes()\Date,4,2)) And IsNumeric(Left(codes()\Date,2)) And Not Val(Mid(codes()\Date,4,2))>12
              codes()\date=Right(codes()\date,4)+"-"+Mid(codes()\date,4,2)+"-"+Left(codes()\date,2)
              fline()=Left(fline(),PosLimit)+codes()\date
              ;Debug fline()
              do=#True            
            EndIf
            
            If Len(codes()\date)<>10 Or Not IsNumeric(Left(codes()\date,4)) Or Not IsNumeric(Mid(codes()\Date,6,2)) Or Not IsNumeric(Right(codes()\Date,2)) Or Val(Mid(codes()\Date,6,2))>12
              PrintN("Wrong Date "+codes()\date+" "+file)
              codes()\fNoError=#False
            EndIf
          EndIf
          
          pos=FindString(fline(),"PB-Version",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\PBVer=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
          pos=FindString(fline(),"OS",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            check=Trim(Mid(fline(),PosLimit+1))
            If FindString(check,"WIN",0,#PB_String_NoCase) : codes()\ForWindows=#True :EndIf
            If FindString(check,"MAC",0,#PB_String_NoCase) : codes()\ForMac=#True :EndIf
            If FindString(check,"LIN",0,#PB_String_NoCase) : codes()\ForLinux=#True :EndIf      
          EndIf
          
          pos=FindString(fline(),"English-Forum",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\EnglishURL=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
          pos=FindString(fline(),"French-Forum",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\FrenchURL=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
          pos=FindString(fline(),"German-Forum",0,#PB_String_NoCase)
          If pos<PosLimit And pos>0
            codes()\GermanURL=Trim(Mid(fline(),PosLimit+1))
          EndIf
          
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
      EndIf 
      ;}
      
      ;{ Compileroption überprfen
      If (ext="PB" Or ext="PBI") And LastElement(FLine())
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
            codes()\fNoError=#False
          EndIf
        Next
        
      EndIf
      ;}
      
      ;{ Datei neu schreiben?      
      If do 
        codes()\fNoError=#False
        If (ext="PB" Or ext="PBI"); And #False ;-------
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
      EndIf
      ;}
      
      ;{ Syntax überprüfen
      If ext="PB" Or ext="PBI"
        Syncheck=CheckSyntax(file,EnableThread)
        If Syncheck
          PrintN(Syncheck)
          codes()\fNoError=#False
        EndIf
      EndIf
      ;}
      
    EndIf
    
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
      If DirectoryEntryType(dir)=#PB_DirectoryEntry_File
        If UCase(name)="PLACEHOLDER.TXT"
          placeholder=name
        Else
          count +1          
          ext=UCase(GetExtensionPart(name))
          If Left(name,1)<>"." And name<>"CodeCleaner.pb" And ext<>"EXE"  And name<>"content.html" And name<>"template.pb"
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
  dir=ExamineDirectory(#PB_Any,Start,"*.*")
  If dir
    While NextDirectoryEntry(dir)
      name.s=DirectoryEntryName(dir)
      If DirectoryEntryType(dir)=#PB_DirectoryEntry_Directory
        If Left(name,1)<>"."
          dir(start+name+#slash)
        EndIf
      EndIf
    Wend
    FinishDirectory(dir)
  EndIf
EndProcedure
Procedure.s SimpleHTML(in.s)
  in=ReplaceString(in,"&","&amp;")
  in=ReplaceString(in,"<","&lt;")
  in=ReplaceString(in,">","&gt;")
  in=ReplaceString(in,"'","&apos;")
  in=ReplaceString(in,Chr(34),"&quot;")
  ProcedureReturn in
EndProcedure

LoadCache()

dir()
PrintN("")
PrintN("Code Count:"+sum)

SaveCache()


Define template.s

template=PeekS(?template,-1,#PB_UTF8)

Define tab.s,oldpath.s
Define p.s
Define counter
tab="":oldpath=""
ForEach codes()
  
  p=ReplaceString(GetPathPart(codes()\file),"\","/")
  If Right(p,1)="/":p=Left(p,Len(p)-1):EndIf
  If Left(p,2)="./":p=Mid(p,3):EndIf
  
  If oldpath<>p
    counter+1
    tab+~"<tr id=\"grey\">"
    If Left(p,2)="z_"
      tab+~"<td><div class=\"hide\">"+RSet(Str(counter),5,"0") +"</div>"+SimpleHTML(Mid(p,3))+"</td>"
    Else
      tab+~"<td><div class=\"hide\">"+RSet(Str(counter),5,"0") +"</div>"+SimpleHTML(p)+"</td>"
    EndIf
    tab+"<td></td>"
    tab+"<td></td>"
    tab+"<td></td>"
    tab+"<td></td>"
    tab+"<td></td>"
    tab+"</tr>"
    
    
    oldpath=p
  EndIf
  
  counter+1
  
  tab+"<tr>"
  tab+"<td><div class="+Chr(34)+"hide"+Chr(34)+">"+RSet(Str(counter),5,"0")+"</div></td>"
  tab+"<td><a href="+Chr(34)+URLEncoder(p+"/"+GetFilePart(codes()\file))+Chr(34)+">"+SimpleHTML(GetFilePart(codes()\file))+"</a></td>"
  
  tab+"<td><div id="+Chr(34)+"block"+Chr(34)+">"
  tab+"<img src="+Chr(34)+".dat/"+StringField("inon.png|iwin.png",codes()\ForWindows+1,"|")+Chr(34)+" alt="+Chr(34)+"winlogo"+Chr(34)+"/>"
  tab+"<img src="+Chr(34)+".dat/"+StringField("inon.png|imac.png",codes()\ForMac+1,"|")+Chr(34)+" alt="+Chr(34)+"maclogo"+Chr(34)+"/>"
  tab+"<img src="+Chr(34)+".dat/"+StringField("inon.png|ilin.png",codes()\ForLinux+1,"|")+Chr(34)+" alt="+Chr(34)+"linlogo"+Chr(34)+"/>"
  tab+"</div></td>"
  
  tab+"<td align="+Chr(34)+"CENTER"+Chr(34)+">"+codes()\PBVer+"</td>"
  
  tab+"<td><div id="+Chr(34)+"block"+Chr(34)+">"
  If codes()\EnglishURL
    tab+"<a href="+Chr(34)+codes()\EnglishURL+Chr(34)+" target="+Chr(34)+"_blank"+Chr(34)+">"
    tab+"<img src="+Chr(34)+".dat/ieng.jpg"+Chr(34)+" alt="+Chr(34)+"eng"+Chr(34)+"/>"
    tab+"</a>"
  Else
    tab+"<img src="+Chr(34)+".dat/iflg.png"+Chr(34)+" alt="+Chr(34)+"none"+Chr(34)+"/>"
  EndIf
  If codes()\FrenchURL
    tab+"<a href="+Chr(34)+codes()\FrenchURL+Chr(34)+" target="+Chr(34)+"_blank"+Chr(34)+">"
    tab+"<img src="+Chr(34)+".dat/ifre.jpg"+Chr(34)+" alt="+Chr(34)+"fre"+Chr(34)+"/>"
    tab+"</a>"
  Else
    tab+"<img src="+Chr(34)+".dat/iflg.png"+Chr(34)+" alt="+Chr(34)+"none"+Chr(34)+"/>"
  EndIf
  If codes()\GermanURL
    tab+"<a href="+Chr(34)+codes()\GermanURL+Chr(34)+" target="+Chr(34)+"_blank"+Chr(34)+">"
    tab+"<img src="+Chr(34)+".dat/iger.jpg"+Chr(34)+" alt="+Chr(34)+"ger"+Chr(34)+"/>"
    tab+"</a>"
  Else
    tab+"<img src="+Chr(34)+".dat/iflg.png"+Chr(34)+" alt="+Chr(34)+"none"+Chr(34)+"/>"
  EndIf
  tab+"</div></td>"
  
  tab+"<td>"+SimpleHTML(codes()\Description)+"</td>"
  
  tab+"</tr>"
Next

template=ReplaceString(template,"$$$TABLE$$$",tab)

tab="<th>Path</th>"
tab+"<th>File</th>"
tab+"<th>OS</th>"
tab+"<th>PB</th>"
tab+"<th>Forum</th>"
tab+"<th>Description</th>"
template=ReplaceString(template,"$$$HEADLINE$$$",tab)

tab=~"<td colspan=\"6\" align=\"right\">"+sum+" codes / "+FormatDate("%dd-%mm-%yyyy",Date())+"</td>"
template=ReplaceString(template,"$$$FEEDER$$$",tab)

Define out
out=CreateFile(#PB_Any,"content.html")
If out
  WriteString(out,template)
  CloseFile(out)
EndIf


PrintN("")
PrintN("Press return")
Input()
CloseConsole()


DataSection
  template:
  IncludeBinary ".dat\CodeCleaner_template.html"
  Data.q 0
EndDataSection


; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 605
; FirstLine = 419
; Folding = -fg-
; EnableUnicode
; EnableXP
; Executable = CodeCleaner.exe
; Compiler = PureBasic 5.41 LTS (Windows - x86)
; DisableCompileCount = 61
; DisableBuildCount = 5
; EnableExeConstant