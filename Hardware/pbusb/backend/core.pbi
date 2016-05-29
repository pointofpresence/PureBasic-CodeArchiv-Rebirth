DeclareModule PBUSB_CORE
	
	#PBUSB_SUCCESS             =  0  ;= #LIBUSB_SUCCESS
	#PBUSB_ERROR_INVALID_PARAM = -2	;= #LIBUSB_ERROR_INVALID_PARAM
	
	Interface Endpoint
		destroy.i()
		writeB.i(*data, size.i, timeout.i = -1)
		readB.i(*data, size.i, timeout.i = -1)
	EndInterface
	
	Prototype.i enumerate_cb(*object)
	
	Interface USBInterface
		destroy.i()
		set_altsetting.i()
		;Calls callback with all available endpoints and destroys them after return
		;To use an enumerated Endpoint, clone() or copy() it.
		enumerate.i(*cb.enumerate_cb)
		
		;Returns an newly created Endpoint object which you have to destroy() after using.
		get.i(index.i)
	EndInterface
	
	Interface Configuration
		destroy.i()
		set.i()
		enumerate.i(*cb.enumerate_cb)
		get.i(index.i, altsetting.i)
	EndInterface
	
	Interface Device
		destroy.i()
		serial_number.s()
		product.s()
		manufacturer.s()
		set_configuration.i(configuration.i = -1)
		get_active_configuration.i()
		set_interface_altsetting(intf.i = -1, alt.i = -1)
		reset.i()
		writeB.i(endpoint.i, *data, size.i, intf.i = -1, timeout.i = -1)
		readB.i(endpoint.i, *data, size.i, intf.i = -1, timeout.i = -1)
		ctrl_transfer.i(bmRequestType.i, bRequest.i, wValue.i = 0, wIndex.i = 0,
		                *data = 0, size.i = 0, timeout.i = -1)
		is_kernel_driver_active(intf.i)
		detach_kernel_driver(intf.i)
		attach_kernel_driver.i(intf.i)
		enumerate.i(*cb.enumerate_cb)
		get.i(index.i)
	EndInterface
EndDeclareModule

