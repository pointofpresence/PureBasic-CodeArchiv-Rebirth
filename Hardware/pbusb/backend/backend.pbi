;Nachfolgend die Strukturen, die sich alle ableiten lassen von libusb und openusb

Structure pbusb_interface_descriptor
  bLength.a
  bDescriptorType.a
  bInterfaceNumber.a
  bAlternateSetting.a
  bNumEndpoints.a
  bInterfaceClass.a
  bInterfaceSubClass.a
  bInterfaceProtocol.a
  iInterface.a
EndStructure

Structure pbusb_endpoint_descriptor
  bLength.a
  bDescriptorType.a
  bEndpointAddress.a
  bmAttributes.a
  wMaxPacketSize.u
  bInterval.a
  bRefresh.a
  bSynchAddress.a
EndStructure

Structure pbusb_config_descriptor
  bLength.a
  bDescriptorType.a
  wTotalLength.u
  bNumInterfaces.a
  bConfigurationValue.a
  iConfiguration.a
  bmAttributes.a
  MaxPower.a
EndStructure

Structure pbusb_device_handle
EndStructure

Interface IBackend
	destroy()
	
	;Füllt eine Liste mit referenzierten Devices
	enumerate_devices.i(List *refDev())
	
	;Füllt die durch *dev_desc übergebene Struktur
	get_device_descriptor.i(*refDev, *dev_desc)
	
	;Gibt die Konfiguration als Pointer zur entsprechenden Struktur zurück
	get_configuration_descriptor.i(*refDev, config.i, *desc.pbusb_config_descriptor = 0)
	
	; Füllt die Struktur mit den gewünschten Daten und gibt einen LIBUSB-Fehler
	; oder im Erfolgsfall den Pointer *desc zurück. Wenn *desc = 0 ist, dann
	; wird der Pointer zur originalen Backend-spezifischen Funktion zurück gegeben.
	get_interface_descriptor.i(*refDev, intf.i, alt.i, config.i, *desc.pbusb_interface_descriptor = 0)
	
	;Gibt einen Pointer zu libusb_endpoint_descriptor zurück oder eine Error-Nummer
	get_endpoint_descriptor.i(*refDev, ep.i, intf.i, alt.i, config.i, *desc.pbusb_endpoint_descriptor = 0)
	
	;Returns an *refDev again if successful. The device handle is stored in the refDevice structure.
	open_device.i(*refDev)
	
	close_device.i(*refDev)
	
	set_configuration.i(*refDev, config_value.i)
	
	get_configuration.i(*refDev)
	
	set_interface_altsetting.i(*refDev, intf.i, altsetting.i)
	
	claim_interface.i(*refDev, intf.i)
	
	release_interface.i(*refDev, intf.i)
	
	bulk_write.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	bulk_read.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	
	intr_write.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	intr_read.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	
	iso_write.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	iso_read.i(*refDev, ep.i, intf.i, *data, size.i, timeout.i)
	
	ctrl_transfer.i(*refDev, bmRequestType.i, bRequest.i, wValue.i, wIndex.i, *Data, length.i, timeout.i)
	
	reset_device.i(*refDev)
	
	is_kernel_driver_active.i(*refDev, intf.i)
	detach_kernel_driver.i(*refDev, intf.i)
	attach_kernel_driver.i(*refDev, intf.i)
	
EndInterface
; IDE Options = PureBasic 5.21 LTS (Linux - x64)
; EnableXP
