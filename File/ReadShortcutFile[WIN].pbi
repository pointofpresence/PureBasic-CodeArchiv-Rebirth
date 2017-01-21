;    Description: Adds support for reading the object path of a shortcut file it links to
;         Author: Jilocasin (Axolotl: updated for support windows 10 and unicode)
;           Date: 2016-05-26
;     PB-Version: 5.42
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=335517#p335517
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

Procedure.s ShortcutTarget(ShortcutFile.s)
  Protected Result.s, *buffer

  If Right(LCase(ShortcutFile), 4) <> ".lnk"
    ProcedureReturn ShortcutFile
  EndIf
  CoInitialize_(0)

  Protected ShellLink.IShellLinkW  ;' A..W (unicode!)
  Protected LinkFile.IPersistFile

  If CoCreateInstance_(?CLSID_ShellLink, 0, 1, ?IID_IShellLink, @ShellLink) = #S_OK
    If ShellLink\QueryInterface(?IID_IPersistFile, @LinkFile) = #S_OK
      *buffer = AllocateMemory(1024)
      If *buffer
        If LinkFile\Load(ShortcutFile, 0) = #S_OK
          If ShellLink\Resolve(0, 1) = #S_OK
            ShellLink\GetPath(*buffer, 1024, 0, 0)
            Result = PeekS(*buffer)
          EndIf
        EndIf
        FreeMemory(*buffer)
      EndIf
      LinkFile\Release()
    EndIf
    ShellLink\Release()
  EndIf
  CoUninitialize_()
  ProcedureReturn Result
EndProcedure

DataSection ;{ CLSID_ShellLink, IID_IPersistFile, ...
  CLSID_ShellLink:
  ; 00021401-0000-0000-C000-000000000046
  Data.l $00021401
  Data.w $0000,$0000
  Data.b $C0,$00,$00,$00,$00,$00,$00,$46

  IID_IPersistFile:
  ; 0000010b-0000-0000-C000-000000000046
  Data.l $0000010B
  Data.w $0000,$0000
  Data.b $C0,$00,$00,$00,$00,$00,$00,$46

  CompilerIf #PB_Compiler_Unicode = 0

  IID_IShellLink:
  ; DEFINE_SHLGUID(IID_IShellLinkA, 0x000214EEL, 0, 0);
  ; C000-000000000046
  Data.l $000214EE
  Data.w $0000,$0000
  Data.b $C0,$00,$00,$00,$00,$00,$00,$46

  CompilerElse

  IID_IShellLink: ; {000214F9-0000-0000-C000-000000000046}
  Data.l $000214F9
  Data.w $0000, $0000
  Data.b $C0, $00, $00, $00, $00, $00, $00, $46

  CompilerEndIf
EndDataSection ;}
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
