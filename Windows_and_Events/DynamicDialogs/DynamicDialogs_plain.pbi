XIncludeFile "DynamicDialogs_MainModul.pbi"

DeclareModule DynamicDialogs_plain
	
	;> ===== XML-Layout Elemente & andere spezielle 'suffixed' Funktionen (wie z.B. Font__() )
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			;Macro	Dialogs() : EndMacro		; No Dummy-Declaration needed for this Macro without parameters
			Macro	Window		(ID, Name$, Titel$, Flags, Width, Height, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam$) : EndMacro
			Macro	vBox			(Expand, Align, Spacing, XmlParam$) : EndMacro
			Macro	hBox			(Expand, Align, Spacing, XmlParam$) : EndMacro
			Macro	GridBox		(Columns, ColSpacing, RowSpacing, ColExpand, RowExpand, XmlParam$) : EndMacro
			Macro	MultiBox		(Expand, Align, Margin$, XmlParam$) : EndMacro
			Macro	SingleBox	(Expand, Align, Margin$, Expandwidth, Expandheight, XmlParam$) : EndMacro
			Macro	Empty			(Width, Height, XmlParam$) : EndMacro
			Macro	Font			(Name$, Height, [Style]) : EndMacro
			Macro	FontByID		([FontID]) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Dialogs		()
				DynamicDialogs::_dyn_Dialogs()
			EndMacro
			Macro	Window		(ID=#PB_Ignore, Name="", Titel="", Flags=#PB_Window_SystemMenu, Width=#PB_Ignore, Height=#PB_Ignore, MinWidth=0, MinHeight=0, MaxWidth=0, MaxHeight=0, XmlParam="")
				DynamicDialogs::_dyn_Window(ID, Name, Titel, Flags, Width, Height, MinWidth, MinHeight, MaxWidth, MaxHeight, XmlParam)
			EndMacro
			Macro	vBox			(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_vBox(Expand, Align, Spacing, XmlParam)
			EndMacro
			Macro	hBox			(Expand=#PB_Default, Align=#PB_Default, Spacing=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_hBox(Expand, Align, Spacing, XmlParam)
			EndMacro
			Macro	GridBox		(Columns=#PB_Default, ColSpacing=#PB_Default, RowSpacing=#PB_Default, ColExpand=#PB_Default, RowExpand=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_GridBox(Columns, ColSpacing, RowSpacing, ColExpand, RowExpand, XmlParam)
			EndMacro
			Macro	MultiBox		(Expand=#PB_Default, Align=#PB_Default, Margin="0", XmlParam="")
				DynamicDialogs::_dyn_MultiBox(Expand, Align, Margin, XmlParam)
			EndMacro
			Macro	SingleBox	(Expand=#PB_Default, Align=#PB_Default, Margin="0", Expandwidth=0, Expandheight=0, XmlParam="")
				DynamicDialogs::_dyn_SingleBox(Expand, Align, Margin, Expandwidth, Expandheight, XmlParam)
			EndMacro
			Macro	Empty			(Width=#PB_Default, Height=#PB_Default, XmlParam="")
				DynamicDialogs::_dyn_Empty(Width, Height, XmlParam)
			EndMacro
			
			Macro	Font			(FontName, Height, Style=0)
				DynamicDialogs::_dyn_Font(FontName, Height, Style)
			EndMacro
			Macro	FontByID		(FontID=#PB_Default)
				DynamicDialogs::_dyn_FontByID(FontID)
			EndMacro
			Macro	EndFont		()
				DynamicDialogs::_dyn_FontByID()
			EndMacro
			
		CompilerEndIf
		;<
	;> ===== XML-Layout Elemente					(Close-Nodes)
			
			Macro	EndDialogs		()	: DynamicDialogs::_dyn_EndDialogs()		: EndMacro
			Macro	EndWindow		()	: DynamicDialogs::_dyn_EndWindow()		: EndMacro
			Macro	EndVBox			()	: DynamicDialogs::_dyn_EndVBox()			: EndMacro
			Macro	EndHBox			()	: DynamicDialogs::_dyn_EndHBox()			: EndMacro
			Macro	EndGridBox		()	: DynamicDialogs::_dyn_EndGridBox()		: EndMacro
			Macro	EndMultiBox		()	: DynamicDialogs::_dyn_EndMultiBox()	: EndMacro
			Macro	EndSingleBox	()	: DynamicDialogs::_dyn_EndSingleBox()	: EndMacro
		;<
	
	;> ===== PuraBasic Container-Elemente
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro Container		(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Frame				(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Panel				(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro ScrollArea		(ID, Name$, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Splitter			(ID, Name$, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$) : EndMacro
			Macro Tab				(Text$, Margin$) : EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Container		(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Container(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Frame				(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Frame(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Panel				(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Panel(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollArea		(ID=#PB_Ignore, Name="", ScrollAreaWidth=#PB_Default, ScrollAreaHeight=#PB_Default, ScrollStep=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollArea(ID, Name, ScrollAreaWidth, ScrollAreaHeight, ScrollStep, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Splitter			(ID=#PB_Ignore, Name="", FirstMinSize=#PB_Default, SecondMinSize=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Splitter(ID, Name, FirstMinSize, SecondMinSize, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tab				(Text="", Margin="")
				DynamicDialogs::_dyn_Tab(Text, Margin)
			EndMacro
			
		CompilerEndIf
		;<	
	;> ===== PuraBasic Container-Elemente		(Close-Nodes)
		
			Macro	EndContainer	()	: DynamicDialogs::_dyn_EndContainer()	: EndMacro
			Macro	EndFrame			()	: DynamicDialogs::_dyn_EndFrame()		: EndMacro
			Macro	EndPanel			()	: DynamicDialogs::_dyn_EndPanel()		: EndMacro
			Macro	EndTab			()	: DynamicDialogs::_dyn_EndTab()			: EndMacro
			Macro	EndScrollArea	()	: DynamicDialogs::_dyn_EndScrollArea()	: EndMacro
			Macro	EndSplitter		()	: DynamicDialogs::_dyn_EndSplitter()	: EndMacro
		
		;<
	
	;> ===== PuraBasic Gadgets
		
		CompilerIf #False				;  Dummy-Declarations (just to get a cleaner Procedure Help-Text in Editor, not used by the Compiler)
			
			Macro	Button			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ButtonImage		(ID, Name$, Image1, Image2, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Calendar			(ID, Name$, Date , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Canvas			(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	CheckBox			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ComboBox			(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	DateTime			(ID, Name$, Mask$, Date, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Editor			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerCombo	(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerList	(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ExplorerTree	(ID, Name$, Path$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	HyperLink		(ID, Name$, Text$, Color, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	IPAddress		(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Image				(ID, Name$, ImageID , Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListIcon			(ID, Name$, FirstColumnTitle$ , FirstColumnWidth, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ListView			(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Option			(ID, Name$, Text$, Group, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ProgressBar		(ID, Name$, Min, Max=100, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	ScrollBar		(ID, Name$, Min, Max=100, Value, PageLength=50, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Spin				(ID, Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	String			(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Text				(ID, Name$, Text$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	TrackBar			(ID, Name$, Min, Max=100, Value, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Tree				(ID, Name$, Flags, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Web				(ID, Name$, URL$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			Macro	Scintilla		(ID, Name$, Width, Height, Align, Margin$, ColSpan, RowSpan, XmlParam$)	: EndMacro
			
		CompilerElse					; these are the real Declarations, which will be used for compiling
			
			Macro	Button			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Button(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ButtonImage		(ID=#PB_Ignore, Name="", ImageID=#PB_Ignore, Image2ID=#PB_Ignore, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ButtonImage(ID, Name, ImageID, Image2ID, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Calendar			(ID=#PB_Ignore, Name="", Date=#PB_Default , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Calendar(ID, Name, Date , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Canvas			(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Canvas(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	CheckBox			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_CheckBox(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ComboBox			(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ComboBox(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	DateTime			(ID=#PB_Ignore, Name="", Mask="", Date=#PB_Default, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_DateTime(ID, Name, Mask, Date, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Editor			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Editor(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerCombo	(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerCombo(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerList	(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerList(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ExplorerTree	(ID=#PB_Ignore, Name="", Path="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ExplorerTree(ID, Name, Path, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	HyperLink		(ID=#PB_Ignore, Name="", Text="", Color=$FF0000, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_HyperLink(ID, Name, Text, Color, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	IPAddress		(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_IPAddress(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Image				(ID=#PB_Ignore, Name="", ImageID=#PB_Ignore , Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Image(ID, Name, ImageID , Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListIcon			(ID=#PB_Ignore, Name="", FirstColumnTitle="" , FirstColumnWidth=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListIcon(ID, Name, FirstColumnTitle , FirstColumnWidth, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ListView			(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ListView(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Option			(ID=#PB_Ignore, Name="", Text="", Group=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Option(ID, Name, Text, Group, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ProgressBar		(ID=#PB_Ignore, Name="", Min=0, Max=100, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ProgressBar(ID, Name, Min, Max, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	ScrollBar		(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, PageLength=50, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_ScrollBar(ID, Name, Min, Max, Value, PageLength, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Spin				(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Spin(ID, Name, Min, Max, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	String			(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_String(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Text				(ID=#PB_Ignore, Name="", Text="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Text(ID, Name, Text, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	TrackBar			(ID=#PB_Ignore, Name="", Min=0, Max=100, Value=0, Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_TrackBar(ID, Name, Min, Max=100, Value, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Tree				(ID=#PB_Ignore, Name="", Flags=0, Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Tree(ID, Name, Flags, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Web				(ID=#PB_Ignore, Name="", URL="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Web(ID, Name, URL, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			Macro	Scintilla		(ID=#PB_Ignore, Name="", Width=#PB_Default, Height=#PB_Default, Align=#PB_Default, Margin="", ColSpan=#PB_Ignore, RowSpan=#PB_Ignore, XmlParam="")
				DynamicDialogs::_dyn_Scintilla(ID, Name, Width, Height, Align, Margin, ColSpan, RowSpan, XmlParam)
			EndMacro
			
		CompilerEndIf
		;<
		
EndDeclareModule
Module	DynamicDialogs_plain
EndModule


CompilerIf	#PB_Compiler_IsMainFile
	
	EnableExplicit
	
	LoadFont(3, "Times New Roman", 9, #PB_Font_Bold | #PB_Font_Italic)
	
	UseModule DynamicDialogs					; we need the 'main'-Modul for standard functions
	UseModule DynamicDialogs_plain			; we need the 'plain'-Modul for XML-Elements
	
		ClearXML()
		
	Dialogs()		; Use 'Dialogs()' if you want to create a XML-Dialog with more than 1 Window
	
		Window(1, "", "Window 1", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 350, 150)
 			FontByID(3)
			Frame(#PB_Ignore, "", " This Font has been set with 'FontByID()' ")
 				Font("Courier New", 8)
				Button(#PB_Any, "", "I'm a Button in Window 1"+#LF$+"and my Font has been set"+#LF$+"with 'Font(Name$, Height)'",#PB_Button_MultiLine)
			EndFrame()
		EndWindow()
		
		; Font will be set back to Default, at the end of a window-definition
	
		Window(2, "Window2", "DynamicDialogs_plain Demo", #PB_Window_SizeGadget | #PB_Window_SystemMenu, 0, 0, 290, 80, 600, 300)
			vBox(1)
			Frame(#PB_Ignore, "", " This is a childwindow on top of Window 1 ")
 					Font("arial", 30)
					Button(0, "", "I'm Button 2")
					EndFont()
				EndFrame()
				Text(#PB_Ignore,"","My Font was set back to Default by 'EndFont()'", #PB_Text_Center)
			EndVBox()
		EndWindow()
		
	EndDialogs()
	
	UnuseModule DynamicDialogs_plain			; we don't need the XML-Elements anymore
	
	; from now on we only need the functions from the 'main'-Modul 'DynamicDialogs'
	
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
; CursorPosition = 235
; Folding = 0-AA-0Hwv----DAAAw-
; EnableUnicode
; EnableXP
; EnableCompileCount = 99
; EnableBuildCount = 0
; EnableExeConstant