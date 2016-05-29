;    Description: Adds support for creating shortcut files
;         Author: Danilo (nco2k: added unicode support; ts-soft: updated for PB 4.50 support)
;           Date: 2016-05-26
;     PB-Version: 5.42
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=270648#p270648
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=3078&highlight=
; Author: Danilo
; Date: 09. December 2003
;
; create shell links/shortcuts
; translated from my old example that used CallCOM()
;
; by Danilo, 09.12.2003

; changed for easy use in PB 4.0 >
; by ts-soft

; changed for PB 4.50 and Unicode

EnableExplicit

Macro DEFINE_GUID(Name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8)
  CompilerIf Defined(Name, #PB_Variable)
    If SizeOf(Name) = SizeOf(GUID)
      Name\Data1    = l
      Name\Data2    = w1
      Name\Data3    = w2
      Name\Data4[0] = b1
      Name\Data4[1] = b2
      Name\Data4[2] = b3
      Name\Data4[3] = b4
      Name\Data4[4] = b5
      Name\Data4[5] = b6
      Name\Data4[6] = b7
      Name\Data4[7] = b8
    Else
      Debug "Error - variable not declared as guid"
    EndIf
  CompilerEndIf
EndMacro

Procedure CreateShortcut(Path.s, Link.s, WorkingDir.s = "", Argument.s = "", ShowCommand.l = #SW_SHOWNORMAL, Description.s =  "", HotKey.l = #Null, IconFile.s = "|", IconIndex.l = 0)
  Protected psl.IShellLinkW, ppf.IPersistFile, Result
  Protected.GUID CLSID_ShellLink, IID_IShellLink, IID_IPersistFile

  DEFINE_GUID(CLSID_ShellLink, $00021401, $0000,$0000, $C0, $00, $00, $00, $00, $00, $00, $46) ; {00021401-0000-0000-C000-000000000046}
  DEFINE_GUID(IID_IShellLink, $000214F9, $0000,$0000, $C0, $00, $00, $00, $00, $00, $00, $46)  ; {000214F9-0000-0000-C000-000000000046}
  DEFINE_GUID(IID_IPersistFile, $0000010B, $0000,$0000, $C0, $00, $00, $00, $00, $00, $00, $46); {0000010b-0000-0000-C000-000000000046}

  If IconFile = "|" : IconFile = Path : EndIf
  If WorkingDir="" : WorkingDir = GetPathPart(Path) : EndIf

  CoInitialize_(0)
  If CoCreateInstance_(@CLSID_ShellLink, 0, 1, @IID_IShellLink, @psl) =  #S_OK

    Set_ShellLink_preferences:
    psl\SetPath(Path)
    psl\SetArguments(Argument)
    psl\SetWorkingDirectory(WorkingDir)
    psl\SetDescription(DESCRIPTION)
    psl\SetShowCmd(ShowCommand)
    psl\SetHotkey(HotKey)
    psl\SetIconLocation(IconFile, IconIndex)
    ShellLink_SAVE:
    If psl\QueryInterface(@IID_IPersistFile, @ppf) = #S_OK
      ppf\Save(Link, #True)
      result = 1
      ppf\Release()
    EndIf
    psl\Release()
  EndIf
  CoUninitialize_()
  ProcedureReturn result
EndProcedure
; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
