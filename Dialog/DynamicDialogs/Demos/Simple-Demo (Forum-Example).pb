XIncludeFile "..\DynamicDialogs_suffixed.pbi"

UseModule	DynamicDialogs					; to enable the 'general' commands
UseModule	DynamicDialogs_suffixed		; to enable the XML-Elements with 'suffixed' syntax

ClearXML()	; make sure, the XML-Dialog is empty before you begin a new one

; --- Create the Dialog ---

Window__(#PB_Any, "", "DynamicDialog Example", #PB_Window_SizeGadget | #PB_Window_SystemMenu)	; create a resizeable window
	vBox__(1)																; create a vertical-Box, where only the first Element in the vBox will be auto-resized
		Editor__(#PB_Ignore, "myEditorGadget","",0,0,180)		; create an EditorGadget() with the 'Name': "myEditorGadget"
		Button__(1,"","Click me ...")									; create a Button with Gadget-Number = 1
	EndVBox__()																; End-Tag for the previously opened vBox
EndWindow__()																; End-Tag for the window

UnuseModule	DynamicDialogs_suffixed									; we don't need the XML-Elements any more

If OpenDialogWindow(1, GetXML())		; Open the last created Window (or specify the Window by ID or Name$)
	
	For n = 1 To 10		; Fill Editor-Gadget with some content. Adress the Editor-Gadget by using its Name => "myEditorGadget"
		SetGadgetText(DialogGadget(1,"myEditorGadget"),GetGadgetText(DialogGadget(1,"myEditorGadget"))+"Line "+Str(n)+#LF$)
	Next
	
	Repeat : Until	WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
