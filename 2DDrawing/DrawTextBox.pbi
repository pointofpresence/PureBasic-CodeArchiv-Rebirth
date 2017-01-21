﻿;    Description: It uses the 2D-Drawing-Lib and draws text boxes
;         Author: mk-soft
;           Date: 2016-04-23
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27954
; -----------------------------------------------------------------------------

;-TOP
; Kommentar     : DrawTextBox
; Author        : mk-soft
; Second Author :
; Datei         : DrawTextBox.pbi
; Version       : 1.04
; Erstellt      : 20.04.2014
; Geändert      : 23.04.2016
;
; Compilermode  :
;
; Link          : http://www.purebasic.fr/german/viewtopic.php?f=8&t=27954
;
; ***************************************************************************************

EnableExplicit

#TBOX_Right   = 1
#TBOX_HCenter = 2
#TBOX_VCenter = 4
#TBOX_Bottom  = 8

Procedure DrawTextBox(x, y, dx, dy, text.s, flags = 0)

  Protected is_right, is_hcenter, is_vcenter, is_bottom
  Protected text_width, text_height
  Protected text_x, text_y, break_y
  Protected text2.s, rows, row, row_text.s, row_text1.s, out_text.s, start, count

  ; Flags
  is_right = flags & #TBOX_Right
  is_hcenter = flags & #TBOX_HCenter
  is_vcenter = flags & #TBOX_VCenter
  is_bottom = flags & #TBOX_Bottom

  ; Übersetze Zeilenumbrüche
  text = ReplaceString(text, #LFCR$, #LF$)
  text = ReplaceString(text, #CRLF$, #LF$)
  text = ReplaceString(text, #CR$, #LF$)

  ; Erforderliche Zeilenumbrüche setzen
  rows = CountString(text, #LF$)
  For row = 1 To rows + 1
    text2 = StringField(text, row, #LF$)
    If text2 = ""
      out_text + #LF$
      Continue
    EndIf
    start = 1
    count = CountString(text2, " ") + 1
    Repeat
      row_text = StringField(text2, start, " ") + " "
      Repeat
        start + 1
        row_text1 = StringField(text2, start, " ")
        If TextWidth(row_text + row_text1) < dx - 12
          row_text + row_text1 + " "
        Else
          Break
        EndIf
      Until start > count
      out_text + RTrim(row_text) + #LF$
    Until start > count
  Next

  ; Berechne Y-Position
  text_height = TextHeight("X")
  rows = CountString(out_text, #LF$)
  If is_vcenter
    text_y = (dy / 2 - text_height / 2) - (text_height / 2 * (rows-1))
  ElseIf is_bottom
    text_y = dy - (text_height * rows) - 2
  Else
    text_y = 2
  EndIf

  ; Korrigiere Y-Position
  While text_y < 2
   text_y + text_height
  Wend

  break_y = dy - text_height - 2

  ; Text ausgeben
  For row = 1 To rows
    row_text = StringField(out_text, row, #LF$)
    If is_hcenter
      text_x = dx / 2 - TextWidth(row_text) / 2
    ElseIf is_right
      text_x = dx - TextWidth(row_text) - 4
    Else
      text_x = 4
    EndIf
    DrawText(x + text_x, y + text_y, row_text)
    text_y + text_height
    If text_y > break_y
      Break
    EndIf
  Next

  ProcedureReturn rows

EndProcedure

; ***************************************************************************************

;- Test

CompilerIf #PB_Compiler_IsMainFile

  ;- Konstanten
  Enumeration ; Window ID
    #Window
  EndEnumeration

  Enumeration ; Menu ID
    #Menu
  EndEnumeration

  Enumeration ; MenuItem ID
    #Menu_Exit
  EndEnumeration

  Enumeration ; Statusbar ID
    #Statusbar
  EndEnumeration

  Enumeration ; Gadget ID
    #Canvas
  EndEnumeration

  ; ***************************************************************************************

  Procedure Draw(output, text.s)

    Define hfont = LoadFont(0, "Arial", 14, #PB_Font_Bold)

    If  StartDrawing(output)
      DrawingFont(hfont)
      DrawingMode(#PB_2DDrawing_Transparent)

      Box(10, 10, 400, 200, $FF901E)
      DrawTextBox(10, 10, 400, 200, text)

      Box(10, 220, 400, 200,$E16941)
      DrawTextBox(10, 220, 400, 200, text, #TBOX_VCenter)

      Box(10, 430, 400, 200,$FF0000)
      DrawTextBox(10, 430, 400, 200, text, #TBOX_Bottom)

      Box(420, 10, 200, 200, $0045FF)
      DrawTextBox(420, 10, 200, 200, text, #TBOX_HCenter)

      Box(420, 220, 200, 200, $00008B)
      DrawTextBox(420, 220, 200, 200, text, #TBOX_HCenter | #TBOX_VCenter)

      Box(420, 430, 200, 200, $20A5DA)
      DrawTextBox(420, 430, 200, 200, text, #TBOX_HCenter | #TBOX_Bottom)

      Box(630, 10, 400, 200, $238E6B)
      DrawTextBox(630, 10, 400, 200, text, #TBOX_Right)

      Box(630, 220, 400, 200, $006400)
      DrawTextBox(630, 220, 400, 200, text, #TBOX_Right | #TBOX_VCenter)

      Box(630, 430, 400, 200, $32CD32)
      DrawTextBox(630, 430, 400, 200, text, #TBOX_Right | #TBOX_Bottom)

      StopDrawing()
    EndIf

  EndProcedure

  ;- Globale Variablen
  Global exit = 0

  ;- Fenster
  Define style = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget
  If OpenWindow(#Window, #PB_Ignore, #PB_Ignore, 1200, 800, "Fenster", style)
    ; Menu
    If CreateMenu(#Menu, WindowID(#Window))
      MenuTitle("&File")
        MenuItem(#Menu_Exit, "&Exit")
    EndIf
    ; Statusbar
    CreateStatusBar(#Statusbar, WindowID(#Window))
    AddStatusBarField(#PB_Ignore)
    StatusBarText(#Statusbar, 0, "Example DrawTextbox")

    ; Gadgets
    CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window) - MenuHeight() - StatusBarHeight(#Statusbar))

    Define t1.s
    t1 = "PureBasic ist eine Hochsprachen Programmiersprache, die auf den bekannten BASIC-Regeln basiert." + #LF$
    t1 + "Sie ist größtenteils kompatibel mit jedem anderen BASIC-Compiler, egal ob für das Amiga- "
    t1 + "oder PC-Format. Das Erlernen von PureBasic ist sehr leicht! PureBasic ist für Anfänger "
    t1 + "genauso wie für Experten geschaffen worden. Die Übersetzungsgeschwindigkeit ist wirklich schnell. "
    t1 + "Diese Software wurde für das Windows- Operating-System entwickelt. "
    ;t1 + "Wir haben eine Menge Anstrengungen in ihre Realisierung gesetzt, um eine schnelle, "
    ;t1 + "zuverlässige und systemfreundliche Sprache zu produzieren"

    Draw(CanvasOutput(#Canvas), t1)

    ;-- Hauptschleife
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_Menu                       ; ein Menü wurde ausgewählt
          Select EventMenu()
            Case #Menu_Exit
              Exit = 1
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            Case #PB_Menu_Quit
              Exit = 1
            CompilerEndIf
          EndSelect
        Case #PB_Event_CloseWindow                ; das Schließgadget vom Fenster wurde gedrückt
          Exit = 1

      EndSelect

    Until Exit
  EndIf

CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
