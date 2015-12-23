;    Description: Convert HHTPHeader into a Map
;         Author: Bismonte
;           Date:2014-06-09
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28100
; -----------------------------------------------------------------------------

Procedure _GetHTTPHeader(Url.s, Map Header.s())
  
  Protected String.s, i, bString.s
  
  ClearMap(Header())
  
  If InitNetwork()
    
    String = GetHTTPHeader(Url)
    If String <> ""
      For i = 1 To CountString(String, Chr(13) + Chr(10))
        bString = Trim(StringField(String, i, Chr(13) + Chr(10)))
        If bString <> ""
          If Left(LCase(bString), 4) = "http"
            Header("STATUS") = bString
          Else
            Header(UCase(StringField(bString, 1, ":"))) = Trim(StringField(bString, 2, ":"))
          EndIf
        EndIf
      Next i
    EndIf
    
  EndIf
  
  ProcedureReturn MapSize(Header())
  
EndProcedure

;- Example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  NewMap kk.s()
  
  If _GetHTTPHeader("http://purebasic.fr/german/styles/subsilver2/imageset/PureBoardLogo.png", kk())
    If FindMapElement(kk(), "CONTENT-LENGTH")
      Debug LSet(MapKey(kk()), 30, " ") + kk()
    EndIf
    Debug "----"
    ForEach kk()
      Debug MapKey(kk())+" = "+kk()
    Next
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP
