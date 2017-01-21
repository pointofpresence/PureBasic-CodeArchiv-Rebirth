; XML-Dialog-Variante zu Michael Vogels Beispiel   =>   http: //www.purebasic.fr/english/viewtopic.php?f=13&t=64868

EnableExplicit

CompilerIf #PB_Compiler_Unicode		; needed just for the 'old-style' XML-check later on. not needed if you use new DynamicDialog-Functions
	#XmlEncoding = #PB_UTF8
CompilerElse 
	#XmlEncoding = #PB_Ascii
CompilerEndIf

XIncludeFile "..\DynamicDialogs_plain.pbi"

#XMLWinMain = 0
#Dialog		= 0
#IconOk		= 0

Runtime Enumeration Windows
	#winMain
EndEnumeration

Runtime Enumeration Gadgets
	#gadListIcon_Liste
EndEnumeration


#WinW=720
#WinH=552
#WinZ=400

CatchImage(#IconOk,?IconOk);

Procedure.s Create_MainWindowDialog()
	
	Protected xml$

	UseModule DynamicDialogs
	UseModule DynamicDialogs_plain
	
	SetXMLOutputFormat(#XMLout_Indent, 5)
	SetXMLOutputFormat(#XMLout_AlignLineBreak, #True)
	
	ClearXML()
	
	Protected WinFlags = #WS_SYSMENU|#PB_Window_ScreenCentered|#PB_Window_Invisible|#PB_Window_SizeGadget| #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
	
 	Window(#winMain,"winMain","", WinFlags, #WinW, #winh, #WinW, #winz,0,0,"margin='10'")
 		vBox(1,0,0)
 			GridBox(2,10,5,#PB_Default,5)
 			
 			; --- Frame: Reguläre Ausdrücke
 			
 				Frame(#PB_Ignore,"","Reguläre Ausdrücke")
					SingleBox(0,0,"horizontal:5,bottom:2")
						hBox(0,0,15)
							vBox()
								hBox(2)
		 							text(#PB_Ignore, "", "Datei&name  ",0,85,0,#alignLeftCenter)
		 							ComboBox(#PB_Ignore, "",#PB_ComboBox_Editable,200)
		 							Image(#PB_Ignore, "Image1", 0,0,20,20)
		 						EndHBox()
		 						hBox(2)
		 							text(#PB_Ignore, "", "Ändern  ",0,85,0,#alignLeftCenter)
		 							ComboBox(#PB_Ignore, "",#PB_ComboBox_Editable,200)
		 							Image(#PB_Ignore, "Image3", 0,0,20,20)
		 						EndHBox()
		 					EndVBox()
		 					vBox()
		 						hBox(2)
		 							text(#PB_Ignore, "", "&Erweiterung  ",0,0,0,#alignLeftCenter)
		 							ComboBox(#PB_Ignore, "",#PB_ComboBox_Editable,120)
		 							Image(#PB_Ignore, "Image2", 0,0,20,20)
		 						EndHBox()
		 						CheckBox(#PB_Ignore, "", " &Groß/Kleinschreibung beachten  ")
	 						EndVBox()
	 					EndHBox()
 	 				EndSingleBox()	
 				EndFrame()	
 				
 			; --- Buttons: Umbenennen und Schließen
 				
 				vBox(0,0,5)
 					SingleBox(0,0,"top:7")
 						Button(#PB_Ignore, "", "&Umbenennen",0,5)
 					EndSingleBox()
	 				Button(#PB_Ignore, "", "S&chließen")
	 			EndVBox()
 				
 			; --- Frame: Suchen und Ersetzen
 			
  				Frame(#PB_Ignore,"","Suchen und Ersetzen")
					SingleBox(0,0,"horizontal:5,bottom:0")
						hBox(0,0,15)
							vBox(#Expand_No, #alignCenter)
; 								Empty(0,4)
								hBox(2)
		 							text(#PB_Ignore, "", "&Anfangs  ",0,85,0,#alignLeftCenter)
		 							ComboBox(#PB_Ignore, "",#PB_ComboBox_Editable,200)
		 							Image(#PB_Ignore, "Image4", 0,0,20,20)
		 						EndHBox()
		 						hBox(2)
		 							text(#PB_Ignore, "", "Abschließen",0,85,0,#alignLeftCenter)
		 							ComboBox(#PB_Ignore, "",#PB_ComboBox_Editable,200)
		 							Image(#PB_Ignore, "Image5", 0,0,20,20)
		 						EndHBox()
		 					EndVBox()
		 					vBox()
		 						CheckBox(#PB_Ignore, "", " Nur den Dateina&men verändern  ",0,190,10,0,"top:-5")
		 						CheckBox(#PB_Ignore, "", " Groß-/&Kleinschreibung beachten  ",0,0,0,0,"top:-5")
		 						CheckBox(#PB_Ignore, "", " Alle &Vorkommen ersetzen  ",0,0,0,0,"top:-5")
	 						EndVBox()
	 					EndHBox()
 	 				EndSingleBox()	
 				EndFrame()	
 			
 			; --- Buttons: Profile und Sonderfunktionen
 				
 				vBox(0,0,5,"width='150'")
 					SingleBox(0,0,"top:7")
 						Button(#PB_Ignore, "", "&Profile")
 					EndSingleBox()
	 				Button(#PB_Ignore, "", "&Sonderfunktionen")
	 			EndVBox()
	 			
	 		; --- Frame: Erweitert
 			
  				Frame(#PB_Ignore,"","Erweitert")
					SingleBox(0,0,"horizontal:5,bottom:2")
						hBox(0,0,0)
							Empty(0,4)
							hBox(2)
	 							text(#PB_Ignore, "", "Schreib&weise: ",0,85,0,#alignLeftCenter)
	 							ComboBox(#PB_Ignore, "Combo6",0,120)
	 						EndHBox()
	 						Empty(10)	
							hBox(2)
	 							text(#PB_Ignore, "", "Erwei&terung: ",0,85,0,#alignLeftCenter)
	 							ComboBox(#PB_Ignore, "Combo7",0,120)
	 						EndHBox()
	 						Empty(10)	
	 						CheckBox(#PB_Ignore, "", " Datei&datum aktualisieren ")
	 					EndHBox()
 	 				EndSingleBox()	
 				EndFrame()	
 			
 			; --- Button: Ergebnisliste filtern
 				
 				SingleBox(0,0,"top:7")
	 				Button(#PB_Ignore, "", "Ergebnisliste &filtern")
	 			EndSingleBox()
	 			
 			; --- ListIconGadget
	 			
	 			Empty(0,2,"colspan='3'")
	 			AddXML("<ListIcon id='#gadListIcon_Liste' expand='yes' width='20' height='10' text=' ·' colspan='3' " +
	 			       "flags='#PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection'/>")
	 			
			EndGridBox()
 		EndVBox()
 	EndWindow()	
 				
	xml$ = GetXML()
	
	Debug xml$
	
	; 'old-style' XML-check		-	the DynamicDialogs-Module has easier Function for this now
	
	If Not (CatchXML(#XMLWinMain, @xml$, StringByteLength(xml$), 0, #XmlEncoding) And XMLStatus(#XMLWinMain) = #PB_XML_Success)
		MessageRequester("Fehler in XML-Definition !!!", "XML error: " + XMLError(#XMLWinMain) + " (Line: " + XMLErrorLine(#XMLWinMain) +
		                 ")"+Chr(10)+Chr(10)+"XML-Definition '"+xml$+"' konnte nicht decodiert werden.", #PB_MessageRequester_Ok)
		End
	EndIf
	
	UnuseModule DynamicDialogs

	
	ProcedureReturn xml$
	
EndProcedure

Procedure	UpdateListIconColumn()
	
	Protected x.f = (GadgetWidth(#gadListIcon_Liste)-210-210-52-102-78-40)/7
   SetGadgetItemAttribute(#gadListIcon_Liste,#PB_Ignore,#PB_ListIcon_ColumnWidth,210+x*3,0);
   SetGadgetItemAttribute(#gadListIcon_Liste,#PB_Ignore,#PB_ListIcon_ColumnWidth,210+x*3,1);
   SetGadgetItemAttribute(#gadListIcon_Liste,#PB_Ignore,#PB_ListIcon_ColumnWidth,78+x,4)	 ;
   
EndProcedure

Define	XML$ = Create_MainWindowDialog()
Define	n

; 'old-style' Dialog-opening	-	the DynamicDialogs-Module has easier Function for this now
	
If CreateDialog(#Dialog) And OpenXMLDialog(#Dialog, #XMLWinMain, "winMain")
	
   BindEvent(#PB_Event_SizeWindow,@UpdateListIconColumn(),#winMain);
   ;SmartWindowRefresh(#WinID, #True)
	
	; Die ImageIDs für ImageGadgets müssen bei XML-Dialogen derzeit noch nachträglich gesetzt werden
	
	For n = 1 To 5
		If IsGadget(DialogGadget(#Dialog, "Image"+Str(n))) : SetGadgetState(DialogGadget(#Dialog, "Image"+Str(n)), ImageID(#IconOk)) : EndIf
	Next
	
	; Einträge zu den unteren ComboBoxen hinzufügen
	
	For n=6 To 7
		If IsGadget(DialogGadget(#Dialog, "Combo"+Str(n)))
	      AddGadgetItem(DialogGadget(#Dialog, "Combo"+Str(n)),-1,"Unverändert")
	      AddGadgetItem(DialogGadget(#Dialog, "Combo"+Str(n)),-1,"Alles klein")
	      AddGadgetItem(DialogGadget(#Dialog, "Combo"+Str(n)),-1,"Wortanfänge groß")
	      AddGadgetItem(DialogGadget(#Dialog, "Combo"+Str(n)),-1,"Alles groß")
      EndIf
   Next n
   
   ; --- Spalten zum ListIconGadget hinzufügen
   
	   SetGadgetItemAttribute(#gadListIcon_Liste,0,#PB_ListIcon_ColumnWidth,20,0);
		AddGadgetColumn(#gadListIcon_Liste,0,"Status",78);
		AddGadgetColumn(#gadListIcon_Liste,0,"Datum",102);
		AddGadgetColumn(#gadListIcon_Liste,0,"Größe",52);
		AddGadgetColumn(#gadListIcon_Liste,0,"Neuer Dateiname",210);
		AddGadgetColumn(#gadListIcon_Liste,0,"Alter Dateiname",210);
		
		HideWindow(#winMain, #False)
		
	; --- Event Handling
		
		Repeat
			Define Event = WaitWindowEvent()
		Until Event = #PB_Event_CloseWindow
	EndIf

   DataSection;
      IconOk:   ; 1406 Bytes;
      Data.q $1010000100010000,$568000800010000,$28000000160000,$20000000100000,$800010000;
      Data.q $1000000,$100000000000000,$3737000001000000,$CB4A0089B5320037,$FFFF00B5E15D009F;
      Data.q $FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Data.q 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Data.q 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$505000000000000,$505050505050505,$505050505050505;
      Data.q $505050505050505,$505050505050505,$505050500050505,$505050505050505,$505050001000505;
      Data.q $505050505050505,$505000102020005,$505050505050505,$500010202020200,$5050505050505;
      Data.q $1020300020202,$300050505050505,$102030005000202,$5050505050500,$203000505050003;
      Data.q $505050505050001,$300050505050500,$505050505000102,$5050505050505,$505050500010203;
      Data.q $505050505050505,$505050001020300,$505050505050505,$505050500030005,$505050505050505;
      Data.q $505050505000505,$505050505050505,$505050505050505,$505050505050505,$FFFF050505050505;
      Data.q $FFFB0000FFFF0000,$FFE00000FFF10000,$3F8000007FC00000,$F8E00001F040000,$83FF000007DF0000;
      Data.q $E3FF0000C1FF0000,$FFFF0000F7FF0000,$FFFF0000;
   EndDataSection;

; IDE Options = PureBasic 5.42 Beta 3 LTS (Windows - x86)
; EnableUnicode
; EnableXP
