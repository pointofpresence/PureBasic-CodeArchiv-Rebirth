XIncludeFile "DynamicDialogs_MainModul.pbi"

DeclareModule DynamicDialogs_suffixed_NameOnly
	
	;> ===== XML-Layout Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			;Macro	Dialogs__() : EndMacro		; No Dummy-Declaration needed for this Macro without parameters
			Macro	Window__		(Name$, Titel$, Flags, Width, Height, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$) : EndMacro
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
			Macro	Window__		(Name="", Titel="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam="")
				DynamicDialogs::_dyn_Window(#PB_Ignore, Name, Titel, Flags, Width, Height, MinWidth, MinHeight, MaxWidth, MaxHeight, XmlParam)
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
			
			Macro	EndDialogs__	()	: DynamicDialogs::_dyn_EndDialogs()		: EndMacro
			Macro	EndWindow__		()	: DynamicDialogs::_dyn_EndWindow()		: EndMacro
			Macro	EndVBox__		()	: DynamicDialogs::_dyn_EndVBox()			: EndMacro
			Macro	EndHBox__		()	: DynamicDialogs::_dyn_EndHBox()			: EndMacro
			Macro	EndGridBox__	()	: DynamicDialogs::_dyn_EndGridBox()		: EndMacro
			Macro	EndMultiBox__	()	: DynamicDialogs::_dyn_EndMultiBox()	: EndMacro
			Macro	EndSingleBox__	()	: DynamicDialogs::_dyn_EndSingleBox()	: EndMacro
		;<
	
	;> ===== PuraBasic Container-Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro Container__		(Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Frame__			(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Panel__			(Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro ScrollArea__	(Name$, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Splitter__		(Name$, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Tab__				(Text$, Margin$) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Container__		(Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Container(#PB_Ignore, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Frame__			(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Frame(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Panel__			(Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Panel(#PB_Ignore, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollArea__	(Name="", ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollArea(#PB_Ignore, Name, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Splitter__		(Name="", FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Splitter(#PB_Ignore, Name, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tab__				(Text="", Margin="")
				DynamicDialogs::_dyn_Tab(Text, Margin)
			EndMacro
			
		CompilerEndIf
		;<	
	;> ===== PuraBasic Container-Elemente		(Close-Nodes)
		
			Macro	EndContainer__	()	: DynamicDialogs::_dyn_EndContainer()	: EndMacro
			Macro	EndFrame__		()	: DynamicDialogs::_dyn_EndFrame()		: EndMacro
			Macro	EndPanel__		()	: DynamicDialogs::_dyn_EndPanel()		: EndMacro
			Macro	EndTab__			()	: DynamicDialogs::_dyn_EndTab()			: EndMacro
			Macro	EndScrollArea__()	: DynamicDialogs::_dyn_EndScrollArea()	: EndMacro
			Macro	EndSplitter__	()	: DynamicDialogs::_dyn_EndSplitter()	: EndMacro
		
		;<
	
	;> ===== PuraBasic Gadgets
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro	Button__			(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ButtonImage__	(Name$, Image1, Image2, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Calendar__		(Name$, Date , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Canvas__			(Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	CheckBox__		(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ComboBox__		(Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	DateTime__		(Name$, Mask$, Date, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Editor__			(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerCombo__(Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerList__	(Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerTree__	(Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	HyperLink__		(Name$, Text$, Color, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	IPAddress__		(Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Image__			(Name$, ImageID , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListIcon__		(Name$, FirstColumnTitle$ , FirstColumnWidth, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListView__		(Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Option__			(Name$, Text$, Group, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ProgressBar__	(Name$, Min, Max=100, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ScrollBar__		(Name$, Min, Max=100, Value, PageLength=50, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Spin__			(Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	String__			(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Text__			(Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	TrackBar__		(Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Tree__			(Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Web__				(Name$, URL$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Scintilla__		(Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Button__			(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Button(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ButtonImage__	(Name="", ImageID=#PB_Ignore, Image2ID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ButtonImage(#PB_Ignore, Name, ImageID, Image2ID, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Calendar__		(Name="", Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Calendar(#PB_Ignore, Name, Date , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Canvas__			(Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Canvas(#PB_Ignore, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	CheckBox__		(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_CheckBox(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ComboBox__		(Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ComboBox(#PB_Ignore, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	DateTime__		(Name="", Mask="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_DateTime(#PB_Ignore, Name, Mask, Date, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Editor__			(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Editor(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerCombo__(Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerCombo(#PB_Ignore, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerList__	(Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerList(#PB_Ignore, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerTree__	(Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerTree(#PB_Ignore, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	HyperLink__		(Name="", Text="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_HyperLink(#PB_Ignore, Name, Text, Color, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	IPAddress__		(Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_IPAddress(#PB_Ignore, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Image__			(Name="", ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Image(#PB_Ignore, Name, ImageID , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListIcon__		(Name="", FirstColumnTitle="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListIcon(#PB_Ignore, Name, FirstColumnTitle , FirstColumnWidth, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListView__		(Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListView(#PB_Ignore, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Option__			(Name="", Text="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Option(#PB_Ignore, Name, Text, Group, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ProgressBar__	(Name="", Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ProgressBar(#PB_Ignore, Name, Min, Max, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollBar__		(Name="", Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollBar(#PB_Ignore, Name, Min, Max, Value, PageLength, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Spin__			(Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Spin(#PB_Ignore, Name, Min, Max, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	String__			(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_String(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Text__			(Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Text(#PB_Ignore, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	TrackBar__		(Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_TrackBar(#PB_Ignore, Name, Min, Max=100, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tree__			(Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Tree(#PB_Ignore, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Web__				(Name="", URL="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Web(#PB_Ignore, Name, URL, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Scintilla__		(Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Scintilla(#PB_Ignore, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
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
Module	DynamicDialogs_suffixed_NameOnly
EndModule


CompilerIf	#PB_Compiler_IsMainFile
	
	EnableExplicit
	
	UseModule DynamicDialogs					; we need the 'main'-Modul (actually just for Canstants etc.)
	UseModule DynamicDialogs_suffixed_NameOnly		; we need the 'suffixes' Functions for autoindent the SourceCode
	
	Dialogs__()		; Use 'Dialogs()' if you want to create a XML-Dialog with more than 1 Window
	
		Window__("Window1", "Window 1", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 250, 150)
			Frame__("", " This is a Frame !!! ")
				Button__("", "I'm a Button"+#LF$+"in Window 1",#PB_Button_MultiLine)
			EndFrame__()
		EndWindow__()
	
		Window__("Window2", "DynamicDialogs_suffixed_NameOnly Demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 0, 0, 290, 80, 600, 300)
			vBox__(1)
				Frame__("", " This is a childwindow on top of Window 1 ")
					Font__("arial", 15, #PB_Font_Bold)
					Button__("", "I'm Button 2")
					EndFont__()
				EndFrame__()
				Text__("","I'm a Text-Gadget !!!", #PB_Text_Center)
			EndVBox__()
		EndWindow__()
		
	EndDialogs__()
	
	UnuseModule DynamicDialogs_suffixed_NameOnly			; we don't need the Suffixed-Functions anymore
	
	; from now on we really need the functions from the 'main'-Modul 'DynamicDialogs'
	
	Debug GetXML()
	
	; ----- Create Dialog '0', use the created XML-Text and open Window with the Name 'Window1'
	
	If OpenDialogWindow(0, GetXML(), 0, "Window1")
		
		; ----- Create Dialog '1', use the same XML-Text as for Window 1,
		;       open Window with the Name "Window2" with Size 360 x 220 as a childwindow of WindowNr.'1'
		
		OpenDialogWindow(1,GetXML(),0,"Window2",#PB_Ignore,#PB_Ignore,480,220,WindowID(DialogWindow(0)))
		
		UnuseModule DynamicDialogs			; we don't need the Module-Functions anymore
		
		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf
; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; CursorPosition = 1
; Folding = 0PA+8Pgf----HAAAA9
; EnableUnicode
; EnableXP
; EnableCompileCount = 13
; EnableBuildCount = 0
; EnableExeConstant