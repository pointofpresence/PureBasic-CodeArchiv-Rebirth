;    Description: WakeOnLan - Module: send MagicPacket
;         Author: Imhotheb (Andreas Wenzl)
;           Date: 02-04-2015
;     PB-Version: PB5.31
;             OS: Windows, Linux
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28836
; -----------------------------------------------------------------------------

; ==================================================
;|                 WakeOnLan - Module               |
;|==================================================|
;| Version: V1.1                Created: 02.04.2015 |
;| Type: PB-Include (Module)                        |
;| Author: Imhotheb (Andreas Wenzl)                 |
;| Compiler: PB5.31 32/64 [Win/Lin]                 |
;| Description: send MagicPacket                    |
; ==================================================
;
; WakeOnLan-Modul V1.1 - 02.04.2015
; ------------------------------------------------------------------
;
; V1.1  - kleiner Bugfix / Kommentare überarbeitet
; V1.0  - erste Version
;
; ein MagicPacket (WoL-Paket) versenden um damit einen Rechner aufzuwecken
;
; Getestet mit PB 5.31 x86/x86 unter Win7 32Bit/64Bit und XUbuntu 14.10 amd64/i386
;
; InitNetwork() wird benötigt
; 
; Linux: Broadcast muss 255.255.255.255, die lokale Broadcast Addresse oder eine direkte IP sein
; Win: für Broadcast ist alles außer 255.255.255.255 zulässig
;
;
; Aufruf:
; WoL::sendMagicPacket("MacAddresse", "Broadcast oder IP", Portnummer)
; MacAddresse als String übergeben z.B. "AA:BB:CC:DD:EE:FF"
; Broadcast als String übergeben Standart = "10.255.255.255"
; Port als Nummer übergeben. Für WoL wird in der Regel 0, 7 und 9 verwendet.
;
; Rückgabewerte: Erfolgreich: #True / Fehlgeschlagen: #False
;
; Hinweise:
; Man kann eine BroadcastAddresse auch im Router/Gateway freigeben und dann sehr einfach
; aus der "Ferne" sein ganzes Netzwerk aufwecken.
; Jedoch sollte aber Nutzen / Risiko abgewogen und andere Ports verwendet werden
; Bei einer direkten Addresse muss der Switch/Hub die Mac intern gespeichert haben, was aber
; i.d.R. kein Problem sein sollte
;
; ------------------------------------------------------------------

DeclareModule WoL
  Declare sendMagicPacket(Mac.s, Broadcast.s = "10.255.255.255", Port = 9)
EndDeclareModule

