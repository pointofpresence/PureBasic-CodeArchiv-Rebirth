;    Description: An easy to use solution for multilanguage programs (freak) 
;         Author: Original freak - Updated GPI
;           Date: 09-09-2015
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?f=12&t=26729&start=15#p471134
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29128
;-----------------------------------------------------------------------------
DeclareModule Language
  EnableExplicit
  Structure Group
    Map Word.s()
  EndStructure
  
  Global NewMap Group.Group()
  
  Macro Get(sGroup,sWord)
    Language::Group(UCase(sGroup))\Word(UCase(sWord))
  EndMacro
  
  Declare Load(*DefaultLanguage,Filenname.s="")
  Declare Save(Filename.s)
EndDeclareModule


Module Language
  Procedure Load(*Default,File.s="")
    Define Group.s="COMMON"
    Define Option.s
    Define Value.s
    Define Len.i
    ClearMap(Group())
    
    Repeat
      ;because read without restore will not work
      Len=MemoryStringLength(*Default)+1
      Option.s=PeekS(*Default)
      *Default+Len*SizeOf(Character)
      
      len=MemoryStringLength(*Default)+1
      Value.s=PeekS(*Default)
      *Default+Len*SizeOf(Character)
      
      Option=UCase(Option)
      Select option
        Case "", "_END_"
          Break
        Case "_GROUP_"
          Group=UCase(Value)
        Default
          Group(Group)\Word(Option)=Value
          ;Debug Group+"\"+Option+"="+Value
      EndSelect
    ForEver
    
    If file
      If OpenPreferences(File)       
        ForEach Group()
          PreferenceGroup(MapKey(Group()))
          ForEach Group()\Word()
            Group()\Word()=ReadPreferenceString(MapKey(Group()\Word()),Group()\Word())
          Next
        Next
        ClosePreferences()
      Else
        ProcedureReturn #False
      EndIf
    EndIf
    ProcedureReturn #True   
  EndProcedure
  
  Procedure Save(File.s)
    If CreatePreferences(File,#PB_Preference_GroupSeparator)
      PreferenceComment("Language File")
      PreferenceGroup("info");just in case we need this information sometimes
      WritePreferenceString("Version","1.00")
      WritePreferenceString("Programm",GetFilePart(ProgramFilename()))
      ForEach Group()       
        PreferenceGroup(MapKey(Group()))
        ForEach Group()\Word()
          WritePreferenceString(MapKey(Group()\Word()),Group()\Word())
        Next
      Next
      ClosePreferences()
      ProcedureReturn #True
    EndIf
    ProcedureReturn #False
  EndProcedure
EndModule

;- Example

CompilerIf #PB_Compiler_IsMainFile
  
  Language::Load(?English)
  ;Language::Load(?English,"german.pref")
  
  
  Debug Language::Get("MenuTitle","File")
  Debug Language::Get("MenuItem","Open")
  
  ;Language::Save("german.pref")
  
  
  
  
  DataSection
    
    ; Here the default language is specified. It is a list of Group, Name pairs,
    ; with some special keywords for the Group:
    ;
    ; "_GROUP_" will indicate a new group in the datasection, the second value is the group name
    ; "_END_" will indicate the end of the language list (as there is no fixed number)
    ;
    ; Note: The identifier strings are case insensitive to make live easier :)
    
    English:
    
    ; ===================================================
    Data.s "_GROUP_",            "MenuTitle"
    ; ===================================================
    
    Data.s "File",             "File"
    Data.s "Edit",             "Edit"
    
    ; ===================================================
    Data.s "_GROUP_",            "MenuItem"
    ; ===================================================
    
    Data.s "New",              "New"
    Data.s "Open",             "Open..."
    Data.s "Save",             "Save"
    
    ; ===================================================
    Data.s "_END_",              ""
    ; ===================================================
    
  EndDataSection
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
