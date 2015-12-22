;    Description: functions for running jobs simultaneously on multiprocessor/multicore systems
;         Author: Danilo Krahn
;           Date: 2014-02-18
;     PB-Version: 5.40
;             OS: Windows, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=16950
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_Thread=#False
  CompilerError "Threadsafe needed!"
CompilerEndIf

;  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;   CompilerError "Windows Only!"
;  CompilerEndIf



;*----------------------------------------------------------------------------------
;*
;* JOBS.pbi
;*
;* Author: Danilo Krahn, 2008/06/19
;*
;* functions for running jobs simultaneously
;* on multiprocessor/multicore systems
;*
;* Version 2, 2008/06/20:   - removed JobResult() and added optional
;*                            pointer to result to AddJob()
;*
;*                          - The JobQueue is now cleared by default
;*                            after all jobs are done.
;*
;*                          - added optional flag #PRESERVE_JOBLIST
;*                            for DoJobs(#PRESERVE_JOBLIST) if you
;*                            want to run the same jobs again
;*
;* Version 3, 2008/06/22    - start X worker threads in background (X = available CPUs/Cores)
;*                            and pause this threads after all jobs are done
;*
;*                          - added EndJobThreads() for stopping
;*                            worker threads at program end
;*
;* Version 4, 2014/02/18    - updated for PB 5.21 LTS
;*
;*                          - Changed PauseThread/ResumeThread to use a semaphore,
;*                            so it works also with Mac OS X
;*
;*                          - CountCPUs() is now used to determine number of background threads
;*
;* functions:
;*
;*   AddJob( @myProcedure(), optional_argument.i = 0, optional_pointerToResult = 0 )  ; add a job to the queue
;*
;*   jobsDone = DoJobs()                   ; run all jobs in the queue and clear job queue (no ClearJobs() needed)
;*
;*   jobsDone = DoJobs(#PRESERVE_JOBLIST)  ; run all jobs in the queue without clearing the job list
;*
;*   ClearJobs()                           ; clear the job queue
;*
;*   EndJobThreads()                       ; end worker threads before program ends
;*
;*
;* compiler options: [X] create threadsafe executable
;*
;*----------------------------------------------------------------------------------
CompilerIf #PB_Compiler_Thread=0
  ;******************************************************
  ;* remove this only if you know what you are doing ;) *
  ;******************************************************
  CompilerError "please use compiler option: [X] create threadsafe executable" ; required for using PB-Strings (also with Debug)
CompilerEndIf

;EnableExplicit

#PRESERVE_JOBLIST = 1

#__JOBS__THREAD__RUNNING =  0
#__JOBS__THREAD__PAUSED  =  1
#__JOBS__SIGNAL__QUIT    = -1

Prototype.i __JOB_PROC(arg.i)

Structure __JOB_INFO
  jobProc.__JOB_PROC
  jobArg.i
  *pjobResult.INTEGER
EndStructure

Structure __JOB_THREAD
  thread_id.i
  thread_paused.i
  thread_semaphore.i
  thread_signal.i
EndStructure


Global NewList __Jobs__.__JOB_INFO()
Global Dim     __Jobs__threads.__JOB_THREAD(0)
Global         __Jobs__mutex.i = 0
Global         __Jobs__CPUs.i  = 0

Procedure __GetNextJob(*job.__JOB_INFO)
  Protected retval.i
  ;
  ; return with no mutex
  ;
  If Not __Jobs__mutex
    ProcedureReturn #False
  EndIf
  ;
  ; get next job from linked list
  ;
  LockMutex(__Jobs__mutex)
  If *job
    If NextElement(__Jobs__())
      *job\jobProc     = __Jobs__()\jobProc
      *job\jobArg      = __Jobs__()\jobArg
      *job\pjobResult  = __Jobs__()\pjobResult
      retval = #True
    EndIf
  EndIf
  UnlockMutex(__Jobs__mutex)
  ProcedureReturn retval
EndProcedure


Procedure __WorkerThread(*me.__JOB_THREAD)
  Protected result.i, job.__JOB_INFO
  ;
  ; Wait until thread_id is written to structure
  ;
  Repeat : Until *me\thread_id
  Delay(0)
  *me\thread_paused = #__JOBS__THREAD__PAUSED
  WaitSemaphore(*me\thread_semaphore)
  *me\thread_paused = #__JOBS__THREAD__RUNNING
  ;Debug "worker thread START"
  
  Repeat
    ;
    ; do all jobs
    ;
    While __GetNextJob(@job)
      If job\jobProc
        result = job\jobProc(job\jobArg)
        If job\pjobResult
          job\pjobResult\i = result
        EndIf
      EndIf
    Wend
    ;
    ; dont pause after quit signal! (possible deadlock)
    ;
    If *me\thread_signal <> #__JOBS__SIGNAL__QUIT
      ;
      ; all jobs done, so take a break
      ;
      Delay(0)
      *me\thread_paused = #__JOBS__THREAD__PAUSED
      WaitSemaphore(*me\thread_semaphore)
      *me\thread_paused = #__JOBS__THREAD__RUNNING
    EndIf
    ;
    ; end worker threads with signal quit from EndJobThreads()
    ;
  Until *me\thread_signal = #__JOBS__SIGNAL__QUIT
  
  ;Debug "worker thread STOP"
EndProcedure


Procedure ClearJobs()
  ;
  ; check mutex for simultaneously access
  ; to the job linked list
  ;
  If Not __Jobs__mutex
    __Jobs__mutex = CreateMutex()
    If Not __Jobs__mutex
      ProcedureReturn #False
    EndIf
  EndIf
  ;
  ; clear linked list with jobs
  ;
  LockMutex(__Jobs__mutex)
  ClearList(__Jobs__())
  UnlockMutex(__Jobs__mutex)
EndProcedure


Procedure.i AddJob( JobProcedure.__JOB_PROC, Arg.i=0, PointerToResult.i=0 )
  Protected retval.i
  ;
  ; check mutex for simultaneously access
  ; to the job linked list
  ;
  If Not __Jobs__mutex
    __Jobs__mutex = CreateMutex()
    If Not __Jobs__mutex
      ProcedureReturn #False
    EndIf
  EndIf
  ;
  ; add job to linked list
  ;
  LockMutex(__Jobs__mutex)
  LastElement(__Jobs__())
  If AddElement(__Jobs__())
    __Jobs__()\jobProc     = JobProcedure
    __Jobs__()\jobArg      = Arg
    __Jobs__()\pjobResult  = PointerToResult
    retval = #True
  EndIf
  UnlockMutex(__Jobs__mutex)
  ProcedureReturn retval
EndProcedure

Procedure.i DoJobs(preserve_joblist.i=0)
  Protected job_count.i, i.i, thread_running.i
  ;
  ; check mutex for simultaneously access
  ; to the job linked list
  ;
  If Not __Jobs__mutex
    __Jobs__mutex = CreateMutex()
    If Not __Jobs__mutex
      ProcedureReturn #False
    EndIf
  EndIf
  ;
  ; start worker threads 1st time this procedure is called
  ;
  If Not __Jobs__CPUs
    __Jobs__CPUs = CountCPUs(#PB_System_ProcessCPUs)
    If __Jobs__CPUs < 1
      __Jobs__CPUs = 1
    EndIf
    ;Debug "Creating "+Str(__Jobs__CPUs)+" worker threads."
    ;
    ; Dim array for CPU count
    ;
    Dim __Jobs__threads.__JOB_THREAD(__Jobs__CPUs)
    ;
    ; start X worker threads
    ;
    For i = 1 To __Jobs__CPUs
      __Jobs__threads(i)\thread_signal    = 0
      __Jobs__threads(i)\thread_semaphore = CreateSemaphore()
      __Jobs__threads(i)\thread_id        = CreateThread(@__WorkerThread(),@__Jobs__threads(i))
    Next i
  EndIf
  ;
  ; reset list before start and count jobs
  ;
  LockMutex(__Jobs__mutex)
  job_count = ListSize(__Jobs__())
  ResetList(__Jobs__())
  UnlockMutex(__Jobs__mutex)
  ;
  ; no jobs, return
  ;
  If Not job_count
    ProcedureReturn #False
  EndIf
  ;
  ; resume worker threads to do the jobs
  ;
  For i = 1 To __Jobs__CPUs
    SignalSemaphore(__Jobs__threads(i)\thread_semaphore)
  Next i
  ;
  ; wait until all worker threads are done
  ;
  Repeat
    thread_running = 0
    For i = 1 To __Jobs__CPUs
      If __Jobs__threads(i)\thread_paused <> #__JOBS__THREAD__PAUSED
        thread_running = 1
      EndIf
    Next i
  Until thread_running = 0
  ;
  ; clear list without optional flag #PRESERVE_JOBLIST
  ;
  If Not (preserve_joblist = #PRESERVE_JOBLIST)
    LockMutex(__Jobs__mutex)
    ClearList(__Jobs__())
    UnlockMutex(__Jobs__mutex)
  EndIf
  
  ProcedureReturn job_count
EndProcedure


Procedure EndJobThreads()
  Protected i.i
  ;
  ClearJobs()
  ;
  If __Jobs__CPUs
    ;
    ; set signal quit
    ; and resume threads
    ;
    For i = 1 To __Jobs__CPUs
      __Jobs__threads(i)\thread_signal = #__JOBS__SIGNAL__QUIT
      SignalSemaphore(__Jobs__threads(i)\thread_semaphore)
    Next i
    ;
    ; wait for all worker threads to end
    ;
    For i = 1 To __Jobs__CPUs
      WaitThread(__Jobs__threads(i)\thread_id,500)
      __Jobs__threads(i)\thread_id = 0
      FreeSemaphore( __Jobs__threads(i)\thread_semaphore )
    Next i
    __Jobs__CPUs = 0
  EndIf
EndProcedure

;*----------------------------------------------------------------------------------
;*--[ END OF INCLUDE 'JOBS.pbi' ]---------------------------------------------------
;*----------------------------------------------------------------------------------



;-Example
CompilerIf #PB_Compiler_IsMainFile
  
  ;*-------------------------------------
  ;----[ Program ]-----------------------
  ;*-------------------------------------
  
  
  EnableExplicit
  
  ;XIncludeFile "JOBS.pbi"
  
  Procedure.i MyJob(arg.i)
    Protected a.i, b.i
    Debug "running job "+Str(arg)
    ; dummy loop
    For a = 1 To 5000000
      b=a*2
    Next a
    ProcedureReturn arg * arg
  EndProcedure
  
  #thread_count = 10
  Define.i a, b
  Dim results.i(#thread_count)
  
  For a = 1 To #thread_count
    AddJob(@MyJob(),a,@results(a))
  Next a
  
  MessageRequester("INFO","START")
  
  CompilerIf #PB_Compiler_Debugger
    For a = 1 To 2 ; with debugger it is sooo much slower
    CompilerElse
      For a = 1 To 300
      CompilerEndIf
      DoJobs(#PRESERVE_JOBLIST)
    Next a
    
    a = DoJobs()
    
    
    Debug "------------------------"
    Debug Str(a)+" jobs done."
    Debug "results:"
    
    For a = 1 To #thread_count
      Debug results(a)
    Next a
    
    EndJobThreads()
    
    MessageRequester("INFO","THE END")
    
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; EnableUnicode
; EnableThread
; EnableXP
; CompileSourceDirectory
