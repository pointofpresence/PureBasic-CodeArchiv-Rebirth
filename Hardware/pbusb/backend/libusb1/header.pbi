; Public libusbx header file for Purebasic
; Copyright © 2007-2008 Daniel Drake <dsd@gentoo.org>
; Copyright © 2001 Johannes Erdfelt <johannes@erdfelt.com>
; Copyright © 2013 Nicolas Göddel <nicolas@freakscorner.de>
;
; This library is free software; you can redistribute it and/or
; modify it under the terms of the GNU Lesser General Public
; License as published by the Free Software Foundation; either
; version 2.1 of the License, or (at your option) any later version.
;
; This library is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public
; License along with this library; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

EnableExplicit

#LIBUSB_MEMORY_ALIGN = SizeOf(Integer)

#LIBUSB_PATH_MAX = 512


; Device And/Or Interface Class codes
Enumeration ;libusb_class_code
	; In the context of a \ref libusb_device_descriptor "device descriptor",
	; this bDeviceClass value indicates that each Interface specifies its
	; own class information And all interfaces operate independently.
	#LIBUSB_CLASS_PER_INTERFACE			=  $00
	#LIBUSB_CLASS_AUDIO						=  $01	; Audio class
	#LIBUSB_CLASS_COMM						=  $02	; Communications class
	#LIBUSB_CLASS_HID							=  $03	; Human Interface Device class
	#LIBUSB_CLASS_PHYSICAL					=	$05	; Physical
	#LIBUSB_CLASS_PRINTER					=  $07	; Printer class
	#LIBUSB_CLASS_PTP							=	$06	; Image class (legacy name from libusb-0.1 usb.h)
	#LIBUSB_CLASS_IMAGE						=	$06	; Image class
	#LIBUSB_CLASS_MASS_STORAGE				=  $08	; Mass storage class
	#LIBUSB_CLASS_HUB							=  $09	; Hub class
	#LIBUSB_CLASS_DATA						=	$0A	; Data class
	#LIBUSB_CLASS_SMART_CARD				=	$0b	; Smart card
	#LIBUSB_CLASS_CONTENT_SECURITY		=	$0d	; Content Security
	#LIBUSB_CLASS_VIDEO						=	$0e	; Video
	#LIBUSB_CLASS_PERSONAL_HEALTHCARE	=	$0f	; Personal Healthcare
	#LIBUSB_CLASS_DIAGNOSTIC_DEVICE		=	$dc	; Diagnostic Device
	#LIBUSB_CLASS_WIRELESS					=	$e0	; Wireless class
	#LIBUSB_CLASS_APPLICATION				=	$fe	; Application class
	#LIBUSB_CLASS_VENDOR_SPEC				=	$ff ; Class is vendor-specific
EndEnumeration

; Descriptor types as defined by the USB specification.
Enumeration ; libusb_descriptor_type
	#LIBUSB_DT_DEVICE		=	$01	; Device descriptor. See libusb_device_descriptor.
	#LIBUSB_DT_CONFIG		=	$02	; Configuration descriptor. See libusb_config_descriptor.
	#LIBUSB_DT_STRING		=	$03	; String descriptor
	#LIBUSB_DT_INTERFACE	=	$04	; Interface descriptor. See libusb_interface_descriptor.
	#LIBUSB_DT_ENDPOINT	=	$05	; Endpoint descriptor. See libusb_endpoint_descriptor.
	
	#LIBUSB_DT_HID			=	$21	; HID descriptor
	#LIBUSB_DT_REPORT		=	$22	; HID report descriptor
	#LIBUSB_DT_PHYSICAL	=	$23	; Physical descriptor
	#LIBUSB_DT_HUB			=	$29	; Hub descriptor
EndEnumeration

; Descriptor sizes per descriptor type
#LIBUSB_DT_DEVICE_SIZE				=	18
#LIBUSB_DT_CONFIG_SIZE				=	 9
#LIBUSB_DT_INTERFACE_SIZE			=	 9
#LIBUSB_DT_ENDPOINT_SIZE			=	 7
#LIBUSB_DT_ENDPOINT_AUDIO_SIZE	=	 9	; Audio extension
#LIBUSB_DT_HUB_NONVAR_SIZE			=	 7

#LIBUSB_ENDPOINT_ADDRESS_MASK		=	$0f	; in bEndpointAddress
#LIBUSB_ENDPOINT_DIR_MASK			=	$80


