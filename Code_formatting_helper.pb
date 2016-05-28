 ;    Description: A PB tool as an alternative to template.pb
;         Author: Sicro
;           Date: 2016-04-23
;     PB-Version: 5.42
;             OS: Windows, Linux, Mac
;  English-Forum:
;   French-Forum:
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29600
; -----------------------------------------------------------------------------

EnableExplicit

; ==================================
; ==        Tool settings         ==
; ==================================

; + Arguments: "%TEMPFILE"
; + Wait until tool quits
; + Reload source after tool has quit
; + Into new source

; ==================================

#ProgramName = "Code formatting helper"

Runtime Enumeration Gadget
  #String_Description
  #String_Author
  #String_PBVersion

  #CheckBox_Windows
  #CheckBox_Linux
  #CheckBox_Mac

  #String_EnglishForum
  #String_FrenchForum
  #String_GermanForum

  #CheckBox_NeedsThreadSafe
  #CheckBox_Only_x86_Systems
  #CheckBox_Only_x64_Systems
  #CheckBox_Only_Ascii_Mode
  #CheckBox_Only_Unicode_Mode

  #Editor_MainCode
  #Editor_ExampleCode

  #Button_GenerateCode
EndEnumeration

#Window_Main = 0
Runtime #Window_Main

#Dialog = 0
#XML    = 0

Define CodeFile$, XML$, Code$, Supported_OS$, Condition$, Item$
Define Event, i, Count

CodeFile$ = ProgramParameter(0)

If CodeFile$ = ""
  Goto CleanUp
EndIf

XML$ = "<window id='#Window_Main' name='Window_Main' text='CodeArchiv - " + #ProgramName + "' " +
       "flags='#PB_Window_Tool | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_Invisible'>" + #CRLF$ +
       "  <vbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='Description:' width='100'/>" + #CRLF$ +
       "      <string id='#String_Description'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='Author:' width='100'/>" + #CRLF$ +
       "      <string id='#String_Author'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='PB-Version:' width='100'/>" + #CRLF$ +
       "      <string id='#String_PBVersion'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='Supported OS:' width='100'/>" + #CRLF$ +
       "      <hbox>" + #CRLF$ +
       "        <checkbox id='#CheckBox_Windows' text='Windows'/>" + #CRLF$ +
       "        <checkbox id='#CheckBox_Linux' text='Linux'/>" + #CRLF$ +
       "        <checkbox id='#CheckBox_Mac' text='Mac'/>" + #CRLF$ +
       "      </hbox>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='English Forum:' width='100'/>" + #CRLF$ +
       "      <string id='#String_EnglishForum'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='French Forum:' width='100'/>" + #CRLF$ +
       "      <string id='#String_FrenchForum'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='German Forum:' width='100'/>" + #CRLF$ +
       "      <string id='#String_GermanForum'/>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <hbox expand='item:2'>" + #CRLF$ +
       "      <text text='Code limitations:' width='100'/>" + #CRLF$ +
       "      <hbox>" + #CRLF$ +
       "        <gridbox columns='3'>" + #CRLF$ +
       "          <checkbox id='#CheckBox_Only_x86_Systems' text='Only for x86 systems'/>" + #CRLF$ +
       "          <checkbox id='#CheckBox_Only_x64_Systems' text='Only for x64 systems'/>" + #CRLF$ +
       "          <checkbox id='#CheckBox_Only_Ascii_Mode' text='Only for ascii mode'/>" + #CRLF$ +
       "          <checkbox id='#CheckBox_Only_Unicode_Mode' text='Only for unicode mode'/>" + #CRLF$ +
       "          <checkbox id='#CheckBox_NeedsThreadSafe' text='Needs Thread-Safe'/>" + #CRLF$ +
       "        </gridbox>" + #CRLF$ +
       "      </hbox>" + #CRLF$ +
       "    </hbox>" + #CRLF$ +
       "    <frame text='Put here the main code from the forum post:'>" + #CRLF$ +
       "      <vbox>" + #CRLF$ +
       "        <editor id='#Editor_MainCode' width='500' height='50'/>" + #CRLF$ +
       "      </vbox>" + #CRLF$ +
       "    </frame>" + #CRLF$ +
       "    <frame text='Put here an example code that shows the use of the code above:'>" + #CRLF$ +
       "      <vbox>" + #CRLF$ +
       "        <editor id='#Editor_ExampleCode' width='500' height='50'/>" + #CRLF$ +
       "      </vbox>" + #CRLF$ +
       "    </frame>" + #CRLF$ +
       "    <button id='#Button_GenerateCode' text='Generate code'/>" + #CRLF$ +
       "  </vbox>" + #CRLF$ +
       "</window>"

