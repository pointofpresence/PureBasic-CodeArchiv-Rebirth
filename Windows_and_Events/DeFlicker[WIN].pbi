;    Description: It reduces flicker of windows and gadgets
;         Author: PureLust
;           Date: 2016-05-28
;     PB-Version: 5.42
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29525
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

;   Modul: DeFlicker   (Windows only)
;   --------------------------------------------------
;   Bei größenveränderlichen Fenstern tritt häufig (vor allem bei älteren, langsameren PCs) ein störendes
;   Flimmern auf, wenn das Fenster und die darin befindlichen Gadgets resized werden.
;   Durch DeFlicker kann man dieses Flimmern nun auf einfache Weise unterbinden.

;   Anwendung:
;   ---------------------
;   Die 'standard' Anwendung ist denkbar einfach:
;   In der Routine, in der das Resizing der Gadgets vorgenommen wird, muss vor dem ersten ResizeGadget()
;   die DeFlicker-Funktion 'StartResize(Window)' aufgerufen werden (mit Angabe der entspechenden Fensternummer).
;   Wenn alle Gadgets resized wurden, muss noch EndResize() aufgerufen werden, wodurch das Fenster und die Gadgets
;   (weitestgehend) flimmerfrei neu gezeichnet wird.

;   Hinweis:
;   ---------------------
;   Manchmal muss - um ein optimales Ergebnis zu erhalten - noch bei eingen Gadgets ein wenig Feintuning betrieben werden.
;   Wenn z.B. transparente Images verwendet werden, so sollte DeFlicker für diese Images ggfl. abgeschaltet werden um
;   keine unschönen Nebeneffekte durch nicht gelöschte Grafikreste zu erhalten (siehe 'SetGadgetDeFlicker()' oder
;   'SetGadgetTypeDeFlicker()' weiter unten).
;
;   Hierzu kann man das DeFlickern auf 4 Arten sowohl generell für eine GadgetTyp als auf für einzelne Gadgets justieren:
;   -   #DeFlicker_Full      -   der gesamte Bereich eines Gadgets wird entflimmert (sinnvoll bei allen 'normalen' rechteckigen Gadgets)
;   -   #DeFlicker_NO         -   der Bereich des Gadgets wird nicht entflimmert (sinnvoll bei allen Arten von Container- Gadgets, die weitere Gadgets enthalten)
;   -   #DeFlicker_Top16/20   -   hier werden nur die oberen 16/20 Pixel des Gadgets entflimmert (z.B. nützlich für PanelGadgets die nur in der Höhe verändert werden)
;      (oder auch Werte)         (statt der Konstanten #DeFlicker_Top16/20 kann auch die Anzahl der Pixel als Parameter übergeben
;                               werden (also z.B. '16' oder '20'. Erlaubt sind hierbei Werte von 3-999 Pixel)
;   -   #DeFlicker_Region      -   Bei #DeFlicker_Region kann ein spezieller Bereich definiert werden, der entflimmert werden soll.
;                              Dies ist z.B. zum Optimieren des Tab-Bereichs bei PanelGadgets sinnvoll.

;   Zur Verfügung stehende Funktionen:
;   ----------------------------------------
;   -    StartResize(Window)               -   verhindert von nun an, dass das Fenster neu gezeichnet wird (s.o.)
;   -   EndResize(RefreshWindow=#True)   -   erlaubt wieder das Neuzeichnen des Fensters und zeichnet den Inhalt neu (s.o.)
;                                          (Hinweis: EndResize() ruft automatisch 'RefreshWindow(Window)' auf um den Fensterinhalt
;                                           neu zu zeichnen. Dies kann durch den optionalen Parameter (RefreshWindow=#False)
;                                           unterbunden werden. RefreshWindow() kann dann bei Bedarf separat aufgerufen werden.
;   -   RefreshWindow(Window)            -   zeichnet den Fensterinhalt möglichst flimmerfrei neu (s.o.)


;   -   SetGadgetTypeDeFlicker(GadgetType, RefreshType)      - setzt die standard DeFlicker-Art für einen bestimmten GadgetType
;                                                           (#DeFlicker_Region ist hierbei nicht möglich)
;   -   GetGadgetTypeDeFlicker(GadgetType)                  - gibt die aktuell eingestellte DeFlicker-Art für einen GadgetType zurück


;   -   SetGadgetDeFlicker(Gadget, RefreshType [, xPos, yPos, Width, Height])
;                                                         - setzt die DeFlicker-Art für ein ganz bestimmtes Gadget
;                                                           Bei #DeFlicker_Region muss noch der Bereich definiert werden
;   -   GetGadgetDeFlicker(Gadget)                           - gibt die aktuell eingestellte DeFlicker-Art für dieses Gadget zurück


;   Anwendungsbeispiel:
;   ---------------------------------------------------------------------------------------------------------------------------
;   Am Ende dieses Codes (nach der Definition des Moduls: DeFlicker) findet Ihr ein kleines Hardcore-Beispiel mit 124 Gadgets


#DeFlicker_NO         = 1
#DeFlicker_Region      = 2
#DeFlicker_Top16      = 16
#DeFlicker_Top20      = 20
#DeFlicker_Full      = 1000

DeclareModule      DeFlicker

   Declare   StartResize(Window)
    Declare   RefreshWindow(Window)
   Declare   EndResize(RefreshWindow=#True)

   Declare   GetGadgetTypeDeFlicker(GadgetType)
   Declare   SetGadgetTypeDeFlicker(GadgetType, RefreshType)

   Declare   GetGadgetDeFlicker(Gadget)
   Declare   SetGadgetDeFlicker(Gadget, RefreshType, xPos=#PB_Ignore, yPos=#PB_Ignore, Width=#PB_Ignore, Height=#PB_Ignore)

EndDeclareModule
Module   DeFlicker

   EnableExplicit

   #DeFlicker_NO         = 1
   #DeFlicker_Region      = 2
   #DeFlicker_Top16      = 16
   #DeFlicker_Top20      = 20
   #DeFlicker_Full      = 1000

   Structure   GadgetDetails_Struct
      GadgetID.i
      GadgetNumber.i
      GadgetType.i
      left.l
      top.l
      right.l
      bottom.l
   EndStructure
   Structure   UserDefined_DeFlickerType_Struct
      GadgetNumber.i
      DeFlicker_Type.l
      xPos.w
      yPos.w
      Width.w
      Height.w
   EndStructure

   #MaxGadgetTypes = 40
   Global   Dim GadgetType_Default.l(#MaxGadgetTypes)
   Global   NewList   CallBackGadgetList.GadgetDetails_Struct()
   Global   NewList   UserDefined_DeFlickerType.UserDefined_DeFlickerType_Struct()
   Global   LastResizedWindow
   Define   n

   For n = 0 To #MaxGadgetTypes
      GadgetType_Default(n) = #DeFlicker_Full                        ; Standard für alle Gadgets ist erst einmal 'Full'-Deflicker
   Next

   GadgetType_Default(#PB_GadgetType_Frame)      = #DeFlicker_Top16   ; Jetzt werden einige Ausnamen voreingestellt
   GadgetType_Default(#PB_GadgetType_Container)   = #DeFlicker_NO
   GadgetType_Default(#PB_GadgetType_Splitter)   = #DeFlicker_NO
   GadgetType_Default(#PB_GadgetType_Panel)      = #DeFlicker_Full

   Procedure   GetGadgetList_Callback(hwnd,*WinPos.POINT)                     ; interne Routine - CallBack zum Ermitteln der Gadgets-Liste

      ; CallBack zur Erstellung einer LinkedListe mit Details zu allen Gadgets in einem Window

      Protected   ActPBGadget, GadgetPos.RECT

      ActPBGadget = GetProp_(hwnd, "PB_ID")                                    ; Gadget# des PB-Gadgets

      If IsGadget(ActPBGadget) And GadgetID(ActPBGadget) = hwnd               ; Checken ob die ermittelte Gadget# aus ok ist
         If AddElement(CallBackGadgetList())
            CallBackGadgetList()\GadgetID         = hwnd
            CallBackGadgetList()\GadgetNumber   = ActPBGadget
            CallBackGadgetList()\GadgetType      = GadgetType(ActPBGadget)
            GetWindowRect_(hwnd, @GadgetPos)                                       ; Desktop-Position des Gadgets ermitteln
            CallBackGadgetList()\left      = GadgetPos\left      - *WinPos\x         ; Gadgetposition auf Position im Fenster umrechnen
            CallBackGadgetList()\top      = GadgetPos\top      - *WinPos\y         ;       ''
            CallBackGadgetList()\right      = GadgetPos\right      - *WinPos\x         ;       ''
            CallBackGadgetList()\bottom   = GadgetPos\bottom   - *WinPos\y         ;       ''
         EndIf
      EndIf

      ProcedureReturn #True

   EndProcedure
   Procedure   GetGadgetList(Window, List GadgetList.GadgetDetails_Struct())   ; interne Routine zum Erstellen einer Liste mit allen Gadgets

      ; Ermittelt Details aller PB-Gadgets in einem Fenster und gibt diese in einer LinkedList zurück

      Protected   WinPos.POINT

      If IsWindow(Window)
         WinPos\x = WindowX(Window, #PB_Window_InnerCoordinate)      ; Window-Position ermitteln, dami diese an den CallBack übergeben werden kann
         WinPos\y = WindowY(Window, #PB_Window_InnerCoordinate)

         ClearList(CallBackGadgetList())                                          ; LinkedList des CallBacks löschen
         EnumChildWindows_(WindowID(Window),@GetGadgetList_Callback(),@WinPos)   ; Alle Gadgets ermitteln und per CallBack auswerten
         CopyList(CallBackGadgetList(), GadgetList())                              ; Die vom CallBack erstellte LinkedListe auf die eigentliche Liste kopieren
      Else
         Debug "Window Nr."+Str(Window)+" konnte nicht gefunden werden."
      EndIf

      ProcedureReturn   ListSize(GadgetList())

   EndProcedure

   Procedure   StartResize(Window)
      If IsWindow(Window)
         SendMessage_(WindowID(Window),#WM_SETREDRAW,#False,0)
         LastResizedWindow = Window
      Else
         Debug "Window Nr."+Str(Window)+" nicht gefunden."
      EndIf
   EndProcedure
   Procedure   RefreshWindow(Window)

      If IsWindow(Window)

         Protected   ps.PAINTSTRUCT
         Protected   Validate.RECT
         Protected   NewList GadgetList.GadgetDetails_Struct()
         Protected   hWnd.i = WindowID(Window)
         Protected   WinRect.rect
         Protected   ActDeFlickerType
         Protected   ClearEventLoop = #True

         GetGadgetList(Window, GadgetList())

         GetClientRect_(hWnd, @WinRect)
         InvalidateRect_(hWnd,WinRect,1)

         ForEach GadgetList()

            If GadgetList()\GadgetType = #PB_GadgetType_Panel
               ClearEventLoop = #True
            EndIf

            ActDeFlickerType   = GadgetType_Default(GadgetList()\GadgetType)

            ForEach UserDefined_DeFlickerType()
               If UserDefined_DeFlickerType()\GadgetNumber = GadgetList()\GadgetNumber
                  ActDeFlickerType = UserDefined_DeFlickerType()\DeFlicker_Type
                  Break
               EndIf
            Next

            Select ActDeFlickerType

               Case   #DeFlicker_Full            ;   Gadget-Bereich wird komplett 'DeFlickered'

                  ValidateRect_(hWnd, @GadgetList()\left)

               Case   #DeFlicker_Region

                  Validate\left      = GadgetList()\left   + UserDefined_DeFlickerType()\xPos
                  Validate\top      = GadgetList()\top   + UserDefined_DeFlickerType()\yPos
                  Validate\right      = GadgetList()\left   + UserDefined_DeFlickerType()\Width
                  Validate\bottom   = GadgetList()\top   + UserDefined_DeFlickerType()\Height

               Case   #DeFlicker_Region+1 To #DeFlicker_Full-1      ;  Nur oberen Teil des Gadgets 'DeFlickern'

                  Validate\left      = GadgetList()\left + 8
                  Validate\top      = GadgetList()\top
                  Validate\right      = GadgetList()\right - 8
                  Validate\bottom   = GadgetList()\top + ActDeFlickerType - 1

                  If GadgetList()\GadgetType = #PB_GadgetType_Frame
                     If StartDrawing(WindowOutput(Window))
                        DrawingFont(GetGadgetFont(GadgetList()\GadgetNumber))
                        Validate\right      = GadgetList()\left + 8 + TextWidth(GetGadgetText(GadgetList()\GadgetNumber))
                        Validate\bottom   = GadgetList()\top + TextHeight(GetGadgetText(GadgetList()\GadgetNumber))
                        If Validate\right > GadgetList()\right : Validate\right = GadgetList()\right : EndIf
                        StopDrawing()
                     EndIf
                  EndIf
                  ValidateRect_(hWnd, @Validate)
               Default

                  ; No DeFlicker at all

            EndSelect

         Next

         BeginPaint_(hWnd, ps.PAINTSTRUCT)
         EndPaint_(hWnd, ps.PAINTSTRUCT)
         RedrawWindow_(hWnd,#Null,#Null,#RDW_INVALIDATE);

         CompilerIf #PB_Compiler_Debugger         ; need this Trick to get special Gadgets refreshed (like PanelGadget)
            DisableDebugger
            If ClearEventLoop
               While WindowEvent() : Wend
            EndIf
            EnableDebugger
         CompilerElse
            If ClearEventLoop
               While WindowEvent() : Wend
            EndIf
         CompilerEndIf

      Else
         Debug "Window Nr."+Str(Window)+" nicht gefunden."
      EndIf
   EndProcedure
   Procedure   EndResize(RefreshWindow=#True)
      SendMessage_(WindowID(LastResizedWindow),#WM_SETREDRAW,#True,0)
      If RefreshWindow : RefreshWindow(LastResizedWindow): EndIf
   EndProcedure

   Procedure   GetGadgetTypeDeFlicker(GadgetType)
      If GadgetType >= 0 And GadgetType <= #MaxGadgetTypes
         ProcedureReturn GadgetType_Default(GadgetType)
      EndIf
   EndProcedure
   Procedure   SetGadgetTypeDeFlicker(GadgetType, RefreshType)
      If GadgetType >= 0 And GadgetType <= #MaxGadgetTypes And RefreshType >= #DeFlicker_NO And RefreshType <= #DeFlicker_Full And RefreshType <> #DeFlicker_Region
         GadgetType_Default(GadgetType) = RefreshType
         ProcedureReturn #True
      EndIf
   EndProcedure

   Procedure   GetGadgetDeFlicker(Gadget)
      ForEach UserDefined_DeFlickerType()
         If UserDefined_DeFlickerType()\GadgetNumber = Gadget
            ProcedureReturn UserDefined_DeFlickerType()\DeFlicker_Type
         EndIf
      Next
   EndProcedure
   Procedure   SetGadgetDeFlicker(Gadget, RefreshType, xPos=#PB_Ignore, yPos=#PB_Ignore, Width=#PB_Ignore, Height=#PB_Ignore)

      If IsGadget(Gadget) And RefreshType >= #DeFlicker_NO And RefreshType <= #DeFlicker_Full

         Repeat
            ForEach UserDefined_DeFlickerType()
               If UserDefined_DeFlickerType()\GadgetNumber = Gadget
                  Break 2
               EndIf
            Next

            AddElement(UserDefined_DeFlickerType())
         Until #True

         With UserDefined_DeFlickerType()
            \GadgetNumber      = Gadget
            \DeFlicker_Type   = RefreshType
            If RefreshType   = #DeFlicker_Region
               \xPos            = xPos
               \yPos            = yPos
               \Width         = Width
               \Height         = Height
            EndIf
         EndWith

      EndIf

   EndProcedure

EndModule


; ========================================================================================
; ====                        Sample-Code with 124 Gadgets                            ====
; ========================================================================================


CompilerIf #PB_Compiler_IsMainFile

   EnableExplicit

   #winMain = 0
   Global   DeFlicker_enabled = #False
   Global   xCount = 8, yCount = 14
   Define   n

   Procedure   ResizeGadgets()      ; Dies ist die BindEvent-Routine zum resizen der Gadgets

      Protected   x,y, ActX, ActY, ActWidth.f, ActHeight.f
      Protected   ActWinWidth = WindowWidth(#winMain), ActWinHeight = WindowHeight(#winMain)

      ; =============================  just call StartResize() before you resize  ============================

      If DeFlicker_enabled
         DeFlicker::StartResize(#winMain)
      EndIf

      ; ======================================================================================================


      ; Resize Button-Area

      ActX = 8
      ActY = 28
      ActWidth = (ActWinWidth - ActX - 300 - (xCount-1) * 5) / xCount
      ActHeight = (ActWinHeight - ActY - 13 - (yCount-1) * 5) / yCount

      For x = 0 To xCount - 1
         For y = 0 To yCount - 1
            ResizeGadget(30 + x + y*xCount, ActX + x * (ActWidth + 5), ActY + y * (ActHeight + 5), ActWidth, ActHeight)
         Next
      Next

      ResizeGadget(1, ActWinWidth - 290, 10, 280, ActWinHeight/2 - 15)
      ResizeGadget(20,ActWinWidth - 270, 35, 250, 19)
      ResizeGadget(21,ActWinWidth - 270, 55, 250, 19)
      ResizeGadget(22,ActWinWidth - 270, 75, 250, 19)
      ResizeGadget(23,ActWinWidth - 275, 98, 250, ActWinHeight/2 - 143)
      ResizeGadget(24,ActWinWidth - 275, ActWinHeight/2 - 38, 250, 25)

      ResizeGadget(2, ActWinWidth - 290, ActWinHeight/2 + 5, 280, ActWinHeight/2 - 15)
      ResizeGadget(10,10,10,(GadgetWidth(2)-6)/2-15, (GadgetHeight(2)-50)/2)
      ResizeGadget(11,(GadgetWidth(2)-6)/2+5,10,(GadgetWidth(2)-6)/2-15, (GadgetHeight(2)-50)/2)
      ResizeGadget(12,10,(GadgetHeight(2)-50)/2 + 20,(GadgetWidth(2)-36)/2, (GadgetHeight(2)-50)/2-10)
      ResizeGadget(13,(GadgetWidth(2)-6)/2+5,(GadgetHeight(2)-50)/2 + 20,(GadgetWidth(2)-6)/2-15, (GadgetHeight(2)-50)/2-10)

      ; =============  just call EndResize() when you are finished with the Gadget resizing  =================

      If DeFlicker_enabled
         DeFlicker::EndResize()
      EndIf

      ; ======================================================================================================

   EndProcedure

   Procedure   CheckBox_EnableDeFlicker()
      If IsGadget(0)
         DeFlicker_enabled = GetGadgetState(0)
      EndIf
   EndProcedure

   OpenWindow(#winMain,0,0,800,600,"DeFlicker Hardcore-Sample", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
   WindowBounds(#winMain, 520, 360, #PB_Default, #PB_Default)

   BindEvent(#PB_Event_SizeWindow, @ResizeGadgets())

   CheckBoxGadget(0,10,5, 150, 20, "enable DeFlicker")      ; CheckBox um
   SetGadgetState(0, DeFlicker_enabled)
   BindGadgetEvent(0, @CheckBox_EnableDeFlicker())

   FrameGadget(1, 10,10,10,10," iFrame ")
   OptionGadget(20,10,10,10,10,"I use PB on Windows")
   OptionGadget(21,10,10,10,10,"I use PB on Linux")
   OptionGadget(22,10,10,10,10,"I use PB on MacOS")
   EditorGadget(23,10,10,10,10, #PB_Editor_WordWrap)
   ComboBoxGadget(24,10,10,10,10)

   PanelGadget(2, 10,10,10,10)
   AddGadgetItem(2, -1, "Panel 1")
   ButtonGadget(10, 10,10,80,80,"do")
   ButtonGadget(11, 100,10,80,80,"re")
   ButtonGadget(12, 10,100,80,80,"mi")
   ButtonGadget(13, 100,100,80,80,"fa")
   AddGadgetItem(2, -1, "Panel 2")
   AddGadgetItem(2, -1, "Panel 3")
   CloseGadgetList()

   For n = 30 To 29 + xCount * yCount
      ButtonGadget(n,10,10,10,10,"Btn:"+Str(n-29))
   Next

   ResizeGadgets()

   While WaitWindowEvent() <> #PB_Event_CloseWindow : Wend

CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; CursorPosition = 436
; FirstLine = 386
; Folding = ---
; EnableUnicode
; EnableXP
; CompileSourceDirectory
; EnablePurifier