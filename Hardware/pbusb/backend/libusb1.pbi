
XIncludeFile #PB_Compiler_FilePath + "libusb1/import.pbi"

DeclareModule ILIBUSB1
	XIncludeFile #PB_Compiler_FilePath + "backend.pbi"

	Interface Libusb1 Extends IBackend
	EndInterface
	
	Declare.i new()

EndDeclareModule

Module ILIBUSB1
	UseModule LIBUSB1
	
	XIncludeFile #PB_Compiler_FilePath + "libusb1/time.pbi"
	
	Structure pbusb_device
		*device.libusb_device
		*cfg.libusb_config_descriptor
		*handle.libusb_device_handle
		count.i
	EndStructure

	Structure Libusb1_S
		*vTable
		*ctx
		List refDevices.pbusb_device()
		eventHandlingThread.i
		quitThread.i
	EndStructure
	
	Structure _libusb_device_descriptor Extends libusb_device_descriptor
		bus.i
		address.i
	EndStructure
	
	Procedure __eventHandlingThread(*this.Libusb1_S)
		Protected timeout.timeval
		timeout\tv_sec = 1
		timeout\tv_usec = 0
		While (Not *this\quitThread)
			libusb_handle_events_timeout_completed(*this\ctx, @timeout, 0)
		Wend
	EndProcedure
	
	Procedure new()
		Protected *this.Libusb1_S = AllocateMemory(SizeOf(Libusb1_S))
		If (Not *this)
			ProcedureReturn #False
		EndIf
		
		With *this
			\vTable = ?vTable
			If (libusb_init(@\ctx) < 0)
				FreeMemory(*this)
				ProcedureReturn #False
			EndIf
			\quitThread = #False
			\eventHandlingThread = CreateThread(@__eventHandlingThread(), *this)
		EndWith
		
		ProcedureReturn *this
	EndProcedure
	
	Procedure destroy(*this.Libusb1_S)
		With *this
			\quitThread = #True
			WaitThread(\eventHandlingThread)
			ForEach \refDevices()
				If (\refDevices()\cfg)
					libusb_free_config_descriptor(\refDevices()\cfg)
				EndIf
				While (\refDevices()\count)
					libusb_unref_device(\refDevices()\device)
				Wend
			Next
			ClearList(\refDevices())
			LIBUSB1::libusb_exit(*this\ctx)
		EndWith
		ClearStructure(*this, Libusb1_S)
		FreeMemory(*this)
	EndProcedure
	
	Procedure.i enumerate_devices(*this.Libusb1_S, List *devices.pbusb_device())
		Protected *p_list.Integer, listed.i
		
		With *this
			
			size = libusb_get_device_list(\ctx, @*p_list)
			
			If (size >= 0)
				ClearList(*devices())
				For i = 0 To size - 1
					listed = #False
					ForEach \refDevices()
						If (\refDevices()\device = *p_list)
							listed = #True
							Break
						EndIf
					Next
					If (Not listed)
						If (AddElement(\refDevices()))
							\refDevices()\device = libusb_ref_device(*p_list\i)
							\refDevices()\count + 1
						EndIf
					EndIf
					If AddElement(*devices())
						*devices() = @\refDevices()
					EndIf
					
					*p_list + SizeOf(Integer)
				Next
				
				ForEach \refDevices()
					listed = #False
					ForEach *devices()
						If (*devices() = @\refDevices())
							listed = #True
							Break
						EndIf
					Next
					If (Not listed)
						libusb_unref_device(\refDevices()\device)
						\refDevices()\count - 1
						If (\refDevices()\count = 0)
							DeleteElement(\refDevices())
						EndIf
					EndIf
				Next
				
				libusb_free_device_list(*p_list, 1)
			EndIf
			
			ProcedureReturn size
		EndWith
	EndProcedure
	
	Procedure.i get_device_descriptor(*this.Libusb1_S, *refDev.pbusb_device, *dev_desc._libusb_device_descriptor)
		Protected result.i
		result = libusb_get_device_descriptor(*refDev\device, *dev_desc)
		If result >= 0	
			*dev_desc\bus = libusb_get_bus_number(*refDev\device)
			*dev_desc\address = libusb_get_device_address(*refDev\device)
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure.i get_configuration_descriptor(*this.Libusb1_S, *refDev.pbusb_device, config.i, *desc.pbusb_config_descriptor = 0)
		Protected result.i
		
		If (Not *refDev\cfg)
			result = libusb_get_config_descriptor(*refDev\device, config, @*refDev\cfg)
		
			If (result < 0)
				*refDev\cfg = 0
				ProcedureReturn result
			EndIf
		EndIf
		
		If (*desc)
			With *desc
				\bLength             = *refDev\cfg\bLength
				\bDescriptorType     = *refDev\cfg\bDescriptorType
				\wTotalLength        = *refDev\cfg\wTotalLength
				\bNumInterfaces      = *refDev\cfg\bNumInterfaces
				\bConfigurationValue = *refDev\cfg\bConfigurationValue
				\iConfiguration      = *refDev\cfg\iConfiguration
				\bmAttributes        = *refDev\cfg\bmAttributes
				\MaxPower            = *refDev\cfg\MaxPower
			EndWith
			
			ProcedureReturn *desc
		EndIf
		
		ProcedureReturn *refDev\cfg
	EndProcedure
	
	Procedure.i get_interface_descriptor(*this.Libusb1_S, *refDev, intf.i, alt.i, config.i, *desc.pbusb_interface_descriptor = 0)
		Protected *cfg.libusb_config_descriptor = get_configuration_descriptor(*this, *refDev, config)
		Protected *interface.libusb_interface
		Protected *alt_setting.libusb_interface_descriptor
		
		If (*cfg < 0)
			ProcedureReturn *cfg
		EndIf
		
		If (intf < 0 Or intf >= *cfg\bNumInterfaces)
			ProcedureReturn #LIBUSB_ERROR_INVALID_PARAM
		EndIf
		*interface = *cfg\interface + SizeOf(libusb_interface) * intf
		
		If (alt < 0 Or alt >= *interface\num_altsetting)
			ProcedureReturn #LIBUSB_ERROR_INVALID_PARAM
		EndIf
		*alt_setting = *interface\altsetting + SizeOf(libusb_interface_descriptor) * alt
		
		If (*desc)
			With *desc
			  \bLength            = *alt_setting\bLength
			  \bDescriptorType    = *alt_setting\bDescriptorType
			  \bInterfaceNumber   = *alt_setting\bInterfaceNumber
			  \bAlternateSetting  = *alt_setting\bAlternateSetting
			  \bNumEndpoints      = *alt_setting\bNumEndpoints
			  \bInterfaceClass    = *alt_setting\bInterfaceClass
			  \bInterfaceSubClass = *alt_setting\bInterfaceSubClass
			  \bInterfaceProtocol = *alt_setting\bInterfaceProtocol
			  \iInterface         = *alt_setting\iInterface
			EndWith
			
			ProcedureReturn *desc
		EndIf
		
		ProcedureReturn *alt_setting
	EndProcedure
	
	Procedure.i get_endpoint_descriptor(*this.Libusb1_S, *refDev, ep.i, intf.i, alt.i, config.i, *desc.pbusb_endpoint_descriptor = 0)
		Protected *i.libusb_interface_descriptor = get_interface_descriptor(*this, *refDev, intf, alt, config)
		Protected *endpoint.libusb_endpoint_descriptor
		
		If (*i < 0)
			ProcedureReturn *i
		EndIf
		
		If (ep < 0 Or ep >= *i\bNumEndpoints)
			ProcedureReturn #LIBUSB_ERROR_INVALID_PARAM
		EndIf
		
		*endpoint = *i\endpoint + SizeOf(libusb_endpoint_descriptor) * ep
		
		If (*desc)
			With *desc
				\bLength          = *endpoint\bLength
				\bDescriptorType  = *endpoint\bDescriptorType
				\bEndpointAddress = *endpoint\bEndpointAddress
				\bmAttributes     = *endpoint\bmAttributes
				\wMaxPacketSize   = *endpoint\wMaxPacketSize
				\bInterval        = *endpoint\bInterval
				\bRefresh         = *endpoint\bRefresh
				\bSynchAddress    = *endpoint\bSynchAddress
			EndWith
			
			ProcedureReturn *desc
		EndIf
		
		ProcedureReturn *endpoint
	EndProcedure
	
	Procedure.i open_device(*this.Libusb1_S, *refDev.pbusb_device)
		Protected result.i
		Protected *handle.libusb_device_handle
		
		result = libusb_open(*refDev\device, @*handle)
		If (result < 0)
			ProcedureReturn result
		EndIf
		
		*refDev\handle = *handle
		
		ProcedureReturn *refDev
	EndProcedure
	
	Procedure.i close_device(*this.Libusb1_S, *refDev.pbusb_device)
		libusb_close(*refDev\handle)
		*refDev\handle = 0
	EndProcedure
	
	Procedure.i set_configuration(*this.Libusb1_S, *refDev.pbusb_device, config_value.i)
		ProcedureReturn libusb_set_configuration(*refDev\handle, config_value)
	EndProcedure
	
	Procedure.i get_configuration(*this.Libusb1_S, *refDev.pbusb_device)
		Protected config.l, result.i
		
		result = libusb_get_configuration(*refDev\handle, @config)
		If (result < 0)
			ProcedureReturn result
		EndIf
		
		ProcedureReturn config
	EndProcedure
	
	Procedure.i set_interface_altsetting(*this.Libusb1_S, *refDev.pbusb_device, intf.i, altsetting.i)
		ProcedureReturn libusb_set_interface_alt_setting(*refDev\handle, intf, altsetting)
	EndProcedure
	
	Procedure.i claim_interface(*this.Libusb1_S, *refDev.pbusb_device, intf.i)
		ProcedureReturn libusb_claim_interface(*refDev\handle, intf)
	EndProcedure
	
	Procedure.i release_interface(*this.Libusb1_S, *refDev.pbusb_device, intf.i)
		ProcedureReturn libusb_release_interface(*refDev\handle, intf)
	EndProcedure
	
	Prototype.l _transfer(*dev_handle.libusb_device_handle, endpoint.a, *data.Ascii, length.l, *actual_length.Long, timeout.l)
	
	Procedure.i __uni_transfer(*fn._transfer, *dev_handle.libusb_device_handle, ep.i, intf.i, *data, size.i, timeout.i)
		Protected transferred.l, result.i
		
		result = *fn(*dev_handle, ep, *data, size, @transferred, timeout)
		If Not (transferred And result = #LIBUSB_ERROR_TIMEOUT)
			If (result < 0)
				ProcedureReturn result
			EndIf
		EndIf
		
		ProcedureReturn transferred
	EndProcedure
	
	Procedure.i bulk_write(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		ProcedureReturn __uni_transfer(@libusb_bulk_transfer(), *refDev\handle, ep, intf, *data, size, timeout)
	EndProcedure
	
	Procedure.i bulk_read(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		ProcedureReturn __uni_transfer(@libusb_bulk_transfer(), *refDev\handle, ep, intf, *data, size, timeout)
	EndProcedure

	Procedure.i intr_write(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		ProcedureReturn __uni_transfer(@libusb_interrupt_transfer(), *refDev\handle, ep, intf, *data, size, timeout)
	EndProcedure
	
	Procedure.i intr_read(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		ProcedureReturn __uni_transfer(@libusb_interrupt_transfer(), *refDev\handle, ep, intf, *data, size, timeout)
	EndProcedure
	
	Structure __iso_transfer_S
		semasphore.i
		done.i
		status.i
	EndStructure
	
	Procedure __iso_transfer_cb(*transfer.libusb_transfer)
		Protected *cb_data.__iso_transfer_S = *transfer\user_data
		If (*transfer\status = #LIBUSB_TRANSFER_COMPLETED)
			*cb_data\done = #True
			SignalSemaphore(*cb_data\semasphore)
		Else
			*cb_data\status = *transfer\status
		EndIf
	EndProcedure
	
	Procedure.i iso_write(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		Protected result.i
		Protected packet_length.i = libusb_get_max_iso_packet_size(*refDev\device, ep)
		Protected packet_count.i = size / packet_length + Bool(size % packet_length)
		Protected cb_data.__iso_transfer_S
		cb_data\semasphore = CreateSemaphore()
		cb_data\done = #False
		
		Protected *transfer.libusb_transfer = libusb_alloc_transfer(packet_count)
		libusb_fill_iso_transfer(*transfer,
										 *refDev\handle,
										 ep,
										 *data,
										 size,
										 packet_count,
										 @__iso_transfer_cb(),
										 @cb_data,
										 timeout)
		
		libusb_set_iso_packet_lengths(*transfer, packet_length)
		Protected r.i = size % packet_length
		If (r)
			*transfer\iso_packet_desc[*transfer\num_iso_packets - 1]\length = r
		EndIf
		
		;Submit
		result = libusb_submit_transfer(*transfer)
		If (result < 0)
			FreeSemaphore(cb_data\semasphore)
			libusb_free_transfer(*transfer)
			ProcedureReturn result
		EndIf
		
		WaitSemaphore(cb_data\semasphore)
		Protected i.i, sum.i
		For i = 0 To *transfer\num_iso_packets
			sum + *transfer\iso_packet_desc[i]\actual_length
		Next
		
		FreeSemaphore(cb_data\semasphore)
		libusb_free_transfer(*transfer)
		
		ProcedureReturn sum
	EndProcedure
	
	Procedure.i iso_read(*this.Libusb1, *refDev.pbusb_device, ep.i, intf.i, *data, size.i, timeout.i)
		ProcedureReturn iso_write(*this, *refDev, ep, intf, *data, size, timeout)
	EndProcedure
	
	Procedure.i ctrl_transfer(*this.Libusb1, *refDev.pbusb_device, bmRequestType.i, bRequest.i, wValue.i, wIndex.i, *data, length.i, timeout.i)
		ProcedureReturn libusb_control_transfer(*refDev\handle, bmRequestType, bRequest, wValue, wIndex, *data, length, timeout)
	EndProcedure
	
	Procedure.i reset_device(*this.Libusb1, *refDev.pbusb_device)
		ProcedureReturn libusb_reset_device(*refDev\handle)
	EndProcedure
	
	Procedure.i is_kernel_driver_active(*refDev.pbusb_device, intf.i)
		ProcedureReturn libusb_kernel_driver_active(*refDev\handle, intf)
	EndProcedure
	Procedure.i detach_kernel_driver(*refDev.pbusb_device, intf.i)
		ProcedureReturn libusb_detach_kernel_driver(*refDev\handle, intf)
	EndProcedure
	Procedure.i attach_kernel_driver(*refDev.pbusb_device, intf.i)
		ProcedureReturn libusb_attach_kernel_driver(*refDev\handle, intf)
	EndProcedure
	
	DataSection
		vTable:
			Data.i @destroy(), @enumerate_devices(), @get_device_descriptor()
			Data.i @get_configuration_descriptor(), @get_interface_descriptor()
			Data.i @get_endpoint_descriptor(), @open_device()
			Data.i @set_configuration(), @get_configuration()
			Data.i @set_interface_altsetting(), @claim_interface(), @release_interface()
			Data.i @bulk_write(), @bulk_read(), @intr_write(), @intr_read()
			Data.i @iso_write(), @iso_read(), @ctrl_transfer()
			Data.i @reset_device(), @is_kernel_driver_active()
			Data.i @detach_kernel_driver(), @attach_kernel_driver()
	EndDataSection
EndModule
; IDE Options = PureBasic 5.31 (Linux - x64)
; EnableXP
