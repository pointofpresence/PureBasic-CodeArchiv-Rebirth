;    Description: Wrapper for winhttp.lib
;         Author: mback2k (ts-soft: added compatibility for x86/x64; Sicro: added a lot of changes)
;           Date: 2013-05-21
;     PB-Version: 5.50 beta 1
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?p=312660#p312660
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

EnableExplicit

Import "winhttp.lib"
  WinHttpOpen(pwszUserAgent.p-unicode, dwAccessType.l, *pwszProxyName, *pwszProxyBypass, dwFlags.l)
  WinHttpConnect(hSession.i, pswzServerName.p-unicode, nServerPort.l, dwReserved.l)
  WinHttpSetOption(hInternet.i, dwOption.l, *lpBuffer, dwBufferLength.l)
  WinHttpSetCredentials(hInternet.i, AuthTargets.l, AuthScheme.l, pwszUserName.p-unicode, pwszPassword.p-unicode, *pAuthParams)
  WinHttpOpenRequest(hConnect.i, pwszVerb.p-unicode, pwszObjectName.p-unicode, *pwszVersion, *pwszReferrer, *ppwszAcceptTypes, dwFlags.l)
  WinHttpSendRequest(hRequest.i, pwszHeaders.p-unicode, dwHeadersLength.l, *lpOptional, dwOptionalLength.l, dwTotalLength.l, dwContext.l)
  WinHttpReceiveResponse(hRequest.i, *lpReserved)
  WinHttpAddRequestHeaders(hRequest.i, pwszHeaders.p-unicode, dwHeadersLength.l, dwModifiers.l)
  WinHttpQueryHeaders(hRequest.i, dwInfoLevel.l, *pwszName, *lpBuffer, *lpdwBufferLength, *lpdwIndex)
  WinHttpQueryDataAvailable(hRequest.i, *lpdwNumberOfBytesAvailable)
  WinHttpReadData(hRequest.i, *lpBuffer, dwNumberOfBytesToRead.l, *lpdwNumberOfBytesRead)
  WinHttpCrackUrl(pwszUrl.p-unicode, dwUrlLength.l, dwFlags.l, *lpUrlComponents)
  WinHttpCloseHandle(hInternet.i)
EndImport

Enumeration
  #INTERNET_SCHEME_HTTP                   = 1
  #INTERNET_SCHEME_HTTPS                  = 2
  #INTERNET_DEFAULT_HTTP_PORT             = 80
  #INTERNET_DEFAULT_HTTPS_PORT            = 443

  #WINHTTP_NO_PROXY_NAME                  = 0
  #WINHTTP_NO_PROXY_BYPASS                = 0
  #WINHTTP_NO_REFERER                     = 0
  #WINHTTP_NO_HEADER_INDEX                = 0
  #WINHTTP_DEFAULT_ACCEPT_TYPES           = 0
  #WINHTTP_ACCESS_TYPE_DEFAULT_PROXY      = 0
  #WINHTTP_HEADER_NAME_BY_INDEX           = 0

  #WINHTTP_AUTH_TARGET_SERVER             = 0
  #WINHTTP_AUTH_TARGET_PROXY              = 1

  #WINHTTP_AUTH_SCHEME_BASIC              = 1
  #WINHTTP_AUTH_SCHEME_NTLM               = 2
  #WINHTTP_AUTH_SCHEME_PASSPORT           = 4
  #WINHTTP_AUTH_SCHEME_DIGEST             = 8
  #WINHTTP_AUTH_SCHEME_NEGOTIATE          = 16

  #WINHTTP_OPTION_REDIRECT_POLICY                         = 88
  #WINHTTP_OPTION_REDIRECT_POLICY_NEVER                   = 0
  #WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP  = 1
  #WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS                  = 2

  #WINHTTP_QUERY_STATUS_CODE              = 19
  #WINHTTP_QUERY_RAW_HEADERS_CRLF         = 22
  #WINHTTP_QUERY_CONTENT_ENCODING         = 29
  #WINHTTP_QUERY_LOCATION                 = 33
  #WINHTTP_QUERY_FLAG_NUMBER              = $20000000
  #WINHTTP_QUERY_CONTENT_LENGTH           = 5

  #WINHTTP_OPTION_USERNAME                = $1000
  #WINHTTP_OPTION_PASSWORD                = $1001

  #WINHTTP_FLAG_REFRESH                   = $00000100
  #WINHTTP_FLAG_SECURE                    = $00800000

  #WINHTTP_ADDREQ_FLAG_ADD                = $20000000