If Not (CatchXML(#XML, @XML$, StringByteLength(XML$), 0) And XMLStatus(#XML) = #PB_XML_Success)
  MessageRequester(#ProgramName, "XML error: " + XMLError(#Xml) + " (Line: " + XMLErrorLine(#Xml) + ")")
  Goto CleanUp
EndIf

If Not (CreateDialog(#Dialog) And OpenXMLDialog(#Dialog, #XML, "Window_Main"))
  MessageRequester(#ProgramName, "Dialog error: " + DialogError(#Dialog))
  Goto CleanUp
EndIf

WindowBounds(#Window_Main, WindowWidth(#Window_Main), WindowHeight(#Window_Main), #PB_Ignore, #PB_Ignore)
StickyWindow(#Window_Main, #True)
HideWindow(#Window_Main, #False)

Repeat
  Event = WaitWindowEvent()

  If Event = #PB_Event_Gadget And EventGadget() = #Button_GenerateCode

    ; Set main informations
    Code$ = ";    Description: " + Trim(GetGadgetText(#String_Description)) + #CRLF$ +
            ";         Author: " + Trim(GetGadgetText(#String_Author)) + #CRLF$ +
            ";           Date: " + FormatDate("%yyyy-%mm-%dd", Date()) + #CRLF$ +
            ";     PB-Version: " + Trim(GetGadgetText(#String_PBVersion)) + #CRLF$ +
            ";             OS: "
    If GetGadgetState(#CheckBox_Windows) : Supported_OS$ + "|Windows|" : EndIf
    If GetGadgetState(#CheckBox_Linux)   : Supported_OS$ + "|Linux|"   : EndIf
    If GetGadgetState(#CheckBox_Mac)     : Supported_OS$ + "|Mac|"     : EndIf
    Code$ + RemoveString(ReplaceString(Supported_OS$, "||", ", "), "|")

    ; Set forum of the source code
    Code$ + #CRLF$ +
            ";  English-Forum: " + Trim(GetGadgetText(#String_EnglishForum)) + #CRLF$ +
            ";   French-Forum: " + Trim(GetGadgetText(#String_FrenchForum))  + #CRLF$ +
            ";   German-Forum: " + Trim(GetGadgetText(#String_GermanForum))  + #CRLF$ +
            "; -----------------------------------------------------------------------------" + #CRLF$ + #CRLF$

    ; Set code limitations
    If Supported_OS$ <> "|Windows||Linux||Mac|" And Supported_OS$ <> ""
      Condition$ = ReplaceString(Supported_OS$, "|Windows|", "#PB_Compiler_OS <> #PB_OS_Windows And ")
      Condition$ = ReplaceString(Condition$, "|Linux|", "#PB_Compiler_OS <> #PB_OS_Linux And ")
      Condition$ = ReplaceString(Condition$, "|Mac|", "#PB_Compiler_OS <> #PB_OS_MacOS")
      If Right(Condition$, Len(" And ")) = " And "
        Condition$ = Left(Condition$, Len(Condition$) - Len(" And "))
      EndIf
      Supported_OS$ = RemoveString(ReplaceString(Supported_OS$, "||", ", "), "|")
      Code$ + "CompilerIf " + Condition$ + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Supported OS are only: " + Supported_OS$ + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf
    If GetGadgetState(#CheckBox_Only_x86_Systems)
      Code$ + "CompilerIf #PB_Compiler_Processor <> #PB_Processor_x86" + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Only for x86 systems!" + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf
    If GetGadgetState(#CheckBox_Only_x64_Systems)
      Code$ + "CompilerIf #PB_Compiler_Processor <> #PB_Processor_x64" + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Only for x64 systems!" + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf
    If GetGadgetState(#CheckBox_Only_Ascii_Mode)
      Code$ + "CompilerIf #PB_Compiler_Unicode" + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Only for ascii mode!" + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf
    If GetGadgetState(#CheckBox_Only_Unicode_Mode)
      Code$ + "CompilerIf Not #PB_Compiler_Unicode" + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Only for unicode mode!" + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf
    If GetGadgetState(#CheckBox_NeedsThreadSafe)
      Code$ + "CompilerIf Not #PB_Compiler_Thread" + #CRLF$ +
              "  CompilerError " + #DQUOTE$ + "Thread-Safe is needed!" + #DQUOTE$ + #CRLF$ +
              "CompilerEndIf" + #CRLF$ + #CRLF$
    EndIf

    ; Write main code and example code
    Count = CountGadgetItems(#Editor_MainCode) - 1
    For i = 0 To Count
      Item$ = GetGadgetItemText(#Editor_MainCode, i)
      If i = 0 : Item$ = LTrim(Item$) : EndIf ; Delete leading spaces only in the first linein order to prevent that the formatting will be destroyed
      Code$ + RTrim(Item$) + #CRLF$
    Next
    Code$ + #CRLF$ +
            ";-Example" + #CRLF$ +
            "CompilerIf #PB_Compiler_IsMainFile" + #CRLF$
    Count = CountGadgetItems(#Editor_ExampleCode) - 1
    For i = 0 To Count
      Item$ = GetGadgetItemText(#Editor_ExampleCode, i)
      If i = 0 : Item$ = LTrim(Item$) : EndIf ; Delete leading spaces only in the first linein order to prevent that the formatting will be destroyed
      Code$ + "  " + RTrim(Item$) + #CRLF$
    Next
    Code$ + "CompilerEndIf"

    ; Create a new file and write in it the new file content on the top and old file content on the bottom
    If CreateFile(0, CodeFile$)
      WriteStringFormat(0, #PB_UTF8)
      WriteString(0, Code$, #PB_UTF8)
      CloseFile(0)
    EndIf

    End
  EndIf
Until Event = #PB_Event_CloseWindow

CleanUp:
If IsXML(#XML) : FreeXML(#XML) : EndIf
DeleteFile(CodeFile$) ; Removes the file in order to prevent that the previous code is displayed 
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; CursorPosition = 233
; FirstLine = 183
; EnableUnicode
; EnableXP
; CompileSourceDirectory
; EnablePurifier