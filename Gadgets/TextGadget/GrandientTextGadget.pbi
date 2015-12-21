;    Description: Grandient Text Gadget
;         Author: Thorsten1867
;           Date: 01-08-2014
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27861
; -----------------------------------------------------------------------------


;/ === GradientTextModule.pbi === [ PureBasic V5.2x/V5.3x ]
;/ Text with gradient background 
;/ March 2014 by Thorsten1867


DeclareModule GradientText
  Declare SetBackColor(GadgetID.i, StartColor.i, EndColor.i)
  Declare SetTextColor(GadgetID.i, Color.i)
  Declare SetFont(GadgetID.i, Font.i)
  Declare SetText(GadgetID.i, Text.s)
  Declare Gadget(GadgetID.i, X.i, Y.i, Width.i, Height.i, Text.s, StartColor.i, EndColor.i, Flags.l=#False)
EndDeclareModule


Module GradientText
  
  EnableExplicit
  
  Structure GradientTextStructure
    Text.s
    TextColor.i
    StartColor.i
    EndColor.i
    Font.i
    Flags.l
    Width.i
    Height.i
  EndStructure
  Global NewMap GradTxt.GradientTextStructure()
  
  Procedure CreateGradientText(GadgetID.i, Width.i, Height.i, Text.s, TextColor.i, StartColor.i, EndColor.i, Font.i=#False, Flags.l=#False)
    Protected ImageID.i, TxtX.f, TxtY.f
    If StartDrawing(CanvasOutput(GadgetID))
      DrawingMode(#PB_2DDrawing_Gradient)
      BackColor(StartColor)
      FrontColor(EndColor)
      LinearGradient(0, 0, Width, Height)
      Box(0, 0, Width, Height)
      If Flags & #PB_Text_Border
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0, 0, Width, Height, RGB(180,180,180))
      EndIf
      If Text
        DrawingMode(#PB_2DDrawing_Transparent)
        If Font : DrawingFont(Font) : EndIf
        If Flags & #PB_Text_Center ;{
          TxtX = (Width - TextWidth(Text))/2
        ElseIf Flags & #PB_Text_Right
          TxtX = Width - TextWidth(Text) - 3
        Else
          TxtX = 3
        EndIf
        TxtY = (Height - TextHeight(Text))/2 ;}
        DrawText(TxtX, TxtY, Text, TextColor)
      EndIf
      StopDrawing()
    EndIf
  EndProcedure 
  
  
  Procedure SetBackColor(GadgetID.i, StartColor.i, EndColor.i)
    Protected GId.s = Str(GadgetID)
    CreateGradientText(GadgetID, GradTxt(GId)\Width, GradTxt(GId)\Height, GradTxt(GId)\Text, GradTxt(GId)\TextColor, StartColor, EndColor, GradTxt(GId)\Font, GradTxt(GId)\Flags)
    GradTxt(GId)\StartColor = StartColor
    GradTxt(GId)\EndColor   = EndColor
  EndProcedure
  
  Procedure SetTextColor(GadgetID.i, Color.i)
    Protected GId.s = Str(GadgetID)
    CreateGradientText(GadgetID, GradTxt(GId)\Width, GradTxt(GId)\Height, GradTxt(GId)\Text, Color, GradTxt(GId)\StartColor, GradTxt(GId)\EndColor, GradTxt(GId)\Font, GradTxt(GId)\Flags)
    GradTxt(GId)\TextColor = Color
  EndProcedure
  
  Procedure SetFont(GadgetID.i, Font.i)
    Protected GId.s = Str(GadgetID)
    CreateGradientText(GadgetID, GradTxt(GId)\Width, GradTxt(GId)\Height, GradTxt(GId)\Text, GradTxt(GId)\TextColor, GradTxt(GId)\StartColor, GradTxt(GId)\EndColor, Font, GradTxt(GId)\Flags)
    GradTxt(GId)\Font = Font
  EndProcedure
  
  Procedure SetText(GadgetID.i, Text.s)
    Protected GId.s = Str(GadgetID)
    CreateGradientText(GadgetID, GradTxt(GId)\Width, GradTxt(GId)\Height, Text, GradTxt(GId)\TextColor, GradTxt(GId)\StartColor, GradTxt(GId)\EndColor, GradTxt(GId)\Font, GradTxt(GId)\Flags)
    GradTxt(GId)\Text = Text
  EndProcedure
  
  Procedure Free(GadgetID.i)
    DeleteMapElement(GradTxt(), Str(GadgetID))
  EndProcedure
  
  Procedure Gadget(GadgetID.i, X.i, Y.i, Width.i, Height.i, Text.s, StartColor.i, EndColor.i, Flags.l=#False)
    Protected GId.s = Str(GadgetID)
    CanvasGadget(GadgetID, X, Y, Width, Height)
    CreateGradientText(GadgetID, Width, Height, Text, RGB($0,$0,$0), StartColor, EndColor, GetGadgetFont(#PB_Default), Flags)
    GradTxt(GId)\Text       = Text
    GradTxt(GId)\TextColor  = RGB($0,$0,$0)
    GradTxt(GId)\StartColor = StartColor
    GradTxt(GId)\EndColor   = EndColor
    GradTxt(GId)\Font       = GetGadgetFont(#PB_Default)
    GradTxt(GId)\Flags      = Flags
    GradTxt(GId)\Width      = Width
    GradTxt(GId)\Height     = Height
  EndProcedure
  
EndModule

;-Example
CompilerIf #PB_Compiler_IsMainFile
  #Text = 1
  #Font = 1
  LoadFont(#Font, "Arial", 10, #PB_Font_Bold)
  If OpenWindow(0, 0, 0, 180, 60, "Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    GradientText::Gadget(#Text, 5, 5, 170, 20, "Gradient Background", RGB(10,59,118), RGB(153,180,209), #PB_Text_Center)
    GradientText::SetFont(#Text, FontID(#Font))
    GradientText::SetTextColor(#Text, RGB($FF,$FF,$FF))
    ;MessageRequester("Test GradientText", "Change Background", #MB_OK)
    ;GradientText::SetBackColor(#Text, RGB($0,$62,$0), RGB($0,$E8,$0))
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
