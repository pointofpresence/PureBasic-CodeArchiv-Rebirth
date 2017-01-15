XIncludeFile "DynamicDialogs_MainModul.pbi"

DeclareModule DynamicDialogs_suffixed
	
	;> ===== XML-Layout Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			;Macro	Dialogs__() : EndMacro		; No Dummy-Declaration needed for this Macro without parameters
			Macro	Window__		(ID, Name$, Titel$, Flags, Width, Height, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$) : EndMacro
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
			Macro	Window__		(ID=#PB_Ignore, Name="", Titel="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam="")
				DynamicDialogs::_dyn_Window(ID, Name, Titel, Flags, Width, Height, MinWidth, MinHeight, MaxWidth, MaxHeight, XmlParam)
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
			
			Macro Container__		(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Frame__			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Panel__			(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro ScrollArea__	(ID, Name$, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Splitter__		(ID, Name$, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Tab__				(Text$, Margin$) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Container__		(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Container(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Frame__			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Frame(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Panel__			(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Panel(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollArea__	(ID=#PB_Ignore, Name="", ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollArea(ID, Name, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Splitter__		(ID=#PB_Ignore, Name="", FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Splitter(ID, Name, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
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
			
			Macro	Button__			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ButtonImage__	(ID, Name$, Image1, Image2, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Calendar__		(ID, Name$, Date , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Canvas__			(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	CheckBox__		(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ComboBox__		(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	DateTime__		(ID, Name$, Mask$, Date, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Editor__			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerCombo__(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerList__	(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerTree__	(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	HyperLink__		(ID, Name$, Text$, Color, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	IPAddress__		(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Image__			(ID, Name$, ImageID , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListIcon__		(ID, Name$, FirstColumnTitle$ , FirstColumnWidth, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListView__		(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Option__			(ID, Name$, Text$, Group, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ProgressBar__	(ID, Name$, Min, Max=100, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ScrollBar__		(ID, Name$, Min, Max=100, Value, PageLength=50, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Spin__			(ID, Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	String__			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Text__			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	TrackBar__		(ID, Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Tree__			(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Web__				(ID, Name$, URL$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Scintilla__		(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Button__			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Button(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ButtonImage__	(ID=#PB_Ignore, Name="", ImageID=#PB_Ignore, Image2ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ButtonImage(ID, Name, ImageID, Image2ID, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Calendar__		(ID=#PB_Ignore, Name="", Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Calendar(ID, Name, Date , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Canvas__			(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Canvas(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	CheckBox__		(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_CheckBox(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ComboBox__		(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ComboBox(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	DateTime__		(ID=#PB_Ignore, Name="", Mask="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_DateTime(ID, Name, Mask, Date, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Editor__			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Editor(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerCombo__(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerCombo(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerList__	(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerList(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerTree__	(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerTree(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	HyperLink__		(ID=#PB_Ignore, Name="", Text="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_HyperLink(ID, Name, Text, Color, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	IPAddress__		(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_IPAddress(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Image__			(ID=#PB_Ignore, Name="", ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Image(ID, Name, ImageID , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListIcon__		(ID=#PB_Ignore, Name="", FirstColumnTitle="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListIcon(ID, Name, FirstColumnTitle , FirstColumnWidth, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListView__		(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListView(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Option__			(ID=#PB_Ignore, Name="", Text="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Option(ID, Name, Text, Group, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ProgressBar__	(ID=#PB_Ignore, Name="", Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ProgressBar(ID, Name, Min, Max, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollBar__		(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollBar(ID, Name, Min, Max, Value, PageLength, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Spin__			(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Spin(ID, Name, Min, Max, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	String__			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_String(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Text__			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Text(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	TrackBar__		(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_TrackBar(ID, Name, Min, Max=100, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tree__			(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Tree(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Web__				(ID=#PB_Ignore, Name="", URL="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Web(ID, Name, URL, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Scintilla__		(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Scintilla(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
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
Module	DynamicDialogs_suffixed
EndModule


CompilerIf	#PB_Compiler_IsMainFile
	
	EnableExplicit
	
	UseModule DynamicDialogs					; we need the 'main'-Modul (actually just for Canstants etc.)
	UseModule DynamicDialogs_suffixed		; we need the 'suffixes' Functions for autoindent the SourceCode
	
	Dialogs__()		; Use 'Dialogs()' if you want to create a XML-Dialog with more than 1 Window
	
		Window__(1, "Window1", "Window 1", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 250, 150)
			Frame__(#PB_Ignore, "", " This is a Frame !!! ")
				Button__(#PB_Any, "", "I'm a Button"+#LF$+"in Window 1",#PB_Button_MultiLine)
			EndFrame__()
		EndWindow__()
	
		Window__(2, "Window2", "DynamicDialogs_suffixed Demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 0, 0, 290, 80, 600, 300)
			vBox__(1)
				Frame__(#PB_Ignore, "", " This is a childwindow on top of Window 1 ")
					Font__("arial", 15, #PB_Font_Bold)
					Button__(0, "", "I'm Button 2")
					EndFont__()
				EndFrame__()
				Text__(#PB_Ignore,"","I'm a Text-Gadget !!!", #PB_Text_Center)
			EndVBox__()
		EndWindow__()
		
	EndDialogs__()
	
	UnuseModule DynamicDialogs_suffixed			; we don't need the Suffixed-Functions anymore
	
	; from now on we really need the functions from the 'main'-Modul 'DynamicDialogs'
	
	Debug GetXML()
	
	; ----- Create Dialog '0', use the created XML-Text and open Window-Nr.'1'
	
	If OpenDialogWindow(0, GetXML(), 1)
		
		; ----- Create Dialog '1', use the same XML-Text as for Window-Nr.'1',
		;       open Window with the Name "Window2" with Size 360 x 220 as a childwindow of WindowNr.'1'
		
		OpenDialogWindow(1,GetXML(),0,"Window2",#PB_Ignore,#PB_Ignore,360,220,WindowID(1))
		
		UnuseModule DynamicDialogs			; we don't need the Module-Functions anymore
		
		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf
; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
