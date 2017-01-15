DeclareModule PBUSB_UTIL
	; descriptor type
	#DESC_TYPE_DEVICE    = $01
	#DESC_TYPE_CONFIG    = $02
	#DESC_TYPE_STRING    = $03
	#DESC_TYPE_INTERFACE = $04
	#DESC_TYPE_ENDPOINT  = $05
	
	; endpoint direction
	#ENDPOINT_IN  = $80
	#ENDPOINT_OUT = $00
	
	; endpoint type
	#ENDPOINT_TYPE_CTRL = $00
	#ENDPOINT_TYPE_ISO  = $01
	#ENDPOINT_TYPE_BULK = $02
	#ENDPOINT_TYPE_INTR = $03
	
	; control request type
	#CTRL_TYPE_STANDARD = (0 << 5)
	#CTRL_TYPE_CLASS    = (1 << 5)
	#CTRL_TYPE_VENDOR   = (2 << 5)
	#CTRL_TYPE_RESERVED = (3 << 5)
	; 
	; control request recipient
	#CTRL_RECIPIENT_DEVICE    = 0
	#CTRL_RECIPIENT_INTERFACE = 1
	#CTRL_RECIPIENT_ENDPOINT  = 2
	#CTRL_RECIPIENT_OTHER     = 3
	
	; control request direction
	#CTRL_OUT = $00
	#CTRL_IN  = $80
	
	#_ENDPOINT_ADDR_MASK          = $0f
	#_ENDPOINT_DIR_MASK           = $80
	#_ENDPOINT_TRANSFER_TYPE_MASK = $03
	#_CTRL_DIR_MASK               = $80
	
	Declare.i endpoint_address(address.i)
	Declare.i endpoint_direction(address.i)
	Declare.i endpoint_type(bmAttributes.i)
	Declare.i ctrl_direction(bmRequestType.i)
	Declare.i build_request_type(direction.i, type.i, recipient.i)
	;Declare.i find_descriptor(desc.i, find_all = #False, custom_match = 0)
	Declare.i claim_interface(*refDev, intf.i)
	Declare.i release_interface(*refDev, intf.i)
	Declare.i dispose_resources(*refDev)
	Declare.s get_string(*refDev, index.i, langid.i = 0)
EndDeclareModule

Module PBUSB_UTIL
EndModule
; IDE Options = PureBasic 5.21 LTS (Linux - x64)
; EnableXP
