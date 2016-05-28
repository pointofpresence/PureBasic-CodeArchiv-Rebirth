DeclareModule DynamicDialogs
	
	;> ===== KONSTANTEN				; diverse Konstanten, z.B. #align...,  #Expand...
		
		#alignTop		= 1								; Konstanten für das Alignment von Elementen
		#alignBottom	= 2
		#alignLeft		= 4
		#alignRight		= 8
		#alignCenter	= 16
		
		#alignTopLeft			= #alignTop | #alignLeft
		#alignTopCenter		= #alignTop | #alignCenter
		#alignTopRight			= #alignTop | #alignRight
		#alignCenterLeft		= #alignCenter | #alignLeft
		#alignCenterRight		= #alignCenter | #alignRight
		#alignLeftCenter		= #alignCenterLeft
		#alignRightCenter		= #alignCenterRight
		#alignBottomLeft		= #alignBottom | #alignLeft
		#alignBottomCenter	= #alignBottom | #alignCenter
		#alignBottomRight		= #alignBottom | #alignRight
		
		#NodeErrorMessage_None	= 0					; Konstanten für die Art der Anzeige von Fehlermeldungen
		#NodeErrorMessage_Short	= 1
		#NodeErrorMessage_Long	= 2
		
		#Expand_Yes				= -2						; Expand-Konstanten für die diversen Layout-Elemente (wie z.B. GridBox, SingleBox, ...)
		#Expand_No				= -3			
		#Expand_Equal			= -4
		#Expand_Vertical   	= -5
		#Expand_Horizontal 	= -6
		
		#XMLout_LineBreak			= 1					; Attribut-Konstanten für:  SetXMLOutputFormat(Attribut, Value)
		#XMLout_Indent				= 2
		#XMLout_UseRealTab		= 3
		#XMLout_AlignLineBreak	= 4
		
		#XmlDefaultMargin$ = "10"
		#XmlDefaultSpacing = 5
		
		#DialogError_No		= 0
		#DialogError_Debug	= 1
		#DialogError_MsgBox	= 2
		
		#Dialog_AutoMinSize	= -64738
		
		Enumeration	XML_NodeID		; Nodes for Elements, which can contain other Elements - so they need an EndNode
			#Node_FirstNode
			
			#Node_Dialog = #Node_FirstNode
			#Node_Window
			#Node_HBox
			#Node_VBox
			#Node_Gridbox
			#Node_Multibox
			#Node_Singlebox
			
			#Node_Container
			#Node_Frame
			#Node_Panel
			#Node_Tab
			#Node_Scrollarea
			#Node_Splitter
			
			#Node_LastNode = #Node_Splitter
		EndEnumeration
		;<
	
	;> ===== Diverse Prozeduren, u.A. zum Bearbeiten des XML-Textes
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Declare		OpenDialogWindow(DialogNr, XML$, [ WindowNr, WindowName$, X, Y, MinWidth, MinHeight, ParentWindowID, ErrorMessageType])
		
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Declare		ShowNodeErrors(State)							; zum de-/aktiviert von Nachrichten, die bei Fehlern von Close-Nodes angezeigt werden
			Declare 		ClearXML(ClearNodeList=#True)					; löschen bzw. zurücksetzen des bisher erzeugten XML-Codes
			Declare.s	GetXML(IncludeExtensions=#True)												; abrufen des bisher erzeugten XML-Codes
			Declare		SetXML(XML_Text$, XmlConvert=#False)		; setzt den XML-Code. alle folgenden Befehle fügen ihren code hier an
			Declare.s	AddXML(XML_Text$, XmlConvert=#False)		; zum einfügen diverser eigener XML-Codes
			Declare		SetXMLOutputFormat(Attribut, Value)			; hiermit können Parameter für die Formatierung des erzeugten XML-Codes gesetzt werden (z.B. ob ein #CR angefüft wird oder ob und wie weit Zeilen eingerückt werden)
			Declare.s	T2H(Text$)
			Declare.s	CloseNode(NodeType = #PB_Any)					; statt immer den passenden Endxxx()-Befehl zu nehmen, kann auch einfach CloseNode() genommen werden. es wird automatisch das zuletzt geöffnete Node geschlossen.
			
			Declare		CheckDialog(XML$, ErrorMessageType = #DialogError_Debug)		; to check, if a Dialog-Definition is OK
			Declare		OpenDialogWindow(DialogNr, XML$, WindowNr=#PB_Ignore, WindowName$="", X=#PB_Ignore, Y=#PB_Ignore, MinWidth=#PB_Ignore, MinHeight=#PB_Ignore, ParentWindowID=0, ErrorMessageType = #DialogError_Debug)
			Declare		CloseDialogWindow(DialogNr)
			
			Declare		_dyn_Font(Name$, Height, Style=0)
			Declare		_dyn_FontByID(FontID=#PB_Default)
			
		CompilerEndIf
		
		Macro EndNode(NodeType = #PB_Any)							; Macro, um statt CloseNode() auch EndNode() nutzen zu können
			DynamicDialogs::CloseNode(NodeType)
		EndMacro
																				;<
		
	;> ===== XML-Layout Elemente
		
		Declare.s	_dyn_Dialogs()
		Declare.s 	_dyn_Window(ID=#PB_Ignore, Name$="", Titel$="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$="")
		Declare.s	_dyn_vBox(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam$="")
		Declare.s	_dyn_hBox(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam$="")
		Declare.s	_dyn_GridBox(Columns=#PB_Default, ColSpacing=#PB_Default, RowSpacing=#PB_Default, ColExpand=#PB_Default, RowExpand=#PB_Default, XmlParam$="")
		Declare.s	_dyn_MultiBox(Expand=#PB_Default, Align=#PB_Default, Margin$="0", XmlParam$="")
		Declare.s	_dyn_SingleBox(Expand=#PB_Default, Align=#PB_Default, Margin$="0", Expandwidth=0, Expandheight=0, XmlParam$="")
		Declare.s	_dyn_Empty(Width=#PB_Default, Height=#PB_Default, XmlParam$="")
		
		;<	
	;> ===== XML-Layout Elemente					(Close-Nodes)
		
		Declare.s	_dyn_EndDialogs()
		Declare.s	_dyn_EndWindow()											; End- bzw Close-Node für einen vorherigen Window()-Container
		Declare.s	_dyn_EndVBox()
		Declare.s	_dyn_EndHBox()
		Declare.s	_dyn_EndGridBox()										; End- bzw Close-Node für einen vorherigen GridBox()-Container
		Declare.s	_dyn_EndMultiBox()
		Declare.s	_dyn_EndSingleBox()
		;<
	
	;> ===== PuraBasic Container-Elemente
		
		Declare.s	_dyn_Container(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Frame(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Panel(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Tab(Text$="", Margin$="")
		Declare.s	_dyn_ScrollArea(ID=#PB_Ignore, Name$="", ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Splitter(ID=#PB_Ignore, Name$="", FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
		;<	
	;> ===== PuraBasic Container-Elemente		(Close-Nodes)
		
		Declare.s	_dyn_EndContainer()
		Declare.s	_dyn_EndFrame()
		Declare.s	_dyn_EndPanel()
		Declare.s	_dyn_EndTab()
		Declare.s	_dyn_EndScrollArea()
		Declare.s	_dyn_EndSplitter()
		;<
	
	;> ===== PuraBasic Gadgets	
		
		Declare.s	_dyn_Button(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ButtonImage(ID=#PB_Ignore, Name$="", ImageID=#PB_Ignore , Image2ID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Calendar(ID=#PB_Ignore, Name$="", Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Canvas(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_CheckBox(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ComboBox(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_DateTime(ID=#PB_Ignore, Name$="", Mask$="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Editor(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ExplorerCombo(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ExplorerList(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ExplorerTree(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_HyperLink(ID=#PB_Ignore, Name$="", Text$="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_IPAddress(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Image(ID=#PB_Ignore, Name$="", ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ListIcon(ID=#PB_Ignore, Name$="", FirstColumnTitle$="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ListView(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Option(ID=#PB_Ignore, Name$="", Text$="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ProgressBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_ScrollBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Spin(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_String(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Text(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_TrackBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Tree(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Web(ID=#PB_Ignore, Name$="", URL$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
		Declare.s	_dyn_Scintilla(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
		;<
		
	;	TODO: ggfl. abklären, was es mit <Item ...> für TreeGadgets auf sich hat
		
EndDeclareModule
Module DynamicDialogs
	
		CompilerIf #PB_Compiler_Unicode
			#XmlEncoding = #PB_UTF8
		CompilerElse 
			#XmlEncoding = #PB_Ascii
		CompilerEndIf

	;> -----  VARIABLEN   -  Globale Variablen und #Konstanten   (innerhalb dieses Moduls)
		
		Global	XMLBuffer$												; Variable, die den gesamten, bisher erzeugten XML-Code beinhaltet
		Global	ExtensionBuffer$										; Puffer für Zusatzfunktion wie Font(), FontByID() oder auch ImageIDs
		Global	LastXMLLine$											; die zu letzt erzeugte XML-Zeile sowie alle Close-Nodes  =>  wir nur für Error-Meldungen verwendet
		Global	NewList NodeTree.l()									; Liste aller offenen Nodes. Beim Schließen einer Node wird der letzte Eintrag gelöscht.
		Global	ShowNodeErrors.l = #NodeErrorMessage_Short	; should be changed to #NodeErrorMessage_None on life-projects
		
		Global	XMLout_LineBreak			= #True					; erstellt beim erzeugten XML-Code nach jeder Zeile einen Zeilenumbruch
		Global	XMLout_Indent				= 5						; legt fest, um wieviele Zeichen der Text bei einer Sub-Node eingerückt wird
		Global	XMLout_UseRealTab			= #False					; nutzt zur einrücken des Textes TABs (Chr(9)), statt Leerzeichen.
		Global	XMLout_AlignLineBreak	= #True					; Durch den automatischen Align-Befehl in allen 'Gadgets' werden evtl. automatisch SingleBoxen-Container erstellt.
																				; mit XMLout_AlignLineBreak kann festgelegt werden, ob auch hierfür Zeilenumbruch und Einrücken genutzt wird.
		
		Global	CR$ = #CR$												; Je nach Status von XMLout_LineBreak beinhaltet CR$ ein #CR$ oder nicht.
		
		#Expand_No$				= "'no'"
		#Expand_Yes$			= "'yes'"
		#Expand_Equal$			= "'equal'"
		#Expand_Vertical$   	= "'vertical'"
		#Expand_Horizontal$ 	= "'horizontal'"
		#Expand_Item$			= "'item:"
		
		Structure	Struct_DialogInfo
			DialogID.i
			XmlID.i
			WinID.i
			WinName$
			ParentWindowID.i
		EndStructure		
		Structure	Struct_Fonts
			Name$
			Height.w
			Style.w
			FontNr.i
			FontID.i			
		EndStructure	
		Structure	Struct_Gadgets
			GadgetNr.i
			GadgetID.i
			GadgetName$
			FontID.i
			ImageID.i
			Image2ID.i
			GadgetType.i
		EndStructure
		
		Global	NewList Dialog.Struct_DialogInfo()
		Global	NewList Fonts.Struct_Fonts()
		Global	NewList Gadgets.Struct_Gadgets()
		Global	LastUsedDialog = -1
		Global	ActFontID		= #PB_Default
		;<
	;> -----  VARIABLEN   -  Definition der Strings für </Close-Nodes>
		
		Global	Dim	NodeType$(#Node_LastNode)
		
		NodeType$(#Node_Dialog)			= "</dialogs>"
		NodeType$(#Node_Window)			= "</window>"
		NodeType$(#Node_HBox)			= "</hbox>"
		NodeType$(#Node_VBox)			= "</vbox>"
		NodeType$(#Node_Gridbox)		= "</gridbox>"
		NodeType$(#Node_Multibox)		= "</multibox>"
		NodeType$(#Node_Singlebox)		= "</singlebox>"
		
		NodeType$(#Node_Container)		= "</container>"
		NodeType$(#Node_Frame)			= "</frame>"
		NodeType$(#Node_Panel)			= "</panel>"
		NodeType$(#Node_Tab)				= "</tab>"
		NodeType$(#Node_Scrollarea)	= "</scrollarea>"
		NodeType$(#Node_Splitter)		= "</splitter>"
		;<
	
	;> -----  MACROS      -  Diverse Macros für immer wieder verwendete Routinen um Parameter zu verarbeiten
		
		Macro Auswertung_Parameter_Date															; Macro für Parameter: Date (Datum)
			
			; TODO - Parameter DATE wird scheinbar noch nicht von der Dialog-Lib unterstützt.  Hier ggfl. UPDATEN falls sich das ändert.
			
			If Date <> #PB_Default And Date <>	0
				Debug "-"
				Debug	"XML-Dialog '<"+#PB_Compiler_Procedure+"...>':   Date='*'  attribute is actually not supported by Dialog-Library. Please set the Date after 'OpenXMLDialog()' by using 'SetGadgetState()'"
				Debug "-"
				XML$	+	" Date='"+Str(Date)+"'"
				XML$	+	" value='"+Str(Date)+"'"
			EndIf
		EndMacro
		Macro Auswertung_Parameter_Mask															; Macro für Parameter: Maske (Datum)
			If Mask$ <> "" : XML$	+	" text='"+T2H(Mask$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_ID																; Macro für Parameter: ID
			If ID = #PB_Any
				XML$	+	" id='#PB_Any'"
			ElseIf ID >= 0
				XML$	+	" id='"+Str(ID)+"'"
			EndIf
		EndMacro
		Macro Auswertung_Parameter_ImageID														; Macro für Parameter: ImageID
			If ImageID <> #PB_Ignore
				If Name$="" And ID < 0 : Name$="Gad_"+Str(Random(999999))+Str(ElapsedMilliseconds()) : EndIf	; Gadget MUST have an ID or a Name, so set the ImageID
				If IsImage(ImageID) : ImageID = ImageID(ImageID) : EndIf
				_dyn_SetGadgetImage(ID, Name$, ImageID)
; 				_dyn_SetGadgetImage(ID, Name$, ImageID, ActGadgetType)
				; XML$	+	" image='"+Str(ImageID)+"'"										; ImageID wird von PB derzeit nicht unterstützt
			EndIf
		EndMacro
		Macro Auswertung_Parameter_Image2ID														; Macro für Parameter: Image2ID
			If Image2ID <> #PB_Ignore
				If Name$="" And ID < 0 : Name$="Gad_"+Str(Random(999999))+Str(ElapsedMilliseconds()) : EndIf	; Gadget MUST have an ID or a Name, so set the ImageID
				If IsImage(Image2ID) : Image2ID = ImageID(Image2ID) : EndIf
				_dyn_SetGadgetImage(ID, Name$, Image2ID, #True)
; 				_dyn_SetGadgetImage(ID, Name$, Image2ID, ActGadgetType, #True)
				; XML$	+	" image='"+Str(Image2ID)+"'"										; ImageID wird von PB derzeit nicht unterstützt
			EndIf
		EndMacro
		Macro Auswertung_Parameter_Color															; Macro für Parameter: Color
			If Color <> #PB_Ignore : XML$	+	" value='"+Str(Color)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Group															; Macro für Parameter: Group (Option Buttons)
			If Group <> #PB_Ignore : XML$	+	" group='"+Str(Group)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Min															; Macro für Parameter: Min	(Progress- & ScrollBar)
			If Min <> #PB_Ignore : XML$	+	" min='"+Str(Min)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Max															; Macro für Parameter: Max	(Progress- & ScrollBar)
			If Max <> #PB_Ignore : XML$	+	" max='"+Str(Max)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Value															; Macro für Parameter: Value (ScrollBar - akt. Wert)
			If Value <> #PB_Ignore : XML$	+	" value='"+Str(Value)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_PageLength													; Macro für Parameter: PageLength (ScrollBar-Seitenlänge)
			If PageLength <> #PB_Ignore : XML$	+	" page='"+Str(PageLength)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Name															; Macro für Parameter: Name$
			If Len(Name$)	:	XML$	+	" name='"+T2H(Name$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Path															; Macro für Parameter: Path$
			If Len(Path$)	:	XML$	+	" text='"+T2H(Path$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Text															; Macro für Parameter: Text$
			If Len(Text$)	:	XML$	+	" text='"+T2H(Text$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_URL															; Macro für Parameter: URL$
			If Len(URL$)	:	URL$	+	" text='"+T2H(URL$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Titel															; Macro für Parameter: Titel$
			If Len(Titel$)	:	XML$	+	" text='"+T2H(Titel$)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Width															; Macro für Parameter: Width
			If Width <>	#PB_Default	And Width <> #PB_Ignore	:	XML$	+	" width='"+Str(Width)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Height														; Macro für Parameter: Height
			If Height <> #PB_Default And Height <>	#PB_Ignore	:	XML$	+	" height='"+Str(Height)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_MinWidth														; Macro für Parameter: MinWidth
			If MinWidth = #Dialog_AutoMinSize
				XML$	+	" minwidth='auto'"
			ElseIf MinWidth <>	#PB_Default	And MinWidth <> #PB_Ignore And MinWidth <> 0
				XML$	+	" minwidth='"+Str(MinWidth)+"'"
			EndIf
		EndMacro
		Macro Auswertung_Parameter_MinHeight													; Macro für Parameter: MinHeight
			If MinHeight = #Dialog_AutoMinSize
				XML$	+	" minheight='auto'"
			ElseIf MinHeight <> #PB_Default And MinWidth <> #PB_Ignore And MinWidth <> 0
				XML$	+	" minheight='"+Str(MinHeight)+"'"
			EndIf
		EndMacro
		Macro Auswertung_Parameter_MaxWidth														; Macro für Parameter: MaxWidth
			If MaxWidth <>	#PB_Default	And MaxWidth <> #PB_Ignore	And MaxWidth <> 0	:	XML$	+	" maxwidth='"+Str(MaxWidth)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_MaxHeight													; Macro für Parameter: MaxHeight
			If MaxHeight <> #PB_Default And MaxHeight <>	#PB_Ignore And MaxHeight <> 0	:	XML$	+	" maxheight='"+Str(MaxHeight)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_XmlParam														; Macro für Parameter: XmlParam$
			If Len(XmlParam$)	:	XML$	+	" "+XmlParam$ : EndIf
		EndMacro
		Macro Auswertung_Parameter_Spacing														; Macro für Parameter: Spacing
			If Spacing <> #PB_Default	: XML$ +	" spacing='"+Str(Spacing)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_Margin														; Macro für Parameter: Margin$
			If Margin$ = "" : Margin$ = "0" : EndIf
			If Margin$ <> #XmlDefaultMargin$ And Not FindString(UCase(Margin$),"DEFAULT")
				XML$ + " margin='"+Margin$+"'"
			EndIf
		EndMacro
		Macro Auswertung_Parameter_Expand														; Macro für Parameter: Expand
			If Expand = 0 : Expand = #PB_Default : EndIf
			If Expand <> #PB_Default																; Parameter: ColExpand
				If 		Expand = #Expand_Yes				: XML$	+	" expand="+#Expand_Yes$					; Expand = Yes
				ElseIf	Expand = #Expand_No				: XML$	+	" expand="+#Expand_No$					; Expand = No
				ElseIf	Expand = #Expand_Equal			: XML$	+	" expand="+#Expand_Equal$				; Expand = Equal
				ElseIf	Expand = #Expand_Vertical		: XML$	+	" expand="+#Expand_Vertical$			; Expand = Vertical
				ElseIf	Expand = #Expand_Horizontal	: XML$	+	" expand="+#Expand_Horizontal$		; Expand = Horizontal
				Else										: XML$	+	" expand="+#Expand_Item$+Str(Expand)+"'"	; Expand = Item:x
				EndIf
			EndIf
		EndMacro
		Macro Auswertung_Parameter_Align															; Macro für Parameter: Align
			Protected	Align$
			If Align = #PB_Default Or Align = #PB_Ignore : Align = 0 : EndIf
			
			If	Align & #alignTop		:	Align$ + "top,"		: EndIf
			If	Align & #alignBottom	:	Align$ + "bottom,"	: EndIf
			If Align & #alignLeft	:	Align$ + "left,"		: EndIf
			If Align & #alignRight	:	Align$ + "right,"		: EndIf
			If Align & #alignCenter	:	Align$ + "center,"	: EndIf
			If Right(Align$,1)="," : Align$=Left(Align$, Len(Align$)-1) : EndIf
			If Len(Align$) : XML$ + " align='"+Align$+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_FirstColumnTitle											; Macro für Parameter: FirstColumnTitle$
			If FirstColumnTitle$ <>	""	:	XML$	+	" text='"+FirstColumnTitle$+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_FirstColumnWidth											; Macro für Parameter: FirstColumnWidth
			If FirstColumnWidth <> #PB_Ignore	:	XML$	+	" value='"+Str(FirstColumnWidth)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_ScrollAreaWidth											; Macro für Parameter: ScrollAreaWidth
			If ScrollAreaWidth <>	#PB_Default	And ScrollAreaWidth <> #PB_Ignore	:	XML$	+	" ScrollAreaWidth='"+Str(ScrollAreaWidth)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_ScrollAreaHeight											; Macro für Parameter: ScrollAreaHeight
			If ScrollAreaHeight <>	#PB_Default	And ScrollAreaHeight <> #PB_Ignore	:	XML$	+	" ScrollAreaHeight='"+Str(ScrollAreaHeight)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_ScrollStep													; Macro für Parameter: ScrollStep
			If ScrollStep <>	#PB_Default	And ScrollStep <> #PB_Ignore	:	XML$	+	" ScrollStep='"+Str(ScrollStep)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_FirstMinSize												; Macro für Parameter: FirstMinSize
			If FirstMinSize <>	#PB_Default	And FirstMinSize <> #PB_Ignore	:	XML$	+	" firstmin='"+Str(FirstMinSize)+"'" : EndIf
		EndMacro
		Macro Auswertung_Parameter_SecondMinSize												; Macro für Parameter: SecondMinSize
			If SecondMinSize <>	#PB_Default	And SecondMinSize <> #PB_Ignore	:	XML$	+	" secondmin='"+Str(SecondMinSize)+"'" : EndIf
		EndMacro
		Macro Auswertung_SetzeAktuellenFont														; Macro um ggfl. den Gadget-Font zu setzen
			If ActFontID <> #PB_Default
				If Name$="" And ID < 0 : Name$="Gad_"+Str(Random(999999))+Str(ElapsedMilliseconds()) : EndIf	; Gadget MUST have an ID or a Name, so set a Font
				_dyn_SetGadgetFont(ID, Name$, ActFontID)
			EndIf
		EndMacro
		;<
	
	;> -----  PROZEDUREN  -  Diverse Prozeduren, u.A. zum Bearbeiten des XML-Textes 
		
		Procedure.s		Indent(AdditionalIndent=0)					; erzeugt die Formatierungs-Leerzeichen bzw. -Tabs zum Einrücken des XML-Textes
			Protected Ind$, n
			If XMLout_Indent > 0 And ListSize(NodeTree()) > 0
				If XMLout_UseRealTab
					For n = 1 To XMLout_Indent * (ListSize(NodeTree()) + AdditionalIndent)
						Ind$ + Chr(9)
					Next
				Else
					Ind$ = Space(XMLout_Indent * (ListSize(NodeTree()) + AdditionalIndent))
				EndIf
			EndIf
			ProcedureReturn Ind$
		EndProcedure
		Procedure		SetXMLOutputFormat(Attribut, Value)		; zum Setzen versch. Parameter für den erzeucgten XML-Code
			Select Attribut
				Case #XMLout_Indent
					XMLout_Indent = Value
				Case #XMLout_LineBreak
					XMLout_LineBreak = Value
				Case #XMLout_UseRealTab
					XMLout_UseRealTab = Value
				Case #XMLout_AlignLineBreak
					XMLout_AlignLineBreak = Value
			EndSelect
		EndProcedure
		
		Procedure.s		Align(XML_Code$, Align=0, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, ForceZeroMargin=#False)
			
			; Flag <ForceZeroMargin> wird für Elemente benötigt, die keine eigene Margin-Option haben und Margin somit durch
			;								  ein aussen-liegendes <singlebox>-Tag definiert werden muss (alle PB-Gadgets)
			
			Protected Col$, Row$, vBoxText$, vAlign$, hBoxText$, hAlign$, EndText$, n, ActPos, CR$, AddIndent, FinalXML$
			
			Protected ZeroMargin$ = " margin='0'"
			
			If ColSpan <> #PB_Ignore : Col$ = " colspan='"+Str(ColSpan)+"'" : EndIf
			If RowSpan <> #PB_Ignore : Row$ = " rowspan='"+Str(RowSpan)+"'" : EndIf
			If Margin$ = #XmlDefaultMargin$ Or FindString(Margin$,"Default",0,#PB_String_NoCase)
				Margin$ = " margin='"+#XmlDefaultMargin$+"'"
			ElseIf Margin$ <> "" 
				Margin$ = " margin='"+Margin$+"'"
			ElseIf ForceZeroMargin
				Margin$ = ZeroMargin$
			EndIf
			
			If XMLout_AlignLineBreak : CR$ = Chr(13) : EndIf
			
			If Align = #PB_Default Or Align = #PB_Ignore : Align = 0 : EndIf
			
			If Align & #alignTop		: vAlign$ + "top"		: EndIf
			If Align & #alignBottom	: vAlign$ + "bottom"	: EndIf
			If Align & #alignCenter And Not Align & (#alignTop | #alignBottom) : vAlign$ = "center" : EndIf
			
			If Align & #alignLeft	: hAlign$ + "left"	: EndIf
			If Align & #alignRight	: hAlign$ + "right"	: EndIf
			If Align & #alignCenter And Not Align & (#alignLeft | #alignRight) : hAlign$ = "center" : EndIf
			
			If Len(vAlign$)										; SingleBox mit vertikaler Expansion für top/bottom Ausrichtung
				If XMLout_AlignLineBreak : EndText$ + Indent() : EndIf
				vBoxText$ + "<singlebox expand='horizontal' align='"+vAlign$+"'"+Margin$+Col$+Row$+">"+CR$
				EndText$	+ "</singlebox>"+CR$
				Margin$	= ZeroMargin$
				ForceZeroMargin = #False
				Col$		= ""
				Row$		= ""
				AddIndent + 1
			EndIf
			If Len(hAlign$) Or (Margin$<>ZeroMargin$ And Margin$<>"" And ForceZeroMargin)			; SingleBox mit horizontaler Expansion für left/right Ausrichtung
				If AddIndent : hBoxText$ + Indent(AddIndent) : EndIf
				hBoxText$ + "<singlebox expand='vertical' align='"+hAlign$+"'" + Margin$+Col$+Row$+">"+CR$
				EndText$	= "</singlebox>"+CR$+EndText$
				If XMLout_AlignLineBreak : EndText$ = Indent(AddIndent) + EndText$ : EndIf
				Margin$	= ""
				Col$		= ""
				Row$		= ""
				AddIndent + 1
			EndIf
			If Len(Col$ + Row$ + Margin$)					; Wenn keine Singlebox erstellt wurde, dann ggfl. Colspan oder Rowspan in übergebenen XML-Text injizieren.
				For n = Len(XML_Code$) To 1 Step -1
					If Mid(XML_Code$, n, 1)=">"
						If Mid(XML_Code$, n-1, 2)="/>" : n-1 : EndIf
						If ForceZeroMargin And Margin$ = ZeroMargin$ : Margin$ = "" : EndIf
						XML_Code$ = Left(XML_Code$,n-1) + Col$ + Row$ + Margin$ + Mid(XML_Code$, n)
						Break
					EndIf
				Next
			EndIf
			
			If AddIndent
				XML_Code$ = Indent(AddIndent) + XML_Code$
			EndIf
			
			FinalXML$ = vBoxText$+hBoxText$+XML_Code$+CR$+EndText$
			If Right(FinalXML$,1) = Chr(13)
				FinalXML$ = Left(FinalXML$, Len(FinalXML$)-1)
			EndIf
			
			ProcedureReturn FinalXML$
			
		EndProcedure
		Procedure.s		T2H(Text$)										; konvertiert alle nicht unterstützten ASCii-Zeichen in gültigen HTML-Code
			Protected Pos=1
			Text$ = ReplaceString(Text$, "&", "&amp;")
			Text$ = ReplaceString(Text$, Chr(9), "&#9;")
			Text$ = ReplaceString(Text$, Chr(10), "&#10;")
			Text$ = ReplaceString(Text$, Chr(39), "&#39;")
			Text$ = ReplaceString(Text$, Chr(60), "&lt;")
			Text$ = ReplaceString(Text$, Chr(62), "&gt;")
			While pos < Len(Text$)
				If Asc(Mid(Text$,Pos,1)) < 32
					Text$ = Left(Text$,Pos-1)+Mid(Text$,pos+1)
				Else
					Pos + 1
				EndIf
			Wend
			ProcedureReturn Text$
		EndProcedure
		
		Procedure		ShowNodeErrors(State)						; zum de-/aktiviert von Nachrichten, die bei Fehlern von Close-Nodes angezeigt werden
			ShowNodeErrors = State
		EndProcedure
		Procedure		ShowNodeErrorMessage(NodeType)			; zeigt eine Close-Node Fehlermeldung an
			
			Protected	ChkNode$
			
			If NodeType < #Node_FirstNode Or NodeType > #Node_LastNode 			; Wenn übergebener NodeType ok ist, dann lese Definition, ansonsten zeige '<??? unknown ???>'
				ChkNode$ = "<??? unknown ???>"
			Else
				ChkNode$ = NodeType$(NodeType)+" ("+Str(NodeType)+")"
			EndIf
			
			Protected	Msg$ = "Trying To close NodeType: '"+ChkNode$+"'"+CR$+CR$
			
			If LastElement(NodeTree())
				Msg$ + "but NodeType: '"+NodeType$(NodeTree())+"' should be closed instead of '"+ChkNode$+"'."
			Else
				Msg$ + "but NodeList is empty."
			EndIf
			
			MessageRequester("Close-Node Error !!!", Msg$, #PB_MessageRequester_Ok)
			
		EndProcedure
		Procedure		CheckLastNode(NodeType, ShowError = #PB_Default)		; returns #False, if last Node is NOT = NodeType, and #True, if last Node = NodeType
			
			If ShowError = #PB_Default : ShowError = ShowNodeErrors : EndIf
			
			If LastElement(NodeTree())
				If NodeType = NodeTree()
					ProcedureReturn #True
				EndIf
			EndIf
			
			If ShowError <> #NodeErrorMessage_None
				ShowNodeErrorMessage(NodeType)
			EndIf
			
		EndProcedure
		
		Procedure		ClearXML(ClearNodeList=#True)				; Löscht den XML-Buffer - setzt also die XML-Definition und ggfl. die Node-Liste zurück
			XMLBuffer$			= ""
			ExtensionBuffer$	= ""
			If ClearNodeList
				ClearList(NodeTree())
			EndIf
		EndProcedure
		Procedure.s		GetXML(IncludeExtensions=#True)											; 
			If IncludeExtensions And Len(ExtensionBuffer$) > 0
				ProcedureReturn	XMLBuffer$ + CR$ + "<?INFO - The following lines contain additional information, used by DynamicDialogs to support fonts and imageIDs ?>" + CR$ + CR$ + ExtensionBuffer$
			Else
				ProcedureReturn	XMLBuffer$
			EndIf	
		EndProcedure
		Procedure		SetXML(XML_Text$, XmlConvert=#False)	; 
			If XmlConvert
				XMLBuffer$ = T2H(XML_Text$)
			Else
				XMLBuffer$ = XML_Text$
			EndIf
		EndProcedure
		Procedure.s		AddXML(XML_Text$, XmlConvert=#False)	; fügt den übergebenen XML-Text dem XML-Puffer hinzu.
			If XmlConvert
				XML_Text$ = T2H(XML_Text$)
			EndIf
			
			If XMLout_Indent : XML_Text$ = Trim(XML_Text$) : EndIf
			
			XMLBuffer$ + Indent() + XML_Text$ + CR$
			LastXMLLine$ + XML_Text$ + CR$
			ProcedureReturn Indent() + XML_Text$
		EndProcedure
		Procedure.s		CloseNode(NodeType = #PB_Any)				; schließt die in NodeType vorgegebene Node, oder die Node des letzten Containers (letzter Listen-Eintrags in NodeTree())
			
			Protected	Node$, XML$
			
			If LastElement(NodeTree())
				If NodeType = #PB_Any
					NodeType = NodeTree()
				EndIf
			EndIf
			
			If NodeType < #Node_FirstNode Or NodeType > #Node_LastNode 			; Wenn übergebener NodeType ok ist, dann lese Definition, ansonsten zeige '<??? unknown ???>'
				XML$ = "</??? unknown node-type: '"+Str(NodeType)+"' ???>"
			Else
				XML$ = NodeType$(NodeType)
			EndIf
			
			If ListSize(NodeTree()) > 0
				DeleteElement(NodeTree(),1)
			EndIf
			
			XMLBuffer$ + Indent() + XML$ + CR$
			LastXMLLine$ + XML$ + CR$
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		
		Procedure		_CheckDialog_(XML$, ErrorMessageType = #DialogError_Debug, CheckOnly = #False)		; to check, if a Dialog-Definition is OK
			
			Protected	ReturnValue = #False
			Protected	xmlCatch = CatchXML(#PB_Any, @XML$, StringByteLength(XML$),0, #XmlEncoding)
			
			If xmlCatch And XMLStatus(xmlCatch) = #PB_XML_Success
				ReturnValue = xmlCatch
			ElseIf ErrorMessageType <> #DialogError_No
				Protected Err$ = "Error in Dialog-Definition: " + XMLError(xmlCatch) + " (Line: " + XMLErrorLine(xmlCatch) + ")"+#CR$+#CR$
				If XMLErrorLine(xmlCatch) > 0
					Err$ + StringField(XML$, XMLErrorLine(xmlCatch) + 1, #CR$)+#CR$+#CR$
				EndIf
				
				;Err$ + "XML-Definition '"+XML$+"' konnte nicht decodiert werden."
				If ErrorMessageType = #DialogError_MsgBox
					MessageRequester("Error in Dialog-Definition !!!", Err$, #PB_MessageRequester_Ok)
				Else
					Debug Err$
				EndIf
			EndIf
			
			If CheckOnly
				If IsXML(xmlCatch) : FreeXML(xmlCatch) : EndIf		; Free the XML.Object, if just needed to check the Definition
			Else
				ReturnValue = xmlCatch
			EndIf
			
			ProcedureReturn	ReturnValue
			
		EndProcedure
		Procedure		CheckDialog(XML$, ErrorMessageType = #DialogError_Debug)		; to check, if a Dialog-Definition is OK
			_CheckDialog_(XML$, ErrorMessageType, #True)	
		EndProcedure
		
		Procedure		OpenDialogWindow(DialogNr, XML$, WindowNr=#PB_Ignore, WindowName$="", X=#PB_Ignore, Y=#PB_Ignore, MinWidth=#PB_Ignore, MinHeight=#PB_Ignore, ParentWindowID=0, ErrorMessageType = #DialogError_Debug)
			
			Protected	TagPos, ActTextPos, LastTextPos, ActText$, ActAttribut$, ActImageID, ActFontID, n, SecondImage	; Text-Such-Variablen für Tags von Font- und Image-Erweiterungen
			
			Protected	DialogID
			Protected	DialogOK = CreateDialog(DialogNr)
			If DialogNr = #PB_Any : DialogID = DialogOK : Else : DialogID = DialogNr : EndIf
				
			Protected	Refresh_Dialog = #False
			Protected	ActGadgetNr
			
			;Debug ListSize(Dialog())
			
			If WindowName$ = ""
				ForEach Dialog()
					If WindowNr = Dialog()\WinID
						WindowName$ = Dialog()\WinName$
						Break
					EndIf
				Next
			Else
				ForEach Dialog()
					If UCase(WindowName$) = UCase(Dialog()\WinName$)
						Break
					EndIf
				Next
			EndIf
			
			Protected	xmlCatch = _CheckDialog_(XML$, ErrorMessageType, #False)
			
			If DialogOK And OpenXMLDialog(DialogID, xmlCatch, WindowName$ , X, Y , MinWidth, MinHeight, ParentWindowID)
				
				If ListIndex(Dialog()) < 0 Or UCase(Dialog()\WinName$) <> UCase(WindowName$)
					AddElement(Dialog())
					Dialog()\WinName$ = WindowName$
				EndIf
				
				If UCase(Dialog()\WinName$) = UCase(WindowName$)
					Dialog()\DialogID = DialogID
					Dialog()\WinID = DialogWindow(DialogID)
					Dialog()\XmlID	= xmlCatch
					If ParentWindowID <> #PB_Ignore : Dialog()\ParentWindowID = ParentWindowID : EndIf
				EndIf
				
				; ----- Gadget-Fonts setzen
				
				ActTextPos = 1
				
				Repeat
					
					TagPos = FindString(XML$, "<?Font ID='", ActTextPos) + 11
					
					If TagPos > 11		; neues <?Font ...>-Tag gefunden
						
						ActFontID = Val(StringField(Mid(XML$, TagPos),1,"'"))		; FontID auslesen
						
						LastTextPos = FindString(XML$, " ?>", TagPos)
						
						; -----  auf GadgetID-Attribut prüfen
						
						ActTextPos = FindString(XML$, "GadgetID='", TagPos, #PB_String_NoCase) + 10
						
						If ActTextPos > 10 And ActTextPos < LastTextPos						;  Attribut 'GadgetID=' gefunden
							
							ActAttribut$ = StringField(Mid(XML$, ActTextPos),1,"'")		;  Werte für Attribut für 'GadgetID=' lesen
							
							If Len(ActAttribut$) > 0
								
								For n = 1 To CountString(ActAttribut$, ",") + 1					;  Alle GadgetIDs für diesen Font abarbeiten
									
									ActGadgetNr = Val(StringField(ActAttribut$, n, ","))
									
									If IsGadget(ActGadgetNr) : SetGadgetFont(ActGadgetNr, ActFontID) : EndIf
									Refresh_Dialog = #True
									
								Next n
								
							EndIf
							
						EndIf
						
						; -----  auf GadgetName-Attribut prüfen
						
						ActTextPos = FindString(XML$, "GadgetName='", TagPos, #PB_String_NoCase) + 12
						
						If ActTextPos > 12 And ActTextPos < LastTextPos						;  Attribut 'GadgetName=' gefunden
							
							ActAttribut$ = StringField(Mid(XML$, ActTextPos),1,"'")		;  Werte für Attribut für 'GadgetName=' lesen
							
							If Len(ActAttribut$) > 0
								
								For n = 1 To CountString(ActAttribut$, "|*|") + 1				;  Alle GadgetIDs für diesen Font abarbeiten
									
									ActText$ = StringField(ActAttribut$, n, "|*|")
									
									If IsGadget(DialogGadget(DialogID, ActText$))
										
									SetGadgetFont(DialogGadget(DialogID, ActText$), ActFontID) : EndIf
									Refresh_Dialog = #True
									
								Next n
								
							EndIf
						
						EndIf
						
						ActTextPos = TagPos + 10
						
					Else			; Kein weiterer <?Font..>-Tag gefunden
						Break
					EndIf
					
				ForEver	; Schleife wird durch BREAK beendet, wenn kein weiterer <?Font..>-Tag mehr gefunden wurde
						
				
				; ----- Gadget-ImageID setzen
				
				ActTextPos = 1
				
				Repeat
					
					TagPos = FindString(XML$, "<?Image ID='", ActTextPos) + 12
					
					If TagPos > 12		; neues <?Image ...>-Tag gefunden
						
						ActImageID = Val(StringField(Mid(XML$, TagPos),1,"'"))		; ImageID auslesen
						
						LastTextPos = FindString(XML$, " ?>", TagPos)
						
						; -----  auf Attribut 'GadgetID=' prüfen
						
						ActTextPos = FindString(XML$, "GadgetID='", TagPos, #PB_String_NoCase) + 10
						
						If ActTextPos > 10 And ActTextPos < LastTextPos						;  Attribut 'GadgetID=' gefunden
							
							ActAttribut$ = StringField(Mid(XML$, ActTextPos),1,"'")		;  Werte für Attribut für 'GadgetID=' lesen
							
							If Len(ActAttribut$) > 0
								
								For n = 1 To CountString(ActAttribut$, ",") + 1					;  Alle GadgetIDs für dieses Image abarbeiten
									
									ActText$ = StringField(ActAttribut$, n, ",")
									If Right(ActText$, 7) = "(#2nd#)"
										SecondImage = #True
										ActText$ = Left(ActText$, Len(ActText$)-7)
									EndIf
									
									ActGadgetNr = Val(StringField(ActText$, n, ","))
									
									If IsGadget(ActGadgetNr)
										
										Select GadgetType(ActGadgetNr)
											Case #PB_GadgetType_ButtonImage
												If SecondImage
													SetGadgetAttribute(ActGadgetNr, #PB_Button_PressedImage, ActImageID)
												Else
													SetGadgetAttribute(ActGadgetNr, #PB_Button_Image, ActImageID)
												EndIf
											Case #PB_GadgetType_Image
												SetGadgetState(ActGadgetNr, ActImageID)
										EndSelect
										
										Refresh_Dialog = #True
										
									EndIf	
									
								Next n
								
							EndIf
							
						EndIf
						
						; -----  auf Attribut 'GadgetName=' prüfen
						
						ActTextPos = FindString(XML$, "GadgetName='", TagPos, #PB_String_NoCase) + 12
						
						If ActTextPos > 12 And ActTextPos < LastTextPos						;  Attribut 'GadgetName=' gefunden
							
							ActAttribut$ = StringField(Mid(XML$, ActTextPos),1,"'")		;  Werte für Attribut für 'GadgetName=' lesen
							
							If Len(ActAttribut$) > 0
								
								For n = 1 To CountString(ActAttribut$, "|*|") + 1				;  Alle GadgetIDs für dieses Image abarbeiten
									
									ActText$ = StringField(ActAttribut$, n, "|*|")
									If Right(ActText$, 7) = "(#2nd#)"
										SecondImage = #True
										ActText$ = Left(ActText$, Len(ActText$)-7)
									EndIf
									
									ActGadgetNr = DialogGadget(DialogID, ActText$)
									
									If IsGadget(ActGadgetNr)
										
										Select GadgetType(ActGadgetNr)
											Case #PB_GadgetType_ButtonImage
												If SecondImage
													SetGadgetAttribute(ActGadgetNr, #PB_Button_PressedImage, ActImageID)
												Else
													SetGadgetAttribute(ActGadgetNr, #PB_Button_Image, ActImageID)
												EndIf
											Case #PB_GadgetType_Image
												SetGadgetState(ActGadgetNr, ActImageID)
										EndSelect
										
										Refresh_Dialog = #True
										
									EndIf	
									
								Next n
								
							EndIf
						
						EndIf
						
						ActTextPos = TagPos + 10
						
					Else			; Kein weiterer <?Image..>-Tag gefunden
						Break
					EndIf
					
				ForEver	; Schleife wird durch BREAK beendet, wenn kein weiterer <?Image..>-Tag mehr gefunden wurde
						
				
				If Refresh_Dialog : RefreshDialog(DialogID) : EndIf

				If DialogNr = #PB_Any
					ProcedureReturn DialogID
				Else
					ProcedureReturn #True
				EndIf
				
			Else
					
				If IsXML(xmlCatch) : FreeXML(xmlCatch) : EndIf
				
				Protected	Err$ = "Error while opening XML-Dialog: "+#CR$+#CR$+"'"+DialogError(DialogID)+"'"
				
				If ErrorMessageType = #DialogError_MsgBox
					MessageRequester("Error while opening XML-Dialog !!!", Err$, #PB_MessageRequester_Ok)
				ElseIf ErrorMessageType = #DialogError_Debug
					Debug Err$
				EndIf
			EndIf
			
		EndProcedure
		Procedure		CloseDialogWindow(DialogNr)
			ForEach Dialog()
				If Dialog()\DialogID = DialogNr
					If IsDialog(Dialog()\DialogID) : FreeDialog(Dialog()\DialogID) : EndIf
					DeleteElement(Dialog())
					
					; Debug ListSize(Dialog())
			
					Break
				EndIf
			Next
		EndProcedure

; 		Procedure		WindowDialog(WindowNr)
; 		EndProcedure
		
		Procedure		_dyn_SetGadgetImage(GadgetNr, GadgetName$, ImageID, SecondImage = #False)
			
			Protected	ImageID_exists = #False
			Protected	ActTextPos, EndTextPos, ActInjectText$
			
				ImageID_exists = FindString(ExtensionBuffer$, "<?Image ID='"+Str(ImageID)+"' ") ; prüfen, ob für das aktuellen Image schon ein Eintrag besteht
				
				If Not ImageID_exists	; Wenn noch kein Eintrag existiert, dann erzeuge einen und setze Zeiger
					ImageID_exists = Len(ExtensionBuffer$) + 1
					ExtensionBuffer$ + "<?Image ID='"+Str(ImageID)+"' ?>" + CR$
				EndIf
				
				EndTextPos = FindString(ExtensionBuffer$, " ?>", ImageID_exists)		; Ende des "<?Image...?>-Tags ermitteln
				
				; --- wenn es eine GadgetID gibt, dann nutze Gadget ID ...
				
				If GadgetNr >= 0
					
					ActInjectText$ = Str(GadgetNr)
					If SecondImage : ActInjectText$ + "(#2nd#)" : EndIf
						
					ActTextPos	= FindString(ExtensionBuffer$, "GadgetID='", ImageID_exists, #PB_String_NoCase) + 10
					
					If ActTextPos <= 10 Or ActTextPos > EndTextPos	; Wenn noch kein 'GadgetID=' Eintrag existiert, dann erstelle einen
						
						ActTextPos = EndTextPos
						ActInjectText$ = " GadgetID='" + ActInjectText$ + "'"
						
					ElseIf Mid(ExtensionBuffer$, ActTextPos, 1) <> "'"	; Wenn schon eine GadgetID existiert, dann füge ein ',' als Trennzeichen hinzu
						
						ActInjectText$ + ","
						
					EndIf
						
					ExtensionBuffer$ = Left(ExtensionBuffer$, ActTextPos-1) + ActInjectText$ + Mid(ExtensionBuffer$, ActTextPos)
						
				Else			; --- ... ansonsten nutze den Namen.
				
					ActInjectText$ = GadgetName$
					If SecondImage : ActInjectText$ + "(#2nd#)" : EndIf
						
					ActTextPos	= FindString(ExtensionBuffer$, "GadgetName='", ImageID_exists, #PB_String_NoCase) + 12
					
					If ActTextPos <= 12 Or ActTextPos > EndTextPos
						
						ActTextPos = EndTextPos
						ActInjectText$ = " GadgetName='" + ActInjectText$ + "'"
						
					ElseIf Mid(ExtensionBuffer$, ActTextPos, 1) <> "'"	; Wenn schon ein GadgetName existiert, dann füge ein '|*|' als Trennzeichen hinzu
						
						ActInjectText$ + "|*|"
						
					EndIf
					
					ExtensionBuffer$ = Left(ExtensionBuffer$, ActTextPos-1) + ActInjectText$ + Mid(ExtensionBuffer$, ActTextPos)
						
				EndIf
				
		EndProcedure
		Procedure		_dyn_SetGadgetFont(GadgetNr, GadgetName$, FontID)
			
			Protected	FontID_exists = #False
			Protected	ActTextPos, EndTextPos, ActInjectText$
			
				FontID_exists = FindString(ExtensionBuffer$, "<?Font ID='"+Str(FontID)+"' ") ; prüfen, ob für den aktuellen Font schon ein Eintrag besteht
				
				If Not FontID_exists	; Wenn noch kein Eintrag existiert, dann erzeuge einen und setze Zeiger
					FontID_exists = Len(ExtensionBuffer$) + 1
					ExtensionBuffer$ + "<?Font ID='"+Str(FontID)+"' ?>" + CR$
				EndIf
				
				EndTextPos = FindString(ExtensionBuffer$, " ?>", FontID_exists)		; Ende des "<?Font...?>-Tags ermitteln
				
				; --- wenn es eine GadgetID gibt, dann nutze Gadget ID ...
				
				If GadgetNr >= 0
					
					ActInjectText$ = Str(GadgetNr)
						
					ActTextPos	= FindString(ExtensionBuffer$, "GadgetID='", FontID_exists, #PB_String_NoCase) + 10
					
					If ActTextPos <= 10 Or ActTextPos > EndTextPos
						
						ActTextPos = EndTextPos
						ActInjectText$ = " GadgetID='" + ActInjectText$ + "'"
						
					ElseIf Mid(ExtensionBuffer$, ActTextPos, 1) <> "'"	; Wenn schon eine GadgetID existiert, dann füge ein ',' als Trennzeichen hinzu
						
						ActInjectText$ + ","
						
					EndIf
						
					ExtensionBuffer$ = Left(ExtensionBuffer$, ActTextPos-1) + ActInjectText$ + Mid(ExtensionBuffer$, ActTextPos)
						
				Else			; --- ... ansonsten nutze den Namen.
				
					ActInjectText$ = GadgetName$
						
					ActTextPos	= FindString(ExtensionBuffer$, "GadgetName='", FontID_exists, #PB_String_NoCase) + 12
					
					If ActTextPos <= 12 Or ActTextPos > EndTextPos
						
						ActTextPos = EndTextPos
						ActInjectText$ = " GadgetName='" + ActInjectText$ + "'"
						
					ElseIf Mid(ExtensionBuffer$, ActTextPos, 1) <> "'"	; Wenn schon eine GadgetID existiert, dann füge ein '|*|' als Trennzeichen hinzu
						
						ActInjectText$ + "|*|"
						
					EndIf
						
					ExtensionBuffer$ = Left(ExtensionBuffer$, ActTextPos-1) + ActInjectText$ + Mid(ExtensionBuffer$, ActTextPos)
						
				EndIf
				
		EndProcedure
		Procedure		_dyn_Font(Name$, Height, Style=0)
			
			Protected NewFont
			
			Repeat	; Dummy-Loop, just to exit with Break
				
				ForEach	Fonts()
					If UCase(Trim(Name$)) = Fonts()\Name$ And Height = Fonts()\Height And Style = Fonts()\Style
						ActFontID = Fonts()\FontID
						Break 2		; Wenn Font schon mal geladen wurde, dann nutze die bereits existierende FontID
					EndIf
				Next
				
				; --- Font wurde zum ersten mal verwendet, also wird er geladen und der Font-Liste hinzu gefügt
				
				NewFont = LoadFont(#PB_Any, Name$, Height, Style)
				If NewFont
					AddElement(Fonts())
					Fonts()\Name$	= Name$
					Fonts()\Height	= Height
					Fonts()\Style	= Style
					Fonts()\FontNr	= NewFont
					Fonts()\FontID	= FontID(NewFont)
					ActFontID = Fonts()\FontID
				EndIf
				
			Until #True
		EndProcedure
		Procedure		_dyn_FontByID(FontID=#PB_Default)
			
			If FontID <> #PB_Default And IsFont(FontID) : FontID = FontID(FontID) : EndIf
			ActFontID = FontID
			
		EndProcedure
		
		;<
		
	;> -----  PROZEDUREN  -  XML-Layout Elements
		
		Procedure.s		_dyn_Dialogs()
			
			Protected XML$ = "<dialogs>"
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Dialog		; Element "Window" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Window(ID=#PB_Ignore, Name$="", Titel$="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$="")
			
			Protected XML$ = "<window"
			
			If Name$="" : Name$="Win_"+Str(Random(999999))+Str(ElapsedMilliseconds()) : EndIf	; Window MUST have a Name, so give it a random-Name
			
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Titel																			; Parameter: Titel$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_MinWidth																		; Parameter: MinWidth
			Auswertung_Parameter_MinHeight																	; Parameter: MinHeight
			Auswertung_Parameter_MaxWidth																		; Parameter: MaxWidth
			Auswertung_Parameter_MaxHeight																	; Parameter: MaxHeight
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Window_SystemMenu			= #PB_Window_SystemMenu			: XML$ + "#PB_Window_SystemMenu | "			: EndIf
				If flags & #PB_Window_MinimizeGadget	= #PB_Window_MinimizeGadget	: XML$ + "#PB_Window_MinimizeGadget | "	: EndIf
				If flags & #PB_Window_MaximizeGadget	= #PB_Window_MaximizeGadget	: XML$ + "#PB_Window_MaximizeGadget | "	: EndIf
				If flags & #PB_Window_SizeGadget			= #PB_Window_SizeGadget			: XML$ + "#PB_Window_SizeGadget | "			: EndIf
				If flags & #PB_Window_Invisible			= #PB_Window_Invisible			: XML$ + "#PB_Window_Invisible | "			: EndIf
				If flags & #PB_Window_TitleBar			= #PB_Window_TitleBar			: XML$ + "#PB_Window_TitleBar | "			: EndIf
				If flags & #PB_Window_Tool					= #PB_Window_Tool					: XML$ + "#PB_Window_Tool | "					: EndIf
				If flags & #PB_Window_BorderLess			= #PB_Window_BorderLess			: XML$ + "#PB_Window_BorderLess | "			: EndIf
				If flags & #PB_Window_ScreenCentered	= #PB_Window_ScreenCentered	: XML$ + "#PB_Window_ScreenCentered | "	: EndIf
				If flags & #PB_Window_WindowCentered	= #PB_Window_WindowCentered	: XML$ + "#PB_Window_WindowCentered | "	: EndIf
				If flags & #PB_Window_Maximize			= #PB_Window_Maximize			: XML$ + "#PB_Window_Maximize | "			: EndIf
				If flags & #PB_Window_Minimize			= #PB_Window_Minimize			: XML$ + "#PB_Window_Minimize | "			: EndIf
				If flags & #PB_Window_NoGadgets			= #PB_Window_NoGadgets			: XML$ + "#PB_Window_NoGadgets | "			: EndIf
				If flags & #PB_Window_NoActivate			= #PB_Window_NoActivate			: XML$ + "#PB_Window_NoActivate | "			: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + ">"
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			; --- Window-Name und evtl. ID in Liste eintragen, damit man bei OpenDialogWindow() die ID mit dem Namen verknüpfen kann
			
			AddElement(Dialog())
			Dialog()\WinName$ = Name$
			If ID = #PB_Ignore Or ID = #PB_Any : Dialog()\WinID = #PB_Any : Else : Dialog()\WinID = ID : EndIf
			
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Window		; Element "Window" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_vBox(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam$="")
			
			Protected XML$ = "<vbox"
			
			Auswertung_Parameter_Expand																						; Parameter: Expand
			Auswertung_Parameter_Align																							; Parameter: Align
			Auswertung_Parameter_Spacing																						; Parameter: Spacing
			Auswertung_Parameter_XmlParam																						; Parameter: XmlParam$
			
			XML$ + ">" 
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_VBox			; Element "vBox" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_hBox(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam$="")
			
			Protected XML$ = "<hbox"
			
			Auswertung_Parameter_Expand																						; Parameter: Expand
			Auswertung_Parameter_Align																							; Parameter: Align
			Auswertung_Parameter_Spacing																						; Parameter: Spacing
			Auswertung_Parameter_XmlParam																						; Parameter: XmlParam$
			
			XML$ + ">" 
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_HBox			; Element "hBox" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_GridBox(Columns=#PB_Default, ColSpacing=#PB_Default, RowSpacing=#PB_Default, ColExpand=#PB_Default, RowExpand=#PB_Default, XmlParam$="")
			
			Protected XML$ = "<gridbox"
			
			If Columns <> #PB_Default		: XML$	+	" columns='"+Str(Columns)+"'"			: EndIf				; Parameter: Columns
			If ColSpacing <> #PB_Default	: XML$	+	" colspacing='"+Str(ColSpacing)+"'" : EndIf				; Parameter: ColSpacing
			If RowSpacing <> #PB_Default	: XML$	+	" rowspacing='"+Str(RowSpacing)+"'" : EndIf				; Parameter: RowSpacing
			If ColExpand <> #PB_Default																							; Parameter: ColExpand
				If 		ColExpand = #Expand_Yes		: XML$	+	" colexpand="+#Expand_Yes$							; Expand = Yes
				ElseIf	ColExpand = #Expand_No		: XML$	+	" colexpand="+#Expand_No$							; Expand = No
				ElseIf	ColExpand = #Expand_Equal	: XML$	+	" colexpand="+#Expand_Equal$						; Expand = Equal
				Else											: XML$	+	" colexpand="+#Expand_Item$+Str(ColExpand)+"'"				; Expand = Item:x
				EndIf
			EndIf
			If RowExpand <> #PB_Default																							; Parameter: RowExpand
				If 		RowExpand = #Expand_Yes		: XML$	+	" rowexpand="+#Expand_Yes$							; Expand = Yes
				ElseIf	RowExpand = #Expand_No		: XML$	+	" rowexpand="+#Expand_No$							; Expand = No
				ElseIf	RowExpand = #Expand_Equal	: XML$	+	" rowexpand="+#Expand_Equal$						; Expand = Equal
				Else											: XML$	+	" rowexpand="+#Expand_Item$+Str(RowExpand)+"'"				; Expand = Item:x
				EndIf
			EndIf
			
			Auswertung_Parameter_XmlParam																							; Parameter: XmlParam$
			
			XML$ + ">" 
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Gridbox		; Element "GridBox" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_MultiBox(Expand=#PB_Default, Align=#PB_Default, Margin$="0", XmlParam$="")
			
			Protected XML$ = "<multibox"
			
			Auswertung_Parameter_Expand																						; Parameter: Expand
			Auswertung_Parameter_Align																							; Parameter: Align
			Auswertung_Parameter_Margin																						; Parameter: Margin$
			Auswertung_Parameter_XmlParam																						; Parameter: XmlParam$
			
			XML$ + ">" 
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$																			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Multibox		; Element "Multibox" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_SingleBox(Expand=#PB_Default, Align=#PB_Default, Margin$="0", Expandwidth=0, Expandheight=0, XmlParam$="")
			
			Protected XML$ = "<singlebox"
			
			Auswertung_Parameter_Expand																						; Parameter: Expand
			Auswertung_Parameter_Align																							; Parameter: Align
			Auswertung_Parameter_Margin																						; Parameter: Margin$
			
			If Expandwidth <> 0	: XML$ + " Expandwidth='"+Str(Expandwidth)+"'"		: EndIf					; Parameter: Expandwidth
			
			If Expandheight <> 0	: XML$ + " Expandheight='"+Str(Expandheight)+"'"	: EndIf					; Parameter: Expandheight
			
			Auswertung_Parameter_XmlParam																						; Parameter: XmlParam$
			
			XML$ + ">" 
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$																			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Singlebox		; Element "Singlebox" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Empty(Width=#PB_Default, Height=#PB_Default, XmlParam$="")
			
			Protected XML$ = "<empty"
			
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			XML$ + "/>"
			
			;XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		
		;<
	;> -----  PROZEDUREN  -  XML-Layout Elements  (Close-Nodes)
		
		Procedure.s		_dyn_EndDialogs()
			CheckLastNode(#Node_Dialog)
			ActFontID	= #PB_Default
			ProcedureReturn	CloseNode(#Node_Dialog)
		EndProcedure
		Procedure.s		_dyn_EndWindow()
			CheckLastNode(#Node_Window)
			ActFontID	= #PB_Default
			ProcedureReturn	CloseNode(#Node_Window)
		EndProcedure
		Procedure.s		_dyn_EndVBox()
			CheckLastNode(#Node_VBox)
			ProcedureReturn	CloseNode(#Node_VBox)
		EndProcedure
		Procedure.s		_dyn_EndHBox()
			CheckLastNode(#Node_HBox)
			ProcedureReturn	CloseNode(#Node_HBox)
		EndProcedure
		Procedure.s		_dyn_EndGridBox()
			CheckLastNode(#Node_Gridbox)
			ProcedureReturn	CloseNode(#Node_Gridbox)
		EndProcedure
		Procedure.s		_dyn_EndMultiBox()
			CheckLastNode(#Node_Multibox)
			ProcedureReturn	CloseNode(#Node_Multibox)
		EndProcedure
		Procedure.s		_dyn_EndSingleBox()
			CheckLastNode(#Node_Singlebox)
			ProcedureReturn	CloseNode(#Node_Singlebox)
		EndProcedure
		
		;<
	
	;> -----  PROZEDUREN  -  PB Container-Elements
		
		Procedure.s		_dyn_Container(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<container"
			
			Auswertung_SetzeAktuellenFont																		; Setze GadgetFont wenn nicht #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Container_Flat			= #PB_Container_Flat			: XML$ + "#PB_Container_Flat | "			: EndIf
				If flags & #PB_Container_Raised		= #PB_Container_Raised		: XML$ + "#PB_Container_Raised | "		: EndIf
				If flags & #PB_Container_Single		= #PB_Container_Single		: XML$ + "#PB_Container_Single | "		: EndIf
				If flags & #PB_Container_Double		= #PB_Container_Double		: XML$ + "#PB_Container_Double | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + ">"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Container		; Element "Container" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Frame(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<frame"
			
			Auswertung_SetzeAktuellenFont																		; Setze GadgetFont wenn nicht #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Frame_Single			= #PB_Frame_Single			: XML$ + "#PB_Frame_Single | "			: EndIf
				If flags & #PB_Frame_Double			= #PB_Frame_Double			: XML$ + "#PB_Frame_Double | "			: EndIf
				If flags & #PB_Frame_Flat				= #PB_Frame_Flat				: XML$ + "#PB_Frame_Flat | "				: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + ">"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Frame		; Element "Frame" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Panel(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<panel"
			
			Auswertung_SetzeAktuellenFont																		; Setze GadgetFont wenn nicht #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			XML$ + ">"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Panel		; Element "Panel" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Tab(Text$="", Margin$="") ;XmlParam$="")
			
			Protected XML$ = "<tab"
			
			Auswertung_Parameter_Text																			; Parameter: Text$
			;Auswertung_Parameter_XmlParam																	; Parameter: XmlParam$
			
			XML$ + ">"
			
			XML$ = Align(XML$, #PB_Default, Margin$, #PB_Ignore, #PB_Ignore)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Tab		; Element "Tab" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ScrollArea(ID=#PB_Ignore, Name$="", ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<scrollarea"
			
			Auswertung_SetzeAktuellenFont																		; Setze GadgetFont wenn nicht #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_ScrollAreaWidth
			Auswertung_Parameter_ScrollAreaHeight
			Auswertung_Parameter_ScrollStep
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			XML$ + ">"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Scrollarea		; Element "ScrollArea" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Splitter(ID=#PB_Ignore, Name$="", FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<splitter"
			
			Auswertung_SetzeAktuellenFont																		; Setze GadgetFont wenn nicht #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_FirstMinSize
			Auswertung_Parameter_SecondMinSize
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Splitter_Vertical			= #PB_Splitter_Vertical			: XML$ + "#PB_Splitter_Vertical | "			: EndIf
				If flags & #PB_Splitter_Separator		= #PB_Splitter_Separator		: XML$ + "#PB_Splitter_Separator | "		: EndIf
				If flags & #PB_Splitter_FirstFixed		= #PB_Splitter_FirstFixed		: XML$ + "#PB_Splitter_FirstFixed | "		: EndIf
				If flags & #PB_Splitter_SecondFixed		= #PB_Splitter_SecondFixed		: XML$ + "#PB_Splitter_SecondFixed | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + ">"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			LastElement(NodeTree()) : AddElement(NodeTree()) : NodeTree() = #Node_Splitter		; Element "Splitter" der Node-Liste hinzufügen
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		
		;<
	;> -----  PROZEDUREN  -  PB Container-Elements  (Close-Nodes)
		
		Procedure.s		_dyn_EndContainer()
			CheckLastNode(#Node_Container)
			ProcedureReturn	CloseNode(#Node_Container)
		EndProcedure
		Procedure.s		_dyn_EndFrame()
			CheckLastNode(#Node_Frame)
			ProcedureReturn	CloseNode(#Node_Frame)
		EndProcedure
		Procedure.s		_dyn_EndPanel()
			CheckLastNode(#Node_Panel)
			ProcedureReturn	CloseNode(#Node_Panel)
		EndProcedure
		Procedure.s		_dyn_EndTab()
			CheckLastNode(#Node_Tab)
			ProcedureReturn	CloseNode(#Node_Tab)
		EndProcedure
		Procedure.s		_dyn_EndScrollArea()
			CheckLastNode(#Node_Scrollarea)
			ProcedureReturn	CloseNode(#Node_Scrollarea)
		EndProcedure
		Procedure.s		_dyn_EndSplitter()
			CheckLastNode(#Node_Splitter)
			ProcedureReturn	CloseNode(#Node_Splitter)
		EndProcedure
		
		;<
	
	;> -----  PROZEDUREN  -  PureBasic Gadget-Elements
		
		Procedure.s		_dyn_Button(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<button"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Button_Right		= #PB_Button_Right		: XML$ + "#PB_Button_Right | "		: EndIf
				If flags & #PB_Button_Left			= #PB_Button_Left			: XML$ + "#PB_Button_Left | "			: EndIf
				If flags & #PB_Button_Default		= #PB_Button_Default		: XML$ + "#PB_Button_Default | "		: EndIf
				If flags & #PB_Button_MultiLine	= #PB_Button_MultiLine	: XML$ + "#PB_Button_MultiLine | "	: EndIf
				If flags & #PB_Button_Toggle		= #PB_Button_Toggle		: XML$ + "#PB_Button_Toggle | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ButtonImage(ID=#PB_Ignore, Name$="", ImageID=#PB_Ignore , Image2ID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<buttonimage"
			; Protected ActGadgetType = #PB_GadgetType_ButtonImage										; wird für ImageID benötigt
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ImageID																		; Parameter: ImageID
			Auswertung_Parameter_Image2ID																		; Parameter: Image2ID
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags	& #PB_Button_Toggle = #PB_Button_Toggle											; Parameter: Flags
				XML$ + " flags='#PB_Button_Toggle'"
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Calendar(ID=#PB_Ignore, Name$="", Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<calendar"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Date																			; Parameter: Date (Datum)
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags	& #PB_Calendar_Borderless = #PB_Calendar_Borderless							; Parameter: Flags
				XML$ + " flags='#PB_Calendar_Borderless'"
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Canvas(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<canvas"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Canvas_Border		= #PB_Canvas_Border		: XML$ + "#PB_Canvas_Border | "		: EndIf
				If flags & #PB_Canvas_ClipMouse	= #PB_Canvas_ClipMouse	: XML$ + "#PB_Canvas_ClipMouse | "	: EndIf
				If flags & #PB_Canvas_Keyboard	= #PB_Canvas_Keyboard	: XML$ + "#PB_Canvas_Keyboard | "	: EndIf
				If flags & #PB_Canvas_DrawFocus	= #PB_Canvas_DrawFocus	: XML$ + "#PB_Canvas_DrawFocus | "	: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_CheckBox(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<checkbox"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_CheckBox_Right			= #PB_CheckBox_Right			: XML$ + "#PB_CheckBox_Right | "				: EndIf
				If flags & #PB_CheckBox_Center		= #PB_CheckBox_Center		: XML$ + "#PB_CheckBox_Center | "			: EndIf
				If flags & #PB_CheckBox_ThreeState	= #PB_CheckBox_ThreeState	: XML$ + "#PB_CheckBox_ThreeState | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ComboBox(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<combobox"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_ComboBox_Editable		= #PB_ComboBox_Editable		: XML$ + "#PB_ComboBox_Editable | "		: EndIf
				If flags & #PB_ComboBox_LowerCase	= #PB_ComboBox_LowerCase	: XML$ + "#PB_ComboBox_LowerCase | "	: EndIf
				If flags & #PB_ComboBox_UpperCase	= #PB_ComboBox_UpperCase	: XML$ + "#PB_ComboBox_UpperCase | "	: EndIf
				If flags & #PB_ComboBox_Image			= #PB_ComboBox_Image			: XML$ + "#PB_ComboBox_Image | "	: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_DateTime(ID=#PB_Ignore, Name$="", Mask$="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<date"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Mask
			Auswertung_Parameter_Date
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Date_UpDown 		= #PB_Date_UpDown		: XML$ + "#PB_Date_UpDown | "		: EndIf
				If flags & #PB_Date_CheckBox		= #PB_Date_CheckBox	: XML$ + "#PB_Date_CheckBox | "	: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Editor(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<editor"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Editor_ReadOnly 	= #PB_Editor_ReadOnly	: XML$ + "#PB_Editor_ReadOnly | "	: EndIf
				If flags & #PB_Editor_WordWrap	= #PB_Editor_WordWrap	: XML$ + "#PB_Editor_WordWrap | "	: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ExplorerCombo(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<explorercombo"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Path																			; Parameter: Path$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Explorer_DrivesOnly		= #PB_Explorer_DrivesOnly		: XML$ + "#PB_Explorer_DrivesOnly | "		: EndIf
				If flags & #PB_Explorer_Editable			= #PB_Explorer_Editable			: XML$ + "#PB_Explorer_Editable | "			: EndIf
				If flags & #PB_Explorer_NoMyDocuments	= #PB_Explorer_NoMyDocuments	: XML$ + "#PB_Explorer_NoMyDocuments | "	: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ExplorerList(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<explorerlist"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Path																			; Parameter: Path$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Explorer_BorderLess				= #PB_Explorer_BorderLess				: XML$ + "#PB_Explorer_BorderLess | "				: EndIf
				If flags & #PB_Explorer_AlwaysShowSelection	= #PB_Explorer_AlwaysShowSelection	: XML$ + "#PB_Explorer_AlwaysShowSelection | "	: EndIf
				If flags & #PB_Explorer_MultiSelect				= #PB_Explorer_MultiSelect				: XML$ + "#PB_Explorer_MultiSelect | "				: EndIf
				If flags & #PB_Explorer_GridLines				= #PB_Explorer_GridLines				: XML$ + "#PB_Explorer_GridLines | "				: EndIf
				If flags & #PB_Explorer_HeaderDragDrop			= #PB_Explorer_HeaderDragDrop			: XML$ + "#PB_Explorer_HeaderDragDrop | "			: EndIf
				If flags & #PB_Explorer_FullRowSelect			= #PB_Explorer_FullRowSelect			: XML$ + "#PB_Explorer_FullRowSelect | "			: EndIf
				If flags & #PB_Explorer_NoFiles					= #PB_Explorer_NoFiles					: XML$ + "#PB_Explorer_NoFiles | "					: EndIf
				If flags & #PB_Explorer_NoFolders				= #PB_Explorer_NoFolders				: XML$ + "#PB_Explorer_NoFolders | "				: EndIf
				If flags & #PB_Explorer_NoParentFolder			= #PB_Explorer_NoParentFolder			: XML$ + "#PB_Explorer_NoParentFolder | "			: EndIf
				If flags & #PB_Explorer_NoDirectoryChange		= #PB_Explorer_NoDirectoryChange		: XML$ + "#PB_Explorer_NoDirectoryChange | "		: EndIf
				If flags & #PB_Explorer_NoDriveRequester		= #PB_Explorer_NoDriveRequester		: XML$ + "#PB_Explorer_NoDriveRequester | "		: EndIf
				If flags & #PB_Explorer_NoSort					= #PB_Explorer_NoSort					: XML$ + "#PB_Explorer_NoSort | "					: EndIf
				If flags & #PB_Explorer_NoMyDocuments			= #PB_Explorer_NoMyDocuments			: XML$ + "#PB_Explorer_NoMyDocuments | "			: EndIf
				If flags & #PB_Explorer_AutoSort					= #PB_Explorer_AutoSort					: XML$ + "#PB_Explorer_AutoSort | "					: EndIf
				If flags & #PB_Explorer_HiddenFiles				= #PB_Explorer_HiddenFiles				: XML$ + "#PB_Explorer_HiddenFiles | "				: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ExplorerTree(ID=#PB_Ignore, Name$="", Path$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<explorertree"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Path																			; Parameter: Path$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Explorer_BorderLess				= #PB_Explorer_BorderLess				: XML$ + "#PB_Explorer_BorderLess | "				: EndIf
				If flags & #PB_Explorer_AlwaysShowSelection	= #PB_Explorer_AlwaysShowSelection	: XML$ + "#PB_Explorer_AlwaysShowSelection | "	: EndIf
				If flags & #PB_Explorer_NoLines					= #PB_Explorer_NoLines					: XML$ + "#PB_Explorer_NoLines | "		: EndIf
				If flags & #PB_Explorer_NoButtons				= #PB_Explorer_NoButtons				: XML$ + "#PB_Explorer_NoButtons | "		: EndIf
				If flags & #PB_Explorer_NoFiles					= #PB_Explorer_NoFiles					: XML$ + "#PB_Explorer_NoFiles | "					: EndIf
				If flags & #PB_Explorer_NoDriveRequester		= #PB_Explorer_NoDriveRequester		: XML$ + "#PB_Explorer_NoDriveRequester | "					: EndIf
				If flags & #PB_Explorer_NoMyDocuments			= #PB_Explorer_NoMyDocuments			: XML$ + "#PB_Explorer_NoMyDocuments | "			: EndIf
				If flags & #PB_Explorer_AutoSort					= #PB_Explorer_AutoSort					: XML$ + "#PB_Explorer_AutoSort | "					: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_HyperLink(ID=#PB_Ignore, Name$="", Text$="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<hyperlink"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Color																			; Parameter: Color
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags	& #PB_HyperLink_Underline = #PB_HyperLink_Underline							; Parameter: Flags
				XML$ + " flags='#PB_HyperLink_Underline'"
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_IPAddress(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<ipaddress"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Image(ID=#PB_Ignore, Name$="", ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<image"
			; Protected ActGadgetType = #PB_GadgetType_Image												; wird für ImageID benötigt
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ImageID																		; Parameter: ImageID - z.Zt. von PB aus nicht unterstützt
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Image_Border	= #PB_Image_Border	: XML$ + "#PB_Image_Border | "		: EndIf
				If flags & #PB_Image_Raised	= #PB_Image_Raised	: XML$ + "#PB_Image_Raised | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ListIcon(ID=#PB_Ignore, Name$="", FirstColumnTitle$="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<listicon"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_FirstColumnTitle
			Auswertung_Parameter_FirstColumnWidth
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_ListIcon_CheckBoxes				= #PB_ListIcon_CheckBoxes				: XML$ + "#PB_ListIcon_CheckBoxes | "		: EndIf
				If flags & #PB_ListIcon_ThreeState				= #PB_ListIcon_ThreeState				: XML$ + "#PB_ListIcon_ThreeState | "		: EndIf
				If flags & #PB_ListIcon_MultiSelect				= #PB_ListIcon_MultiSelect				: XML$ + "#PB_ListIcon_MultiSelect | "		: EndIf
				If flags & #PB_ListIcon_GridLines				= #PB_ListIcon_GridLines				: XML$ + "#PB_ListIcon_GridLines | "		: EndIf
				If flags & #PB_ListIcon_FullRowSelect			= #PB_ListIcon_FullRowSelect			: XML$ + "#PB_ListIcon_FullRowSelect | "		: EndIf
				If flags & #PB_ListIcon_HeaderDragDrop			= #PB_ListIcon_HeaderDragDrop			: XML$ + "#PB_ListIcon_HeaderDragDrop | "		: EndIf
				If flags & #PB_ListIcon_AlwaysShowSelection	= #PB_ListIcon_AlwaysShowSelection	: XML$ + "#PB_ListIcon_AlwaysShowSelection | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ListView(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<listview"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_ListView_MultiSelect				= #PB_ListView_MultiSelect				: XML$ + "#PB_ListView_Multiselect | "		: EndIf
				If flags & #PB_ListView_ClickSelect				= #PB_ListView_ClickSelect				: XML$ + "#PB_ListView_ClickSelect | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Option(ID=#PB_Ignore, Name$="", Text$="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<option"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Group
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ProgressBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<progressbar"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Min
			Auswertung_Parameter_Max
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_ProgressBar_Smooth	= #PB_ProgressBar_Smooth	: XML$ + "#PB_ProgressBar_Smooth | "		: EndIf
				If flags & #PB_ProgressBar_Vertical	= #PB_ProgressBar_Vertical	: XML$ + "#PB_ProgressBar_Vertical | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_ScrollBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<scrollbar"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Min
			Auswertung_Parameter_Max
			Auswertung_Parameter_PageLength
			Auswertung_Parameter_Value
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags	& #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical							; Parameter: Flags
				XML$ + " flags='#PB_ScrollBar_Vertical'"
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Spin(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<spin"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Min																			; Parameter: Min
			Auswertung_Parameter_Max																			; Parameter: Max
			Auswertung_Parameter_Value																			; Parameter: Value
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Spin_ReadOnly	= #PB_Spin_ReadOnly	: XML$ + "#PB_Spin_ReadOnly | "		: EndIf
				If flags & #PB_Spin_Numeric	= #PB_Spin_Numeric	: XML$ + "#PB_Spin_Numeric | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_String(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<string"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_String_Numeric		= #PB_String_Numeric			: XML$ + "#PB_String_Numeric | "			: EndIf
				If flags & #PB_String_Password	= #PB_String_Password		: XML$ + "#PB_String_Password | "		: EndIf
				If flags & #PB_String_ReadOnly	= #PB_String_ReadOnly		: XML$ + "#PB_String_ReadOnly | "		: EndIf
				If flags & #PB_String_LowerCase	= #PB_String_LowerCase		: XML$ + "#PB_String_LowerCase | "		: EndIf
				If flags & #PB_String_UpperCase	= #PB_String_UpperCase		: XML$ + "#PB_String_UpperCase | "		: EndIf
				If flags & #PB_String_BorderLess	= #PB_String_BorderLess		: XML$ + "#PB_String_BorderLess | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Text(ID=#PB_Ignore, Name$="", Text$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<text"
			

			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Text																			; Parameter: Text$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$
			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Text_Center	= #PB_Text_Center		: XML$ + "#PB_Text_Center | "		: EndIf
				If flags & #PB_Text_Right	= #PB_Text_Right		: XML$ + "#PB_Text_Right | "		: EndIf
				If flags & #PB_Text_Border	= #PB_Text_Border		: XML$ + "#PB_Text_Border | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			If Len(Margin$)
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			Else
				XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			EndIf
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_TrackBar(ID=#PB_Ignore, Name$="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<trackbar"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Min																			; Parameter: Min
			Auswertung_Parameter_Max																			; Parameter: Max
			Auswertung_Parameter_Value																			; Parameter: Value
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_TrackBar_Ticks		= #PB_TrackBar_Ticks		: XML$ + "#PB_TrackBar_Ticks | "		: EndIf
				If flags & #PB_TrackBar_Vertical	= #PB_TrackBar_Vertical	: XML$ + "#PB_TrackBar_Vertical | "		: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Tree(ID=#PB_Ignore, Name$="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<tree"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			If Flags																									; Parameter: Flags
				
				XML$ + " flags='"
				
				If flags & #PB_Tree_AlwaysShowSelection	= #PB_Tree_AlwaysShowSelection	: XML$ + "#PB_Tree_AlwaysShowSelection | "	: EndIf
				If flags & #PB_Tree_NoLines					= #PB_Tree_NoLines					: XML$ + "#PB_Tree_NoLines | "					: EndIf
				If flags & #PB_Tree_NoButtons					= #PB_Tree_NoButtons					: XML$ + "#PB_Tree_NoButtons | "					: EndIf
				If flags & #PB_Tree_CheckBoxes				= #PB_Tree_CheckBoxes				: XML$ + "#PB_Tree_CheckBoxes | "				: EndIf
				If flags & #PB_Tree_ThreeState				= #PB_Tree_ThreeState				: XML$ + "#PB_Tree_ThreeState | "				: EndIf
				If Right(XML$,3)=" | " : XML$ = Left(XML$, Len(XML$)-3) : EndIf
				XML$ + "'"
				
			EndIf
				
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Web(ID=#PB_Ignore, Name$="", URL$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<web"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_URL																			; Parameter: URL$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure
		Procedure.s		_dyn_Scintilla(ID=#PB_Ignore, Name$="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin$="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam$="")
			
			Protected XML$ = "<scintilla"
			
			Auswertung_SetzeAktuellenFont																		; Setze Gadget-Font, wenn ActFontID <> #PB_Default
			Auswertung_Parameter_ID																				; Parameter: ID
			Auswertung_Parameter_Name																			; Parameter: Name$
			Auswertung_Parameter_Width																			; Parameter: Width
			Auswertung_Parameter_Height																		; Parameter: Height
			Auswertung_Parameter_XmlParam																		; Parameter: XmlParam$

			
			XML$ + "/>"
			
			XML$ = Align(XML$, Align, Margin$, ColSpan, RowSpan, #True)
			
			XMLBuffer$		+ Indent() + XML$ + CR$
			LastXMLLine$	= XML$ + CR$			; Store last XML-Line, to show in Error-Message
			
			ProcedureReturn Indent() + XML$
			
		EndProcedure

;  			 <tree> - kann <item> beinhalten


		;<
		
EndModule
; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
