;    Description: Keyed-Hash Message Authentication Code (HMAC) Modul
;         Author: Christian+
;           Date: 2014-03-26
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27864
; -----------------------------------------------------------------------------
; GPI: Update for 5.40

; ----------------------------------------------------------------------
;- HMAC.pb
; ----------------------------------------------------------------------
; | Title:   | HMAC
; ----------------------------------------------------------------------
; | Author:  | Christian+
; ----------------------------------------------------------------------
; | Date:    | 2014-03-26
; ----------------------------------------------------------------------
; | Version: | 1.0
; ----------------------------------------------------------------------
; | URL:     | http://www.purebasic.fr/german/viewtopic.php?p=321343#p321343
; ----------------------------------------------------------------------

DeclareModule HMAC
  
  EnableExplicit
  UseMD5Fingerprint()
  
  UseSHA1Fingerprint()
  
  
  Enumeration Mode
    #Hash_MD5
    #Hash_SHA1
  EndEnumeration
  
  Declare.i ExamineHMAC(*Key, KeySize.i, Mode.i)
  Declare  NextHMAC(*HMAC, *Message, MessageSize.i = -1)
  Declare.s FinishHMAC(*HMAC)
  
  Declare.s HMAC(*Key, KeySize.i, *Message, MessageSize.i, Mode.i)
  
  Declare.s StringHMAC(Key.s, Message.s, Mode.i)
  
EndDeclareModule

Module HMAC
  
  EnableExplicit
  
  Structure HMAC_DATA
    Mode.i
    *OKeyPad
    Fingerprint.i
  EndStructure
  
  Global Dim HashByteSize.i(1)
  HashByteSize(#Hash_MD5) = 16
  HashByteSize(#Hash_SHA1) = 20
  
  Global Dim HashBlockSize.i(1)
  HashBlockSize(#Hash_MD5) = 64
  HashBlockSize(#Hash_SHA1) = 64
  
  Procedure.i ConvertHexToBin(String.s)
    Protected Index.i, Len.i = Len(String), *DestMemory = AllocateMemory(Len / 2)
    For Index = 1 To Len Step 2
      PokeA(*DestMemory + (Index - 1) / 2, Val("$" + Mid(String, Index, 2)))
    Next
    ProcedureReturn *DestMemory
  EndProcedure
  
  Procedure.i ExamineFingerprint(Mode.i)
    Protected Fingerprint.i
    Select Mode
      Case #Hash_MD5
        Fingerprint = StartFingerprint(#PB_Any,#PB_Cipher_MD5 )
      Case #Hash_SHA1
        Fingerprint = StartFingerprint(#PB_Any,#PB_Cipher_SHA1)
    EndSelect
    ProcedureReturn Fingerprint
  EndProcedure
  
  Procedure.i ExamineHMAC(*Key, KeySize.i, Mode.i)
    Protected *NewKey, Fingerprint.i, HashString.s, *Hash, *OKeyPad, *IKeyPad, Index.i, *HMAC.HMAC_DATA
    *HMAC = AllocateMemory(SizeOf(HMAC_DATA))
    *HMAC\Mode = Mode
    *NewKey = AllocateMemory(HashBlockSize(Mode))
    If KeySize > HashBlockSize(Mode)
      Fingerprint = ExamineFingerprint(Mode)
      AddFingerprintBuffer(Fingerprint, *Key, KeySize)
      HashString = FinishFingerprint(Fingerprint)
      *Hash = ConvertHexToBin(HashString)
      CopyMemory(*Hash, *NewKey, HashByteSize(Mode))
      FreeMemory(*Hash)
    Else
      CopyMemory(*Key, *NewKey, KeySize)
    EndIf
    *HMAC\OKeyPad = AllocateMemory(HashBlockSize(Mode), #PB_Memory_NoClear)
    *IKeyPad = AllocateMemory(HashBlockSize(Mode), #PB_Memory_NoClear)
    For Index = 0 To HashBlockSize(Mode) - 1
      PokeB(*HMAC\OKeyPad + Index, PeekB(*NewKey + Index) ! $5c)
      PokeB(*IKeyPad + Index, PeekB(*NewKey + Index) ! $36)
    Next
    FreeMemory(*NewKey)
    *HMAC\Fingerprint = ExamineFingerprint(Mode)
    AddFingerprintBuffer(*HMAC\Fingerprint, *IKeyPad, HashBlockSize(Mode))
    FreeMemory(*IKeyPad)
    ProcedureReturn *HMAC
  EndProcedure
  
  Procedure NextHMAC(*HMAC.HMAC_DATA, *Message, MessageSize.i = -1)
    If MessageSize = -1 : MessageSize = MemorySize(*Message) : EndIf
    If MessageSize > 0 : AddFingerprintBuffer(*HMAC\Fingerprint, *Message, MessageSize) : EndIf
  EndProcedure
  
  Procedure.s FinishHMAC(*HMAC.HMAC_DATA)
    Protected HashString.s, *Hash, Fingerprint.i
    HashString = FinishFingerprint(*HMAC\Fingerprint)
    *Hash = ConvertHexToBin(HashString)
    Fingerprint = ExamineFingerprint(*HMAC\Mode)
    AddFingerprintBuffer(Fingerprint, *HMAC\OKeyPad, HashBlockSize(*HMAC\Mode))
    AddFingerprintBuffer(Fingerprint, *Hash, HashByteSize(*HMAC\Mode))
    HashString = FinishFingerprint(Fingerprint)
    FreeMemory(*Hash)
    FreeMemory(*HMAC\OKeyPad)
    FreeMemory(*HMAC)
    ProcedureReturn HashString
  EndProcedure
  
  Procedure.s HMAC(*Key, KeySize.i, *Message, MessageSize.i, Mode.i)
    Protected *HMAC = ExamineHMAC(*Key, KeySize, Mode)
    NextHMAC(*HMAC, *Message, MessageSize)
    ProcedureReturn FinishHMAC(*HMAC)
  EndProcedure
  
  Procedure.s StringHMAC(Key.s, Message.s, Mode.i)
    Protected KeySize.i, *Key, MessageSize.i, *Message, HMAC.s
    KeySize = StringByteLength(Key, #PB_UTF8)
    *Key = AllocateMemory(KeySize + SizeOf(Character))
    PokeS(*Key, Key, -1, #PB_UTF8)
    MessageSize = StringByteLength(Message, #PB_UTF8)
    *Message = AllocateMemory(MessageSize + SizeOf(Character))
    PokeS(*Message, Message, -1, #PB_UTF8)
    HMAC = HMAC(*Key, KeySize, *Message, MessageSize, Mode)
    FreeMemory(*Key)
    FreeMemory(*Message)
    ProcedureReturn HMAC
  EndProcedure
  
EndModule

;- Example
CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  
  UseModule HMAC
  
  Define Key.s = ""
  Define Message.s = ""
  
  Debug "Key = ''  Message = ''"
  Debug "HMAC_MD5: " + StringHMAC(Key, Message, #Hash_MD5)
  If "74e6f7298a9c2d168935f58c001bad88"<>StringHMAC(Key, Message, #Hash_MD5)
    Debug "ERROR!"
  EndIf
  Debug "HMAC_SHA1: " + StringHMAC(Key, Message, #Hash_SHA1)
  If "fbdb1d1b18aa6c08324b7d64b71fb76370690e1d"<>StringHMAC(Key, Message, #Hash_SHA1)
    Debug "ERROR!"
  EndIf
  
  Debug ""
  
  Define Key.s = "key"
  Define Message.s = "The quick brown fox jumps over the lazy dog"
  
  Debug "Key = 'key'  Message = 'The quick brown fox jumps over the lazy dog'"
  Debug "HMAC_MD5: " + StringHMAC(Key, Message, #Hash_MD5)
  If "80070713463e7749b90c2dc24911e275"<>StringHMAC(Key, Message, #Hash_MD5)
    Debug "ERROR!"
  EndIf
  Debug "HMAC_SHA1: " + StringHMAC(Key, Message, #Hash_SHA1)
  If "de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9"<> StringHMAC(Key, Message, #Hash_SHA1)
    Debug "ERROR!"
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
