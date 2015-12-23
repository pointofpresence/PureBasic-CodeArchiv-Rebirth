;    Description: Simple routines for easier AES. With java-example to encode/decode
;         Author: Christian+
;           Date:2014-03-29
;     PB-Version: 5.41
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=26479
; -----------------------------------------------------------------------------


; ----------------------------------------------------------------------
;- SimpleAES.pb
; ----------------------------------------------------------------------
; | Title:   | SimpleAES
; ----------------------------------------------------------------------
; | Author:  | Christian+
; ----------------------------------------------------------------------
; | Date:    | 2014-03-29
; ----------------------------------------------------------------------
; | Version: | 1.4
; ----------------------------------------------------------------------
; | URL:     | http://forums.purebasic.com/german/viewtopic.php?p=309907#p309907
; ----------------------------------------------------------------------

CompilerIf #PB_Compiler_Version=540
  CompilerWarning "Because of a bug, please update to 541"
CompilerEndIf


DeclareModule SimpleAES
  
  EnableExplicit
  UseMD5Fingerprint()
  
  ; ----------------------------------------------------------------------------
  ; Overview
  ; ----------------------------------------------------------------------------
  ; Declare.i SimpleAES_StartCipher(*Key, Mode.i = #PB_Cipher_Encode, *Options.SimpleAES_Config = 0)
  ; Declare.i SimpleAES_AddCipherBuffer(*Data, *InputMemory, InputSize.i, *OutputMemory, Finish.i = #False)
  ; Declare   SimpleAES_FinishCipher(*Data)
  
  ; Declare.i SimpleAES_CryptMemory(*Key, Mode.i, *Memory, Size.i = -1, *Options.SimpleAES_Config = 0)
  
  ; Declare.s SimpleAES_CryptString(*Key, Mode.i, String.s, Type.i = #PB_UTF8, *Options.SimpleAES_Config = 0)
  
  ; Declare.i SimpleAES_CryptFile(*Key, Mode.i, SourceFileName.s, NewFileName.s, *Procedure = 0, BlockSize.i = 0, *Options.SimpleAES_Config = 0)
  
  ; Declare.s SimpleAES_Base64Encoder(*Memory, Size.i = -1, Falgs.i = 0)
  ; Declare.i SimpleAES_Base64Decoder(Base64String.s)
  ; ----------------------------------------------------------------------------
  
  ; Default Anzahl an Bits für den Schlüssel (128 Bit, 192 Bit oder 256 Bit sind möglich!)
  Global DefaultBits = 128
  
  Enumeration
    #PKCS5Padding  ;Kompatibel mit Java (z.B.: "AES/CBC/PKCS5Padding")
                   ;...
  EndEnumeration
  
  Structure SimpleAES_Config
    CipherMode.i  ; = #PB_Cipher_CBC
    Bits.i        ; = DefaultBits
    Padding.i     ; = #PKCS5Padding
    AttachIV.i    ; = #True
    CryptRandom.i ; = #False
    *IV           ; = 0
  EndStructure
  
  ; ----------------------------------------------------------------------------
  ; *Key -> "Ein Speicherbereich, welcher den Schlüssel enthält. (Schlüssel: 16 Byte bei 128 Bit; 24 Byte bei 192 Bit; 32 Byte bei 256 Bit)"
  ; Mode -> "#PB_Cipher_Encode oder #PB_Cipher_Decode"
  ; *Options -> "Struktur die für Fortgeschrittene zusätzliche Konfigurationsmöglichkeiten bietet."
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "SimpleAES Cipher Pointer"
  ; ----------------------------------------------------------------------------
  Declare.i SimpleAES_StartCipher(*Key, Mode.i = #PB_Cipher_Encode, *Options.SimpleAES_Config = 0)
  
  ; ----------------------------------------------------------------------------
  ; *Data -> "SimpleAES Cipher Pointer"
  ; *InputMemory -> "Eingabespeicherbereich"
  ; InputSize -> "Größe des Eingabespeicherbereich"
  ; *OutputMemory -> "Ausgabespeicherbereich (Wichtig: *OutputMemory muss 32 Byte größer als *InputMemory sein!)"
  ; Finish -> "#True um Ver/Entschlüsselung zu beenden und alle restlichen Daten in *OutputMemory zu schreiben (Wichtig für das Padding)."
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "Anzahl an Bytes die in *OutputMemory geschrieben wurden."
  ; ----------------------------------------------------------------------------
  Declare.i SimpleAES_AddCipherBuffer(*Data, *InputMemory, InputSize.i, *OutputMemory, Finish.i = #False)
  
  ; ----------------------------------------------------------------------------
  ; *Data -> "SimpleAES Cipher Pointer"
  ; ----------------------------------------------------------------------------
  Declare   SimpleAES_FinishCipher(*Data)
  
  ; ----------------------------------------------------------------------------
  ; *Key -> "Ein Speicherbereich, welcher den Schlüssel enthält. (Schlüssel: 16 Byte bei 128 Bit; 24 Byte bei 192 Bit; 32 Byte bei 256 Bit)"
  ; Mode -> "#PB_Cipher_Encode oder #PB_Cipher_Decode"
  ; *Memory -> "Eingabespeicherbereich"
  ; Size -> "Größe des Eingabespeicherbereich"
  ; *Options -> "Struktur die für Fortgeschrittene zusätzliche Konfigurationsmöglichkeiten bietet."
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "Pointer auf Speicherbereich mit den verschlüsselten Daten."
  ; ----------------------------------------------------------------------------
  Declare.i SimpleAES_CryptMemory(*Key, Mode.i, *Memory, Size.i = -1, *Options.SimpleAES_Config = 0)
  
  ; ----------------------------------------------------------------------------
  ; *Key -> "Ein Speicherbereich, welcher den Schlüssel enthält. (Schlüssel: 16 Byte bei 128 Bit; 24 Byte bei 192 Bit; 32 Byte bei 256 Bit)"
  ; Mode -> "#PB_Cipher_Encode oder #PB_Cipher_Decode"
  ; String -> "String der Verschlüsselt bzw. Entschlüsselt werden soll."
  ; Type -> "Codierung dir für den String verwendet werden soll (#PB_Ascii, #PB_UTF8 oder #PB_Unicode)"
  ; *Options -> "Struktur die für Fortgeschrittene zusätzliche Konfigurationsmöglichkeiten bietet."
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "Verschlüsselter bzw Entschlüsselter String."
  ; ----------------------------------------------------------------------------
  Declare.s SimpleAES_CryptString(*Key, Mode.i, String.s, Type.i = #PB_UTF8, *Options.SimpleAES_Config = 0)
  
  ; ----------------------------------------------------------------------------
  ; *Key -> "Ein Speicherbereich, welcher den Schlüssel enthält. (Schlüssel: 16 Byte bei 128 Bit; 24 Byte bei 192 Bit; 32 Byte bei 256 Bit)"
  ; Mode -> "#PB_Cipher_Encode oder #PB_Cipher_Decode"
  ; SourceFileName -> "Die Quelldatei"
  ; NewFileFileName -> "Die Zieldatei"
  ; *Procedure -> "Optinale Adresse einer Procedure mit zwei Int Parametern die nach jedem verarbeiteten Block an Daten aufgerufen wird."
  ; BlockSize -> Anzahl an Bytes die auf einmal gelesen / verarbeitet werden sollen.
  ; *Options -> "Struktur die für Fortgeschrittene zusätzliche Konfigurationsmöglichkeiten bietet."
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "#True bei Erfolg"
  ; ----------------------------------------------------------------------------
  Declare.i SimpleAES_CryptFile(*Key, Mode.i, SourceFileName.s, NewFileName.s, *Procedure = 0, BlockSize.i = 0, *Options.SimpleAES_Config = 0)
  
  ; ----------------------------------------------------------------------------
  ; *Memory -> "Eingabespeicherbereich"
  ; Size -> "Größe des Eingabespeicherbereich"
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "Base64 codierter String"
  ; ----------------------------------------------------------------------------
  Declare.s SimpleAES_Base64Encoder(*Memory, Size.i = -1, Falgs.i = 0)
  
  ; ----------------------------------------------------------------------------
  ; Base64String -> "Base64 codierter String"
  ; ----------------------------------------------------------------------------
  ; Rückgabewert: "Pointer auf Daten im Memory"
  ; ----------------------------------------------------------------------------
  Declare.i SimpleAES_Base64Decoder(Base64String.s)
  
EndDeclareModule

Module SimpleAES
  
  EnableExplicit
  
  Structure SimpleAES_CipherData
    *Key
    Mode.i
    Options.SimpleAES_Config
    Cipher.i
    MemorySize.i
    *Memory
  EndStructure 
  
  Procedure.i SimpleAES_StartCipher(*Key, Mode.i = #PB_Cipher_Encode, *Options.SimpleAES_Config = 0)
    Protected *Data.SimpleAES_CipherData = AllocateMemory(SizeOf(SimpleAES_CipherData))
    If *Options
      *Data\Options\CipherMode = *Options\CipherMode
      *Data\Options\Bits = *Options\Bits
      *Data\Options\Padding = *Options\Padding
      *Data\Options\AttachIV = *Options\AttachIV
      *Data\Options\CryptRandom = *Options\CryptRandom
      If *Options\IV <> 0 : *Data\Options\IV = AllocateMemory(16, #PB_Memory_NoClear) : CopyMemory(*Options\IV, *Data\Options\IV, 16) : EndIf
    Else
      *Data\Options\CipherMode = #PB_Cipher_CBC
      *Data\Options\Bits = DefaultBits
      *Data\Options\Padding = #PKCS5Padding
      *Data\Options\AttachIV = #True
      *Data\Options\CryptRandom = #False
    EndIf
    *Data\Key = AllocateMemory(*Data\Options\Bits/8, #PB_Memory_NoClear) : CopyMemory(*Key, *Data\Key, *Data\Options\Bits/8)
    *Data\Mode = Mode
    *Data\Memory = AllocateMemory(16, #PB_Memory_NoClear)
    ProcedureReturn *Data
  EndProcedure
  
  Procedure.i SimpleAES_AddCipherBuffer(*Data.SimpleAES_CipherData, *InputMemory, InputSize.i, *OutputMemory, Finish.i = #False)
    Protected *IV, OutputSize.i, Size.i, LeftOver.i, FillValue.i   
    If *Data\Cipher = 0
      Select *Data\Options\CipherMode
        Case #PB_Cipher_CBC
          If *Data\Mode = #PB_Cipher_Encode       
            If *Data\Options\IV <> 0
              CopyMemory(*Data\Options\IV, *Data\Memory, 16)
            Else
              If Not *Data\Options\CryptRandom Or Not CryptRandomData(*Data\Memory, 16) : RandomData(*Data\Memory, 16) : EndIf
            EndIf
            If *Data\Options\AttachIV
              CopyMemory(*Data\Memory, *OutputMemory, 16)
              OutputSize + 16
            EndIf
            
            *Data\Cipher = StartAESCipher(#PB_Any, *Data\Key, *Data\Options\Bits, *Data\Memory, *Data\Mode | *Data\Options\CipherMode)
          ElseIf *Data\Mode = #PB_Cipher_Decode
            If *Data\Options\IV <> 0
              CopyMemory(*Data\Options\IV, *Data\Memory, 16)
              *Data\Cipher = StartAESCipher(#PB_Any, *Data\Key, *Data\Options\Bits, *Data\Memory, *Data\Mode | *Data\Options\CipherMode)
            ElseIf InputSize >= 16
              CopyMemory(*InputMemory, *Data\Memory, 16)
              *InputMemory + 16
              InputSize - 16
              *Data\Cipher = StartAESCipher(#PB_Any, *Data\Key, *Data\Options\Bits, *Data\Memory, *Data\Mode | *Data\Options\CipherMode)
            ElseIf *Data\MemorySize + InputSize >= 16
              Size = 16-*Data\MemorySize
              CopyMemory(*InputMemory, *Data\Memory+*Data\MemorySize, Size)
              *InputMemory + Size
              InputSize - Size
              *Data\MemorySize = 0
              *Data\Cipher = StartAESCipher(#PB_Any, *Data\Key, *Data\Options\Bits, *Data\Memory, *Data\Mode | *Data\Options\CipherMode)
            EndIf       
          EndIf
        Case #PB_Cipher_ECB
          *Data\Cipher = StartAESCipher(#PB_Any, *Data\Key, *Data\Options\Bits, *Data\Memory, *Data\Mode | *Data\Options\CipherMode)
      EndSelect
    EndIf   
    If *Data\MemorySize + InputSize < 16     
      If InputSize > 0 : CopyMemory(*InputMemory, *Data\Memory+*Data\MemorySize, InputSize) : EndIf
      *Data\MemorySize + InputSize
    Else     
      If *Data\MemorySize > 0
        Size = 16-*Data\MemorySize
        CopyMemory(*InputMemory, *Data\Memory+*Data\MemorySize, Size)
        *InputMemory + Size
        InputSize - Size
        AddCipherBuffer(*Data\Cipher, *Data\Memory, *OutputMemory+OutputSize, 16)
        *Data\MemorySize = 0
        OutputSize + 16
      EndIf
      LeftOver = InputSize % 16
      InputSize - LeftOver
      If LeftOver > 0
        CopyMemory(*InputMemory+InputSize, *Data\Memory, LeftOver)
        *Data\MemorySize = LeftOver
      EndIf
      If InputSize > 0
        AddCipherBuffer(*Data\Cipher, *InputMemory, *OutputMemory+OutputSize, InputSize)
        OutputSize + InputSize
      EndIf     
    EndIf   
    If Finish
      Select *Data\Options\Padding
        Case #PKCS5Padding
          If *Data\Mode = #PB_Cipher_Encode
            FillValue = 16 - *Data\MemorySize
            FillMemory(*Data\Memory+*Data\MemorySize, FillValue, FillValue, #PB_Byte)
            AddCipherBuffer(*Data\Cipher, *Data\Memory, *OutputMemory+OutputSize, 16)
            OutputSize + 16
          EndIf
          If *Data\Mode = #PB_Cipher_Decode
            OutputSize - PeekA(*OutputMemory+OutputSize-1)
          EndIf
          *Data\MemorySize = 0
      EndSelect
    EndIf   
    ProcedureReturn OutputSize
  EndProcedure
  
  Procedure SimpleAES_FinishCipher(*Data.SimpleAES_CipherData)
    FinishCipher(*Data\Cipher)
    FreeMemory(*Data\Key)
    If *Data\Options\IV <> 0 : FreeMemory(*Data\Options\IV) : EndIf
    FreeMemory(*Data\Memory)
    FreeMemory(*Data)
  EndProcedure
  
  Procedure.i SimpleAES_CryptMemory(*Key, Mode.i, *Memory, Size.i = -1, *Options.SimpleAES_Config = 0)
    Protected Cipher.i, NewSize, *NewMemory
    If Size = -1 : Size = MemorySize(*Memory) : EndIf       
    *NewMemory = AllocateMemory(Size + 32, #PB_Memory_NoClear)   
    Cipher = SimpleAES_StartCipher(*Key, Mode, *Options)
    NewSize = SimpleAES_AddCipherBuffer(Cipher, *Memory, Size, *NewMemory, #True)
    SimpleAES_FinishCipher(Cipher)   
    ReAllocateMemory(*NewMemory, NewSize)
    ProcedureReturn *NewMemory
  EndProcedure
  
  Procedure.s SimpleAES_CryptString(*Key, Mode.i, String.s, Type.i = #PB_UTF8, *Options.SimpleAES_Config = 0)
    Protected Cipher.i, Size, *Memory, NewSize, *NewMemory, ResultString.s = ""       
    If Mode = #PB_Cipher_Encode   
      Size = StringByteLength(String, Type)
      *Memory = AllocateMemory(Size + SizeOf(Character), #PB_Memory_NoClear)
      PokeS(*Memory, String, -1, Type)
    Else
      *Memory = SimpleAES_Base64Decoder(String)
      Size = MemorySize(*Memory)
    EndIf   
    *NewMemory = AllocateMemory(Size + 32 + SizeOf(Character), #PB_Memory_NoClear)   
    Cipher = SimpleAES_StartCipher(*Key, Mode, *Options)
    NewSize = SimpleAES_AddCipherBuffer(Cipher, *Memory, Size, *NewMemory, #True)
    SimpleAES_FinishCipher(Cipher)   
    If Mode = #PB_Cipher_Encode   
      ResultString = SimpleAES_Base64Encoder(*NewMemory, NewSize)
    Else     
      PokeC(*NewMemory + NewSize, 0)
      If NewSize > 0 : ResultString = PeekS(*NewMemory, NewSize, Type) : EndIf
    EndIf   
    FreeMemory(*Memory)
    FreeMemory(*NewMemory)     
    ProcedureReturn ResultString
  EndProcedure
  
  Procedure.i SimpleAES_CryptFile(*Key, Mode.i, SourceFileName.s, NewFileName.s, *Procedure = 0, BlockSize.i = 0, *Options.SimpleAES_Config = 0)
    Protected Cipher.i, SourceFile.i, NewFile.i, SourceSize.i, Size.i, *SourceMemory, *NewMemory, Cancel.i, NewBlockSize.i, Status.i
    If BlockSize <= 0 : BlockSize = 16 * 1024 * 1024 : EndIf
    Cipher = SimpleAES_StartCipher(*Key, Mode, *Options)
    SourceFile = ReadFile(#PB_Any, SourceFileName)
    If SourceFile
      NewFile = CreateFile(#PB_Any, NewFileName)     
      If NewFile
        SourceSize = Lof(SourceFile)
        Size = SourceSize
        *SourceMemory = AllocateMemory(BlockSize, #PB_Memory_NoClear)
        *NewMemory = AllocateMemory(BlockSize + 32, #PB_Memory_NoClear)
        While Size > 0
          If *Procedure
            Cancel = CallFunctionFast(*Procedure, SourceSize - Size, SourceSize)
          EndIf
          If Cancel
            CloseFile(SourceFile)
            CloseFile(NewFile)
            DeleteFile(NewFileName)
            SimpleAES_FinishCipher(Cipher)
            If *Procedure
              CallFunctionFast(*Procedure, 0, 0)
            EndIf           
            ProcedureReturn #False
          EndIf
          If Size <= BlockSize
            ReadData(SourceFile, *SourceMemory, Size)
            NewBlockSize = SimpleAES_AddCipherBuffer(Cipher, *SourceMemory, Size, *NewMemory, #True)
            Status = #True
          Else
            ReadData(SourceFile, *SourceMemory, BlockSize)
            NewBlockSize = SimpleAES_AddCipherBuffer(Cipher, *SourceMemory, BlockSize, *NewMemory, #False)
          EndIf
          WriteData(NewFile, *NewMemory, NewBlockSize)
          Size - BlockSize
        Wend
        CloseFile(NewFile)
      EndIf
      CloseFile(SourceFile)
    EndIf
    SimpleAES_FinishCipher(Cipher)
    If *Procedure
      If status
        CallFunctionFast(*Procedure, SourceSize, SourceSize)
      Else
        CallFunctionFast(*Procedure, -1, -1)
      EndIf
    EndIf
    ProcedureReturn Status
  EndProcedure
  
  Procedure.s SimpleAES_Base64Encoder(*Memory, Size.i = -1, Flags = 0)
    Protected Base64Size.i, *Base64, Base64String.s
    If Size = -1 : Size = MemorySize(*Memory) : EndIf
    Base64Size = 64.0 + Size * 1.35
    *Base64 = AllocateMemory(Base64Size, #PB_Memory_NoClear)
    Base64Size = Base64Encoder(*Memory, Size, *Base64, Base64Size, Flags)
    Base64String = PeekS(*Base64, Base64Size, #PB_Ascii)
    FreeMemory(*Base64)
    ProcedureReturn Base64String
  EndProcedure
  
  Procedure.i SimpleAES_Base64Decoder(Base64String.s)
    Protected Base64Size.i, *Base64, *Memory, Size.i
    Base64Size = StringByteLength(Base64String, #PB_Ascii)
    *Base64 = AllocateMemory(Base64Size + 1, #PB_Memory_NoClear)
    PokeS(*Base64, Base64String, Base64Size, #PB_Ascii)
    Size = Base64Size + 64
    *Memory = AllocateMemory(Size, #PB_Memory_NoClear)
    Size = Base64Decoder(*Base64, Base64Size, *Memory, Size)
    FreeMemory(*Base64)
    ReAllocateMemory(*Memory, Size)
    ProcedureReturn *Memory
  EndProcedure
  
EndModule

;- Example
CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  
  Procedure.i ConvertHexToBin(String.s)
    Protected Index.i, Len.i = Len(String), *DestMemory = AllocateMemory(Len / 2)
    For Index = 1 To Len Step 2
      PokeA(*DestMemory + (Index - 1) / 2, Val("$" + Mid(String, Index, 2)))
    Next
    ProcedureReturn *DestMemory
  EndProcedure
  
  Procedure.i Create128BitMD5HashKey(Password.s)
    Protected *Memory, HashString.s
    *Memory = AllocateMemory(StringByteLength(Password, #PB_UTF8)+SizeOf(Character))
    PokeS(*Memory, Password, -1, #PB_UTF8)
    HashString = Fingerprint(*Memory, StringByteLength(Password, #PB_UTF8),#PB_Cipher_MD5)
    FreeMemory(*Memory)
    ProcedureReturn ConvertHexToBin(HashString)
  EndProcedure
  
  UseModule SimpleAES 
  
  Define *Key = Create128BitMD5HashKey("MyPassword123")
  
  ; String Test
  Debug "" : Debug "String Test"
  
  Define SourceString.s, DecodedString.s, EncodedString.s
  
  SourceString = "Hallo, dies ist ein Test des SimpleAES Moduls für Strings."
  Debug "SourceString: " + SourceString
  
  EncodedString = SimpleAES_CryptString(*Key, #PB_Cipher_Encode, SourceString)
  Debug "EncodedString: " + EncodedString
  
  DecodedString = SimpleAES_CryptString(*Key, #PB_Cipher_Decode, EncodedString)
  Debug "DecodedString: " + DecodedString
  If DecodedString<>SourceString
    Debug "ERROR!"
  EndIf
  
  ; Custom Options Test
  Debug "" : Debug "Custom Options Test"
  
  Define Options.SimpleAES_Config
  Options\CipherMode.i = #PB_Cipher_ECB
  Options\Bits = 256
  Options\Padding = #PKCS5Padding
  
  Debug "SourceString: " + SourceString
  
  EncodedString = SimpleAES_CryptString(?Key, #PB_Cipher_Encode, SourceString, #PB_Ascii, @Options)
  Debug "EncodedString: " + EncodedString
  
  DecodedString = SimpleAES_CryptString(?Key, #PB_Cipher_Decode, EncodedString, #PB_Ascii, @Options)
  Debug "DecodedString: " + DecodedString
  If DecodedString<>SourceString
    Debug "ERROR!"
  EndIf
  
  
  
  ; Memory Test
  Debug "" : Debug "Memory Test"
  
  Define EncodedMemory.i, DecodedMemory.i
  
  Debug "SourceString: " + SourceString
  
  EncodedMemory = SimpleAES_CryptMemory(*Key, #PB_Cipher_Encode, @SourceString, StringByteLength(SourceString) + SizeOf(Character)) 
  
  DecodedMemory = SimpleAES_CryptMemory(*Key, #PB_Cipher_Decode, EncodedMemory) 
  
  Debug "DecodedString: " + PeekS(DecodedMemory)
  If DecodedString<>SourceString
    Debug "ERROR!"
  EndIf
  
  ; File Test
  Debug "" : Debug "File Test"
  
  Define SourceFileName.s, EncodedFileName.s, DecodedFileName.s
  
  Procedure Progress(BytesProcessed, FileSize)
    If BytesProcessed = 0
      Debug "Start"
    EndIf
    Debug "(" + BytesProcessed + " / " + FileSize + ")"
    If BytesProcessed = FileSize
      Debug "End"
    EndIf
    If BytesProcessed = -1 And FileSize = -1
      Debug "Error"
    EndIf
  EndProcedure
  
  ;       SourceFileName = OpenFileRequester("Bitte Datei zum Verschlüsseln auswählen", "", "Alle Dateien (*.*)|*.*", 0)
  ;       If SourceFileName
  ;        
  ;         EncodedFileName = GetPathPart(SourceFileName) + GetFilePart(SourceFileName, #PB_FileSystem_NoExtension) + "(Encoded)." + GetExtensionPart(SourceFileName)
  ;        
  ;         SimpleAES_CryptFile(*Key, #PB_Cipher_Encode, SourceFileName, EncodedFileName, @Progress())
  ;        
  ;         DecodedFileName = GetPathPart(SourceFileName) + GetFilePart(SourceFileName, #PB_FileSystem_NoExtension) + "(Decoded)." + GetExtensionPart(SourceFileName)
  ;        
  ;         SimpleAES_CryptFile(*Key, #PB_Cipher_Decode, EncodedFileName, DecodedFileName, @Progress())
  ;        
  ;       EndIf
  
  DataSection
    Key:
    Data.b $06 , $a9 , $21 , $40 , $36 , $b8 , $a2 , $5b , $51 , $2e , $03 , $d6 , $36 , $12 , $01 , $07, $06 , $a9 , $21 , $40 , $36 , $b8 , $a2 , $5b , $51 , $2e , $03 , $d6 , $36 , $12 , $01 , $07
  EndDataSection
  
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