; Endpoint direction. Values For bit 7 of the
; libusb_endpoint_descriptor\bEndpointAddress "endpoint address" scheme.
Enumeration ; libusb_endpoint_direction/*
	#LIBUSB_ENDPOINT_IN		=	$80	; In: device-To-host
	#LIBUSB_ENDPOINT_OUT		=	$00	; Out: host-To-device
EndEnumeration

#LIBUSB_TRANSFER_TYPE_MASK	=	$03	; in bmAttributes

; Endpoint transfer type. Values For bits 0:1 of the
; libusb_endpoint_descriptor\bmAttributes "endpoint attributes" field.
Enumeration ; libusb_transfer_type
	#LIBUSB_TRANSFER_TYPE_CONTROL		=	0	; Control endpoint
	#LIBUSB_TRANSFER_TYPE_ISOCHRONOUS	=	1	; Isochronous endpoint
	#LIBUSB_TRANSFER_TYPE_BULK			=	2	; Bulk endpoint
	#LIBUSB_TRANSFER_TYPE_INTERRUPT		=	3	; Interrupt endpoint
EndEnumeration

; Standard requests, As defined in table 9-3 of the USB2 specifications
Enumeration ; libusb_standard_request
	#LIBUSB_REQUEST_GET_STATUS			=	$00	; Request status of the specific recipient
	#LIBUSB_REQUEST_CLEAR_FEATURE		=	$01	; Clear Or disable a specific feature
	; $02 is reserved
	#LIBUSB_REQUEST_SET_FEATURE			=	$03	; Set or enable a specific feature
	; $04 is reserved
	#LIBUSB_REQUEST_SET_ADDRESS			=	$05	; Set device address For all future accesses
	#LIBUSB_REQUEST_GET_DESCRIPTOR		=	$06	; Get the specified descriptor
	#LIBUSB_REQUEST_SET_DESCRIPTOR		=	$07	; Used to update existing descriptors or add new descriptors
	#LIBUSB_REQUEST_GET_CONFIGURATION	=	$08	; Get the current device configuration value
	#LIBUSB_REQUEST_SET_CONFIGURATION	=	$09	; Set device configuration
	#LIBUSB_REQUEST_GET_INTERFACE		=	$0A	; Return the selected alternate setting for the specified interface
	#LIBUSB_REQUEST_SET_INTERFACE		=	$0B	; Select an alternate interface for the specified interface
	#LIBUSB_REQUEST_SYNCH_FRAME			=	$0C	; Set then report an endpoint's synchronization frame
EndEnumeration

; Request type bits of the libusb_control_setup\bmRequestType "bmRequestType" field in control transfers.
Enumeration ; libusb_request_type
	#LIBUSB_REQUEST_TYPE_STANDARD	=	($00 << 5)	; Standard
	#LIBUSB_REQUEST_TYPE_CLASS		=	($01 << 5)	; Class
	#LIBUSB_REQUEST_TYPE_VENDOR		=	($02 << 5)	; Vendor
	#LIBUSB_REQUEST_TYPE_RESERVED	=	($03 << 5)	; Reserved
EndEnumeration

; Recipient bits of the libusb_control_setup\bmRequestType "bmRequestType" field in control transfers. Values 4 through 31 are reserved.
Enumeration ; libusb_request_recipient
	#LIBUSB_RECIPIENT_DEVICE	=	$00	; Device
	#LIBUSB_RECIPIENT_INTERFACE	=	$01	; Interface
	#LIBUSB_RECIPIENT_ENDPOINT	=	$02	; Endpoint
	#LIBUSB_RECIPIENT_OTHER		=	$03	; Other
EndEnumeration

#LIBUSB_ISO_SYNC_TYPE_MASK		=	$0C

; Synchronization type For isochronous endpoints. Values For bits 2:3 of the
; libusb_endpoint_descriptor\bmAttributes "bmAttributes" field in
; libusb_endpoint_descriptor.
Enumeration ; libusb_iso_sync_type
	#LIBUSB_ISO_SYNC_TYPE_NONE		=	0	; No synchronization
	#LIBUSB_ISO_SYNC_TYPE_ASYNC		=	1	; Asynchronous
	#LIBUSB_ISO_SYNC_TYPE_ADAPTIVE	=	2	; Adaptive
	#LIBUSB_ISO_SYNC_TYPE_SYNC		=	3	; Synchronous
EndEnumeration

#LIBUSB_ISO_USAGE_TYPE_MASK	=	$30

; Usage type For isochronous endpoints. Values For bits 4:5 of the
; libusb_endpoint_descriptor\bmAttributes "bmAttributes" field in
; libusb_endpoint_descriptor.
Enumeration ; libusb_iso_usage_type
	#LIBUSB_ISO_USAGE_TYPE_DATA		=	0	; Data endpoint
	#LIBUSB_ISO_USAGE_TYPE_FEEDBACK	=	1	; Feedback endpoint
	#LIBUSB_ISO_USAGE_TYPE_IMPLICIT	=	2	; Implicit feedback data endpoint
EndEnumeration

; A structure representing the standard USB device descriptor. This
; descriptor is documented in section 9.6.1 of the USB 2.0 specification.
; All multiple-byte fields are represented in host-endian format.
Structure libusb_device_descriptor
	bLength.a				; Size of this descriptor (in bytes)
	bDescriptorType.a		; Descriptor type. Will have value libusb_descriptor_type\LIBUSB_DT_DEVICE LIBUSB_DT_DEVICE in this context.
	bcdUSB.u				; USB-IF class code for the device. See libusb_class_code.
	bDeviceClass.a			; USB-IF class code for the device. See libusb_class_code.
	bDeviceSubClass.a		; USB-IF subclass code for the device, qualified by the bDeviceClass value.
	bDeviceProtocol.a		; USB-IF protocol code for the device, qualified by the bDeviceClass and bDeviceSubClass values.
	bMaxPacketSize0.a		; Maximum packet size for endpoint 0.
	idVendor.u				; USB-IF vendor ID.
	idProduct.u				; USB-IF product ID.
	bcdDevice.u				; Device release number in binary-coded decimal.
	iManufacturer.a			; Index of string descriptor describing manufacturer.
	iProduct.a				; Index of string descriptor describing product.
	iSerialNumber.a			; Index of string descriptor containing device serial number.
	bNumConfigurations.a	; Number of possible configurations.
EndStructure

; A Structure representing the standard USB endpoint descriptor. This
; descriptor is documented in section 9.6.3 of the USB 2.0 specification.
; All multiple-byte fields are represented in host-endian format.
Structure libusb_endpoint_descriptor
	bLength.a			; Size of this descriptor (in bytes).
	bDescriptorType.a	; Descriptor type. Will have value
						; libusb_descriptor_type\LIBUSB_DT_ENDPOINT LIBUSB_DT_ENDPOINT in this context.
	bEndpointAddress.a	; The address of the endpoint described by this descriptor. Bits 0:3 are
						; the endpoint number. Bits 4:6 are reserved. Bit 7 indicates direction,
						; see libusb_endpoint_direction.
	bmAttributes.a		; Attributes which apply to the endpoint when it is configured using
						; correspond to libusb_transfer_type. Bits 2:3 are only used For
						; isochronous endpoints and correspond To libusb_iso_sync_type.
						; Bits 4:5 are also only used for isochronous endpoints and correspond To
						; libusb_iso_usage_type. Bits 6:7 are reserved.
	wMaxPacketSize.u	; Maximum packet size this endpoint is capable of sending/receiving.
	bInterval.a			; Interval for polling endpoint for data transfers.
	bRefresh.a			; For audio devices only: the rate at which synchronization feedback is provided.
	bSynchAddress.a		; For audio devices only: the address if the synch endpoint
CompilerIf #LIBUSB_MEMORY_ALIGN
	pad0.a[#LIBUSB_MEMORY_ALIGN - 1]
CompilerEndIf
	*extra.Ascii		; Extra descriptors. If libusbx encounters unknown endpoint descriptors,
						; it will store them here, should you wish to parse them.
	extra_length.l		; Length of the extra descriptors, in bytes.
CompilerIf #LIBUSB_MEMORY_ALIGN = 8
	pad1.l
CompilerEndIf
EndStructure

; A Structure representing the standard USB interface descriptor. This
; descriptor is documented in section 9.6.5 of the USB 2.0 specification.
; All multiple-byte fields are represented in host-endian format.
Structure libusb_interface_descriptor
	bLength.a								; Size of this descriptor (in bytes)
	bDescriptorType.a						; Descriptor type. Will have value
											; libusb_descriptor_type\LIBUSB_DT_INTERFACE LIBUSB_DT_INTERFACE in this context.
	bInterfaceNumber.a						; Number of this interface
	bAlternateSetting.a						; Value used to select this alternate setting for this interface
	bNumEndpoints.a							; Number of endpoints used by this interface (excluding the control endpoint).
	bInterfaceClass.a						; USB-IF class code for this interface. See \ref libusb_class_code.
	bInterfaceSubClass.a					; USB-IF subclass code for this interface, qualified by the bInterfaceClass value.
	bInterfaceProtocol.a					; USB-IF protocol code for this interface, qualified by the bInterfaceClass
											; and bInterfaceSubClass values.
	iInterface.a							; Index of string descriptor describing this interface.
CompilerIf #LIBUSB_MEMORY_ALIGN
	pad0.a[#LIBUSB_MEMORY_ALIGN - 1]
CompilerEndIf
	*endpoint.libusb_endpoint_descriptor	; Array of endpoint descriptors. This length of this array is determined
											; by the bNumEndpoints field.
	
	*extra.Ascii							; Extra descriptors. If libusbx encounters unknown interface descriptors,
											; it will store them here, should you wish to parse them.
	extra_length.l							; Length of the extra descriptors, in bytes.
CompilerIf #LIBUSB_MEMORY_ALIGN = 8
	pad1.l
CompilerEndIf
EndStructure

; A collection of alternate settings for a particular USB interface.
Structure libusb_interface
	*altsetting.libusb_interface_descriptor	; Array of interface descriptors. The length of this array is determined
											; by the num_altsetting field.
	
	num_altsetting.l						; The number of alternate settings that belong to this interface.
CompilerIf #LIBUSB_MEMORY_ALIGN = 8
	pad0.l
CompilerEndIf
EndStructure

; A structure representing the standard USB configuration descriptor. This
; descriptor is documented in section 9.6.3 of the USB 2.0 specification.
; All multiple-byte fields are represented in host-endian format.
Structure libusb_config_descriptor
	bLength.a					; Size of this descriptor (in bytes).
	bDescriptorType.a			; Descriptor type. Will have value libusb_descriptor_type\LIBUSB_DT_CONFIG LIBUSB_DT_CONFIG in this context.
	wTotalLength.u				; Total length of data returned for this configuration.
	bNumInterfaces.a			; Number of interfaces supported by this configuration.
	bConfigurationValue.a		; Identifier value for this configuration.
	iConfiguration.a			; Index of string descriptor describing this configuration.
	bmAttributes.a				; Configuration characteristics
	MaxPower.a					; Maximum power consumption of the USB device from this bus in this
								; configuration when the device is fully opreation. Expressed in units of 2 mA.
CompilerIf #LIBUSB_MEMORY_ALIGN
	pad0.a[#LIBUSB_MEMORY_ALIGN - 1]
CompilerEndIf
	*interface.libusb_interface	; Array of interfaces supported by this configuration. The length of
								; this array is determined by the bNumInterfaces field.
	
	*extra.Ascii				; Extra descriptors. If libusbx encounters unknown configuration
								; descriptors, it will store them here, should you wish to parse them.
	extra_length.l				; Length of the extra descriptors, in bytes.
CompilerIf #LIBUSB_MEMORY_ALIGN = 8
	pad1.l
CompilerEndIf
EndStructure

; Setup packet for control transfers.
Structure libusb_control_setup
  bRequestType.a	; Request type. Bits 0:4 determine recipient, see libusb_request_recipient. Bits 5:6 determine type, see
  					; libusb_request_type. Bit 7 determines data transfer direction, see libusb_endpoint_direction.
  bRequest.a		; Request. If the type bits of bmRequestType are equal to libusb_request_type\LIBUSB_REQUEST_TYPE_STANDARD
  					; "LIBUSB_REQUEST_TYPE_STANDARD" then this field refers to libusb_standard_request. For other cases, use of
  					; this field is application-specific.
  wValue.u			; Value. Varies according to request.
  wIndex.u			; Index. Varies according to request, typically used to pass an index or offset.
  wLength.u			; Number of bytes to transfer.
EndStructure

#LIBUSB_CONTROL_SETUP_SIZE	= (SizeOf(libusb_control_setup))

; libusbx

Structure libusb_context
EndStructure
Structure libusb_device
EndStructure
Structure libusb_device_handle
EndStructure

; Structure providing the version of the libusbx runtime
Structure libusb_version
	major.u			; Library major version.
	minor.u			; Library minor version.
	micro.u			; Library micro version.
	nano.u			; Library nano version.
	*rc.Ascii		; Library release candidate suffix string, e.g. "-rc4".
	*describe.Ascii	; For ABI compatibility only.
EndStructure

; Speed codes. Indicates the speed at which the device is operating.
Enumeration ; libusb_speed
	#LIBUSB_SPEED_UNKNOWN	= 0	; The OS doesn't report or know the device speed.
	#LIBUSB_SPEED_LOW		= 1	; The device is operating at low speed (1.5MBit/s).
	#LIBUSB_SPEED_FULL		= 2	; The device is operating at full speed (12MBit/s).
	#LIBUSB_SPEED_HIGH		= 3	 ; The device is operating at high speed (480MBit/s).
	#LIBUSB_SPEED_SUPER		= 4	 ; The device is operating at super speed (5000MBit/s).
EndEnumeration

; Error codes. Most libusbx functions Return 0 on success Or one of these
; codes on failure.
; You can call libusb_error_name() To retrieve a string representation
; of an error code.
Enumeration ; libusb_error
	#LIBUSB_SUCCESS				=	 0	; Success (no error)
	#LIBUSB_ERROR_IO			=	-1	; Input/output error
	#LIBUSB_ERROR_INVALID_PARAM	=	-2	; Invalid parameter
	#LIBUSB_ERROR_ACCESS		=	-3	; Access denied (insufficient permissions)
	#LIBUSB_ERROR_NO_DEVICE		=	-4	; No such device (it may have been disconnected)
	#LIBUSB_ERROR_NOT_FOUND		=	-5	; Entity not found
	#LIBUSB_ERROR_BUSY			=	-6	; Resource busy
	#LIBUSB_ERROR_TIMEOUT		=	-7	; Operation timed out
	#LIBUSB_ERROR_OVERFLOW		=	-8	; Overflow
	#LIBUSB_ERROR_PIPE			=	-9	; Pipe error
	#LIBUSB_ERROR_INTERRUPTED	=	-10	; System call interrupted (perhaps due to signal)
	#LIBUSB_ERROR_NO_MEM		=	-11	; Insufficient memory
	#LIBUSB_ERROR_NOT_SUPPORTED	=	-12	; Operation not supported or unimplemented on this platform
	; NB! Remember To update libusb_error_name()
	; when adding new error codes here.
	#LIBUSB_ERROR_OTHER			=	-99	; Other error
EndEnumeration

; Transfer status codes
Enumeration ; libusb_transfer_status {
	#LIBUSB_TRANSFER_COMPLETED	; Transfer completed without error. Note that this does not indicate
								; that the entire amount of requested data was transferred.
	#LIBUSB_TRANSFER_ERROR		; Transfer failed
	#LIBUSB_TRANSFER_TIMED_OUT	; Transfer timed out
	#LIBUSB_TRANSFER_CANCELLED	; Transfer was cancelled
	#LIBUSB_TRANSFER_STALL		; For bulk/interrupt endpoints: halt condition detected (endpoint
								; stalled). For control endpoints: control request not supported.
	#LIBUSB_TRANSFER_NO_DEVICE	; Device was disconnected
	#LIBUSB_TRANSFER_OVERFLOW	; Device sent more data than requested
EndEnumeration

; libusb_transfer.flags values
Enumeration ; libusb_transfer_flags
	#LIBUSB_TRANSFER_SHORT_NOT_OK		= 1<<0	; Report short frames as errors
	#LIBUSB_TRANSFER_FREE_BUFFER		= 1<<1	; Automatically free() transfer buffer during libusb_free_transfer()

	; Automatically call libusb_free_transfer() after callback returns.
	; If this flag is set, it is illegal To call libusb_free_transfer()
	; from your transfer callback, As this will result in a double-free
	; when this flag is acted upon.
	#LIBUSB_TRANSFER_FREE_TRANSFER		= 1<<2

	; Terminate transfers that are a multiple of the endpoint's
	; wMaxPacketSize with an extra zero length packet. This is useful
	; when a device protocol mandates that each logical request is
	; terminated by an incomplete packet (i.e. the logical requests are
	; not separated by other means).
	; 
	; This flag only affects host-To-device transfers To bulk and interrupt
	; endpoints. In other situations, it is ignored.
	; 
	; This flag only affects transfers with a length that is a multiple of
	; the endpoint's wMaxPacketSize. On transfers of other lengths, this
	; flag has no effect. Therefore, if you are working with a device that
	; needs a ZLP whenever the end of the logical request falls on a packet
	; boundary, then it is sensible to set this flag on <em>every</em>
	; transfer (you do not have to worry about only setting it on transfers
	; that end on the boundary).
	; 
	; This flag is currently only supported on Linux.
	; On other systems, libusb_submit_transfer() will return
	; LIBUSB_ERROR_NOT_SUPPORTED for every transfer where this flag is set.
	; 
	; Available since libusb-1.0.9.
	#LIBUSB_TRANSFER_ADD_ZERO_PACKET	= 1<<3
EndEnumeration

; Isochronous packet descriptor.
Structure libusb_iso_packet_descriptor
	length.l		; Length of data To request in this packet.
	actual_length.l	; Amount of data that was actually transferred.
	status.l		; Status code for this packet. See libusb_transfer_status.
EndStructure

; Asynchronous transfer callback function type. When submitting asynchronous
; transfers, you pass a pointer to a callback function of this type via the
; \ref libusb_transfer::callback "callback" member of the libusb_transfer
; structure. libusbx will call this function later, when the transfer has
; completed or failed. See \ref asyncio for more information.
; \param transfer The libusb_transfer struct the callback function is being
; notified about.
Prototype.i libusb_transfer_cb_fn(*transfer)	;Returns void. *transfer has to be of type libusb_transfer.

; The generic USB transfer Structure. The user populates this Structure And
; then submits it in order To request a transfer. After the transfer has
; completed, the library populates the transfer With the results And passes
; it back To the user.
Structure libusb_transfer
	*dev_handle.libusb_device_handle				; Handle of the device that this transfer will be submitted to.
	flags.a											; A bitwise or combination of \ref libusb_transfer_flags.
	endpoint.a										; Address of the endpoint where this transfer will be sent.
	type.a											; Type of the endpoint from \ref libusb_transfer_type.
CompilerIf #LIBUSB_MEMORY_ALIGN
	pad0.a
CompilerEndIf
	timeout.l										; Timeout for this transfer in millseconds. A value of 0 indicates no timeout.

	; The status of the transfer. read-only, and only for use within transfer callback function.
	; If this is an isochronous transfer, this field may read COMPLETED even if there were errors in the frames. Use the
	; libusb_iso_packet_descriptor\status "status" field in each packet to determine if errors occurred.
	status.l										; libusb_transfer_status
	length.l										; Length of the data buffer.
	actual_length.l									; Actual length of data that was transferred. Read-only, and only for
													; use within transfer callback function. Not valid for isochronous
													; endpoint transfers.
CompilerIf #LIBUSB_MEMORY_ALIGN = 8
	pad1.l
CompilerEndIf
	callback.libusb_transfer_cb_fn					; Callback function. This will be invoked when the transfer completes,
													; fails, or is cancelled.
	*user_data										; User context data to pass to the callback function.
	*buffer.Ascii									; Data buffer.
	num_iso_packets.l								; Number of isochronous packets. Only used for I/O with isochronous endpoints.
	iso_packet_desc.libusb_iso_packet_descriptor[0]	; Isochronous packet descriptors, for isochronous transfers only.
EndStructure

; Capabilities supported by this instance of libusb. Test if the loaded
; library supports a given capability by calling
; libusb_has_capability().
Enumeration ; libusb_capability
	#LIBUSB_CAP_HAS_CAPABILITY	=	0	; The libusb_has_capability() API is available.
EndEnumeration

; Log message levels.
; - LIBUSB_LOG_LEVEL_NONE (0)    : no messages ever printed by the library (default)
; - LIBUSB_LOG_LEVEL_ERROR (1)   : error messages are printed To stderr
; - LIBUSB_LOG_LEVEL_WARNING (2) : warning and error messages are printed To stderr
; - LIBUSB_LOG_LEVEL_INFO (3)    : informational messages are printed To stdout, warning and error messages are printed To stderr
; - LIBUSB_LOG_LEVEL_DEBUG (4)   : debug and informational messages are printed to stdout, warnings and errors To stderr.
Enumeration ; libusb_log_level
	#LIBUSB_LOG_LEVEL_NONE	=	0
	#LIBUSB_LOG_LEVEL_ERROR
	#LIBUSB_LOG_LEVEL_WARNING
	#LIBUSB_LOG_LEVEL_INFO
	#LIBUSB_LOG_LEVEL_DEBUG
EndEnumeration
; IDE Options = PureBasic 5.22 LTS (Linux - x64)
; EnableXP
