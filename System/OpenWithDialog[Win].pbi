;    Description: Open a File with the "Open With" Dialog
;         Author: Marty2PB
;           Date: 30-05-2015
;     PB-Version: 5.40
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28919#p330197
;-----------------------------------------------------------------------------
EnableExplicit

#OAIF_ALLOW_REGISTRATION = $00000001 ; Enable the "always use this program" checkbox. If Not passed, it will be disabled.
#OAIF_REGISTER_EXT       = $00000002 ; Do the registration after the user hits the OK button.
#OAIF_EXEC               = $00000004 ; Execute file after registering.
#OAIF_FORCE_REGISTRATION = $00000008 ; Force the Always use this program checkbox To be checked. Typically, you won't use the OAIF_ALLOW_REGISTRATION flag when you pass this value.
#OAIF_HIDE_REGISTRATION  = $00000020 ; Introduced IN Windows Vista. Hide the Always use this program checkbox. If this flag is specified, the OAIF_ALLOW_REGISTRATION And OAIF_FORCE_REGISTRATION flags will be ignored.
#OAIF_URL_PROTOCOL       = $00000040 ; Introduced IN Windows Vista. The value For the extension that is passed is actually a protocol, so the Open With dialog box should show applications that are registered As capable of handling that protocol.
#OAIF_FILE_IS_URI        = $00000080 ; Introduced IN Windows 8. The location pointed To by the pcszFile parameter is given As a URI.

Structure OPENASINFO
  pcszFile.i
  pcszClass.i
  oaifInFlags.l
EndStructure

Prototype pSH_OpenWithDialog(HWND, *poainfo)

Procedure.l OpenWithDialog(File$, OPEN_AS_INFO_FLAGS.l = 0, hwnd.i = 0)
  Static hShell32 = #False
  Protected OWD.OPENASINFO, SH_OpenWithDialog_.pSH_OpenWithDialog, Result = #False
  
  If (Not hShell32)
    hShell32 = OpenLibrary(#PB_Any, "SHELL32")
  EndIf
  
  If hShell32
    SH_OpenWithDialog_ = GetFunction(hShell32, "SHOpenWithDialog")
    If SH_OpenWithDialog_
      OWD\pcszFile = @File$
      OWD\pcszClass = #Null
      OWD\oaifInFlags = OPEN_AS_INFO_FLAGS
      Result = SH_OpenWithDialog_(hwnd, @OWD.OPENASINFO)
    Else
      Result = OpenAs_RunDLL_(hwnd, 0, File$, 0)
    EndIf
  EndIf   
  
  ProcedureReturn Result
EndProcedure   

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Define File$ = #PB_Compiler_Home + "SDK\VisualC\Readme.txt"
  Debug OpenWithDialog(File$,#OAIF_ALLOW_REGISTRATION|#OAIF_EXEC) 
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 4
; Folding = -
; EnableUnicode
; EnableXP
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant