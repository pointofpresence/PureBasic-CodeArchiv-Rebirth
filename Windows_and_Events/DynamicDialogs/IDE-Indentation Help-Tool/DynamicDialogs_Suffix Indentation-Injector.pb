; Indentation-Injector - Litte Prog to add some Indentation-Keywords to your PureBasic-Preference File

; have a look at the DataSection below, to see which commands will be injected into your indentation-settings

; HINT:  You need to exit the PureBasic IDE BEFORE you start this tools.
;        otherwise the IDE will overwrite the changes on exit.

EnableExplicit

Procedure.s GetSpecialFolder(folderno)
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Protected listptr=0
		Protected result$=Space(270)
		SHGetSpecialFolderLocation_(0,folderno,@listptr) 
		SHGetPathFromIDList_(listptr,@result$) 
		ProcedureReturn Trim(result$)
	CompilerEndIf
EndProcedure

Structure	KeyWords
	KeyWord$
	Before.l
	After.l
EndStructure

Define	PBConfigPath$, PBConfigFile$, n

PBConfigPath$= GetSpecialFolder(26)+"\PureBasic\"

PBConfigFile$ = OpenFileRequester("Please select your PureBasic-Preference File", PBConfigPath$, "PureBasic Preference File| PureBasic.prefs|All Files|*.*", 0)

If PBConfigFile$ > "" And FileSize(PBConfigFile$) > 0
	If OpenPreferences(PBConfigFile$)
		PreferenceGroup("Indentation")
		
		NewList KeyList.KeyWords()
		Define Anzahl = ReadPreferenceInteger("NbKeywords",0)
		
		If Anzahl < 1			; Maybe wrong Preference-File Version
			MessageRequester("ERROR", "No Keywords found."+#LF+"Maybe wrong Preference-File Version.")
			End
		EndIf
		
		; =====  Read List with existing KeyWords from PureBasic Preference-File
		
		For n = 0 To Anzahl-1
			AddElement(KeyList())
			With KeyList()
				
				\KeyWord$	= ReadPreferenceString("Keyword_"+Str(n),"")
				\Before		= ReadPreferenceInteger("Before_"+Str(n),-999)
				\After		= ReadPreferenceInteger("After_"+Str(n),-999)
				
				If \KeyWord$ = "" Or \Before < -990 Or \After < -990
					MessageRequester("ERROR", "Suspicious Data found while trying to read Keyword:"+Str(n)+#LF+#LF+"Maybe wrong Preference-File Version.")
					End
				EndIf
				
			EndWith
		Next
		
		Define NewKeyWord$, NewBefore, NewAfter
		
		; =====  Read Data for new KeyWords, check if they already exist, and if not - add them to the KeyWord-List
		
		Restore Indentation_DynamicDialog_withSuffix
		
		Read.s	NewKeyWord$
		Read.l	NewBefore
		Read.l	NewAfter
			
		While NewBefore + NewAfter > -1900
			
			Repeat	; Dummy-Loop, just to use Break to exit it
				
				With KeyList()
					
					ForEach KeyList()
						If UCase(\KeyWord$) = UCase(NewKeyWord$)
							Break 2		; KeyWord already exists - do not change any settings
						EndIf
					Next
					
					AddElement(KeyList())			; Add new Keyword and Indentation to KeyWord-List
					\KeyWord$	= NewKeyWord$
					\Before		= NewBefore
					\After		= NewAfter
					
				EndWith							
					
			Until #True
			
			Read.s	NewKeyWord$
			Read.l	NewBefore
			Read.l	NewAfter
			
		Wend
		
		; =====  Write updated KeyWord-List to PureBasic Preference-File
		
		WritePreferenceInteger("NbKeywords",ListSize(KeyList()))
		
		ForEach KeyList()
			
			WritePreferenceString("Keyword_"+Str(ListIndex(KeyList()))	, KeyList()\KeyWord$)
			WritePreferenceInteger("Before_"+Str(ListIndex(KeyList()))	, KeyList()\Before)
			WritePreferenceInteger("After_"+Str(ListIndex(KeyList()))	, KeyList()\After)
			
		Next
		
		MessageRequester("PureBasic Preference-File Updated",Str(ListSize(KeyList())-Anzahl)+" Indentation-Keys have been added to your Preference-File." +
		                                                     #CRLF$+#CRLF$+"You have to close the IDE BEFORE you start this program to make these changes permanent.")
		
		
	EndIf
EndIf

DataSection
	
	Indentation_DynamicDialog_withSuffix:
	
	Data.s	"Dialogs__"			:	Data.l	0,	1		; ===== XML-Layout Elements
	Data.s	"Window__"			:	Data.l	0,	1
	Data.s	"vBox__"				:	Data.l	0,	1
	Data.s	"hBox__"				:	Data.l	0,	1
	Data.s	"GridBox__"			:	Data.l	0,	1
	Data.s	"MultiBox__"		:	Data.l	0,	1
	Data.s	"SingleBox__"		:	Data.l	0,	1
	
	Data.s	"Container__"		:	Data.l	0,	1		; ===== PuraBasic Container-Elements
	Data.s	"Frame__"			:	Data.l	0,	1
	Data.s	"Panel__"			:	Data.l	0,	1
	Data.s	"Tab__"				:	Data.l	0,	1
	Data.s	"ScrollArea__"		:	Data.l	0,	1
	Data.s	"Splitter__"		:	Data.l	0,	1
	
	Data.s	"EndDialogs__"		:	Data.l	-1,	0		; ===== Close-Nodes
	Data.s	"EndWindow__"		:	Data.l	-1,	0
	Data.s	"EndVBox__"			:	Data.l	-1,	0
	Data.s	"EndHBox__"			:	Data.l	-1,	0
	Data.s	"EndGridBox__"		:	Data.l	-1,	0
	Data.s	"EndMultiBox__"	:	Data.l	-1,	0
	Data.s	"EndSingleBox__"	:	Data.l	-1,	0
	Data.s	"EndContainer__"	:	Data.l	-1,	0
	Data.s	"EndFrame__"		:	Data.l	-1,	0
	Data.s	"EndPanel__"		:	Data.l	-1,	0
	Data.s	"EndTab__"			:	Data.l	-1,	0
	Data.s	"EndScrollArea__"	:	Data.l	-1,	0
	Data.s	"EndSplitter__"	:	Data.l	-1,	0
	Data.s	"EndNode__"			:	Data.l	-1,	0
	Data.s	"CloseNode__"		:	Data.l	-1,	0
	
	Data.s	"_NoMoreKeys_"		:	Data.l -999,-999
	
EndDataSection

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
; DisableDebugger
