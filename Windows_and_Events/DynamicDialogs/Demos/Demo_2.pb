; DynamicDialogs Demo 2 

EnableExplicit

XIncludeFile "..\DynamicDialogs_suffixed.pbi"			; include the Wrapper, to easily build correct XML-Dialogs

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

; ----- Creating the MainWindow by using the Dialog-Wrapper Commands

UseModule DynamicDialogs							; we need the 'main'-Module for constants and the standard Functions
UseModule DynamicDialogs_suffixed				; use the aditional Module "DynamicDialogs_suffixed" with suffix for auto indentation

ClearXML()						; Clear the internal XML-Buffer, to marke sure, we start from scrath (not really neccessarry at the beginning)

; SetXMLOutputFormat(#XMLout_Indent, 5)						; Each new created subnode will have an indent of 5 Spaces
; SetXMLOutputFormat(#XMLout_AlignLineBreak, #True)		; 

Window__(#WinMain, "MainWindow", "DynamicDialogs Demo2 ", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget, 810, 480, 800, 550)
	vBox__(5,0,10)		; only the 5th Element (the container with 2 Splitter-Elements) will change it's size, 10px between each Element
				GridBox__(3)
					Option__(#PB_Ignore,"","Option 1")
					Option__(#PB_Ignore,"","Option 1")
					Option__(#PB_Ignore,"","Option 1")
					Option__(#PB_Ignore,"","Option 21",2)
					Option__(#PB_Ignore,"","Option 22",2)
					Option__(#PB_Ignore,"","Option 1")
				EndGridBox__()
				ProgressBar__(#PB_Ignore,"Progress",35,120,0,0,40)
				Spin__(#PB_Ignore,"Spin",35,120,40,#PB_Spin_Numeric,0,0,#alignCenter)
				ScrollBar__(#PB_Ignore,"Scroll",35,120,40,10,0,0,24)
		Container__()
	vBox__()
				Panel__()
					Tab__("Tab 1")
						Splitter__(#PB_Ignore, "", 100,200,#PB_Splitter_Vertical,0,0,0,"0")
							CheckBox__(2545,""," Check me !!!", 0,0,0,#alignCenter)
							Editor__(4444)
						EndSplitter__()
					EndTab__()				
					Tab__("Tab 3","2")
						Splitter__(#PB_Ignore,"",200,100, #PB_Splitter_Vertical)
							Button__(25345)
							Editor__(424)
						EndSplitter__()
					EndTab__()
				EndPanel__()
				Splitter__(#PB_Ignore,"Splitter_03",100,100,#PB_Splitter_Vertical)
					Button__(255,"","Button"+#LF$+"in 'Splitter_03'", #PB_Button_MultiLine)
					Editor__(444,"","Editor-Gadget in 'Splitter_03'", #PB_Editor_WordWrap)
				EndSplitter__()
	EndVBox__()
		EndContainer__()
	EndVBox__()
EndWindow__()


Define xmlWinMain$ = GetXML()		; get the up to now build XML-Code

Debug xmlWinMain$						; Debug the XML-Code, just for your Information

; ----- Check the generated XML-Code, if there are any problems.  If so, generate a MessageBox and Debug some infos.

CheckDialog(xmlWinMain$, #DialogError_MsgBox)

Define n

If OpenDialogWindow(0, xmlWinMain$, #WinMain, "", #PB_Ignore,#PB_Ignore,850,600,0,#DialogError_MsgBox)
	
	SetGadgetState(DialogGadget(#DialogMain, "Progress"), 50)
	
	Repeat
		Define Event = WaitWindowEvent()
		If Event = #PB_Event_SizeWindow
			Debug WindowWidth(#WinMain)
			Debug WindowHeight(#WinMain)
		EndIf
		
	Until Event = #PB_Event_CloseWindow 
	
EndIf

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; CursorPosition = 31
; FirstLine = 26
; Folding = -
; EnableUnicode
; EnableXP
; EnableCompileCount = 165
; EnableBuildCount = 0
; EnableExeConstant