EndEnumeration

Enumeration
  #WINHTTP_RETURNTYPE_MEMORY
  #WINHTTP_RETURNTYPE_FILE
EndEnumeration

Structure WinHTTP_ParametersStruc
  URL.s
  RequestType.s
  ReturnHeader.i
  UserName.s
  Password.s
  HeaderData.s
  OptionalData.s
  UserAgent.s
  CallbackID.i
  *CallbackStart
  *CallbackProgress
  *CallbackEnd
  *Memory
  FilePath.s
  FileBufferSize.i
EndStructure

Procedure WinHTTP_DownloadURLData(*WinHTTP_Parameters.WinHTTP_ParametersStruc)
  Protected lpUrlComponents.URL_COMPONENTS\dwStructSize = SizeOf(URL_COMPONENTS)
  Protected lStatusCode.l, lContentLen.q, lRedirectPolicy.l = #WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS, lLongSize.l = SizeOf(Long), QuadSize.l = SizeOf(Quad)
  Protected.i hInternet, hConnect, hRequest, lStartTime, lResult
  Protected.q lBytesRead, lReadUntilNow, AllDataSize
  Protected lPort.i, lFlags.i, sDomain$, sPath$, sQuery$, *OptionalBuffer, OptionalLength.i, *MemoryBuffer, MemoryLength.q
  Protected FileID.i, IsNoError.i = #True, URL.s, ReturnType.i
  Static hSession.i

  With *WinHTTP_Parameters

  URL = \URL

  If \FilePath <> ""
    ReturnType = #WINHTTP_RETURNTYPE_FILE
  EndIf

  If ReturnType = #WINHTTP_RETURNTYPE_MEMORY
    If \Memory = 0:             ProcedureReturn #False: EndIf
    If MemorySize(\Memory) = 0: ProcedureReturn #False: EndIf
  Else
    If \FileBufferSize = 0
      \FileBufferSize = 16*1024
    EndIf

    FileID = CreateFile(#PB_Any, \FilePath)
    If Not IsFile(FileID): ProcedureReturn #False: EndIf
  EndIf

  If Left(URL, 7) <> "http://" And Left(URL, 8) <> "https://"
    URL = "http://" + URL
  EndIf

  If CountString(Mid(URL, 9), "/") = 0
    URL + "/"
  EndIf

  If \UserAgent = ""
    \UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0"
  EndIf

  If \RequestType = ""
    \RequestType = "GET"
  EndIf

  lStartTime = ElapsedMilliseconds()
  lpUrlComponents\dwSchemeLength = -1
  lpUrlComponents\dwHostNameLength = -1
  lpUrlComponents\dwUrlPathLength = -1
  lpUrlComponents\dwExtraInfoLength = -1

  If WinHttpCrackUrl(URLEncoder(URL), #Null, #Null, @lpUrlComponents)

    Select lpUrlComponents\nScheme

      Case #INTERNET_SCHEME_HTTP
        lPort = #INTERNET_DEFAULT_HTTP_PORT
        lFlags = #WINHTTP_FLAG_REFRESH

      Case #INTERNET_SCHEME_HTTPS
        lPort = #INTERNET_DEFAULT_HTTPS_PORT
        lFlags = #WINHTTP_FLAG_REFRESH | #WINHTTP_FLAG_SECURE

    EndSelect

    If lPort And lFlags

      If lpUrlComponents\lpszHostName And lpUrlComponents\dwHostNameLength
        sDomain$ = PeekS(lpUrlComponents\lpszHostName, lpUrlComponents\dwHostNameLength, #PB_Unicode)
      EndIf

      If lpUrlComponents\lpszUrlPath And lpUrlComponents\dwUrlPathLength
        sPath$ = PeekS(lpUrlComponents\lpszUrlPath, lpUrlComponents\dwUrlPathLength, #PB_Unicode)
      EndIf

      If lpUrlComponents\lpszExtraInfo And lpUrlComponents\dwExtraInfoLength
        sQuery$ = PeekS(lpUrlComponents\lpszExtraInfo, lpUrlComponents\dwExtraInfoLength, #PB_Unicode)
      EndIf

      If sDomain$ And sPath$

        If Not hSession
          hSession = WinHttpOpen(\UserAgent, #WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, #WINHTTP_NO_PROXY_NAME, #WINHTTP_NO_PROXY_BYPASS, 0)
        EndIf

        If hSession

          hInternet = WinHttpConnect(hSession, sDomain$, lPort, #Null)
          If hInternet

            hRequest = WinHttpOpenRequest(hInternet, \RequestType, sPath$+sQuery$, #Null, #WINHTTP_NO_REFERER, #WINHTTP_DEFAULT_ACCEPT_TYPES, lFlags)
            If hRequest

              If StringByteLength(\OptionalData, #PB_UTF8)
                *OptionalBuffer = AllocateMemory(StringByteLength(\OptionalData, #PB_UTF8)+1)
              EndIf

              If *OptionalBuffer
                OptionalLength = MemorySize(*OptionalBuffer)
                PokeS(*OptionalBuffer, \OptionalData, OptionalLength, #PB_UTF8)
                OptionalLength - 1
              EndIf

              If lpUrlComponents\nScheme = #INTERNET_SCHEME_HTTP
                WinHttpSetOption(hRequest, #WINHTTP_OPTION_REDIRECT_POLICY, @lRedirectPolicy, SizeOf(Long))
              EndIf

              If Len(\UserName)
                WinHttpSetCredentials(hRequest, #WINHTTP_AUTH_TARGET_SERVER, #WINHTTP_AUTH_SCHEME_BASIC, \UserName, \Password, #Null)
              EndIf

              If WinHttpAddRequestHeaders(hRequest, "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"+#CRLF$, -1, #WINHTTP_ADDREQ_FLAG_ADD)
                WinHttpAddRequestHeaders(hRequest, "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7"+#CRLF$, -1, #WINHTTP_ADDREQ_FLAG_ADD)
                WinHttpAddRequestHeaders(hRequest, "Accept-Language: en-us,en-gb;q=0.9,en;q=0.8,*;q=0.7"+#CRLF$, -1, #WINHTTP_ADDREQ_FLAG_ADD)
              EndIf

              If \RequestType = "POST"
                WinHttpAddRequestHeaders(hRequest, "Content-Type: application/x-www-form-urlencoded"+#CRLF$, -1, #WINHTTP_ADDREQ_FLAG_ADD)
              EndIf

              If \CallbackStart
                CallFunctionFast(\CallbackStart, \CallbackID, hRequest)
              EndIf

              If WinHttpSendRequest(hRequest, \HeaderData, Len(\HeaderData), *OptionalBuffer, OptionalLength, OptionalLength, \CallbackID)
                If WinHttpReceiveResponse(hRequest, #Null)
                  If WinHttpQueryHeaders(hRequest, #WINHTTP_QUERY_FLAG_NUMBER | #WINHTTP_QUERY_STATUS_CODE, #WINHTTP_HEADER_NAME_BY_INDEX, @lStatusCode, @lLongSize, #WINHTTP_NO_HEADER_INDEX)
                    WinHttpQueryHeaders(hRequest, #WINHTTP_QUERY_FLAG_NUMBER | #WINHTTP_QUERY_CONTENT_LENGTH, #WINHTTP_HEADER_NAME_BY_INDEX, @AllDataSize, @QuadSize, #WINHTTP_NO_HEADER_INDEX)

                    If lStatusCode = 200
                      lResult = WinHttpQueryDataAvailable(hRequest, @lContentLen)
                    Else
                      lResult = #True
                      lContentLen = 0
                    EndIf

                    If lResult

                      If ReturnType = #WINHTTP_RETURNTYPE_FILE
                        *MemoryBuffer = AllocateMemory(\FileBufferSize)
                      Else
                        *MemoryBuffer = \Memory
                      EndIf

                      If *MemoryBuffer

                        MemoryLength = MemorySize(*MemoryBuffer)-2

                        If \ReturnHeader

                          If WinHttpQueryHeaders(hRequest, #WINHTTP_QUERY_RAW_HEADERS_CRLF, #WINHTTP_HEADER_NAME_BY_INDEX, *MemoryBuffer, @MemoryLength, #WINHTTP_NO_HEADER_INDEX)
                            *MemoryBuffer = ReAllocateMemory(*MemoryBuffer, MemoryLength)
                          EndIf

                        ElseIf lContentLen

                          Repeat

                            If ReturnType = #WINHTTP_RETURNTYPE_MEMORY
                              If MemoryLength-lReadUntilNow <= lContentLen
                                *MemoryBuffer = ReAllocateMemory(*MemoryBuffer, MemoryLength + lContentLen + 1)
                                If *MemoryBuffer
                                  MemoryLength = MemorySize(*MemoryBuffer)
                                Else
                                  Break
                                  IsNoError = #False
                                EndIf
                              EndIf

                              *MemoryBuffer + lReadUntilNow
                            EndIf

                            If WinHttpReadData(hRequest, *MemoryBuffer, lContentLen, @lBytesRead)
                              If ReturnType = #WINHTTP_RETURNTYPE_MEMORY
                                *MemoryBuffer - lReadUntilNow
                              EndIf

                              If lBytesRead
                                lReadUntilNow + lBytesRead

                                If ReturnType = #WINHTTP_RETURNTYPE_FILE
                                  WriteData(FileID, *MemoryBuffer, lBytesRead)
                                EndIf

                              Else
                                Break
                              EndIf

                              If \CallbackProgress
                                CallFunctionFast(\CallbackProgress, \CallbackID, lReadUntilNow, AllDataSize, (ElapsedMilliseconds() - lStartTime) / 1000)
                              EndIf
                            Else
                              Break
                              IsNoError = #False
                            EndIf

                            If Not WinHttpQueryDataAvailable(hRequest, @lContentLen)
                              Break
                            EndIf

                          ForEver

                          If ReturnType = #WINHTTP_RETURNTYPE_MEMORY
                            If lReadUntilNow >= lContentLen
                              *MemoryBuffer = ReAllocateMemory(*MemoryBuffer, lReadUntilNow)
                            EndIf

                            \Memory = *MemoryBuffer
                          EndIf

                          If ReturnType = #WINHTTP_RETURNTYPE_FILE
                            FreeMemory(*MemoryBuffer)
                            CloseFile(FileID)
                          EndIf

                        EndIf
                      EndIf
                    EndIf
                  Else
                    IsNoError = #False
                  EndIf
                Else
                  IsNoError = #False
                EndIf
              Else
                IsNoError = #False
              EndIf

              If *OptionalBuffer
                FreeMemory(*OptionalBuffer)
              EndIf

              If \CallbackEnd
                CallFunctionFast(\CallbackEnd, \CallbackID, *MemoryBuffer, lReadUntilNow, AllDataSize, (ElapsedMilliseconds() - lStartTime) / 1000)
              EndIf
            Else
              IsNoError = #False
            EndIf
          Else
            IsNoError = #False
          EndIf
        Else
          IsNoError = #False
        EndIf
      EndIf
    EndIf
  EndIf

  If hRequest:  WinHttpCloseHandle(hRequest):  EndIf
  If hInternet: WinHttpCloseHandle(hInternet): EndIf
  ; If hSession
  ;   WinHttpCloseHandle(hSession)
  ; EndIf

  EndWith

  ProcedureReturn IsNoError
EndProcedure

Procedure WinHTTP_DownloadProcess(CallbackID.i, lReadUntilNow.q, AllDataSize.q, ElapsedSeconds.i)
  Debug Str(lReadUntilNow) + " / " + Str(AllDataSize)
EndProcedure

Procedure.s WinHTTP_GetStringFromURL(URL.s)
  Protected Result$, Parameters.WinHTTP_ParametersStruc

  With Parameters
    \URL = URL

    \Memory = AllocateMemory(1024)
    If \Memory = 0
      ProcedureReturn
    EndIf

    If WinHTTP_DownloadURLData(Parameters)

      If \ReturnHeader
        Result$ = PeekS(\Memory, MemorySize(\Memory), #PB_Unicode)
      Else
        Result$ = PeekS(\Memory, MemorySize(\Memory), #PB_UTF8)
      EndIf

    EndIf

    FreeMemory(\Memory)

  EndWith

  ProcedureReturn Result$
EndProcedure

Procedure WinHTTP_DownloadURLDataToFile(URL.s, FilePath.s)
  Protected Parameters.WinHTTP_ParametersStruc

  With Parameters
    \URL = URL
    \FilePath = FilePath
    \CallbackProgress = @WinHTTP_DownloadProcess()
  EndWith

  ProcedureReturn WinHTTP_DownloadURLData(@Parameters)
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Debug WinHTTP_GetStringFromURL("www.google.de")
  Debug WinHTTP_DownloadURLDataToFile("www.google.de", GetTemporaryDirectory()+"google.txt")
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
