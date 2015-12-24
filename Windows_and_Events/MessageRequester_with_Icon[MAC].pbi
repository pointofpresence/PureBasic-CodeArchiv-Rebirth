;    Description: MessageRequester with Icon
;         Author: Shardik/Wilbert
;           Date: 2013-04-06
;     PB-Version: 5.40
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=410009#p410009
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf
EnableExplicit

Global Workspace.i = CocoaMessage(0, 0, "NSWorkspace sharedWorkspace")

Procedure MessageRequesterEx(Title.s, Info.s, Type.s)
  Protected Alert.i = CocoaMessage(0, CocoaMessage(0, 0, "NSAlert new"), "autorelease")
  CocoaMessage(0, Alert, "setMessageText:$", @Title)
  CocoaMessage(0, Alert, "setInformativeText:$", @Info)
  CocoaMessage(0, Alert, "setIcon:", CocoaMessage(0, Workspace, "iconForFileType:$", @Type))
  CocoaMessage(0, Alert, "runModal")
EndProcedure
;-Example
CompilerIf #PB_Compiler_IsMainFile  
  MessageRequesterEx("Icon demo 1", "Requester with app icon", "'APPL'")
  MessageRequesterEx("Icon demo 2", "Requester with caution icon", "'caut'")
  MessageRequesterEx("Icon demo 3", "Requester with note icon", "'note'")
  MessageRequesterEx("Icon demo 4", "Requester with stop icon", "'stop'")
CompilerEndIf
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
