; DynamicDialogs Demo 3 - Font & ImageID

EnableExplicit

XIncludeFile "..\DynamicDialogs_suffixed_IDOnly.pbi"			; include the Wrapper, to easily build correct XML-Dialogs

; Load some Sample-Fonts

LoadFont(0,"Arial", 12, #PB_Font_StrikeOut)
LoadFont(1,"Lucida Console", 8)

; Create some Sample-Images

Define n,m
#ImageWidth = 300
#ImageHeight = 60

For n = 0 To 4
	If CreateImage(n, #ImageWidth, #ImageHeight)
		If StartDrawing(ImageOutput(n))
			For m = 1 To 100
				Circle(Random(#ImageWidth), Random(#ImageHeight), 5+Random(30), RGB(Random($44), Random($cc), Random($cc)))
			Next
			DrawingMode(#PB_2DDrawing_Transparent )
			DrawingFont(FontID(1))
			Select n
				Case 0
					DrawText(10,10,"Image-Gadget, aligned center-right")
				Case 1
					DrawText(10,10,"Image-Gadget with Border")
				Case 2
					DrawText(10,10,"ButtonImage-Gadget")
				Case 3,4
					DrawText(10,10,"ButtonImage-Gadget with 2 Images")
			EndSelect
			StopDrawing()
		EndIf
	EndIf
Next

; ----- Creating the MainWindow by using DynamicDialog Commands

UseModule DynamicDialogs								; we need the 'main'-Module for constants and the standard Functions
UseModule DynamicDialogs_suffixed_IDonly		; use the aditional Module "DynamicDialogs_suffixed_NameOnly" with suffix for auto indentation

ClearXML()						; Clear the internal XML-Buffer, to marke sure, we start from scrath (not really neccessarry at the beginning)

Window__(0, "DynamicDialogs - Font & ImageID Demo ", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget,0,0,#Dialog_AutoMinSize,#Dialog_AutoMinSize)
	vBox__()
		
		; ----- Image Sample		(Info:  you can either use the #ImageNr or the ImageID() as Parameter)
		
		Image__(#PB_Any,ImageID(0),0,0,0,#alignCenterRight)					; Image w/o  Border, using ImageID(), Align: Center-Right
		Image__(#PB_Any,1,#PB_Image_Border,#ImageWidth, #ImageHeight)		; Image with Border, using #ImageNr as Parameter
		ButtonImage__(4, ImageID(2))									; ButtonImage, with only 1 image, using ImageID() as Parameter
		ButtonImage__(5,3,4,0,0,0,#alignCenter)					; ButtonImage, with 2 images, centered
		
		; ----- Font Sample		(Info: you can use a preloaded Font, or set the font directly by Name, Size and Style
		
		FontByID__(0)																; Set pre-loaded Font 0 ("Arial", 12, #PB_Font_StrikeOut)
		Text__(#PB_Any,"The quick brown fox ...")
		
		FontByID__()																; reset to default-font. you can also use 'EndFont()'
		Text__(#PB_Any,"jumps over ...")
		
		Font__("Segoe Script", 12, #PB_Font_Italic)						; Set font directly by Name, Size and Style
		Text__(7,"the lazy dog.")
		
	EndVBox__()
EndWindow__()
			

Define xmlWinMain$ = GetXML()		; get the up to now build XML-Code from the Wrapper-Modul

Debug xmlWinMain$						; Debug the XML-Code, just for your Info

; ----- Check the generated XML-Code, if there are any problems.  If so, generate a MessageBox and Debug some infos.

CheckDialog(xmlWinMain$, #DialogError_MsgBox)			; not really necessary if you don't utilize the given back result
																		; OpenDialogWindow() could generate the same Error-Message (see: #DialogError_MsgBox)

If OpenDialogWindow(0, xmlWinMain$, 0, "", #PB_Ignore,#PB_Ignore,0,0,0,#DialogError_MsgBox)
	
	Repeat
		Define	Event = WaitWindowEvent()
		
	Until Event = #PB_Event_CloseWindow 
	
EndIf

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
