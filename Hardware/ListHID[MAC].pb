;    Description: List all Human Interface Devices (HID) currently attached to your Mac
;         Author: Shardik
;           Date: 2014-03-13
;     PB-Version: 5.41
;             OS: Mac
;  English-Forum: http://www.purebasic.fr/english/viewtopic.php?p=440354#p440354
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS<>#PB_OS_MacOS
  CompilerError "MacOs only!"
CompilerEndIf

; Converted from C source code on
; http://atose.org/?page_id=113

EnableExplicit

ImportC "/System/Library/Frameworks/IOKit.framework/IOKit"
  IOHIDDeviceGetProperty(IOHIDDeviceRef.I, KeyStringRef.I)
  IOHIDManagerCopyDevices(IOHIDManagerRef.I)
  IOHIDManagerCreate(CFAllocatorRef.I, IOOptions.I)
  IOHIDManagerOpen(IOHIDManagerRef.I, IOOptions.I)
  IOHIDManagerSetDeviceMatching(IOHIDManagerRef.I, MatchingDictionary.I)
EndImport

ImportC ""
  CFSetGetCount(CFSetRef.I)
  CFSetGetValues(CFSetRef.I, *ValueArray)
  CFStringGetCString(CFStringRef.I, *StringBuffer, BufferSize.I,
                     CFStringEncoding.I)
EndImport

Procedure.S ConvertCFStringIntoString(CFString.I)
  Protected String.S = Space(256)
  
  CFStringGetCString(CFString, @String, Len(String), 0)
  
  CompilerIf #PB_Compiler_Unicode
    PokeS(@String, PeekS(@String, -1, #PB_Ascii), -1, #PB_Unicode)
  CompilerEndIf
  
  ProcedureReturn Trim(String)
EndProcedure

Define *DeviceArray
Define DeviceSet.I
Define HIDManager.I
Define i.I
Define Info.S
Define KeyNameRef.I
Define kIOHIDManufacturerKey.S = "Manufacturer"
Define kIOHIDProductKey.S = "Product"
Define NumDevices.I

CompilerIf #PB_Compiler_Unicode
  PokeS(@kIOHIDManufacturerKey, PeekS(@kIOHIDManufacturerKey, -1, #PB_Unicode),
        -1, #PB_Ascii)
  PokeS(@kIOHIDProductKey, PeekS(@kIOHIDProductKey, -1, #PB_Unicode),
        -1, #PB_Ascii)
CompilerEndIf

HIDManager = IOHIDManagerCreate(0, 0)

If HIDManager
  IOHIDManagerSetDeviceMatching(HIDManager, 0)
  IOHIDManagerOpen(HIDManager, 0)
  DeviceSet = IOHIDManagerCopyDevices(HIDManager)
  NumDevices = CFSetGetCount(DeviceSet)
  Info = "Number of devices detected: " + NumDevices
  
  If NumDevices > 0
    *DeviceArray = AllocateMemory(NumDevices * SizeOf(Integer))
    CFSetGetValues(DeviceSet, *DeviceArray)
    
    For i = 0 To NumDevices - 1
      KeyNameRef = IOHIDDeviceGetProperty(PeekI(*DeviceArray +
                                                i * SizeOf(Integer)), CFStringCreateWithCString_(0,
                                                                                                 kIOHIDProductKey, 0))
      
      If KeyNameRef
        Info + #CR$ + "- " + ConvertCFStringIntoString(KeyNameRef)
      EndIf
      
      KeyNameRef = IOHIDDeviceGetProperty(PeekI(*DeviceArray +
                                                i * SizeOf(Integer)), CFStringCreateWithCString_(0,
                                                                                                 kIOHIDManufacturerKey, 0))
      
      If KeyNameRef
        Info + " (" + ConvertCFStringIntoString(KeyNameRef) + ")"
      EndIf
    Next i
  EndIf
  
  FreeMemory(*DeviceArray)
  CFRelease_(DeviceSet)
  CFRelease_(HIDManager)
EndIf

MessageRequester("Attached Human Interface Devices (HID)", Info)
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; EnableUnicode
; EnableXP
