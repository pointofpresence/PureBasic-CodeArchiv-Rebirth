; DynamicDialogs Demo to show / test 9 Gadgets: Button to ExplorerCombo  

; This Demo uses the 'suffixed' Version, to demonstrate the indentation of the source-code, after you have used the Tool: DynamicDialogs_Suffix Indentation-Injector.exe

EnableExplicit

XIncludeFile "..\DynamicDialogs_suffixed.pbi"			; include DynamicDialogs, to easily build correct XML-Dialogs

#WinMain = 0
#xmlMain = 0
#DialogMain = 0

Enumeration	Gadgets
	#gadButton
	#gadButtonImage
	#gadCalendar
	#gadCanvas
	
	; The other Gadgets will be accessed by "Name", just to show how to do it
	
EndEnumeration

CreateImage(0,60,50)

; ----- Creating the MainWindow by using the Dialog-Wrapper Commands

UseModule DynamicDialogs							; activate 'main' Module "DynamicDialogs"
UseModule DynamicDialogs_suffixed				; activate AddOn-Module  "DynamicDialogs_suffixed"

ClearXML()						; Clear the internal XML-Buffer, to marke sure, we start from scrath (not really neccessarry at the beginning)

SetXMLOutputFormat(#XMLout_Indent, 5)						; Each new created subnode will have an indent of 5 Spaces
SetXMLOutputFormat(#XMLout_AlignLineBreak, #True)		; 

Window__(#WinMain, "MainWindow", "DialogWrapper Demo1 - 9 Gadgets: Button to ExplorerCombo", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget, 810, 480, 800, 550)
	SingleBox__(0,0,"20")
		GridBox__(3,20,20,#Expand_Yes, 4)		; Create a Gridbox with 3 columns and 40 Pixel spacing between each row/column
			
			Canvas__(#gadCanvas,"", #PB_Canvas_ClipMouse | #PB_Canvas_DrawFocus)
			ButtonImage__(#gadButtonImage, "",0,0,#PB_Button_Toggle )
			Calendar__(#gadCalendar,"",Date()-3600*48,0,150)		; parameter 'Date' is not supportet by the Dialogs-Lib so far
			HyperLink__(#PB_Ignore, "", "www.PureBasic.com")
			ComboBox__(#PB_Ignore, "MyComboBox", #PB_ComboBox_Editable,260,0,#alignCenter)
			Editor__(#PB_Ignore, "", "Test-Text", #PB_Editor_WordWrap)
			CheckBox__(#PB_Ignore, "MyCheckBox", " just turn me ON of OFF", #PB_CheckBox_ThreeState,0,0,#alignCenter)
			DateTime__(#PB_Ignore, "", "  Datum: %mm/%dd/%yyyy Time: %hh:%ii       ", 22, #PB_Date_CheckBox,240,28,#alignCenter)		; parameter 'Date' is not supportet by the Dialogs-Lib so far
			ExplorerCombo__(#PB_Ignore, "", "c:\Windows\System32\drivers\",0,240,28,#alignCenter)
			ExplorerList__(#PB_Ignore, "", "c:\Windows\System32\drivers\", #PB_Explorer_GridLines)
			Button__(#gadButton, "", "Button-Gadget"+#LF$+#LF$+"Click to set random"+#CRLF$+"Date && Time", #PB_Button_MultiLine,0,90)
			ExplorerTree__(#PB_Ignore, "", "c:\Windows\System32\drivers\", #PB_Explorer_AutoSort | #PB_Explorer_NoFiles,0,100)
			
		EndGridBox__()
	EndSingleBox__()
EndWindow__()

UnuseModule DynamicDialogs_suffixed				;  we don't need the 'suffixed'-functions any more

Define xmlWinMain$ = GetXML()		; get the up to now build XML-Code from the Wrapper-Modul

Debug xmlWinMain$						; Debug the XML-Code, just for your Info

Define n

If OpenDialogWindow(#DialogMain, xmlWinMain$,0, "MainWindow",0,0,0,0,0,#DialogError_MsgBox)
	
	UnuseModule DynamicDialogs				;  Unuse module "DynamicDialogs". From now on you need to add "DynamicDialogs::" in front of any DynamicDialogs-Module Function
	
	Repeat
		Define Event = WaitWindowEvent()
		If Event = #PB_Event_SizeWindow
			Debug WindowWidth(#WinMain)
			Debug WindowHeight(#WinMain)
		EndIf
		
	Until Event = #PB_Event_CloseWindow 
	
EndIf

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
; DisableDebugger