Module PBUSB_CORE
	XIncludeFile #PB_Compiler_FilePath + "/backend.pbi"
	
	Interface _ResourceManager
		destroy.i()
		managed_open.i()
		managed_close.i()
		
		; config:         Description
		; -1              Use first configuration returned from Device\get(0).
		;  0              Set bConfigurationValue = 0.
		; Configuration   Use this Configuration object.
		; 0 <= x < 256    Use util.find_descriptor for bConfigurationValue=config.
		managed_set_configuration.i(*device.Device, config.i = -1)
		
		; intf:           Description
		; -1              Use the interface from active configuration of the given device.
		; USBInterface    Use the interface given by this USBInterface object.
		; 0 <= x < 256    Use the given interface number as bInterfaceNumber.
		managed_claim_interface.i(*device.Device, intf.i = -1)
		
		; intf:           Description
		; -1              Use the interface from active configuration of the given device.
		; USBInterface    Use the interface given by this USBInterface object.
		; 0 <= x < 256    Use the given interface number as bInterfaceNumber.
		managed_release_interface.i(*device.Device, intf.i = -1)
		
		; intf:           alt:            Description
		; USBInterface    -1              Use bInterfaceNumber and bAlternateSetting from intf
		; USBInterface    0-255           Use bInterfaceNumber from intf and bAlternateSetting = alt
		; USBInterface    >255            #PBUSB_ERROR_INVALID_PARAM
		; -1              -1              Use bInterfaceNumber and bAlternateSetting from active configuration
		; -1              0-255           Use bInterfaceNumber from active configuration and bAlternateSetting = alt
		; -1              >255            #PBUSB_ERROR_INVALID_PARAM
		; 0-255           -1              Uses util.find_descriptor with bInterfaceNumber = intf and first found alternate setting
		; 0-255           0-255           Uses util.find_descriptor with bInterfaceNumber = intf and bAlternateSetting = alt
		; 0-255           >255            #PBUSB_ERROR_INVALID_PARAM
		; >255            -               #PBUSB_ERROR_INVALID_PARAM
		managed_set_interface.i(*device.Device, intf.i = -1, alt.i = -1)
		
		get_interface.i(*device.Device, intf.i = -1)
		get_active_configuration.i(*device.Device)
		get_endpoint_type.i(*device.Device, address.i, intf.i)
		release_all_interfaces.i(*device.Device)
		dispose.i(*device.Device, close_handle = #True)
	EndInterface
	
	Structure Endpoint_S
		*vTable
		StructureUnion
			*device.Device
			*device_s.Device_S
		EndStructureUnion
		intf.i
		index.i
		desc.pbusb_endpoint_descriptor
	EndStructure
	
	Structure USBInterface_S
		*vTable
		StructureUnion
			*device.Device
			*device_s.Device_S
		EndStructureUnion
		alt_index.i
		index.i
		configuration.i
		desc.pbusb_interface_descriptor
	EndStructure
	Declare.i USBI_new(*device.Device, intf.i, altsetting.i, config.i)
	
	Structure Configuration_S
		*vTable
		StructureUnion
			*device.Device
			*device_s.Device_S
		EndStructureUnion
		index.i
		desc.pbusb_config_descriptor
	EndStructure
	
	Structure _ResourceManager_S
		*vTable
		*backend.IBackend
		_active_cfg_index.i
		*refDev
		*handle						;   <- if the devices was opened *handle = *refDev
		_claimed_intf.i[256]
		_alt_set.i[256]
		Map _ep_type_map.i()
		_ep_type_lock.i
	EndStructure
	
	Structure Device_S
		*vTable
		
	EndStructure
	
	;{ Class Endpoint

	Procedure.i EP_new(*device.Device, endpoint.i, intf.i, altsetting.i, config.i)
		Protected *this.Endpoint_S = AllocateMemory(SizeOf(Endpoint_S))
		Protected *intf_s.USBInterface_S, *intf.USBInterface
		Protected *backend.IBackend
		Protected error.i
		
		If (Not *this)
			ProcedureReturn #False
		EndIf
		With *this
			\vTable = ?Endpoint_vTable
			\device = device
			*intf_s = USBI_new(*device, intf, altsetting, config)
			If (*intf_s < 0)
				error = *intf_s
				FreeMemory(*this)
				ProcedureReturn error
			EndIf
			\intf = *intf_s\desc\bInterfaceNumber
			*intf = *intf_s
			*intf\destroy()
			\index = endpoint
			*backend = \device_s\_ctx\backend
			error = *backend\get_endpoint_descriptor(\device_s\_ctx\refDev, endpoint, intf, altsetting, config, @\desc)
			If (error <> @\desc)
				FreeMemory(*this)
				ProcedureReturn error
			EndIf
		EndWith
		
		ProcedureReturn *this
	EndProcedure
	
	Procedure EP_destroy(*this.Endpoint_S)
		FreeMemory(*this)
	EndProcedure
	
	Procedure.i EP_writeB(*this.Endpoint_S, *Data, size.i, timeout.i = -1)
		With *this
			ProcedureReturn \device\writeB(\desc\bEndpointAddress, *data, size, \intf, timeout)
		EndWith
	EndProcedure
	
	Procedure.i EP_readB(*this.Endpoint_S, *Data, size.i, timeout.i = -1)
		With *this
			ProcedureReturn \device\readB(\desc\bEndpointAddress, *data, size, \intf, timeout)
		EndWith
	EndProcedure
	
	DataSection
		Endpoint_vTable:
			Data.i @EP_destroy(),
			       @EP_writeB(),
			       @EP_readB()
	EndDataSection
	
	;}
	
	;{ Class USBInterface
	
	Procedure.i USBI_new(*device.Device, intf.i, altsetting.i, config.i)
		Protected *this.USBInterface_S = AllocateMemory(SizeOf(USBInterface_S))
		Protected *backend.IBackend, *desc.libusb_interface_descriptor
		Protected error.i
		
		If (Not *this)
			ProcedureReturn #False
		EndIf
		With *this
			\vTable = ?USBInterface_vTable
			\device = *device
			\alt_index = altsetting
			\index = intf
			\configuration = config
			
			*backend = \device_s\_ctx\backend
			error = *backend\get_interface_descriptor(\device_s\_ctx\refDev, intf, altsetting, config, @\desc)
			If (error <> @\desc)
				FreeMemory(*this)
				ProcedureReturn error
			EndIf
		EndWith
		
		ProcedureReturn *this
	EndProcedure
	
	Procedure USBI_destroy(*this.USBInterface_S)
		FreeMemory(*this)
	EndProcedure
	
	Procedure USBI_set_altsetting(*this.USBInterface_S)
		With *this
			\device\set_interface_altsetting(\desc\bInterfaceNumber, \desc\bAlternateSetting)
		EndWith
	EndProcedure
	
	Procedure USBI_enumerate(*this.USBInterface_S, *cb.enumerate_cb)
		Protected i.i, *endpoint.Endpoint
		With *this
			For i = 0 To \desc\bNumEndpoints - 1
				*endpoint = EP_new(\device, i, \index, \alt_index, \configuration)
				If (*endpoint < 0)
					Break
				EndIf
				*cb(*endpoint)
				*endpoint\destroy()
			Next
		EndWith
	EndProcedure
	
	Procedure USBI_get(*this.USBInterface_S, index.i)
		With *this
			ProcedureReturn EP_new(\device, index, \index, \alt_index, \configuration)
		EndWith
	EndProcedure
	
	DataSection
		USBInterface_vTable:
			Data.i @USBI_destroy(),
			       @USBI_set_altsetting(),
			       @USBI_enumerate(),
			       @USBI_get()
	EndDataSection
	;}
	
	;{ Class Configuration
	
	Procedure.i CFG_new(*device.Device, configuration.i = 0)
		Protected *this.Configuration_S = AllocateMemory(SizeOf(Configuration_S))
		Protected *backend.IBackend, error.i
		
		If (Not *this)
			ProcedureReturn #False
		EndIf
		
		With *this
			\vTable = ?Configuration_vTable
			\device = *device
			\index = configuration
			*backend = \device_s\_ctx\backend
			error = *backend\get_configuration_descriptor(\device_s\_ctx\refDev, configuration, @\desc)
			If (error <> @\desc)
				FreeMemory(*this)
				ProcedureReturn error
			EndIf
		EndWith
		
		ProcedureReturn *this
	EndProcedure
	
	Procedure.i CFG_destroy(*this.Configuration_S)
		FreeMemory(*this)
	EndProcedure
	
	Procedure.i CFG_set(*this.Configuration_S)
		With *this
			ProcedureReturn \device\set_configuration(\desc\bConfigurationValue)
		EndWith
	EndProcedure
	
	Procedure.i CFG_enumerate(*this.Configuration_S, *cb.enumerate_cb)
		Protected i.i, *intf.USBInterface, alt.i
		With *this
			For i = 0 To \desc\bNumInterfaces - 1
				alt = 0
				Repeat
					*intf = USBI_new(\device, i, alt, \index)
					If (*intf < 0)
						Break
					EndIf
					*cb(*intf)
					*intf\destroy()
					alt + 1
				ForEver
			Next
		EndWith
	EndProcedure
	
	Procedure.i CFG_get(*this.Configuration_S, index.i, altsetting.i)
		With *this
			ProcedureReturn USBI_new(\device, index, altsetting, \index)
		EndWith
	EndProcedure
	
	DataSection
		Configuration_vTable:
			Data.i @CFG_destroy(),
			       @CFG_set(),
			       @CFG_enumerate(),
			       @CFG_get()
	EndDataSection
	
	;}
	
	;{ Class _ResourceManager
	
	Procedure __RM_reset_ep_map(*this._ResourceManager_S)
		LockMutex(*this\_ep_type_lock)
		ClearMap(*this\_ep_type_map())
		UnlockMutex(*this\_ep_type_lock)
	EndProcedure
	Procedure __RM_get_ep_map(*this._ResourceManager_S, address.i, bInterfaceNumber.i, bAlternateSetting.i)
		Protected key.s = Str(address) + ":" + Str(bInterfaceNumber) + ":" + Str(bAlternateSetting)
		Protected etype.i = -1
		LockMutex(*this\_ep_type_lock)
		If (FindMapElement(*this\_ep_type_map(), key)
			etype = *this\_ep_type_map()
		EndIf
		UnlockMutex(*this\_ep_type_lock)
		ProcedureReturn etype
	EndProcedure
	Procedure __RM_set_ep_map(*this._ResourceManager_S, address.i, bInterfaceNumber.i, bAlternateSetting.i, etype.i)
		Protected key.s = Str(address) + ":" + Str(bInterfaceNumber) + ":" + Str(bAlternateSetting)
		Protected etype.i = -1
		LockMutex(*this\_ep_type_lock)
		*this\_ep_type_map(key) = etype
		UnlockMutex(*this\_ep_type_lock)
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	Procedure __RM_reset_claimed_intf(*this._ResourceManager_S)
		Protected i.i
		For i = 0 To 255
			*this\_claimed_intf[i] = #False
		Next
	EndProcedure
	Procedure __RM_reset_alt_set(*this._ResourceManager_S)
		Protected i.i
		For i = 0 To 255
			*this\_alt_set[i] = -1
		Next
	EndProcedure
	
	Procedure.i RM_new(*refDev, *backend.IBackend)
		Protected *this._ResourceManager_S = AllocateMemory(SizeOf(_ResourceManager_S))
		If (Not *this)
			ProcedureReturn 0
		EndIf
		
		InitializeStructure(*this, _ResourceManager_S)
		
		With *this
			\vTable = ?_ResourceManager_vTable
			\backend = *backend
			\_active_cfg_index = -1
			\refDev = *refDev
			\handle = 0
			__RM_reset_claimed_intf(*this)
			__RM_reset_ep_map(*this)
			__RM_reset_alt_set(*this)
		EndWith
		
		ProcedureReturn *this
	EndProcedure
	
	Procedure.i RM_destroy(*this._ResourceManager_S)
		FreeMutex(*this\_ep_type_lock)
		ClearStructure(*this, _ResourceManager_S)
		FreeMemory(*this)
	EndProcedure
	
	Procedure.i RM_managed_open(*this._ResourceManager_S)
		Protected result.i
		With *this
			If (Not \handle)
				result = \backend\open_device(\refDev)
				If (result < 0)
					ProcedureReturn result
				EndIf
				\handle = result
			EndIf
			
			ProcedureReturn \refDev
		EndWith
	EndProcedure
	
	Procedure.i RM_managed_close(*this._ResourceManager_S)
		With *this
			If (\handle)
				\backend\close_device(\refDev)
				\handle = 0
			EndIf
		EndWith
	EndProcedure
	
	Procedure.i RM_managed_set_configuration(*this._ResourceManager_S, *device.Device, config.i = -1)
		Protected *cfg.Configuration_S = config, *cfgI.Configuration
		Protected *thisI._ResourceManager
		Protected error.i, bConfigurationValue.i = 0, index.i = -1
		
		If (config = -1)		;None
			*cfg = *device\get(0)
			If (*cfg < 0)
				ProcedureReturn *cfg
			EndIf
			*cfgI = *cfg
			bConfigurationValue = *cfg\desc\bConfigurationValue
			index = *cfg\index
			*cfgI\destroy()
			
		ElseIf (*cfg = 0)
			;FakeConfiguration
			bConfigurationValue = 0
			index = -1
		
		ElseIf (config >= 0 And config < 256)
			;TODO: use util.find_descriptor()
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		
		ElseIf (*cfg\vTable = Configuration_vTable)
			bConfigurationValue = *cfg\desc\bConfigurationValue
			index = *cfg\index
			
		Else
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		EndIf
		
		error = *thisI\managed_open()
		If (error < 0) : ProcedureReturn error : EndIf
		error = *this\backend\set_configuration(*this\refDev, bConfigurationValue)
		If (error < 0)
			*thisI\managed_close()
			ProcedureReturn error
		EndIf
		*this\_active_cfg_index = index
		__RM_reset_ep_map(*this)
		ClearList(*this\_alt_set())
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	Procedure.i __RM_get_bInterfaceNumber(*thisI._ResourceManager, *device.Device, intf.i = -1)
		Protected error.i, *cfg.Configuration
		Protected *intf.USBInterface_S = intf, *intfI.USBInterface
		Protected i.i
		
		If (intf = -1)		;None
			*cfg = *thisI\get_active_configuration(*device)
			If (*cfg < 0)
				ProcedureReturn *cfg
			EndIf
			*intf = *cfg\get(0, 0)
			If (*intf < 0)
				*cfg\destroy()
				ProcedureReturn *intf
			EndIf
			i = *intf\desc\bInterfaceNumber
			*intfI = *intf
			*intfI\destroy()
			*cfg\destroy()
		ElseIf (intf >= 0 And intf < 256)
			i = intf
		ElseIf (*intf\vTable = ?USBInterface_vTable)
			i = *intf\desc\bInterfaceNumber
		Else
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		EndIf
		
		If (i < 0 Or i >= 256)
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		EndIf
		
		ProcedureReturn i
	EndProcedure
	
	Procedure.i RM_claim_interface(*thisI._ResourceManager, *device.Device, intf.i = -1)
		Protected *this._ResourceManager_S = *thisI
		Protected i.i
		
		error = *thisI\managed_open()
		If (error < 0)
			ProcedureReturn error
		EndIf
		
		i = __RM_get_bInterfaceNumber(*thisI, *device, intf)
		If (i < 0)
			ProcedureReturn i
		EndIf
		
		If (Not *this\_claimed_intf[i])
			*this\backend\claim_interface(*this\refDev, i)
			*this\_claimed_intf[i] = #True
		EndIf
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	Procedure.i RM_managed_release_interface(*thisI._ResourceManager, *device.Device, intf.i = -1)
		Protected error.i, *this._ResourceManager_S = *thisI
		Protected i.i
		
		i = __RM_get_bInterfaceNumber(*thisI, *device, intf)
		If (i < 0)
			ProcedureReturn i
		EndIf
		
		If (*this\_claimed_intf[i])
			*this\backend\release_interface(*this\refDev, i)
			*this\_claimed_intf[i] = #False
		EndIf
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	Procedure.i RM_set_interface(*thisI._ResourceManager, *device.Device, intf.i = -1, alt.i = -1)
		Protected *intf.USBInterface_S = intf, *intfI.USBInterface
		Protected *cfg.Configuration
		Protected bInterfaceNumber.i, bAlternateSetting.i
		Protected *this._ResourceManager_S
		Protected error.i
		
		If (intf >= -1 And intf < 256)		;None
			*cfg = *thisI\get_active_configuration(*device)
			If (*cfg < 0)
				ProcedureReturn *cfg
			EndIf
			If (intf = -1)
				*intf = *cfg\get(0, 0)
				If (*intf < 0)
					*cfg\destroy()
					ProcedureReturn *intf
				EndIf
				bInterfaceNumber = *intf\desc\bInterfaceNumber
				*intfI = *intf
				*intfI\destroy()
				*cfg\destroy()
			Else
				bInterfaceNumber = intf
			EndIf
			
			If (alt < -1 Or alt >= 256)
				ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
			ElseIf (alt = -1)
				;TODO Use util.find_descriptor
				ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
			Else
				bAlternateSetting = alt
			EndIf
			
		ElseIf (*intf\vTable = ?USBInterface_vTable)
			bInterfaceNumber = *intf\desc\bInterfaceNumber
			If (alt = -1)
				bAlternateSetting = *intf\desc\bAlternateSetting
			ElseIf (alt < 0 Or alt >= 256)
				ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
			Else
				bAlternateSetting = alt
			EndIf
		Else
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		EndIf
		
		error = *thisI\managed_claim_interface(*device, bInterfaceNumber)
		If (error < 0)
			ProcedureReturn error
		EndIf
		error = *this\backend\set_interface_altsetting(*this\refDev, bInterfaceNumber, bAlternateSetting)
		If (error < 0)
			ProcedureReturn error
		EndIf
		*this\_alt_set[bInterfaceNumber] = bAlternateSetting
		
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	Procedure.i RM_get_interface(*thisI._ResourceManager, *device.Device, intf.i = -1)
		Protected *intf.USBInterface_S = intf, *intfI.USBInterface
		Protected *cfg.Configuration_S, *cfgI.Configuration
		Protected *this._ResourceManager_S
		
		If (intf = -1)  ;None
			*cfgI = *thisI\get_active_configuration(*device)
			If (*cfgI < 0)
				ProcedureReturn *cfgI
			EndIf
			*intf = *cfgI\get(0, 0)
			If (*intf < 0)
				ProcedureReturn *intf
			EndIf
			intf = *intf\desc\bInterfaceNumber
			*intfI = *intf
			*intfI\destroy()
			*cfgI\destroy()
			
		ElseIf (intf >= 0 And intf < 256)
			;do nothing
		ElseIf (*intf\vTable = ?USBInterface_vTable)
			ProcedureReturn *intf
		Else
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
		EndIf
		
		*this = *thisI
		If (*this\_alt_set[intf])
			;TODO ProcedureReturn util.find_descriptor(cfg, bInterfaceNumber=intf, bAlternateSetting=self._alt_set[intf])
		EndIf
		;TODO ProcedureReturn util.find_descriptor(cfg, bInterfaceNumber=intf)
		
		ProcedureReturn #PBUSB_ERROR_INVALID_PARAM
	EndProcedure
	
	Procedure.i RM_get_active_configuration(*this._ResourceManager_S, *device.Device)
		Protected *thisI._ResourceManager = *this
		Protected error.i
		Protected *cfg.Configuration_S
		
		If (*this\_active_cfg_index = -1) ;None
			error = *thisI\managed_open()
			If (error < 0)
				ProcedureReturn error
			EndIf
			;TODO *cfg = util.find_descriptor(*device, bConfigurationValue=*this\backend\get_configuration(*this\refDev))
			If (*cfg < 0)
				ProcedureReturn *cfg
			EndIf
			*this\_active_cfg_index = *cfg\index
			
			ProcedureReturn #PBUSB_ERROR_INVALID_PARAM ;FIXME entfernen, wenn TODO gelöst
			ProcedureReturn *cfg
		EndIf
		
		ProcedureReturn *device\get(*this\_active_cfg_index)
	EndProcedure
	
	Procedure.i RM_get_endpoint_type(*thisI._ResourceManager, *device.Device, address.i, intf.)
		Protected *intf.USBInterface_S
		Protected etype.i
		
		*intf = *thisI\get_interface(*device, intf)
		If (*intf < 0)
			ProcedureReturn *intf
		EndIf
		etype = __RM_get_ep_map(*thisI, address, *intf\desc\bInterfaceNumber, *intf\desc\bAlternateSetting)
		If (etype < 0)
			;TODO WEITER MACHEN
		EndIf
		
		ProcedureReturn etype
	EndProcedure
	
	Procedure.i RM_release_all_interfaces(*this._ResourceManager_S, *device.Device)
		Protected *thisI._ResourceManager = *this
		Protected i.i
		
		For i = 0 To 255
			If (*this\_claimed_intf[i])
				*thisI\managed_release_interface(*device, i)
			EndIf
		Next
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	Procedure.i RM_dispose(*thisI._ResourceManager, *device.Device, close_handle.i = #True)
		Protected *this._ResourceManager_S
		
		*thisI\release_all_interfaces(*device)
		If (close_handle)
			*thisI\managed_close()
		EndIf
		__RM_reset_ep_map(*this)
		__RM_reset_alt_set(*this)
		*this\_active_cfg_index = -1
		
		ProcedureReturn #PBUSB_SUCCESS
	EndProcedure
	
	DataSection
		_ResourceManager_vTable:
			Data.i @RM_destroy(),
			       @RM_managed_open(),
			       @RM_managed_close(), 
			       @RM_managed_set_configuration(),
			       @RM_managed_claim_interface(), 
			       @RM_managed_release_interface(),
			       @RM_managed_set_interface(),
			       @RM_get_interface(),
			       @RM_get_active_configuration(),
			       @RM_get_endpoint_type(),
			       @RM_release_all_interfaces(),
			       @RM_dispose()
	EndDataSection
	
	;}
EndModule
; IDE Options = PureBasic 5.21 LTS (Linux - x64)
; EnableXP
