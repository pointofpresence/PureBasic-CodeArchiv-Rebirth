XIncludeFile "DynamicDialogs_MainModul.pbi"

DeclareModule DynamicDialogs_suffixed_IDonly
	
	;> ===== XML-Layout Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			;Macro	Dialogs__() : EndMacro		; No Dummy-Declaration needed for this Macro without parameters
			Macro	Window__		(ID, Titel$, Flags, Width, Height, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$) : EndMacro
			Macro	vBox__		(Expand, Align, Spacing, XmlParam$) : EndMacro
			Macro	hBox__		(Expand, Align, Spacing, XmlParam$) : EndMacro
			Macro	GridBox__	(Columns, ColSpacing, RowSpacing, ColExpand, RowExpand, XmlParam$) : EndMacro
			Macro	MultiBox__	(Expand, Align, Margin$, XmlParam$) : EndMacro
			Macro	SingleBox__	(Expand, Align, Margin$, Expandwidth, Expandheight, XmlParam$) : EndMacro
			Macro	Empty__		(Width, Height, XmlParam$) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Dialogs__	()
				DynamicDialogs::_dyn_Dialogs()
			EndMacro
			Macro	Window__		(ID=#PB_Ignore, Titel="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam="")
				DynamicDialogs::_dyn_Window(ID, "", Titel, Flags, Width, Height, MinWidth, MinHeight, MaxWidth, MaxHeight, XmlParam)
			EndMacro
			Macro	vBox__		(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_vBox(Expand, Align, Spacing, XmlParam)
			EndMacro
			Macro	hBox__		(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_hBox(Expand, Align, Spacing, XmlParam)
			EndMacro
			Macro	GridBox__	(Columns=#PB_Default, ColSpacing=#PB_Default, RowSpacing=#PB_Default, ColExpand=#PB_Default, RowExpand=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_GridBox(Columns, ColSpacing, RowSpacing, ColExpand, RowExpand, XmlParam)
			EndMacro
			Macro	MultiBox__	(Expand=#PB_Default, Align=#PB_Default, Margin="0", XmlParam="")
				DynamicDialogs::_dyn_MultiBox(Expand, Align, Margin, XmlParam)
			EndMacro
			Macro	SingleBox__	(Expand=#PB_Default, Align=#PB_Default, Margin="0", Expandwidth=0, Expandheight=0, XmlParam="")
				DynamicDialogs::_dyn_SingleBox(Expand, Align, Margin, Expandwidth, Expandheight, XmlParam)
			EndMacro
			Macro	Empty__		(Width=#PB_Default, Height=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_Empty(Width, Height, XmlParam)
			EndMacro
			
		CompilerEndIf
		;<
	;> ===== XML-Layout Elemente					(Close-Nodes)
			
			Macro	EndDialogs__	()	: DynamicDialogs::_dyn_EndDialogs()	: EndMacro
			Macro	EndWindow__		()	: DynamicDialogs::_dyn_EndWindow()		: EndMacro
			Macro	EndVBox__		()	: DynamicDialogs::_dyn_EndVBox()		: EndMacro
			Macro	EndHBox__		()	: DynamicDialogs::_dyn_EndHBox()		: EndMacro
			Macro	EndGridBox__	()	: DynamicDialogs::_dyn_EndGridBox()	: EndMacro
			Macro	EndMultiBox__	()	: DynamicDialogs::_dyn_EndMultiBox()	: EndMacro
			Macro	EndSingleBox__	()	: DynamicDialogs::_dyn_EndSingleBox()	: EndMacro
		;<
	
	;> ===== PuraBasic Container-Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro Container__		(ID, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Frame__			(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Panel__			(ID, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro ScrollArea__	(ID, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Splitter__		(ID, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Tab__				(Text$, Margin$) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Container__		(ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Container(ID, "", Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Frame__			(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Frame(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Panel__			(ID=#PB_Ignore, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Panel(ID, "", Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollArea__	(ID=#PB_Ignore, ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollArea(ID, "", ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Splitter__		(ID=#PB_Ignore, FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Splitter(ID, "", FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tab__				(Text="", Margin="")
				DynamicDialogs::_dyn_Tab(Text, Margin)
			EndMacro
			
		CompilerEndIf
		;<	
	;> ===== PuraBasic Container-Elemente		(Close-Nodes)
		
			Macro	EndContainer__	()	: DynamicDialogs::_dyn_EndContainer()		: EndMacro
			Macro	EndFrame__		()	: DynamicDialogs::_dyn_EndFrame()			: EndMacro
			Macro	EndPanel__		()	: DynamicDialogs::_dyn_EndPanel()			: EndMacro
			Macro	EndTab__			()	: DynamicDialogs::_dyn_EndTab()				: EndMacro
			Macro	EndScrollArea__()	: DynamicDialogs::_dyn_EndScrollArea()	: EndMacro
			Macro	EndSplitter__	()	: DynamicDialogs::_dyn_EndSplitter()		: EndMacro
		
		;<
	
	;> ===== PuraBasic Gadgets
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro	Button__			(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ButtonImage__	(ID, Image1, Image2, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Calendar__		(ID, Date , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Canvas__			(ID, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	CheckBox__		(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ComboBox__		(ID, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	DateTime__		(ID, Mask$, Date, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Editor__			(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerCombo__(ID, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerList__	(ID, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerTree__	(ID, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	HyperLink__		(ID, Text$, Color, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	IPAddress__		(ID, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Image__			(ID, ImageID , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListIcon__		(ID, FirstColumnTitle$ , FirstColumnWidth, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListView__		(ID, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Option__			(ID, Text$, Group, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ProgressBar__	(ID, Min, Max=100, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ScrollBar__		(ID, Min, Max=100, Value, PageLength=50, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Spin__			(ID, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	String__			(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Text__			(ID, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	TrackBar__		(ID, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Tree__			(ID, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Web__				(ID, URL$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Scintilla__		(ID, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Button__			(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Button(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ButtonImage__	(ID=#PB_Ignore, ImageID=#PB_Ignore ,Image2ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ButtonImage(ID, "", ImageID, Image2ID, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Calendar__		(ID=#PB_Ignore, Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Calendar(ID, "", Date , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Canvas__			(ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Canvas(ID, "", Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	CheckBox__		(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_CheckBox(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ComboBox__		(ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ComboBox(ID, "", Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	DateTime__		(ID=#PB_Ignore, Mask="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_DateTime(ID, "", Mask, Date, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Editor__			(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Editor(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerCombo__(ID=#PB_Ignore, Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerCombo(ID, "", Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerList__	(ID=#PB_Ignore, Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerList(ID, "", Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerTree__	(ID=#PB_Ignore, Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerTree(ID, "", Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	HyperLink__		(ID=#PB_Ignore, Text="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_HyperLink(ID, "", Text, Color, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	IPAddress__		(ID=#PB_Ignore, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_IPAddress(ID, "", Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Image__			(ID=#PB_Ignore, ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Image(ID, "", ImageID , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListIcon__		(ID=#PB_Ignore, FirstColumnTitle="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListIcon(ID, "", FirstColumnTitle , FirstColumnWidth, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListView__		(ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListView(ID, "", Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Option__			(ID=#PB_Ignore, Text="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Option(ID, "", Text, Group, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ProgressBar__	(ID=#PB_Ignore, Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ProgressBar(ID, "", Min, Max, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollBar__		(ID=#PB_Ignore, Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollBar(ID, "", Min, Max, Value, PageLength, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Spin__			(ID=#PB_Ignore, Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Spin(ID, "", Min, Max, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	String__			(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_String(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Text__			(ID=#PB_Ignore, Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Text(ID, "", Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	TrackBar__		(ID=#PB_Ignore, Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_TrackBar(ID, "", Min, Max=100, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tree__			(ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Tree(ID, "", Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Web__				(ID=#PB_Ignore, URL="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Web(ID, "", URL, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Scintilla__		(ID=#PB_Ignore, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Scintilla(ID, "", Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			
			Macro	Font__			(FontName, Height, Style=0)
				DynamicDialogs::_dyn_Font(FontName, Height, Style)
			EndMacro
			Macro	FontByID__		(FontID=#PB_Default)
				DynamicDialogs::_dyn_FontByID(FontID)
			EndMacro
			Macro	EndFont__		()
				DynamicDialogs::_dyn_FontByID()
			EndMacro
			
		CompilerEndIf
		;<
		
EndDeclareModule
Module	DynamicDialogs_suffixed_IDonly
EndModule


CompilerIf	#PB_Compiler_IsMainFile
	
	EnableExplicit
	
	UseModule DynamicDialogs							; we need the 'main'-Modul (actually just for Canstants etc.)
	UseModule DynamicDialogs_suffixed_IDonly		; we need the 'suffixes' Functions for autoindent the SourceCode
	
	Dialogs__()		; Use 'Dialogs()' if you want to create a XML-Dialog with more than 1 Window
	
		Window__(1, "Window 1", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 300, 200)
			Frame__(#PB_Ignore, " This is a Frame !!! ")
				Button__(#PB_Any, "I'm a Button"+#LF$+"in Window 1",#PB_Button_MultiLine)
			EndFrame__()
		EndWindow__()
	
		Window__(2, "DynamicDialogs_suffixed_IDonly Demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 0, 0, 480, 80, 600, 300)
			vBox__(1)
				Frame__(#PB_Ignore, " This is a childwindow on top of Window 1 ")
					Font__("arial", 15, #PB_Font_Bold)
					Button__(0, "I'm Button 2")
					EndFont__()
				EndFrame__()
				Text__(#PB_Ignore,"I'm a Text-Gadget !!!", #PB_Text_Center)
			EndVBox__()
		EndWindow__()
		
	EndDialogs__()
	
	UnuseModule DynamicDialogs_suffixed_IDonly			; we don't need the Suffixed-Functions anymore
	
	; from now on we really need the functions from the 'main'-Modul 'DynamicDialogs'
	
	Debug GetXML()
	
	; ----- Create Dialog '0', use the created XML-Text and open Window-Nr.'1'
	
	If OpenDialogWindow(0, GetXML(), 1)
		
		; ----- Create Dialog '1', use the same XML-Text as for Window-Nr.'1',
		;       open Window with the Name "Window2" with Size 360 x 220 as a childwindow of WindowNr.'1'
		
		OpenDialogWindow(1,GetXML(),2,"",#PB_Ignore,#PB_Ignore,360,220,WindowID(1))
		
		UnuseModule DynamicDialogs			; we don't need the Module-Functions anymore
		
		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf
; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
