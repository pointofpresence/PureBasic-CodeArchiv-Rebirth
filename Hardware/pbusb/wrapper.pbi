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

IncludeFile #PB_Compiler_FilePath + "/backend/libusb1/import.pbi"

DeclareModule LIBUSB
	
	#STRING_BUFFER_LENGTH = 1024
	
	UseModule LIBUSB1
	
	Declare.i init()		;Return type: libusb_context
	Declare.i getLastError()
	Declare exit(*context.libusb_context)
	Declare setDebug(*context.libusb_context, level.l)
	Declare.i getVersion()	;Return type: libusb_version
	Declare.s getVersionString()
	Declare.l hasCapability(capability.l)
	Declare.s getErrorName(errorCode.l)
	Declare.s getLastErrorName()
	
	Declare.i getDeviceList(*context.libusb_context, List *devices.libusb_device())
	Declare.i findDevice(*context.libusb_context, idVendor.i = -1, idProduct.i = -1)
	Declare.i getBusNumber(*device.libusb_device)
	Declare.i getDeviceAddress(*device.libusb_device)
	Declare.i getDeviceDescriptor(*device.libusb_device, *descriptor.libusb_device_descriptor)
	Declare.s getDeviceManufacturerName(*deviceHandle.libusb_device_handle, *descriptor.libusb_device_descriptor)
	Declare.s getDeviceProductName(*deviceHandle.libusb_device_handle, *descriptor.libusb_device_descriptor)
	
	Declare.i openDevice(*device.libusb_device) ;Return type: libusb_device_handle
	Declare closeDevice(*deviceHandle.libusb_device_handle)
EndDeclareModule

