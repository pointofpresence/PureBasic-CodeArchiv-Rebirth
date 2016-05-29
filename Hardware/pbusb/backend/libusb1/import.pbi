; Public libusbx header file + Wrapper for Purebasic
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

; Aktuell sind nur die Headerdateien für libusb-1.0.9 bis libusb-1.0.11 angepasst

DeclareModule LIBUSB1
	
	IncludeFile #PB_Compiler_FilePath + "/header.pbi"
	IncludeFile #PB_Compiler_FilePath + "/time.pbi"
	
	; File descriptor for polling
	Structure libusb_pollfd
		fd.l		; Numeric file descriptor
		events.w	; Event flags to poll for from <poll.h>. POLLIN indicates that you
					; should monitor this file descriptor for becoming ready to read from,
					; and POLLOUT indicates that you should monitor this file descriptor for
					; nonblocking write readiness.
	EndStructure
	
	#VERSION_MAJOR = 1
	#VERSION_MINOR = 0
	#VERSION_MICRO = 11
	
	CompilerIf #VERSION_MAJOR = 1 And #VERSION_MINOR = 0 And #VERSION_MICRO >= 9 And #VERSION_MICRO <= 11
		Declare.i libusb_init(*p_ctx.libusb_context)
		Declare libusb_exit(*ctx.libusb_context)
		Declare libusb_set_debug(*ctx.libusb_context, level.l)
		Declare.i libusb_get_version() ;Return type: *libusb_version
		Declare.l libusb_has_capability(capability.l)
		Declare.i libusb_error_name(errcode.l)
		
		Declare.i libusb_get_device_list(*ctx.libusb_context, *pp_list.libusb_device) ;Return Type: Size or LIBUSB_ERROR
		Declare libusb_free_device_list(*p_list.libusb_device, unref_devices.l)
		Declare.i libusb_ref_device(*dev.libusb_device) ;Return type: *libusb_device
		Declare libusb_unref_device(*dev.libusb_device)
		
		Declare.l libusb_get_configuration(*dev.libusb_device_handle, *config.Long)
		Declare.l libusb_get_device_descriptor(*dev.libusb_device, *desc.libusb_device_descriptor)
		Declare.l libusb_get_active_config_descriptor(*dev.libusb_device, *p_config.libusb_config_descriptor)
		Declare.l libusb_get_config_descriptor(*dev.libusb_device, config_index.a, *p_config.libusb_config_descriptor)
		Declare.l libusb_get_config_descriptor_by_value(*dev.libusb_device, bConfigurationValue.a, *p_config.libusb_config_descriptor)
		Declare libusb_free_config_descriptor(*config.libusb_config_descriptor)
		Declare.a libusb_get_bus_number(*dev.libusb_device)
		Declare.a libusb_get_device_address(*dev.libusb_device)
		Declare.a libusb_get_device_speed(*dev.libusb_device)
		Declare.l libusb_get_max_packet_size(*dev.libusb_device, endpoint.a)
		Declare.l libusb_get_max_iso_packet_size(*dev.libusb_device, endpoint.a)
		
		Declare.l libusb_open(*dev.libusb_device, *p_handle.libusb_device_handle) ;Return Type: LIBUSB_ERROR
		Declare libusb_close(*dev_handle.libusb_device_handle)
		Declare.i libusb_get_device(*dev_handle.libusb_device_handle) ;Return type: *libusb_device
		
		Declare.l libusb_set_configuration(*dev.libusb_device_handle, configuration.l) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_claim_interface(*dev.libusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_release_interface(*dev.libusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		
		Declare.i libusb_open_device_with_vid_pid(*ctx.libusb_context, vendor_id.u, product_id.u) ;Return type: *libusb_device_handle
		
		Declare libusb_set_interface_alt_setting(*dev.libusb_device_handle, interface_number.l, alternate_setting.l) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_clear_halt(*dev.libusb_device_handle, endpoint.a) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_reset_device(*dev.libusb_device_handle) ;?Return type: LIBUSB_ERROR
		
		Declare.l libusb_kernel_driver_active(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_detach_kernel_driver(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_attach_kernel_driver(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		
		Declare.i libusb_alloc_transfer(iso_packets) ;Return type: *libusb_transfer
		Declare.l libusb_submit_transfer(*transfer.libusb_transfer) ;?Return type: LIBUSB_ERROR
		Declare.l libusb_cancel_transfer(*transfer.libusb_transfer) ;?Return type: LIBUSB_ERROR
		Declare libusb_free_transfer(*transfer.libusb_transfer)
		
		; sync I/O
		Declare.l libusb_control_transfer(*dev_handle.libusb_device_handle, request_type.a, bRequest.a, wValue.u, wIndex.u, *data.Ascii, wLength.u, timeout.l) ;Return Type: LIBUSB_ERROR
		Declare.l libusb_bulk_transfer(*dev_handle.libusb_device_handle, endpoint.a, *data.Ascii, length.l, *actual_length.Long, timeout.l) ;Return Type: LIBUSB_ERROR
		Declare.l libusb_interrupt_transfer(*dev_handle.libusb_device_handle, endpoint.a, *data.Ascii, length.l, *actual_length.Long, timeout.l) ;Return Type: LIBUSB_ERROR
		Declare.l libusb_get_string_descriptor_ascii(*dev_handle.libusb_device_handle, desc_index.a, *data.Ascii, length.l) ;Return Type: LIBUSB_ERROR
		
		; polling and timeouts
		Declare.l libusb_try_lock_events(*ctx.libusb_context)
		Declare.l libusb_lock_events(*ctx.libusb_context)
		Declare.l libusb_unlock_events(*ctx.libusb_context)
		Declare.l libusb_event_handling_ok(*ctx.libusb_context)
		Declare.l libusb_event_handler_active(*ctx.libusb_context)
		Declare.l libusb_lock_event_waiters(*ctx.libusb_context)
		Declare.l libusb_unlock_event_waiters(*ctx.libusb_context)
		Declare.l libusb_wait_for_event(*ctx.libusb_context, *tv.timeval)
		Declare.l libusb_handle_events_timeout(*ctx.libusb_context, *tv.timeval)
		Declare.l libusb_handle_events_timeout_completed(*ctx.libusb_context, *tv.timeval, *completed.Long)
		Declare.l libusb_handle_events(*ctx.libusb_context)
		Declare.l libusb_handle_events_completed(*ctx.libusb_context, *completed.Long)
		Declare.l libusb_handle_events_locked(*ctx.libusb_context, *tv.timeval)
		Declare.l libusb_pollfds_handle_timeouts(*ctx.libusb_context)
		Declare.l libusb_get_next_timeout(*ctx.libusb_context, *tv.timeval)

	CompilerEndIf
	
	Declare.i libusb_control_transfer_get_data(*transfer.libusb_transfer) ; Return type is a pointer to an Ascii.
	Declare.i libusb_control_transfer_get_setup(*transfer.libusb_transfer)
	Declare.i libusb_fill_control_setup(*buffer.Ascii, bmRequestType.a, bRequest.a, wValue.u, wIndex.u, wLength.u)
	Declare.i libusb_fill_control_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, *buffer.Ascii, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
	Declare libusb_fill_bulk_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
	Declare libusb_fill_interrupt_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
	Declare libusb_fill_iso_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, num_iso_packets.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
	Declare libusb_set_iso_packet_lengths(*transfer.libusb_transfer, length.l)
	Declare.i libusb_get_iso_packet_buffer(*transfer.libusb_transfer, packet.l) ; Return type is a pointer to Ascii
	Declare.i libusb_get_iso_packet_buffer_simple(*transfer.libusb_transfer, packet.l)
	Declare.l libusb_get_descriptor(*dev.libusb_device_handle, desc_type.a, desc_index.a, *data.Ascii, length.l)
	Declare.l libusb_get_string_descriptor(*dev.libusb_device_handle, desc_index.a, langid.u, *data.Unicode, length.l)
EndDeclareModule

Module LIBUSB1
	ImportC "-lusb-1.0" ;/lib/x86_64-linux-gnu/libusb-1.0.so.0
		CompilerIf #VERSION_MAJOR = 1 And #VERSION_MINOR = 0 And #VERSION_MICRO >= 9 And #VERSION_MICRO <= 11
		libusb_init.i(*p_ctx.libusb_context)
		libusb_exit(*ctx.libusb_context)
		libusb_set_debug(*ctx.libusb_context, level.l)
		libusb_get_version.i() ;Return type: *libusb_version
		libusb_has_capability.l(capability.l)
		libusb_error_name.i(errcode.l)
		
		libusb_get_device_list.i(*ctx.libusb_context, *pp_list.libusb_device) ;Return Type: Size or LIBUSB_ERROR
		libusb_free_device_list(*p_list.libusb_device, unref_devices.l)
		libusb_ref_device.i(*dev.libusb_device) ;Return type: *libusb_device
		libusb_unref_device(*dev.libusb_device)
		
		libusb_get_configuration.l(*dev.libusb_device_handle, *config.Long)
		libusb_get_device_descriptor.l(*dev.libusb_device, *desc.libusb_device_descriptor)
		libusb_get_active_config_descriptor.l(*dev.libusb_device, *p_config.libusb_config_descriptor)
		libusb_get_config_descriptor.l(*dev.libusb_device, config_index.a, *p_config.libusb_config_descriptor)
		libusb_get_config_descriptor_by_value.l(*dev.libusb_device, bConfigurationValue.a, *p_config.libusb_config_descriptor)
		libusb_free_config_descriptor(*config.libusb_config_descriptor)
		libusb_get_bus_number.a(*dev.libusb_device)
		libusb_get_device_address.a(*dev.libusb_device)
		libusb_get_device_speed.a(*dev.libusb_device)
		libusb_get_max_packet_size.l(*dev.libusb_device, endpoint.a)
		libusb_get_max_iso_packet_size.l(*dev.libusb_device, endpoint.a)
		
		libusb_open.l(*dev.libusb_device, *p_handle.libusb_device_handle) ;Return Type: LIBUSB_ERROR
		libusb_close(*dev_handle.libusb_device_handle)
		libusb_get_device.i(*dev_handle.libusb_device_handle) ;Return type: *libusb_device
		
		libusb_set_configuration.l(*dev.libusb_device_handle, configuration.l) ;?Return type: LIBUSB_ERROR
		libusb_claim_interface.l(*dev.libusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		libusb_release_interface.l(*dev.libusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		
		libusb_open_device_with_vid_pid.i(*ctx.libusb_context, vendor_id.u, product_id.u) ;Return type: *libusb_device_handle
		
		libusb_set_interface_alt_setting(*dev.libusb_device_handle, interface_number.l, alternate_setting.l) ;?Return type: LIBUSB_ERROR
		libusb_clear_halt.l(*dev.libusb_device_handle, endpoint.a) ;?Return type: LIBUSB_ERROR
		libusb_reset_device.l(*dev.libusb_device_handle) ;?Return type: LIBUSB_ERROR
		
		libusb_kernel_driver_active.l(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		libusb_detach_kernel_driver.l(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		libusb_attach_kernel_driver.l(*devlibusb_device_handle, interface_number.l) ;?Return type: LIBUSB_ERROR
		
		libusb_alloc_transfer.i(iso_packets) ;Return type: *libusb_transfer
		libusb_submit_transfer.l(*transfer.libusb_transfer) ;?Return type: LIBUSB_ERROR
		libusb_cancel_transfer.l(*transfer.libusb_transfer) ;?Return type: LIBUSB_ERROR
		libusb_free_transfer(*transfer.libusb_transfer)
		
		; sync I/O
		libusb_control_transfer.l  (*dev_handle.libusb_device_handle, request_type.a, bRequest.a, wValue.u, wIndex.u, *data.Ascii, wLength.u, timeout.l) ;Return Type: LIBUSB_ERROR
		libusb_bulk_transfer.l     (*dev_handle.libusb_device_handle, endpoint.a, *data.Ascii, length.l, *actual_length.Long, timeout.l) ;Return Type: LIBUSB_ERROR
		libusb_interrupt_transfer.l(*dev_handle.libusb_device_handle, endpoint.a, *data.Ascii, length.l, *actual_length.Long, timeout.l) ;Return Type: LIBUSB_ERROR
		libusb_get_string_descriptor_ascii.l(*dev_handle.libusb_device_handle, desc_index.a, *data.Ascii, length.l) ;Return Type: LIBUSB_ERROR
		
		; polling and timeouts
		libusb_try_lock_events.l(*ctx.libusb_context)
		libusb_lock_events.l(*ctx.libusb_context)
		libusb_unlock_events.l(*ctx.libusb_context)
		libusb_event_handling_ok.l(*ctx.libusb_context)
		libusb_event_handler_active.l(*ctx.libusb_context)
		libusb_lock_event_waiters.l(*ctx.libusb_context)
		libusb_unlock_event_waiters.l(*ctx.libusb_context)
		libusb_wait_for_event.l(*ctx.libusb_context, *tv.timeval)
		libusb_handle_events_timeout.l(*ctx.libusb_context, *tv.timeval)
		libusb_handle_events_timeout_completed.l(*ctx.libusb_context, *tv.timeval, *completed.Long)
		libusb_handle_events.l(*ctx.libusb_context)
		libusb_handle_events_completed.l(*ctx.libusb_context, *completed.Long)
		libusb_handle_events_locked.l(*ctx.libusb_context, *tv.timeval)
		libusb_pollfds_handle_timeouts.l(*ctx.libusb_context)
		libusb_get_next_timeout.l(*ctx.libusb_context, *tv.timeval)
		CompilerEndIf
	EndImport
	
		;{ ============ Some implemented procedures from the header file ============
	
	
	; async I/O
	
	; Get the data section of a control transfer. This convenience function is here
	; to remind you that the data does not start until 8 bytes into the actual
	; buffer, as the setup packet comes first.
	; 
	; Calling this function only makes sense from a transfer callback function,
	; or situations where you have already allocated a suitably sized buffer at
	; transfer->buffer.
	; 
	; \param transfer a transfer
	; \returns pointer to the first byte of the data section
	Procedure.i libusb_control_transfer_get_data(*transfer.libusb_transfer) ; Return type is a pointer to an Ascii.
		ProcedureReturn *transfer\buffer + #LIBUSB_CONTROL_SETUP_SIZE;
	EndProcedure
	
	; Get the control setup packet of a control transfer. This convenience
	; function is here to remind you that the control setup occupies the first
	; 8 bytes of the transfer data buffer.
	; 
	; Calling this function only makes sense from a transfer callback function,
	; or situations where you have already allocated a suitably sized buffer at
	; transfer->buffer.
	; 
	; \param transfer a transfer
	; \returns a casted pointer to the start of the transfer data buffer
	Procedure.i libusb_control_transfer_get_setup(*transfer.libusb_transfer) ; Return type is a pointer to libusb_control_setup.
		ProcedureReturn *transfer\buffer
	EndProcedure
	
	; Helper function to populate the setup packet (first 8 bytes of the data
	; buffer) for a control transfer. The wIndex, wValue and wLength values should
	; be given in host-endian byte order.
	; 
	; \param buffer buffer to output the setup packet into
	; \param bmRequestType see the
	; \ref libusb_control_setup::bmRequestType "bmRequestType" field of
	; \ref libusb_control_setup
	; \param bRequest see the
	; \ref libusb_control_setup::bRequest "bRequest" field of
	; \ref libusb_control_setup
	; \param wValue see the
	; \ref libusb_control_setup::wValue "wValue" field of
	; \ref libusb_control_setup
	; \param wIndex see the
	; \ref libusb_control_setup::wIndex "wIndex" field of
	; \ref libusb_control_setup
	; \param wLength see the
	; \ref libusb_control_setup::wLength "wLength" field of
	; \ref libusb_control_setup
	Procedure.i libusb_fill_control_setup(*buffer.Ascii, bmRequestType.a, bRequest.a, wValue.u, wIndex.u, wLength.u)
		Protected *setup.libusb_control_setup = *buffer
		
		With *setup
			\bRequestType	=	bmRequestType
			\bRequest		=	bRequest
			\wValue			=	wValue		;PureBasic runs only on little endian systems
			\wIndex			=	wIndex
			\wLength		=	wLength
		EndWith
	EndProcedure
	
	; Helper function to populate the required \ref libusb_transfer fields
	; for a control transfer.
	; 
	; If you pass a transfer buffer to this function, the first 8 bytes will
	; be interpreted as a control setup packet, and the wLength field will be
	; used to automatically populate the \ref libusb_transfer::length "length"
	; field of the transfer. Therefore the recommended approach is:
	; -# Allocate a suitably sized data buffer (including space for control setup)
	; -# Call libusb_fill_control_setup()
	; -# If this is a host-to-device transfer with a data stage, put the data
	;    in place after the setup packet
	; -# Call this function
	; -# Call libusb_submit_transfer()
	;
	; It is also legal to pass a NULL buffer to this function, in which case this
	; function will not attempt to populate the length field. Remember that you
	; must then populate the buffer and length fields later.
	; 
	; \param transfer the transfer to populate
	; \param dev_handle handle of the device that will handle the transfer
	; \param buffer data buffer. If provided, this function will interpret the
	; first 8 bytes as a setup packet and infer the transfer length from that.
	; \param callback callback function to be invoked on transfer completion
	; \param user_data user data to pass to callback function
	; \param timeout timeout for the transfer in milliseconds
	Procedure.i libusb_fill_control_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, *buffer.Ascii, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
		Protected *setup.libusb_control_setup = *buffer
		
		With *transfer
			\dev_handle		=	*dev_handle
			\endpoint		=	0
			\type			=	#LIBUSB_TRANSFER_TYPE_CONTROL
			\timeout		=	timeout
			\buffer			=	*buffer
			If (*setup)
				\length = #LIBUSB_CONTROL_SETUP_SIZE + *setup\wLength
			EndIf
			\user_data		=	*user_data
			\callback		=	*callback
		EndWith
	EndProcedure
	
	; Helper function to populate the required \ref libusb_transfer fields
	; for a bulk transfer.
	;
	; \param transfer the transfer to populate
	; \param dev_handle handle of the device that will handle the transfer
	; \param endpoint address of the endpoint where this transfer will be sent
	; \param buffer data buffer
	; \param length length of data buffer
	; \param callback callback function to be invoked on transfer completion
	; \param user_data user data to pass to callback function
	; \param timeout timeout for the transfer in milliseconds
	Procedure libusb_fill_bulk_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
		With *transfer
			\dev_handle		=	*dev_handle
			\endpoint		=	endpoint
			\type			=	#LIBUSB_TRANSFER_TYPE_BULK
			\timeout		=	timeout
			\buffer			=	*buffer
			\length			=	length
			\user_data		=	*user_data
			\callback		=	*callback
		EndWith
	EndProcedure
	
	
	; Helper function to populate the required \ref libusb_transfer fields
	; for an interrupt transfer.
	; 
	; \param transfer the transfer to populate
	; \param dev_handle handle of the device that will handle the transfer
	; \param endpoint address of the endpoint where this transfer will be sent
	; \param buffer data buffer
	; \param length length of data buffer
	; \param callback callback function to be invoked on transfer completion
	; \param user_data user data to pass to callback function
	; \param timeout timeout for the transfer in milliseconds
	Procedure libusb_fill_interrupt_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
		With *transfer
			\dev_handle		=	*dev_handle
			\endpoint		=	endpoint
			\type			=	#LIBUSB_TRANSFER_TYPE_INTERRUPT
			\timeout		=	timeout
			\buffer			=	*buffer
			\length			=	length
			\user_data		=	*user_data
			\callback		=	*callback
		EndWith
	EndProcedure
	
	; Helper function to populate the required \ref libusb_transfer fields
	; for an isochronous transfer.
	; 
	; \param transfer the transfer to populate
	; \param dev_handle handle of the device that will handle the transfer
	; \param endpoint address of the endpoint where this transfer will be sent
	; \param buffer data buffer
	; \param length length of data buffer
	; \param num_iso_packets the number of isochronous packets
	; \param callback callback function to be invoked on transfer completion
	; \param user_data user data to pass to callback function
	; \param timeout timeout for the transfer in milliseconds
	Procedure libusb_fill_iso_transfer(*transfer.libusb_transfer, *dev_handle.libusb_device_handle, endpoint.a, *buffer.Ascii, length.l, num_iso_packets.l, *callback.libusb_transfer_cb_fn, *user_data, timeout.l)
		With *transfer
			\dev_handle			=	*dev_handle
			\endpoint			=	endpoint
			\type				=	#LIBUSB_TRANSFER_TYPE_ISOCHRONOUS
			\timeout			=	timeout
			\buffer				=	*buffer
			\length				=	length
			\num_iso_packets	=	num_iso_packets
			\user_data			=	*user_data
			\callback			=	*callback
		EndWith
	EndProcedure
	
	; Convenience function to set the length of all packets in an isochronous
	; transfer, based on the num_iso_packets field in the transfer structure.
	; 
	; \param transfer a transfer
	; \param length the length to set in each isochronous packet descriptor
	; \see libusb_get_max_packet_size()
	Procedure libusb_set_iso_packet_lengths(*transfer.libusb_transfer, length.l)
		Protected i.i = 0
		While i < *transfer\num_iso_packets
			*transfer\iso_packet_desc[i]\length = length
			i + 1
		Wend
	EndProcedure
	
	; Convenience function to locate the position of an isochronous packet
	; within the buffer of an isochronous transfer.
	; 
	; This is a thorough function which loops through all preceding packets,
	; accumulating their lengths to find the position of the specified packet.
	; Typically you will assign equal lengths to each packet in the transfer,
	; and hence the above method is sub-optimal. You may wish to use
	; libusb_get_iso_packet_buffer_simple() instead.
	; 
	; \param transfer a transfer
	; \param packet the packet to return the address of
	; \returns the base address of the packet buffer inside the transfer buffer,
	; or NULL if the packet does not exist.
	; \see libusb_get_iso_packet_buffer_simple()
	Procedure.i libusb_get_iso_packet_buffer(*transfer.libusb_transfer, packet.l) ; Return type is a pointer to Ascii
		Protected i.i = 0, offset.i = 0, _packet.i
		
		; oops..slight bug in the API. packet is an unsigned int, but we use
		; signed integers almost everywhere else. range-check and convert to
		; signed to avoid compiler warnings. FIXME for libusb-2.
		
		If (packet & $1000000)
			ProcedureReturn 0
		EndIf
		_packet = packet
		
		If (_packet >= *transfer\num_iso_packets)
			ProcedureReturn 0
		EndIf
		
		While i < _packet
			offset + *transfer\iso_packet_desc[i]\length
			i + 1
		Wend
		
		ProcedureReturn *transfer\buffer + offset
	EndProcedure
	
	
	; Convenience function to locate the position of an isochronous packet
	; within the buffer of an isochronous transfer, for transfers where each
	; packet is of identical size.
	; 
	; This function relies on the assumption that every packet within the transfer
	; is of identical size to the first packet. Calculating the location of
	; the packet buffer is then just a simple calculation:
	; <tt>buffer + (packet_size * packet)</tt>
	; 
	; Do not use this function on transfers other than those that have identical
	; packet lengths for each packet.
	; 
	; \param transfer a transfer
	; \param packet the packet to return the address of
	; \returns the base address of the packet buffer inside the transfer buffer,
	; or NULL if the packet does not exist.
	; \see libusb_get_iso_packet_buffer()
	Procedure.i libusb_get_iso_packet_buffer_simple(*transfer.libusb_transfer, packet.l)
		Protected _packet.l
		
		; oops..slight bug in the API. packet is an unsigned int, but we use
		; signed integers almost everywhere else. range-check and convert to
		; signed to avoid compiler warnings. FIXME for libusb-2.
		If (packet & $1000000)
			ProcedureReturn 0
		EndIf
		_packet = packet
		
		If (_packet >= *transfer\num_iso_packets)
			ProcedureReturn 0
		EndIf
		
		ProcedureReturn *transfer\buffer + (*transfer\iso_packet_desc[0]\length * _packet)
		
	EndProcedure
	
	; sync I/O
	
	; Retrieve a descriptor from the default control pipe.
	; This is a convenience function which formulates the appropriate control
	; message to retrieve the descriptor.
	; 
	; \param dev a device handle
	; \param desc_type the descriptor type, see \ref libusb_descriptor_type
	; \param desc_index the index of the descriptor to retrieve
	; \param data output buffer for descriptor
	; \param length size of data buffer
	; \returns number of bytes returned in data, or LIBUSB_ERROR code on failure
	Procedure.l libusb_get_descriptor(*dev.libusb_device_handle, desc_type.a, desc_index.a, *data.Ascii, length.l)
		ProcedureReturn libusb_control_transfer(*dev, #LIBUSB_ENDPOINT_IN, #LIBUSB_REQUEST_GET_DESCRIPTOR, (desc_type << 8) | desc_index, 0, *data, length, 1000)
	EndProcedure
	
	; Retrieve a descriptor from a device.
	; This is a convenience function which formulates the appropriate control
	; message to retrieve the descriptor. The string returned is Unicode, as
	; detailed in the USB specifications.
	; 
	; \param dev a device handle
	; \param desc_index the index of the descriptor to retrieve
	; \param langid the language ID for the string descriptor
	; \param data output buffer for descriptor
	; \param length size of data buffer
	; \returns number of bytes returned in data, or LIBUSB_ERROR code on failure
	; \see libusb_get_string_descriptor_ascii()
	Procedure.l libusb_get_string_descriptor(*dev.libusb_device_handle, desc_index.a, langid.u, *data.Unicode, length.l)
		ProcedureReturn libusb_control_transfer(*dev, #LIBUSB_ENDPOINT_IN, #LIBUSB_REQUEST_GET_DESCRIPTOR, #LIBUSB_DT_STRING << 8 | desc_index, langid, *data, length, 1000)
	EndProcedure
	;}
EndModule
; IDE Options = PureBasic 5.22 LTS (Linux - x64)
; EnableXP
