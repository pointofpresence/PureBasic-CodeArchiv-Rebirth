;    Description: Get the geographic coordinates from a adresse
;         Author: Kurzer
;           Date: 2016-09-16
;     PB-Version: 5.50
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=29821
; -----------------------------------------------------------------------------

EnableExplicit

InitNetwork()

Global.i *Buffer
Global.s sTemp, sAdresse, sBreitengrad, sLaengengrad, sKorrAdresse

#URL = "http://maps.google.com/maps/api/geocode/xml?sensor=false&address="

;sAdresse = "Autohaus, Radegaster Strasse 50a, 06369 Görzig"
sAdresse = "Schopperstr. 83, 07937 Zeulenroda"
;sAdresse = "556 Main Street New York"

Procedure.s GetXMLElement(sString.s, sElementname.s)
   Protected.i iPos1, iPos2

   iPos1 = FindString(sString, "<" + sElementname + ">") + Len(sElementname) + 2
   iPos2 = FindString(sString, "</" + sElementname + ">")
   If iPos2 > iPos1
      ProcedureReturn Mid(sString, iPos1, iPos2 - iPos1)
   EndIf
   ProcedureReturn ""
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  ; Anfrage an Google senden. Die Adresse ist in die URL eingebunden, Umlaute müssen nicht umgewandelt werden
  ; Google korrigiert ggf. fehlerhaft geschriebene Straßennamen, Orte und PLZ und gibt diese zusammen mit der Geo-Koordinate zurück.
  *Buffer = ReceiveHTTPMemory(#URL+URLEncoder(sAdresse, #PB_UTF8))
  If *Buffer
     sTemp = PeekS(*Buffer, MemorySize(*Buffer), #PB_UTF8)
     FreeMemory(*Buffer)
  
     If GetXMLElement(sTemp, "status") = "OK"
        sKorrAdresse = GetXMLElement(sTemp, "formatted_address")
        sLaengengrad = GetXMLElement(sTemp, "lat")
        sBreitengrad = GetXMLElement(sTemp, "lng")
     Else
        Debug "Fehler"
     EndIf
  
  Else
     Debug "Fehler"
  EndIf
  
  Debug sTemp
  Debug "Korrigierte Adresse: " + sKorrAdresse
  Debug "Breitengrad:         " + sBreitengrad
  Debug "Längengrad:          " + sLaengengrad
CompilerEndIf
; IDE Options = PureBasic 5.50 (Linux - x64)
; EnableXP
; EnablePurifier