Module LIBUSB
	;{ ============ IMPORT =============
	UseModule LIBUSB1
	
	;{ =============== BEGIN OWN IMPLEMENTATION ===============
	
	Global lastErrorCode.l = 0
	
	Structure p_libusb_device
		*device.libusb_device[0]
	EndStructure
	
	Global *p_list.p_libusb_device = 0
	
	Procedure.i init()		;Return type: libusb_context
		Protected *context.libusb_context
		
		lastErrorCode = libusb_init(@*context)
		
		If (lastErrorCode = 0)
			ProcedureReturn *context
		EndIf
		
		ProcedureReturn 0
	EndProcedure
	
	Procedure.i getLastError()
		ProcedureReturn lastErrorCode
	EndProcedure
	
	Procedure exit(*context.libusb_context)
		libusb_free_device_list(*p_list, 1)
		*p_list = 0
		libusb_exit(*context)
	EndProcedure
	
	Procedure setDebug(*context.libusb_context, level.l)
		libusb_set_debug(*context, level)
	EndProcedure
	
	Procedure.i getVersion()	;Return type: libusb_version
		ProcedureReturn libusb_get_version()		
	EndProcedure
	
	Procedure.s getVersionString()
		Protected *version.libusb_version
		Protected result.s
		
		*version = getVersion()
		With *version
			result = Str(\major) + "." + Str(\minor) + "." + Str(\micro) + "." + Str(\nano)
			If (\rc)
				result + PeekS(\rc, #PB_Ascii)
			EndIf
			If (\describe)
				result + " (" + PeekS(\describe, #PB_Ascii) + ")"
			EndIf
		EndWith
		
		ProcedureReturn result
	EndProcedure
	
	Procedure.l hasCapability(capability.l)
		ProcedureReturn libusb_has_capability(capability)
	EndProcedure
	
	Procedure.s getErrorName(errorCode.l)
		Protected *string = libusb_error_name(errorCode)
		
		If (*string)
			ProcedureReturn PeekS(*string, #PB_Ascii)
		EndIf
		
		ProcedureReturn ""
	EndProcedure
	
	Procedure.s getLastErrorName()
		ProcedureReturn getErrorName(getLastError())
	EndProcedure
	
	Procedure.i getDeviceList(*context.libusb_context, List *devices.libusb_device())
		Protected size.l, i.i
		
		If (*p_list)
			libusb_free_device_list(*p_list, 1)
			*p_list = 0
		EndIf
		
		size = libusb_get_device_list(*context, @*p_list)
		
		If (size >= 0)
			lastErrorCode = #LIBUSB_SUCCESS
			ClearList(*devices())
			For i = 0 To size - 1
				If AddElement(*devices())
					*devices() = *p_list\device[i]
				EndIf
			Next
		Else
			lastErrorCode = size
		EndIf
	EndProcedure
	
	Procedure.i findDevice(*context.libusb_context, idVendor.i = -1, idProduct.i = -1)
		Protected desc.libusb_device_descriptor
		Protected NewList *devices.libusb_device()
		
		getDeviceList(*context, *devices())
		ForEach *devices()
			getDeviceDescriptor(*devices(), @desc)
			If (desc\idProduct = idProduct Or idProduct = -1) And (desc\idVendor = idVendor Or idVendor = -1)
				ProcedureReturn *devices()
			EndIf
		Next
		
		ProcedureReturn 0
	EndProcedure
	
	Procedure.i getBusNumber(*device.libusb_device)
		ProcedureReturn libusb_get_bus_number(*device)
	EndProcedure
	
	Procedure.i getDeviceAddress(*device.libusb_device)
		ProcedureReturn libusb_get_device_address(*device)
	EndProcedure
	
	Procedure.i getDeviceDescriptor(*device.libusb_device, *descriptor.libusb_device_descriptor)
		lastErrorCode = libusb_get_device_descriptor(*device, *descriptor)
		If (lastErrorCode <> #LIBUSB_SUCCESS)
			ProcedureReturn #False
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure.s getStringDescriptor(*deviceHandle.libusb_device_handle, index.a)
		Protected *buffer = AllocateMemory(#STRING_BUFFER_LENGTH)
		Protected result.s = "", error.l
		
		error = libusb_get_string_descriptor_ascii(*deviceHandle, index, *buffer, #STRING_BUFFER_LENGTH)
		lastErrorCode = error
		If (error >= 0)
			lastErrorCode = #LIBUSB_SUCCESS
			result = PeekS(*buffer, #PB_Ascii)
		EndIf
		
		FreeMemory(*buffer)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure.s getDeviceManufacturerName(*deviceHandle.libusb_device_handle, *descriptor.libusb_device_descriptor)
		ProcedureReturn getStringDescriptor(*deviceHandle, *descriptor\iManufacturer)
	EndProcedure
	
	Procedure.s getDeviceProductName(*deviceHandle.libusb_device_handle, *descriptor.libusb_device_descriptor)
		ProcedureReturn getStringDescriptor(*deviceHandle, *descriptor\iProduct)
	EndProcedure
	
	Procedure.i openDevice(*device.libusb_device) ;Return type: libusb_device_handle
		Protected *deviceHandle.libusb_device_handle = 0
		Protected error.l
		
		error = libusb_open(*device, @*deviceHandle)
		If (error = #LIBUSB_SUCCESS)
			lastErrorCode = error
			ProcedureReturn *deviceHandle
		EndIf
		lastErrorCode = error
		
		ProcedureReturn 0
	EndProcedure
	
	Procedure closeDevice(*deviceHandle.libusb_device_handle)
		libusb_close(*deviceHandle)
	EndProcedure
	
	;}
EndModule

CompilerIf #PB_Compiler_IsMainFile

Procedure OUT(s.s)
	Debug s
	PrintN(s)
EndProcedure

Define result.i, *context.LIBUSB1::libusb_context

OpenConsole()

OUT("Version: " + LIBUSB::getVersionString())

*context = LIBUSB::init()
OUT(LIBUSB::getLastErrorName())
If (*context)
	OUT("*context = " + *context)
	
	NewList *devices.LIBUSB1::libusb_device()
	
	LIBUSB::getDeviceList(*context, *devices())
	ForEach *devices()
		Define output.s
		Define desc.LIBUSB1::libusb_device_descriptor
		
		LIBUSB::getDeviceDescriptor(*devices(), @desc)
		output.s = 	"Bus " + RSet(Str(LIBUSB::getBusNumber(*devices())), 3, "0") + " " +
					"Device " + RSet(Str(LIBUSB::getDeviceAddress(*devices())), 3, "0") + ": " +
					"ID " + RSet(Hex(desc\idVendor), 4, "0") + ":" +
					RSet(Hex(desc\idProduct), 4, "0") + " "

		Define *deviceHandle = LIBUSB::openDevice(*devices())
		
		If (*deviceHandle)
			output +	LIBUSB::getDeviceManufacturerName(*deviceHandle, @desc) + " " +
						LIBUSB::getDeviceProductName(*deviceHandle, @desc)
			LIBUSB::closeDevice(*deviceHandle)
		Else
			OUT("[ERR] LIBUSB::openDevice: " + LIBUSB::getLastErrorName())
		EndIf
		
		OUT(output)
	Next

	LIBUSB::exit(*context)
EndIf

CloseConsole()

CompilerEndIf
; IDE Options = PureBasic 5.21 LTS (Linux - x64)
; EnableXP
; EnablePurifier = 1,1,1,1
