;    Description: Example how to Enumerate PB_Event_CustomValue and PB_EventType_FirstCustomValue
;         Author: hjbremer
;           Date:2014-09-11
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28379
;-----------------------------------------------------------------------------

CompilerIf Defined(Common_Event_CustomValue, #PB_Module) = #False
  
  DeclareModule Common_Event_CustomValue
    
    Enumeration PB_Event_CustomValue  #PB_Event_FirstCustomValue
    EndEnumeration
    
    Enumeration PB_EventType_CustomValue #PB_EventType_FirstCustomValue
    EndEnumeration
    
  EndDeclareModule
  
  Module Common_Event_CustomValue
  EndModule
  
CompilerEndIf

DeclareModule test1   
  UseModule Common_Event_CustomValue
  
  Enumeration PB_Event_CustomValue
    #my_test1_Event_1
    #my_test1_Event_2
  EndEnumeration
  
  Enumeration PB_EventType_CustomValue
    #my_test1_Eventtype_1
    #my_test1_Eventtype_2
  EndEnumeration 
  
EndDeclareModule

Module test1
EndModule


DeclareModule test11
  UseModule Common_Event_CustomValue
  
  Enumeration PB_Event_CustomValue
    #my_test11_Event_1
    #my_test11_Event_2
  EndEnumeration
  
  Enumeration PB_EventType_CustomValue
    #my_test11_Eventtype_1
    #my_test11_Eventtype_2
  EndEnumeration
  
EndDeclareModule

Module test11   
EndModule

UseModule test1
UseModule test11

Debug #my_test1_Event_1
Debug #my_test1_Event_2
Debug #my_test11_Event_1
Debug #my_test11_Event_2

Debug #my_test1_Eventtype_1
Debug #my_test1_Eventtype_2
Debug #my_test11_Eventtype_1
Debug #my_test11_Eventtype_2

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; EnableUnicode
; EnableXP
