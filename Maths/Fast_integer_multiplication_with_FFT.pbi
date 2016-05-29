;    Description: Fast integer multiplication with FFT
;         Author: Helle
;           Date: 2016-04-23
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=334591#p334591
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_Unicode
  CompilerError "Only for ascii mode!"
CompilerEndIf

;- Schnelle Integer-Multiplikation mit FFT für große Zahlen
;- Bis auf die max.Länge keine Einschränkungen mehr bei den Faktoren!
;- Kein Unicode bei Strings!
;- Zur Erhöhung des Wertebereiches wird mit 80-Bit-FPU gerechnet
;- Getestet bis Faktoren-Länge 128MB mit CPU Intel i7-6700K @4.7GHz und RAM 32GB DDR4
;- Berechnungs-Schema läuft ab nach Schmetterlingsgraph
;- Keine Fremd-Bibliotheken, keine globalen Variablen
;- Zur besseren Orientierung im Code ist der Großteil des PB-Codes noch auskommentiert enthalten. Kann natürlich entfernt werden (wie auch die Infos)
;- Windows7/64, PureBasic 5.41 LTS (x64)
;- "Helle" Klaus Helbing, 06.01.2016

Procedure.s FFT_Mul(LFak1, LFak2, PFak1, PFak2)
  EnableASM
  ;EnableExplicit ;war für Übersicht mal nötig
  Protected.q BufferCos, BufferCosA, BufferDez, BufferDezA, BufferFX, BufferFXA, BufferFaktor1, BufferFaktor1A
  Protected.q BufferFaktor2, BufferFaktor2A, BufferProdukt, BufferProduktA, BufferSin, BufferSinA, N
  Protected.q Exponent, L1, TA_Gesamt, TE_Gesamt, TA_Faktoren, TE_Faktoren, TA_Winkel, TE_Winkel, TA_FFT, TE_FFT
  Protected.q TA_Multi, TE_Multi, TA_Rueck, TE_Rueck, TA_Ergebnis, TE_Ergebnis
  Protected.s sAusgabe, sProdukt, sFaktor, sExpo, sWinkel, sFaktoren, sFFT, sMulti, sRueck, sErgebnis, sGesamt

  If #PB_Compiler_Unicode      ;das jetzt noch für Unicode zu machen schenke ich mir
    sAusgabe = "Achtung! Bei Strings als Faktoren kein Unicode verwenden!" + #LFCR$ + #LFCR$
  EndIf

  ;PF1 = PFak1
  !mov r8,[p.v_PFak1]        ;zur Sicherheit so, sonst r8 direkt (als erstes natürlich)
  !mov [PF1],r8
  ;PF2 = PFak2
  !mov r9,[p.v_PFak2]        ;zur Sicherheit so, sonst r9 direkt
  !mov [PF2],r9

  ;L1 = LFak1
  !mov rax,[p.v_LFak1]       ;zur Sicherheit so, sonst rcx direkt
  !mov [L1],rax
  ;LNull11 = L1               ;echte Länge, auch hier Null-Test möglich
  !mov [LNull11],rax         ;echte Länge, auch hier Null-Test möglich
  ;L2 = LFak2
  !mov rdx,[p.v_LFak2]       ;zur Sicherheit so, sonst rdx direkt
  !mov [L2],rdx
  ;LNull22 = L2
  !mov [LNull22],rdx

  ;If L1 < L2
  ;  LNull1 = L1              ;hier als Zwischenspeicher
  ;  L1 = L2                  ;größte Länge ermitteln; evtl. hier auf Null testen
  ;  L2 = LNull1
  ;EndIf
  !cmp rax,rdx
  !jae @f
    !mov rcx,rax
    !mov [L1],rdx
    !mov [L2],rcx
  !@@:
  ;LenF = L1
  !mov rdx,[L1]
  !mov [LenF],rdx            ;LenF erstmal setzen, könnte ja schon 2-er Potenz sein

  !bsr rcx,[L1]              ;höchstes gesetztes Bit
  !bsf rdx,[L2]              ;Test auf Länge Null
  !jz @f
    !mov [Exponent],rcx
    !bsf rdx,[L1]            ;niedrigstes gesetztes Bit
    !jmp .Faktoren_OK        ;local label
  !@@:
  sAusgabe + #LFCR$ + "Fehler: Mindestens einer der Faktoren hat Länge Null!"
 ProcedureReturn sAusgabe

  !.Faktoren_OK:
  !cmp rcx,rdx
  !je @f                     ;also nur 1 Bit (identisch) gesetzt, ist 2-er Potenz
    !inc rcx
    !mov rax,1
    !shl rax,cl
    !mov [LenF],rax          ;LenF ist jetzt 2-er Potenz
    !add [Exponent],1
  !@@:
  !add [Exponent],1

  !mov rcx,3                 ;Produkt-Länge muss mindestens 8 sein, sonst an anderen Stellen Klimmzüge
  !sub rcx,[Exponent]
  !js @f                     ;Exponent ist > 3 (Hauptfall)
  !jz @f                     ;Exponent ist = 3
    !shl [LenF],cl
    !add [Exponent],rcx
  !@@:

  !push [Exponent]           ;die beiden nur für Anzeige, blanke Optik!
  POP Exponent
  !push [L1]
  POP L1

  !cmp [Exponent],28
  !jbe @f
    sAusgabe + " Hinweis: Diese Größenordnung ist ungetestet! Keine Garantie auf Richtigkeit!"+ #LFCR$  ;Space am Anfang beachten!
  !@@:

  ;N = LenF << 1
  !mov rax,[LenF]
  !shl rax,1
  !mov [N],rax
  !push [N]
  POP N                      ;wird für AllocateMemory benötigt!

  ;LNull1 = LenF - LNull11    ;LNull11=echte Länge. Bei LNull1 fängt hinterstes Byte an
  !mov rax,[LenF]
  !sub rax,[LNull11]
  !mov [LNull1],rax
  ;LNull2 = LenF - LNull22
  !mov rax,[LenF]
  !sub rax,[LNull22]
  !mov [LNull2],rax
  ;L1hinten = LenF >> 1       ;LenF ist 2-er Potenz
  ;L2hinten = LenF >> 1
  !mov rax,[LenF]
  !shr rax,1
  !mov [L1hinten],rax
  !mov [L2hinten],rax
  ;If LNull11 < L1hinten
    ;L1hinten = LNull11
  ;EndIf
  !cmp rax,[LNull11]
  !jbe @f
    !mov rax,[LNull11]
    !mov [L1hinten],rax
  !@@:
  ;L1vorn = LNull11 - L1hinten
  !mov rax,[LNull11]
  !sub rax,[L1hinten]
  !mov [L1vorn],rax
  ;If LNull22 < L2hinten
    ;L2hinten = LNull22
  ;EndIf
  !mov rax,[L2hinten]
  !cmp rax,[LNull22]
  !jbe @f
    !mov rax,[LNull22]
    !mov [L2hinten],rax
  !@@:
  ;L2vorn = LNull22 - L2hinten
  !mov rax,[LNull22]
  !sub rax,[L2hinten]
  !mov [L2vorn],rax

  ;Register-, Status- und Control- Speicher-Reservierung
  BufferFX = AllocateMemory(512 + 64)
  If BufferFX
    BufferFXA = BufferFX + (64 - (BufferFX & $3F))    ;64-er Alignment, klotzen, nicht kleckern!
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferFX!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferFXA
  !pop [BufferFXA]

  !mov rax,[BufferFXA]
  !fxsave64 [rax]            ;sichert erstmal komplett FPU und XMM (0-15). Lass ich mal so, obwohl FNSAVE auch reichen würde. Dann aber so keine Register-Sicherung
  !mov [rax+464],rdi         ;callee-save registers sichern, also auf RBX und RBP verzichten
  !mov [rax+472],rsi
  !mov [rax+480],r12
  !mov [rax+488],r13
  !mov [rax+496],r14
  !mov [rax+504],r15

  ;FFT-Speicher-Reservierung; 10=80Bit
  BufferSin = AllocateMemory((N * 10) + 128)          ;#PB_Memory_NoClear besser nicht
  If BufferSin
    BufferSinA = BufferSin + (64 - (BufferSin & $3F)) ;64-er Alignment, klotzen, nicht kleckern!
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferSin!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferSinA            ;Protected nach FAsm
  !pop [BufferSinA]

  BufferCos = AllocateMemory((N * 10) + 128)
  If BufferCos
    BufferCosA = BufferCos + (64 - (BufferCos & $3F)) ;64-er Alignment
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferCos!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferCosA
  !pop [BufferCosA]

  BufferFaktor1 = AllocateMemory((2 * N * 10) + 128)
  If BufferFaktor1
    BufferFaktor1A = BufferFaktor1 + (64 - (BufferFaktor1 & $3F))    ;64-er Alignment
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferFaktor1!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferFaktor1A
  !pop [BufferFaktor1A]

  BufferFaktor2 = AllocateMemory((2 * N * 10) + 128)
  If BufferFaktor2
    BufferFaktor2A = BufferFaktor2 + (64 - (BufferFaktor2 & $3F))    ;64-er Alignment
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferFaktor2!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferFaktor2A
  !pop [BufferFaktor2A]

  ;======================================================================================
  TA_Gesamt = ElapsedMilliseconds()
  TA_Faktoren = ElapsedMilliseconds()
  ;Faktoren bearbeiten
  ;Zuerst die Ziffern gemäß reverse Verteilung neu setzen, dabei gleich in Long konvertieren
  !mov r12d,55555555h
  !mov r13d,33333333h
  !mov r14d,0F0F0F0Fh
  !mov r15d,00FF00FFh
  !mov rcx,32
  !sub rcx,[Exponent]

  ;For i = (N / 4) - 1 To 0 Step -1
  !xor r11,r11               ;FakPos
  !mov r10,[N]
  !shr r10,2
  !mov rdx,r10               ;j = N >> 2
  !dec r10                   ;hier nötig

  !.RevPosLoop:              ;local label
    !mov r8,r11              ;müssen für reverse Bits dann 32-Bit-Register sein!
    !shr r8d,1
    !and r8d,r12d
    !mov edi,r11d
    !and edi,r12d
    !shl edi,1
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,2
    !and r8d,r13d
    !and edi,r13d
    !shl edi,2
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,4
    !and r8d,r14d
    !and edi,r14d
    !shl edi,4
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,8
    !and r8d,r15d
    !and edi,r15d
    !shl edi,8
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,16
    !shl edi,16
    !or r8d,edi              ;r8=RevPos

    !shr r8d,cl              ;cl=32-Exponent
    !shl r8d,1               ;lieber doch so

    ;If L1hinten <= 0
      ;WL = 0
     ;Else
      ;WL = PeekB(PF1 + i + j - LNull1) & $F     ;statt -30h; sicherer bei anderer Quelle als String
      ;L1hinten - 1
    ;EndIf
    ;PokeL(BufferSinA + RevPos, WL)
    !xor r9,r9               ;WL=r9d
    !cmp [L1hinten],0
    !jbe @f
      !mov rax,[PF1]
      !add rax,r10
      !sub rax,[LNull1]
      !movzx r9d,byte[rax+rdx]    ;rdx=j
      !and r9d,0fh
      !dec [L1hinten]
    !@@:
    !mov rax,[BufferSinA]
    !mov dword[rax+r8],r9d

    ;If L2hinten <= 0
      ;WL = 0
     ;Else
      ;WL = PeekB(PF2 + i + j - LNull2) & $F
      ;L2hinten - 1
    ;EndIf
    ;PokeL(BufferCosA + RevPos, WL)
    !xor r9,r9               ;WL=r9d
    !cmp [L2hinten],0
    !jbe @f
      !mov rax,[PF2]
      !add rax,r10
      !sub rax,[LNull2]
      !movzx r9d,byte[rax+rdx]    ;rdx=j
      !and r9d,0fh
      !dec [L2hinten]
    !@@:
    !mov rax,[BufferCosA]
    !mov dword[rax+r8],r9d

    ;RevPos + 4
    !add r8,4

    ;If L1vorn <= 0
      ;WL = 0
     ;Else
      ;WL = PeekB(PF1 + i - LNull1) & $F
      ;L1vorn - 1
    ;EndIf
    ;PokeL(BufferSinA + RevPos, WL)
    !xor r9,r9               ;WL=r9d
    !cmp [L1vorn],0
    !jbe @f
      !mov rax,[PF1]
      !add rax,r10
      !sub rax,[LNull1]
      !movzx r9d,byte[rax]
      !and r9d,0fh
      !dec [L1vorn]
    !@@:
    !mov rax,[BufferSinA]
    !mov dword[rax+r8],r9d

    ;If L2vorn <= 0
      ;WL = 0
     ;Else
      ;WL = PeekB(PF2 + i - LNull2) & $F
      ;L2vorn - 1
    ;EndIf
    ;PokeL(BufferCosA + RevPos, WL)
    !xor r9,r9               ;WL=r9d
    !cmp [L2vorn],0
    !jbe @f
      !mov rax,[PF2]
      !add rax,r10
      !sub rax,[LNull2]
      !movzx r9d,byte[rax]
      !and r9d,0fh
      !dec [L2vorn]
    !@@:
    !mov rax,[BufferCosA]
    !mov dword[rax+r8],r9d
    ;FakPos + 1
    !inc r11
    !dec r10                 ;i
  ;Next
  !jns .RevPosLoop

  ;--------------------------------------------------------
  ;die Integer-DWords in 80-Bit-Floats konvertieren und abspeichern
  ;j = 0
  !fninit                              ;FPU wurde gesichert mit fxsave64

  !xor r13,r13               ;i
  !xor r14,r14               ;j
  !mov r15,[N]
  !shl r15,1
  ;For i = 0 To 2 * N Step 4            ;Step 4 = Long
  !@@:
    ;WL = PeekL(BufferSinA + i)
    ;WR = WL
    ;PokeD(BufferFaktor1A + j, WR)
    ;PokeD(BufferFaktor1A + j + 16, WR)
    ;P1 = BufferSinA + i
    !mov rcx,[BufferSinA]
    !add rcx,r13             ;P1=rcx
    ;P2 = BufferFaktor1A + j
    !mov rdx,[BufferFaktor1A]
    !add rdx,r14             ;P2=rdx
    !fild dword[rcx]
    !fld st0                 ;st0 und st1
    !fstp tword[rdx]         ;Real-Wert
    !fstp tword[rdx+20]      ;gedoppelter Real-Wert. Die dazwischen liegenden Imaginär-Werte sind Null (von AllocateMemory, deshalb dort nicht #PB_Memory_NoClear)
    ;WL = PeekL(BufferCosA + i)
    ;WR = WL
    ;PokeD(BufferFaktor2A + j, WR)
    ;PokeD(BufferFaktor2A + j + 16, WR)
    ;P1 = BufferCosA + i
    !mov rcx,[BufferCosA]
    !add rcx,r13             ;P1=rcx
    ;P2 = BufferFaktor2A + j
    !mov rdx,[BufferFaktor2A]
    !add rdx,r14             ;P2=rdx
    !fild dword[rcx]
    !fld st0                 ;st0 und st1
    !fstp tword[rdx]
    !fstp tword[rdx+20]
    ;j + 40
    !add r14,40

    !add r13,4
    !sub r15,4
  ;Next
  !jnz @b
  TE_Faktoren = ElapsedMilliseconds() - TA_Faktoren

  ;========================================================
  ;Winkel erst hier, weil BufferSinA und BufferCosA oben "missbraucht" werden
  TA_Winkel = ElapsedMilliseconds()
  ;Rad1 = Pi / LenF
  !fldpi
  !fild qword[LenF]
  !fdivp st1,st0
  !fstp tword[Rad1]

  ;SinCos; da dies lahm ist und sowieso beide Werte benötigt werden, wird nur bis Pi/4 (45°) ermittelt und der Rest (bis 180°) nur umkopiert
  !xor r14,r14                         ;P00
  !mov r8,[BufferSinA]
  !mov r9,[BufferCosA]
  !mov r10,10                          ;80Bit=10 Bytes
  !lea r11,[Sin]
  !lea r12,[Cos]
  !mov rcx,[N]
  !shr rcx,3
  ;For k = 0 To (N >> 3)
  !@@:
    ;Rad = Rad1 * k                     ;nicht aufaddieren! Zu ungenau
    !fld tword[Rad1]
    !push r14
    !fild qword[rsp]                   ;geht nur mit Mem
    !pop r14
    !fmulp st1,st0
    ;Si = Sin(Rad)
    ;Co = Cos(Rad)
    !fsincos
    !fstp tword[Cos]                   ;nebenbei, FST kann tword nicht
    !fstp tword[Sin]
    ;PokeD(BufferSinA + k * 8, Si)     ;0-45°
    !mov rax,r14                       ;[v_P00]
    !mul r10
    !mov r13,rax                       ;k * 8
    !add rax,r8
    !add r13,r9
    !fld tword[r11]
    !fstp tword[rax]                   ;Sin 0-45°
    ;PokeD(BufferCosA + k * 8, Co)     ;0-45°
    !fld tword[r12]
    !fstp tword[r13]                   ;Cos 0-45°
    ;PokeD(BufferCosA + ((N >> 2) - k) * 8, Si)  ;45-90°
    !mov rax,[LenF]
    !shr rax,1
    !sub rax,r14                       ;[v_P00]
    !mul r10
    !mov r13,rax
    !add rax,r9
    !add r13,r8
    !fld tword[r11]
    !fstp tword[rax]                   ;Cos 45-90°
    ;PokeD(BufferSinA + ((N >> 2) - k) * 8, Co)  ;45-90°
    !fld tword[r12]
    !fstp tword[r13]                   ;Sin 45-90°
    ;PokeD(BufferCosA + ((N >> 2) + k) * 8, -Si) ;90-135°
    !mov rax,[LenF]
    !shr rax,1
    !add rax,r14                       ;[v_P00]
    !mul r10
    !mov r13,rax
    !add rax,r9
    !add r13,r8
    !fld tword[r11]
    !fchs
    !fstp tword[rax]                   ;Cos 90-135°
    ;PokeD(BufferSinA + ((N >> 2) + k) * 8, Co)  ;90-135°
    !fld tword[r12]
    !fstp tword[r13]                   ;Sin 90-135°
    ;PokeD(BufferCosA + (LenF - k) * 8, -Co)     ;135-180°
    !mov rax,[LenF]
    !sub rax,r14                       ;[v_P00]
    !mul r10
    !mov r13,rax
    !add rax,r9
    !add r13,r8
    !fld tword[r12]
    !fchs
    !fstp tword[rax]                   ;Cos 135-180°
    ;PokeD(BufferSinA + (LenF - k) * 8, Si) ;135-180°
    !fld tword[r11]
    !fstp tword[r13]                   ;Sin 135-180°

    !inc r14                           ;[v_P00]
    !dec rcx
  ;Next
  !jns @b
  TE_Winkel = ElapsedMilliseconds() - TA_Winkel

  ;========================================================
  ;Faktor1
  TA_FFT = ElapsedMilliseconds()
  ;Pointer0 = 2
  !mov r12,2
  ;Pointer1 = 0
  !xor rdi,rdi
  ;Pointer2 = Pointer0
  !mov rsi,r12
  !mov r13,2
  ;While Pointer2 < N
  !.OuterLoopF1:
    ;While Pointer2 < N
    !.InnerLoopF1:
      !mov r14,r12
      ;For k = 1 To Pointer0
      !@@:
        ;EW = (N / Pointer0 << 1) * Pointer1 * 10
        !mov r8,[N]
        !mov rax,10
        !mul rdi
        !mov rcx,r13
        !shr r8,cl
        !mul r8
        !mov r15,rax              ;EW=r15

        ;P0 = Pointer2 * 20
        !mov rax,20
        !mul rsi                  ;P0=rax
        ;P1 = BufferFaktor1A + P0
        !mov rcx,[BufferFaktor1A]
        !add rcx,rax              ;P1=rcx
        ;P5 = (Pointer2 - Pointer0) * 20
        ;P6 = BufferFaktor1A + P5
        !mov rax,rsi
        !sub rax,r12
        !mov r10,20               ;imul will ich nicht
        !mul r10                  ;P5=rax   an dieser Stelle wegen rdx
        !add rax,[BufferFaktor1A] ;=P6
        ;P2 = BufferCosA + EW
        !mov rdx,[BufferCosA]
        !add rdx,r15
        ;P3 = BufferFaktor1A + 10 + P0
        !mov r8,rcx
        !add r8,10
        ;P4 = BufferSinA + EW
        !mov r9,[BufferSinA]
        !add r9,r15               ;P4=r9
        ;WR = (PeekD(BufferFaktor1A + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) - PeekD(BufferFaktor1A + 8 + 2*Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WR = PeekD(P1) * PeekD(P2) - PeekD(P3) * PeekD(P4)
        !fld tword[rcx]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[r8]
        !fld tword[r9]
        !fmulp st1,st0
        !fsubp st1,st0
        !fstp tword[WR]
        ;WI = (PeekD(BufferFaktor1A + 8 + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) + PeekD(BufferFaktor1A + 2 * Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WI = PeekD(P3) * PeekD(P2) + PeekD(P1) * PeekD(P4)
        !fld tword[r8]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[rcx]
        !fld tword[r9]
        !fmulp st1,st0
        !faddp st1,st0
        !fstp tword[WI]
        ;ZR = PeekD(BufferFaktor1A + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZR = PeekD(P6)
        ;PokeD(BufferFaktor1A + 2 * (Pointer2 - Pointer0) * 8, ZR + WR)
        ;->PokeD(P6, ZR + WR)
        !fld tword[rax]
        !fld st0
        !fstp tword[ZR]
        !fld tword[WR]
        !faddp st1,st0
        !fstp tword[rax]
        ;P7 = P6 + 10             ;P6=rax
        ;ZI = PeekD(BufferFaktor1A + 8 + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZI = PeekD(P7)
        ;PokeD(BufferFaktor1A + 8 + 2 * (Pointer2 - Pointer0) * 8, ZI + WI)
        ;->PokeD(P7, ZI + WI)
        !fld tword[rax+10]
        !fld st0
        !fstp tword[ZI]
        !fld tword[WI]
        !faddp st1,st0
        !fstp tword[rax+10]
        ;PokeD(BufferFaktor1A + 2 * Pointer2 * 8, ZR - WR)
        ;->PokeD(P1, ZR - WR)
        !fld tword[ZR]
        !fld tword[WR]
        !fsubp st1,st0
        !fstp tword[rcx]
        ;PokeD(BufferFaktor1A + 8 + 2 * Pointer2 * 8, ZI - WI)
        ;->PokeD(P3, ZI - WI)
        !fld tword[ZI]
        !fld tword[WI]
        !fsubp st1,st0
        !fstp tword[r8]
        ;Pointer1 + 1
        !inc rdi;[v_Pointer1]
        ;Pointer2 + 1
        !inc rsi;[v_Pointer2]
        !dec r14
      ;Next
      !jnz @b

      ;Pointer1 = 0
      !xor rdi,rdi
     ;Pointer2 + Pointer0
      !add rsi,r12
    ;Wend     While Pointer2 < N
      !cmp rsi,[N]
    !jb .InnerLoopF1

    !inc r13
    ;Pointer0 << 1
    !shl r12,1
    ;Pointer1 = 0
    !xor rdi,rdi
    ;Pointer2 = Pointer0
    !mov rsi,r12
  ;Wend     While Pointer2 < N
    !cmp rsi,[N]
  !jb .OuterLoopF1

  ;========================================================
  ;Faktor2
  ;Pointer0 = 2
  !mov r12,2
  ;Pointer1 = 0
  !xor rdi,rdi
  ;Pointer2 = Pointer0
  !mov rsi,r12
  !mov r13,2
  ;While Pointer2 < N
  !.OuterLoopF2:
    ;While Pointer2 < N
    !.InnerLoopF2:
      ;For k = 1 To Pointer0
        !mov r14,r12
      !@@:
        ;EW = (N / Pointer0 << 1) * Pointer1 * 10
        !mov r8,[N]
        !mov rax,10
        !mul rdi
        !mov rcx,r13
        !shr r8,cl
        !mul r8
        !mov r15,rax              ;EW=r15

        ;P0 = Pointer2 * 20
        !mov rax,20
        !mul rsi                  ;P0=rax
        ;P1 = BufferFaktor2A + P0
        !mov rcx,[BufferFaktor2A]
        !add rcx,rax   ;P1=rcx
        ;P5 = (Pointer2 - Pointer0) * 20
        ;P6 = BufferFaktor2A + P5
        !mov rax,rsi
        !sub rax,r12
        !mov r10,20               ;imul will ich nicht
        !mul r10                  ;P5=rax   an dieser Stelle wegen rdx
        !add rax,[BufferFaktor2A] ;=P6
        ;P2 = BufferCosA + EW
        !mov rdx,[BufferCosA]
        !add rdx,r15;[v_EW];P2=rdx
        ;P3 = BufferFaktor2A + 10 + P0
        !mov r8,rcx
        !add r8,10
        ;P4 = BufferSinA + EW
        !mov r9,[BufferSinA]
        !add r9,r15   ;[v_EW];P4=r9
        ;WR = (PeekD(BufferFaktor2A + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) - PeekD(BufferFaktor2A + 8 + 2*Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WR = PeekD(P1) * PeekD(P2) - PeekD(P3) * PeekD(P4)
        !fld tword[rcx]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[r8]
        !fld tword[r9]
        !fmulp st1,st0
        !fsubp st1,st0
        !fstp tword[WR]
        ;WI = (PeekD(BufferFaktor2A + 8 + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) + PeekD(BufferFaktor2A + 2 * Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WI = PeekD(P3) * PeekD(P2) + PeekD(P1) * PeekD(P4)
        !fld tword[r8]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[rcx]
        !fld tword[r9]
        !fmulp st1,st0
        !faddp st1,st0
        !fstp tword[WI]
        ;ZR = PeekD(BufferFaktor2A + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZR = PeekD(P6)
        ;PokeD(BufferFaktor2A + 2 * (Pointer2 - Pointer0) * 8, ZR + WR)
        ;->PokeD(P6, ZR + WR)
        !fld tword[rax]
        !fld st0
        !fstp tword[ZR]
        !fld tword[WR]
        !faddp st1,st0
        !fstp tword[rax]
        ;P7 = P6 + 10             ;P6=rax
        ;ZI = PeekD(BufferFaktor2A + 8 + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZI = PeekD(P7)
        ;PokeD(BufferFaktor2A + 8 + 2 * (Pointer2 - Pointer0) * 8, ZI + WI)
        ;->PokeD(P7, ZI + WI)
        !fld tword[rax+10]
        !fld st0
        !fstp tword[ZI]
        !fld tword[WI]
        !faddp st1,st0
        !fstp tword[rax+10]
        ;PokeD(BufferFaktor2A + 2 * Pointer2 * 8, ZR - WR)
        ;->PokeD(P1, ZR - WR)
        !fld tword[ZR]
        !fld tword[WR]
        !fsubp st1,st0
        !fstp tword[rcx]
        ;PokeD(BufferFaktor2A + 8 + 2 * Pointer2 * 8, ZI - WI)
        ;->PokeD(P3, ZI - WI)
        !fld tword[ZI]
        !fld tword[WI]
        !fsubp st1,st0
        !fstp tword[r8]
        ;Pointer1 + 1
        !inc rdi
        ;Pointer2 + 1
        !inc rsi
        !dec r14
      ;Next
      !jnz @b

      ;Pointer1 = 0
      !xor rdi,rdi
      ;Pointer2 + Pointer0
      !add rsi,r12
    ;Wend     While Pointer2 < N
      !cmp rsi,[N]
    !jb .InnerLoopF2

    !inc r13
    ;Pointer0 << 1
    !shl r12,1
    ;Pointer1 = 0
    !xor rdi,rdi
    ;Pointer2 = Pointer0
    !mov rsi,r12
  ;Wend     While Pointer2 < N
    !cmp rsi,[N]
  !jb .OuterLoopF2
  TE_FFT = ElapsedMilliseconds() - TA_FFT

  ;========================================================
  ;Und jetzt die beiden transformierten Vektoren miteinander multiplizieren
  TA_Multi = ElapsedMilliseconds()
  !mov r10,[N]               ;ohne -1, dafür unten jnz und nicht jns
  !xor rax,rax               ;rax=P0
  ;For k = 0 To N - 1
  !@@:
    ;P1 = BufferFaktor1A + P0
    !mov rcx,[BufferFaktor1A]
    !add rcx,rax             ;rcx=P1
    ;P2 = BufferFaktor2A + P0
    !mov rdx,[BufferFaktor2A]
    !add rdx,rax
    ;P3 = BufferFaktor1A + 10 + P0
    !mov r8,rcx
    !add r8,10               ;r8=P3
    ;P4 = BufferFaktor2A + 10 + P0
    !mov r9,rdx
    !add r9,10               ;r9=P4
    ;WR = (PeekD(BufferFaktor1A + 2 * k * 8) * PeekD(BufferFaktor2A + 2 * k * 8)) - (PeekD(BufferFaktor1A + 8 + 2 * k * 8) * PeekD(BufferFaktor2A + 8 + 2 * k * 8))    ;hier kann nicht direkt in BufferFaktor1RA geschrieben werden
    ;->WR = PeekD(P1) * PeekD(P2) - PeekD(P3) * PeekD(P4)
    !fld tword[rcx]
    !fld tword[rdx]
    !fmulp st1,st0
    !fld tword[r8]
    !fld tword[r9]
    !fmulp st1,st0
    !fsubp st1,st0
    !fstp tword[WR]

    ;PokeD(BufferFaktor1A + 8 + 2 * k * 8, (PeekD(BufferFaktor1A + 2 * k * 8) * PeekD(BufferFaktor2A + 8 + 2 * k * 8)) + (PeekD(BufferFaktor1A + 8 + 2 * k * 8) * PeekD(BufferFaktor2A + 2 * k * 8)))
    ;->PokeD(P3, PeekD(P1) * PeekD(P4) + PeekD(P3) * PeekD(P2))
    !fld tword[rcx]
    !fld tword[r9]
    !fmulp st1,st0
    !fld tword[r8]
    !fld tword[rdx]
    !fmulp st1,st0
    !faddp st1,st0
    !fstp tword[r8]

    ;PokeD(BufferFaktor1A + 2 * k * 8, WR)  ;weil vorher BufferFaktor1RA noch benötigt wird
    ;->PokeD(P1, WR)
    !fld tword[WR]
    !fstp tword[rcx]

    !add rax,20              ;rax=P0=k*20
    !dec r10
  ;Next
  !jnz @b
  TE_Multi = ElapsedMilliseconds() - TA_Multi

  ;========================================================
  ;Die Produkt-Werte wieder revers "verteilen"
  TA_Rueck = ElapsedMilliseconds()
  !mov r12d,55555555h
  !mov r13d,33333333h
  !mov r14d,0F0F0F0Fh
  !mov r15d,00FF00FFh
  !mov rcx,32
  !sub rcx,[Exponent]

  !xor r11,r11               ;Zähler und FakPos zugleich
  !mov r10,[N]
  !shr r10,1
  ;For i = 0 To (N / 2) - 1
  !@@:                       ;erste und letzte Ziffern könnten übergangen werden
    !mov r8,r11              ;müssen für reverse Bits 32-Bit-Register sein!!!
    !shr r8d,1
    !and r8d,r12d
    !mov edi,r11d
    !and edi,r12d
    !shl edi,1
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,2
    !and r8d,r13d
    !and edi,r13d
    !shl edi,2
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,4
    !and r8d,r14d
    !and edi,r14d
    !shl edi,4
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,8
    !and r8d,r15d
    !and edi,r15d
    !shl edi,8
    !or r8d,edi

    !mov edi,r8d             ;sichern
    !shr r8d,16
    !shl edi,16
    !or r8d,edi              ;r8=RevPos

    !shr r8d,cl              ;cl=32-Exponent

    ;PokeD(BufferFaktor2A + 2 * 8 * RevPos, PeekD(BufferFaktor1A + 2 * i * 8))
    ;P1 = BufferFaktor2A + 2 * 10 * RevPos
    !mov rax,20
    !mul r8                  ;[v_RevPos]
    !add rax,[BufferFaktor2A]
    !mov rsi,rax
    ;P2 = BufferFaktor1A + 2 * i * 10
    !mov rax,20
    !mul r11
    !add rax,[BufferFaktor1A]
    !mov r9,rax

    !fld tword[rax]
    !fstp tword[rsi]
    ;PokeD(BufferFaktor2A + 8 + 2 * 8 * RevPos, PeekD(BufferFaktor1A + 8 + 2 * i * 8))
    ;P1 = P1 + 10
    ;P2 = P2 + 10
    !fld tword[rax+10]
    !fstp tword[rsi+10]
    ;PokeD(BufferFaktor2A + 2 * 8 * (RevPos + 1), PeekD(BufferFaktor1A + (2 * i * 8) + N * 8))
    ;P1 = BufferFaktor2A + 2 * 10 * (RevPos + 1)
    !inc r8
    !mov rax,20
    !mul r8
    !add rax,[BufferFaktor2A]
    !mov rsi,rax
    ;P2 = BufferFaktor1A + (2 * i * 10) + N * 10
    ;P2 + N * 10
    !mov rax,10
    !mul [N]
    !add rax,r9
    !fld tword[rax]
    !fstp tword[rsi]
    ;PokeD(BufferFaktor2A + 8 + 2 * 8 * (RevPos + 1), PeekD(BufferFaktor1A + 8 + (2 * i * 8) + N * 8))
    ;P1 = P1 + 10
    ;P2 = P2 + 10
    !fld tword[rax+10]
    !fstp tword[rsi+10]

    !inc r11                 ;ist auch FakPos
    !dec r10
  ;Next
  !jnz @b
  FreeMemory(BufferFaktor1)

  ;========================================================
  ;Anfangswerte verteilen für FFT
  !xor rax,rax               ;rax=P0
  !mov r10,[N]               ;ohne -2, dafür unten jnz und nicht jns
  ;For i = 0 To N - 2 Step 2
  !@@:
    ;P00 = (i + 1) * 20
    ;->P00 = P0 + 20
    ;P1 = BufferFaktor2A + P0
    !mov rcx,[BufferFaktor2A]
    !add rcx,rax             ;rcx=P1
    ;P2 = BufferFaktor2A + P00
    !mov rdx,rcx
    !add rdx,20              ;rdx=P2
    ;P3 = BufferFaktor2A + 10 + P0
    !mov r8,rcx
    !add r8,10               ;r8=P3
    ;P4 = BufferFaktor2A + 10 + P00
    !mov r9,r8
    !add r9,20               ;r9=P4

    ;WR = PeekD(BufferFaktor2A + 2 * i * 8) + PeekD(BufferFaktor2A + 2 * (i + 1) * 8)
    ;->WR = PeekD(P1) + PeekD(P2)
    !fld tword[rcx]
    !fld tword[rdx]
    !faddp st1,st0
    !fstp tword[WR]
    ;WI = PeekD(BufferFaktor2A + 8 + 2 * i * 8) + PeekD(BufferFaktor2A + 8 + 2 * (i + 1) * 8)
    ;->WI = PeekD(P3) + PeekD(P4)
    !fld tword[r8]
    !fld tword[r9]
    !faddp st1,st0
    !fstp tword[WI]
    ;ZR = PeekD(BufferFaktor2A + 2 * i * 8) - PeekD(BufferFaktor2A + 2 * (i + 1) * 8)
    ;->ZR = PeekD(P1) - PeekD(P2)
    !fld tword[rcx]
    !fld tword[rdx]
    !fsubp st1,st0
    ;PokeD(BufferFaktor2A + 2 * (i + 1) * 8, ZR)
    !fstp tword[rdx]
    ;ZI = PeekD(BufferFaktor2A + 8 + 2 * i * 8) - PeekD(BufferFaktor2A + 8 + 2 * (i + 1) * 8)
    ;->ZI = PeekD(P3) - PeekD(P4)
    !fld tword[r8]
    !fld tword[r9]
    !fsubp st1,st0
    ;PokeD(BufferFaktor2A + 8 + 2 * (i + 1) * 8, ZI)
    !fstp tword[r9]
    ;PokeD(BufferFaktor2A + 2 * i * 8, WR)
    !fld tword[WR]
    !fstp tword[rcx]
    ;PokeD(BufferFaktor2A + 8 + 2 * i * 8, WI)
    !fld tword[WI]
    !fstp tword[r8]

    !add rax,40              ;P0 = i * 20
    !sub r10,2
  ;Next
  !jnz @b

  ;==========================================================
  ;nochmal FFT, jetzt aber invers (mit neg.Sinus)
  ;Pointer0 = 2
  !mov r12,2
  ;Pointer1 = 0
  !xor rdi,rdi
  ;Pointer2 = Pointer0
  !mov rsi,r12

  !mov r13,2
  ;While Pointer2 < N               ;da erstmal wahr hier fußgesteuert
  !.OuterLoopP:
    ;While Pointer2 < N
    !.InnerLoopP:
      !mov r14,r12
      ;For k = 1 To Pointer0
      !@@:
        ;EW = (N / Pointer0 << 1) * Pointer1 * 10
        !mov r8,[N]
        !mov rax,10
        !mul rdi;[v_Pointer1]
        !mov rcx,r13
        !shr r8,cl
        !mul r8
        !mov r15,rax              ;EW=r15

        ;P0 = Pointer2 * 20
        !mov rax,20
        !mul rsi                  ;P0=rax
        ;P1 = BufferFaktor2A + P0
        !mov rcx,[BufferFaktor2A]
        !add rcx,rax              ;P1=rcx
        ;P5 = (Pointer2 - Pointer0) * 20
        ;P6 = BufferFaktor2A + P5
        !mov rax,rsi
        !sub rax,r12
        !mov r10,20               ;imul will ich nicht
        !mul r10                  ;P5=rax   an dieser Stelle wegen rdx
        !add rax,[BufferFaktor2A] ;=P6
        ;P2 = BufferCosA + EW
        !mov rdx,[BufferCosA]
        !add rdx,r15
        ;P3 = BufferFaktor2A + 10 + P0
        !mov r8,rcx
        !add r8,10
        ;P4 = BufferSinA + EW
        !mov r9,[BufferSinA]
        !add r9,r15               ;P4=r9
        ;WR = (PeekD(BufferFaktor2A + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) + PeekD(BufferFaktor2A + 8 + 2*Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WR = PeekD(P1) * PeekD(P2) - PeekD(P3) * PeekD(P4)
        !fld tword[rcx]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[r8]
        !fld tword[r9]
        !fmulp st1,st0
        !faddp st1,st0
        !fstp tword[WR]
        ;WI = (PeekD(BufferFaktor2A + 8 + 2 * Pointer2 * 8) * PeekD(BufferCosA + EW) - PeekD(BufferFaktor2A + 2 * Pointer2 * 8) * PeekD(BufferSinA + EW))
        ;->WI = PeekD(P3) * PeekD(P2) + PeekD(P1) * PeekD(P4)
        !fld tword[r8]
        !fld tword[rdx]
        !fmulp st1,st0
        !fld tword[rcx]
        !fld tword[r9]
        !fmulp st1,st0
        !fsubp st1,st0
        !fstp tword[WI]
        ;ZR = PeekD(BufferFaktor2A + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZR = PeekD(P6)
        ;PokeD(BufferFaktor2A + 2 * (Pointer2 - Pointer0) * 8, ZR + WR)
        ;->PokeD(P6, ZR + WR)
        !fld tword[rax]
        !fld st0
        !fstp tword[ZR]
        !fld tword[WR]
        !faddp st1,st0
        !fstp tword[rax]
        ;P7 = P6 + 10             ;P6=rax
        ;ZI = PeekD(BufferFaktor2A + 8 + 2 * (Pointer2 - Pointer0) * 8)
        ;->ZI = PeekD(P7)
        ;PokeD(BufferFaktor2A + 8 + 2 * (Pointer2 - Pointer0) * 8, ZI + WI)
        ;->PokeD(P7, ZI + WI)
        !fld tword[rax+10]
        !fld st0
        !fstp tword[ZI]
        !fld tword[WI]
        !faddp st1,st0
        !fstp tword[rax+10]
        ;PokeD(BufferFaktor2A + 2 * Pointer2 * 8, ZR - WR)
        ;->PokeD(P1, ZR - WR)
        !fld tword[ZR]
        !fld tword[WR]
        !fsubp st1,st0
        !fstp tword[rcx]
        ;PokeD(BufferFaktor2A + 8 + 2 * Pointer2 * 8, ZI - WI)
        ;->PokeD(P3, ZI - WI)
        !fld tword[ZI]
        !fld tword[WI]
        !fsubp st1,st0
        !fstp tword[r8]
        ;Pointer1 + 1
        !inc rdi
        ;Pointer2 + 1
        !inc rsi
        !dec r14
      ;Next
      !jnz @b

      ;Pointer1 = 0
      !xor rdi,rdi
      ;Pointer2 + Pointer0
      !add rsi,r12
    ;Wend     While Pointer2 < N
      !cmp rsi,[N]
    !jb .InnerLoopP

    !inc r13
    ;Pointer0 << 1
    !shl r12,1
    ;Pointer1 = 0
    !xor rdi,rdi
    ;Pointer2 = Pointer0
    !mov rsi,r12

  ;Wend     While Pointer2 < N
    !cmp rsi,[N]
  !jb .OuterLoopP
  TE_Rueck = ElapsedMilliseconds() - TA_Rueck

  ;==========================================================
  FreeMemory(BufferCos)
  FreeMemory(BufferSin)

  TA_Ergebnis = ElapsedMilliseconds()
  ;die Doubles von FFT in Integer konvertieren und Koeffizienten aufaddieren mit Zehner-Versatz
  BufferProdukt = AllocateMemory((N * 8) + 128)
  If BufferProdukt
    BufferProduktA = BufferProdukt + (64 - (BufferProdukt & $3F)); + 64 ;64-er Alignment, +64 zur Vermeidung Unterlauf (unsauber, aber schneller!)
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferProdukt!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferProduktA
  !pop [BufferProduktA]

  BufferDez = AllocateMemory(32 + 128)   ;BufferDez ist Protected
  If BufferDez
    BufferDezA = BufferDez + (64 - (BufferDez & $3F)) ;64-er Alignment
   Else
    sAusgabe + #LFCR$ + "Fehler: Nicht genügend Speicher für BufferDez!"
 ProcedureReturn sAusgabe
  EndIf
  PUSH BufferDezA
  !pop [BufferDezA]          ;BufferDezA jetzt für FAsm

  !mov r15,[N]
  !xor r14,r14
  !lea rcx,[WR]
  !lea r10,[Dezi]
  !mov r11,[BufferDezA]
  ;Pointer_Produkt = N - 1
  !mov rdi,r15
  !dec rdi
  ;For i = 0 To N - 1         ;vom Produkt alle Werte durch
  !fninit                    ;zur Sicherheit, setzt auch Rundung auf round to nearest
  !.DeziLoop:
    ;Division der Produktwerte durch N und Konvertierung Double in Integer
    ;QuadWert = Round(PeekD(BufferFaktor2A + i * 16), #PB_Round_Nearest)  ;Double zu Quad
    !mov rax,20
    !mul r14
    !mov r9,[BufferFaktor2A]
    !fld tword[r9+rax]       ;Reihenfolge getauscht, FNINIT oben reicht zur Sicherheit
    !fild [N]
    !fdivp st1,st0           ;P(OP) jetzt nötig
    ;!fabs                    ;wohl nicht nötig
    !fistp qword[rcx]        ;jetzt als Quad-Integer abspeichern. SSE2 (cvtsd2si) bringt jetzt hier nichts
    !mov rax,[rcx]           ;rax=QuadWert

    ;Hex2Dez
    ;Ziffer = 0
    !xor r12b,r12b
    ;Pointer1 = 0
    !xor r8,r8
    ;Pointer2 = 0
    !xor r9,r9

    ;While PeekQ(?Dezi + Pointer1) <> 0 oder Zähler wie jetzt
    !mov rsi,11              ;Anzahl Dezi-Werte ohne Null
    !.OuterLoopDez1:
      ;While (QuadWert - PeekQ(?Dezi + Pointer1)) >= 0
      !mov r13,rax
      !.InnerLoopDez1:
        !sub r13,[r10+r8]
        !js .InnerLoopDez1End
        ;Ziffer + 1
        !inc r12b
        ;QuadWert - PeekQ(?Dezi + Pointer1)
        ;!sub rax,[r10+r8]
        !mov rax,r13         ;AL ist unten letzte Ziffer
      ;Wend     (QuadWert - PeekQ(?Dezi + Pointer1)) >= 0
      !jmp .InnerLoopDez1

      !.InnerLoopDez1End:
      ;PokeB(BufferDezA + Pointer2, Ziffer)
      !mov [r11+r9],r12b
      ;Pointer1 + 8
      !add r8,8
      ;Pointer2 + 1
      !inc r9
      ;Ziffer = 0
      !xor r12b,r12b
      !dec rsi
    ;Wend      PeekQ(?Dezi + Pointer1) <> 0 oder Zähler wie jetzt
    !jnz .OuterLoopDez1

    ;PokeB(BufferDezA + Pointer2, QuadWert1)   ;letzte Dezimal-Ziffer abspeichern
    !mov [r11+r9],al         ;AL ist letzte Ziffer von oben
    ;Pointer_Produkt1 = Pointer_Produkt
    !mov rsi,rdi
    !mov rax,11              ;11 reicht, evtl. sogar anpassen je nach Exponent
    !mov rdx,[BufferProduktA]
    ;For k = 0 To 15
    !@@:
      ;Ziffer = PeekB(BufferProduktA + Pointer_Produkt1)
      !mov r12b,[rdx+rsi]
      ;Ziffer + PeekB(BufferDezA + Pointer2)
      !add r12b,[r11+r9]
      ;PokeB(BufferProduktA + Pointer_Produkt1, Ziffer)
      !mov [rdx+rsi],r12b
      ;If Ziffer > 9                           ;Übertrag
      !cmp r12b,9              ;Übertrag?
      !jbe .ZifferOK
        ;Ziffer - 10
        !sub r12b,10
        ;PokeB(BufferProduktA + Pointer_Produkt1, Ziffer)
        !mov [rdx+rsi],r12b
        ;Ziffer = PeekB(BufferProduktA + Pointer_Produkt1 - 1) + 1
        !mov r12b,[rdx+rsi-1]
        !inc r12b
        ;PokeB(BufferProduktA + Pointer_Produkt1 - 1, Ziffer)
        !mov [rdx+rsi-1],r12b
      ;EndIf
      !.ZifferOK:
      ;Pointer_Produkt1 - 1
      !dec rsi
      !js .Reicht
      ;Pointer2 - 1
      !dec r9
      !dec rax
    ;Next
    !jnz @b

    !.Reicht:
    ;Pointer_Produkt - 1
    !dec rdi
    !inc r14
    !dec r15
  ;Next
  !jnz .DeziLoop

  ;------------------------
  ;Ergebnis (Produkt) in ASCII-Ziffern abspeichern
  !mov rdx,3030303030303030h
  !mov rcx,[N]
  !mov rax,[BufferProduktA]
  !mov byte[rax+rcx],0       ;Zero-Byte zur Sicherheit für String-Auslesen
  !sub rcx,8
  !@@:
    !or [rax+rcx],rdx
    !sub rcx,8
  !jns @b

  FreeMemory(BufferFaktor2)
  FreeMemory(BufferDez)

  sProdukt = LTrim(PeekS(BufferProduktA), "0")   ;evtl. führende Null(en) weg
  If sProdukt = ""
    sProdukt = "0"
  EndIf

  FreeMemory(BufferProdukt)

  TE_Ergebnis = ElapsedMilliseconds() - TA_Ergebnis

  TE_Gesamt = ElapsedMilliseconds() - TA_Gesamt

  sFaktor = "Faktor-Laenge (max.): " + Str(L1) + " Bytes (=Ziffern)" + #CRLF$
  sExpo = "Exponent 2^ für angepasste Faktoren-Laenge: " + Str(Exponent - 1) + #CRLF$
  sWinkel = "Zeit für Sinus/Cosinus-Berechnung: " + Str(TE_Winkel) + " ms" + #CRLF$
  sFaktoren = "Zeit für Faktoren-Aufbereitung: " + Str(TE_Faktoren) + " ms" + #CRLF$
  sFFT = "Zeit für Fast Fourier Transformation: " + Str(TE_FFT) + " ms" + #CRLF$
  sMulti = "Zeit für Multiplikation: " + Str(TE_Multi) + " ms" + #CRLF$
  sRueck = "Zeit für Rueck-Transformation: " + Str(TE_Rueck) + " ms" + #CRLF$
  sErgebnis = "Zeit für Ergebnis-Aufbereitung als String: " + Str(TE_Ergebnis) + " ms" + #CRLF$
  sGesamt = "Zeit gesamt: " + Str(TE_Gesamt) + " ms"
  sAusgabe + sFaktor + sExpo + sWinkel + sFaktoren + sFFT + sMulti + sRueck + sErgebnis + sGesamt + "XX" + sProdukt    ;"XX" dient als Trenner zwischen Infos und Produkt

  !mov rax,[BufferFXA]
  !fxrstor64 [rax]
  !mov rdi,[rax+464]         ;callee-save registers zurücksichern, RBX und RBP wurden nicht gesichert (und von mir nicht benutzt)
  !mov rsi,[rax+472]
  !mov r12,[rax+480]
  !mov r13,[rax+488]
  !mov r14,[rax+496]
  !mov r15,[rax+504]
  FreeMemory(BufferFX)       ;Register-mäßig interessant :-)

  ;DisableASM                 ;geschenkt
 ProcedureReturn sAusgabe

  ;--------------------------------------------------------
  DataSection
    !Rad1            dt ?    ;10-Byte-Variablen
    !                dp ?    ;6 Bytes Dummy wegen Alignment
    !Sin             dt ?
    !                dp ?
    !Cos             dt ?
    !                dp ?
    !WR              dt ?
    !                dp ?
    !WI              dt ?
    !                dp ?
    !ZR              dt ?
    !                dp ?
    !ZI              dt ?
    !                dp ?

    !BufferCosA      dq ?
    !BufferDezA      dq ?
    !BufferFaktor1A  dq ?
    !BufferFaktor2A  dq ?
    !BufferFXA       dq ?
    !BufferProduktA  dq ?
    !BufferSinA      dq ?
    !Exponent        dq ?
    !L1              dq ?
    !L2              dq ?
    !LenF            dq ?
    !LNull1          dq ?
    !LNull11         dq ?
    !L1hinten        dq ?
    !L1vorn          dq ?
    !LNull2          dq ?
    !LNull22         dq ?
    !L2hinten        dq ?
    !L2vorn          dq ?
    !N               dq ?
    !PF1             dq ?
    !PF2             dq ?

    !Dezi            dq     100000000000    ;einhundert Milliarden reichen bis 1GB Faktoren-Länge!
    !                dq      10000000000
    !                dq       1000000000
    !                dq        100000000
    !                dq         10000000
    !                dq          1000000
    !                dq           100000
    !                dq            10000
    !                dq             1000
    !                dq              100
    !                dq               10
    !                dq                0    ;bleibt zur Sicherheit
  EndDataSection

EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ;ein Auswahl-Menü schenke ich mir hier. Einen der Tests auswählen, Goto oder nicht Goto, das ist hier die Frage... ;-)
  ;Quellen-Auswahl: (Faktoren erstellen, kann jeder selbst generieren)
  ;Goto NixLongString
  Faktor1$ = "6582018229284824168619876730229402019930943462534319453394436096"  ;64-Bytes
  Faktor2$ = "5486721320215405789450123459785103469751240504554109782315460125"
  
  FL = 6                  ;Faktoren-Länge: FL=6=4KB(2ms), wird im MessageRequester noch mit Produkt angezeigt, Werte von 0 bis 21 (je nach RAM-Ausstattung) möglich, 22=Out of Memory bei mir
  For i = 1 To FL         ;für Test. Faktoren-Länge: FL=14=1MB(1s); 15=2MB(3s); 16=4MB(8s); 17=8MB(17s); 18=16MB(37s); 19=32MB(80s); 20=64MB(173s); 21=128MB(369s); 22=Out of Memory (32GB!)
    Faktor1$ + Faktor1$   ;um auf "Länge" zu kommen :-)
    Faktor2$ + Faktor2$
  Next
  String = 1
  NixLongString:
  ;----------------------------------------------------------
  Goto NixLongStringKrumm
  ;oder
  Faktor1$ = "6730229402019930943462534319453394436096"
  Faktor2$ = "9751240504554109782315460125"
  For i = 1 To 10
    Faktor1$ + Faktor1$
    Faktor2$ + Faktor2$
  Next
  String = 1
  NixLongStringKrumm:
  ;----------------------------------------------------------
  Goto NixShortString
  ;oder
  Faktor1$ = "10"
  Faktor2$ = "15"
  String = 1
  NixShortString:
  ;----------------------------------------------------------
  Goto NixMem
  ;oder, wenn die Faktoren irgendwo im Speicher stehen, z.B.:
  LFMem1 = 6                        ;z.B.6 Ziffern
  PFMem1 = AllocateMemory(LFMem1)
  For i = 0 To LFMem1 - 1
    PokeB(PFMem1 + i, i + 1)        ;sollen die 6 Ziffern sein. Bei höher 9 natürlich andere Wertezuweisung (Bereich 0-9)
  Next
  LFMem2 = 5                        ;z.B.5 Ziffern
  PFMem2 = AllocateMemory(LFMem2)
  For i = 0 To LFMem2 - 1
    PokeB(PFMem2 + i, i + 1)        ;sollen die 5 Ziffern sein. Bei höher 9 natürlich andere Wertezuweisung (Bereich 0-9)
  Next
  ;String = 0
  Nixmem:
  ;----------------------------------------------------------
  
  ;die FFT_Mul-Procedure aufrufen. Um die Unicode-Problematik zu umgehen empfehle ich natürlich die Memory-Variante, was in einer Anwendung sowieso so sein sollte
  If String
    Result$ = FFT_Mul(Len(Faktor1$), Len(Faktor2$), @Faktor1$, @Faktor2$)
   Else
    Result$ = FFT_Mul(LFMem1, LFMem2, PFMem1, PFMem2)
  EndIf
  
  ;die Rückgabe der Procedure auswerten
  Pos_XX = FindString(Result$, "XX", 1, #PB_String_CaseSensitive)
  If Pos_XX                              ;Pos_XX ist Null bei Fehler
    L_Result = Len(Result$)
    L_Produkt = L_Result - Pos_XX - 2    ;2=XX
    Produkt$ = Mid(Result$, Pos_XX + 2)
    Info$ = Mid(Result$, 1, L_Result - L_Produkt - 3)
  
    SetClipboardText(Produkt$)           ;oder eigene Methode
  
    If L_Result < 10000                  ;damit der MessageRequester nicht schlapp macht. Direkt angezeigt wird bis Faktor-Länge 4KB
      MessageRequester("Helles Integer-Multiplikation-FFT-Test", Info$ + #LFCR$ + "Produkt:" + #LFCR$ + Produkt$ + #LFCR$ + #LFCR$ + "Das Produkt ist auch in der Zwischenablage zu finden!")
     Else
      MessageRequester("Helles Integer-Multiplikation-FFT-Test", Info$ + #LFCR$ + #LFCR$ + "Das Produkt ist für die Anzeige zu groß und deshalb nur in der Zwischenablage zu finden!")
    EndIf
  
   Else
    MessageRequester("Helles Integer-Multiplikation-FFT-Test", Result$)     ;irgendeine Fehlermeldung wurde generiert
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
