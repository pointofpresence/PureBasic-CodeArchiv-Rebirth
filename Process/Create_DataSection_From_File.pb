;    Description: Create an DataSection.pbi from a binary file. Multi file select supported
;         Author: GPI
;           Date: 2015-12-19
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29361
; -----------------------------------------------------------------------------

EnableExplicit

Procedure.s Simple_Name(a$)
  Protected i
  Protected b$="Data_"
  Protected char
  
  For i=1 To Len(a$)
    char=Asc(Mid(a$,i,1))
    Select char
      Case 'a' To 'z','A' To 'Z', '0' To '9'
        b$+Chr(char)
      Default 
        b$+"_"
    EndSelect
    
    
  Next
  ProcedureReturn b$
EndProcedure
Procedure WriteMem(out,file.s,*mem,len)
  Protected a$,b$
  Protected i
  Protected limit=80
  file=simple_name(GetFilePart(file))
  
  WriteStringN(out,file+"_len:")
  WriteStringN(out,"data.i "+Str(len))
  WriteString(out,file+":")
  For i=0 To len-1 Step 8
    If limit>=80
      WriteStringN(out,"")
      WriteString(out, "Data.q ")
      limit=7
    Else
      WriteString(out,",")
      limit+1
    EndIf
    a$="$"+Hex(PeekQ(*mem+i)) 
    b$=Str(PeekQ(*mem+i))
    If Len(a$)<Len(b$)
      WriteString(out,a$)
      limit+Len(a$)
    Else
      WriteString(out,b$)
      limit+Len(b$)
    EndIf    
  Next
  WriteStringN(out,"")
EndProcedure

Define a$
Define file$
Define len
Define *mem
Define in
Define out

file$=GetCurrentDirectory()
Repeat
  file$=OpenFileRequester("Create Data pbi",file$,"*.*|*.*",1,#PB_Requester_MultiSelection)
  If file$="" 
    Break
  EndIf
  
  out=CreateFile(#PB_Any,file$+".pbi")      
  If out
    WriteStringN(out,"DataSection")
    Repeat
      len=FileSize(file$)
      If len>0
        *mem=AllocateMemory(len+8)
        If *mem
          in=ReadFile(#PB_Any,file$)
          If in
            ReadData(in,*mem,len)
            CloseFile(in)
          Else
            Debug "Error Read in"
          EndIf
          writemem(out,file$,*mem,len)
          WriteStringN(out,"")
          
          FreeMemory(*mem)
          *mem=0
        EndIf
      EndIf
      a$=NextSelectedFileName()
      If a$=""
        Break
      EndIf
      file$=a$
    ForEver
    
    WriteStringN(out,"EndDataSection")
    CloseFile(out)
  EndIf
  
  
ForEver
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