Module WoL
  EnableExplicit
 
  Structure MacAddress
    Byte.b[6]
  EndStructure
 
  Structure MagicPacket
    Header.b[6]
    Mac.MacAddress[16]
  EndStructure
   
  Structure MacAddress_Stringfields
    Byte1.s{2}
    Seperator1.s{1}
    Byte2.s{2}
    Seperator2.s{1}
    Byte3.s{2}
    Seperator3.s{1}
    Byte4.s{2}
    Seperator4.s{1}
    Byte5.s{2}
    Seperator5.s{1}
    Byte6.s{2}
  EndStructure
 
  Structure MacAddress_String
    StructureUnion
      Stringfields.MacAddress_Stringfields
      Mac.s{17}
    EndStructureUnion
  EndStructure
 
  ; Konstanten und Strukturen für Linux / sendMagicPacket()
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    Structure sockaddr_in Align #PB_Structure_AlignC
      IP_Family.u
      Port.u
      Addr.l
      Zero.a[8]
    EndStructure     
    #IP_Family = 2      ;IPv4
    #Socket_DGRAM = 2     ;UDP
    #SO_BROADCAST = 6 ;??
    #SOL_SOCKET = 1   ;??
    #FIONBIO = $5421
    #INVALID_SOCKET = -1
  CompilerEndIf
 
 
 
  ; MacAddress & MagicPacket
  ; ----------------------
 
  ; *dest = Zeiger mit einer MacAddress-Struktur
  ; Mac.s = MacAddress als String (z.B. 11:22:33:44:55:66 oder 11-22-33-44-55-66)
  Procedure createMacAdress(*Dest.MacAddress, Mac.s)
    Protected Mac_String.MacAddress_String
    Mac_String\Mac = Mac
   
    ; man könnte hier sicherlich auch StringField() benutzen,
    ; aber so können die Trennzeichen beliebig gewählt werden
    *dest\Byte[0] = Val("$" + Mac_String\Stringfields\Byte1)
    *dest\Byte[1] = Val("$" + Mac_String\Stringfields\Byte2)
    *dest\Byte[2] = Val("$" + Mac_String\Stringfields\Byte3)
    *dest\Byte[3] = Val("$" + Mac_String\Stringfields\Byte4)
    *dest\Byte[4] = Val("$" + Mac_String\Stringfields\Byte5)
    *dest\Byte[5] = Val("$" + Mac_String\Stringfields\Byte6)
   
    ProcedureReturn #True
  EndProcedure
 
  ; *dest = Zeiger mit einer MacAddress-Struktur
  ; Mac.s = MacAddress als String (z.B. 11:22:33:44:55:66 oder 11-22-33-44-55-66)
  Procedure createMagicPacket(*Dest.MagicPacket, Mac.s)
    Protected i.b, j.b
    Protected MacAddress.MacAddress
   
    createMacAdress(@MacAddress, Mac)
   
    For i = 0 To 5              ; Header erstellen ($FFFFFFFFFFFF)
      *Dest\Header[i] = $FF
    Next
    For i = 0 To 15             ; erstelle 16 x Mac
      For j = 0 To 5
        *Dest\Mac[i]\Byte[j] = MacAddress\Byte[j]
      Next j
    Next i
   
    ProcedureReturn #True 
  EndProcedure
 
 
  ; BENÖTIGT: InitNetwork()
  ; Linux: Broadcast muss 255.255.255.255, die lokale Broadcast Addresse oder eine direkte IP sein
  ; Win: für Broadcast ist alles außer 255.255.255.255 zulässig
  Procedure sendMagicPacket(Mac.s, Broadcast.s = "10.255.255.255", Port = 9)
    Protected MagicPacket.MagicPacket
    createMagicPacket(@MagicPacket, Mac)
   
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected cID                 ; ConnectionID
        Protected sendBytes.w
        Protected BufferLength = SizeOf(MagicPacket)
       
        cID = OpenNetworkConnection(Broadcast, Port, #PB_Network_UDP)
        If cID
          sendBytes = SendNetworkData(cID, @MagicPacket, BufferLength)
          If sendBytes = -1
            Debug "WOL::sendMagicPacket(): keine Daten übertragen" ; TODO Debug wenn nicht gewünscht entfernen/ändern
            CloseNetworkConnection(cID)
            ProcedureReturn #False
          ElseIf sendBytes = BufferLength
            CloseNetworkConnection(cID)
            ProcedureReturn #True
          Else
            Debug "WoL::sendMagicPacket(): Puffer / übertragene Daten unterschiedlich: " +
                  Str(sendBytes) + "/" + Str(BufferLength) ; TODO Debug wenn nicht gewünscht entfernen/ändern
             ProcedureReturn #False
          EndIf
        Else
          Debug "WoL::sendMagicPacket(): Kann Netzwrkverbindung nicht herstellen" ; TODO Debug wenn nicht gewünscht entfernen/ändern
          ProcedureReturn #False
        EndIf
        ProcedureReturn #True
       
      CompilerCase #PB_OS_Linux
        Protected TxAddr.sockaddr_in  ; Structur-Zeiger für Socket-Erstellung
        Protected Socket.i
        Protected argp.l      ; Zeiger für Parameterübergabe
        Protected Addr_Broadcast  ; wir brauchen eine numerische IP
        Addr_Broadcast = MakeIPAddress(Val(StringField(Broadcast, 1, ".")),Val(StringField(Broadcast, 2, ".")),
                                       Val(StringField(Broadcast, 3, ".")), Val(StringField(Broadcast, 4, ".")))
       
        ; Socket erstellen
        Socket = SOCKET_(#IP_Family, #Socket_DGRAM, 0)
        If Socket = #INVALID_SOCKET
          Debug "SocketFehler" ; TODO Debug wenn nicht gewünscht entfernen/ändern
          ProcedureReturn #False
        EndIf
       
        ; Blocking abschalten
        argp = 1
        ioctl_(Socket, #FIONBIO, @argp)
       
        ; Broadcasts erlauben
        argp = Addr_Broadcast ; oder $FFFFFFFF
        setsockopt_(Socket, #SOL_SOCKET, #SO_BROADCAST, @argp, 4)
       
        ; Daten-Zeiger erzeugen
        TxAddr\IP_Family = #IP_Family
        TxAddr\Port = htons_(Port)   ;PortNr.
        TxAddr\Addr = Addr_Broadcast
       
        ;senden
        sendto_(Socket, @MagicPacket, SizeOf(MagicPacket) , 0, @TxAddr, SizeOf(sockaddr_in))
       
        ;schließen
        close_(Socket)
        ProcedureReturn #True
       
    CompilerEndSelect
   
    ProcedureReturn #False
  EndProcedure 
EndModule

CompilerIf #PB_Compiler_IsMainFile
 
  ; Netzwerk MUSS initialisiert sein:
  InitNetwork()
 
  a=WoL::sendMagicPacket("AA:BB:CC:DD:EE:FF", "127.255.255.255", 9)
  Debug a
  
  UseModule WoL
  sendMagicPacket("AA:BB:CC:DD:EE:FF", "127.255.255.255", 9)
  
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
