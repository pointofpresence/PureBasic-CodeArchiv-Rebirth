;    Description: Extends Random Funtion to use different Engines
;         Author: cxAlex
;           Date: 2013-03-18
;     PB-Version: 5.50 beta 1
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=26524
; -----------------------------------------------------------------------------

Enumeration
  #Random_PB
  #Random_glibc
  #Random_ANSIC
  #Random_BorlandC_rand
  #Random_BorlandC_lrand
  #Random_MVCpp
  #Random_MVB6
EndEnumeration

;- Internal

Prototype ___rSeed(Seed.i)
Prototype.i ___Random(Max.i, Min.i = #Null)
Prototype.i ___rTruncator(Value.i)

Global ___rValSeed.i
Global ___rSeed.___rSeed
Global ___Random.___Random
Global ___rTruncator.___rTruncator
Global ___rand_a.i
Global ___rand_c.i
Global ___rand_m.i

Procedure ___RandomSeed_PB(Seed.i)
  RandomSeed(Seed)
EndProcedure

Procedure ___Random_PB(Max.i, Min.i)
  ProcedureReturn Random(Max, Min)
EndProcedure

Procedure.i ___rTruncator_none(Value.i)
  ProcedureReturn Value
EndProcedure

Procedure.i ___rTruncator_glibc(Value.i)
  ProcedureReturn Value & ((1 << 31) - 1 )
EndProcedure

Procedure.i ___rTruncator_ansic(Value.i)
  ProcedureReturn Value & ( ((1 << 31) - 1 ) ! ((1 << 16) - 1 ))
EndProcedure

Procedure.i ___RandomSeed_n(Seed.i)
  ___rValSeed = Seed
EndProcedure

Procedure.i ___Random_n(Max.i, Min.i = #Null)
  Max = Max - Min
  ___rValSeed = (___rValSeed * ___rand_a + ___rand_c) & ___rand_m
  If Max
    ProcedureReturn Min + ___rTruncator(___rValSeed)%(Max+1)
  Else
    ProcedureReturn ___rTruncator(___rValSeed)
  EndIf
EndProcedure

;- Public
Procedure Random_SelectEngine(Engine.i, Seed = 0)
  Select Engine
    Case #Random_PB
      ___rSeed = @___RandomSeed_PB()
      ___Random = @___Random_PB()
    Default
      ___rSeed = @___RandomSeed_n()
      ___Random = @___Random_n()
      Select Engine
        Case #Random_glibc
          ___rand_a = 1103515245
          ___rand_c = 12345
          ___rand_m = (1 << 31) - 1
          ___rTruncator = @___rTruncator_glibc()

        Case #Random_ANSIC
          ___rand_a = 1103515245
          ___rand_c = 12345
          ___rand_m = (1 << 31) - 1
          ___rTruncator = @___rTruncator_ansic()

        Case #Random_BorlandC_rand
          ___rand_a = 22695477
          ___rand_c = 1
          ___rand_m = (1 << 32) - 1
          ___rTruncator = @___rTruncator_ansic()

        Case #Random_BorlandC_lrand
          ___rand_a = 22695477
          ___rand_c = 1
          ___rand_m = (1 << 32) - 1
          ___rTruncator = @___rTruncator_glibc()

        Case #Random_MVCpp
          ___rand_a = 214013
          ___rand_c = 2531011
          ___rand_m = (1 << 32) - 1
          ___rTruncator = @___rTruncator_ansic()

        Case #Random_MVB6
          ___rand_a = 1140671485
          ___rand_c = 12820163
          ___rand_m = (1 << 24) - 1
          ___rTruncator = @___rTruncator_none()

        Default
            ___rSeed = @___RandomSeed_PB()
            ___Random = @___Random_PB()
      EndSelect
  EndSelect
  ___rSeed(0)
EndProcedure : Random_SelectEngine(#Random_PB)

; Override Original PB - Functions

Macro RandomSeed(Seed)
  ___rSeed(Seed)
EndMacro

Macro Random(Max, Min = #Null)
  ___Random(Max, Min)
EndMacro

;-Example
CompilerIf #PB_Compiler_IsMainFile
  Macro TestVect()
    Debug "------"
    Define i
    For i = 1 To 10
      Debug Random(100)
    Next
  EndMacro
  
  
  
  Random_SelectEngine(#Random_PB) : TestVect()
  Random_SelectEngine(#Random_glibc) : TestVect()
  Random_SelectEngine(#Random_ANSIC) : TestVect()
  Random_SelectEngine(#Random_BorlandC_rand) : TestVect()
  Random_SelectEngine(#Random_BorlandC_lrand) : TestVect()
  Random_SelectEngine(#Random_MVCpp) : TestVect()
  Random_SelectEngine(#Random_MVB6) : TestVect()
CompilerEndIf
; IDE Options = PureBasic 5.50 beta 1 (Linux - x64)
; EnableXP
; EnablePurifier
