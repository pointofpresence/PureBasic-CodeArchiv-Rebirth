;    Description: Uses 2D-Drawing-Lib and draws perlin noise
;         Author: remi_meier (Code has been improved by edel, Nino, ts-soft and Sicro)
;           Date: 2016-04-23
;     PB-Version: 5.42
;             OS: Windows
;  English-Forum: 
;   French-Forum: 
;   German-Forum: 
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Supported OS are only: Windows"
CompilerEndIf

; Auf und Ab drücken!

EnableExplicit

Prototype.d NoiseFunc(x.d, y.d, z.d)

Structure Noise
  Noise.NoiseFunc
EndStructure

Procedure.d Interpolate(a.d, b.d, x.d)
  Protected f.d

  f = (1 - Cos(x * #PI)) * 0.5
  ProcedureReturn a * (1 - f) + b * f
EndProcedure

Procedure.d InterpolatedNoise(Noise.NOISEFUNC, x.d, y.d, z.d)
  Protected integer_X, fractional_X.d, integer_Y, fractional_Y.d, integer_Z, fractional_Z.d
  Protected v1.d, v2.d, v3.d, v4.d, i1.d, i2.d, n1.d, n2.d
  integer_X    = Int(x)
  fractional_X = x - integer_X

  integer_Y    = Int(y)
  fractional_Y = y - integer_Y

  integer_Z    = Int(z)
  fractional_Z = z - integer_Z

  v1 = Noise(integer_X,     integer_Y,     integer_Z)
  v2 = Noise(integer_X + 1, integer_Y,     integer_Z)
  v3 = Noise(integer_X,     integer_Y + 1, integer_Z)
  v4 = Noise(integer_X + 1, integer_Y + 1, integer_Z)
  i1 = Interpolate(v1 , v2 , fractional_X)
  i2 = Interpolate(v3 , v4 , fractional_X)
  n1 = Interpolate(i1 , i2 , fractional_Y)

  v1 = Noise(integer_X,     integer_Y,     integer_Z + 1)
  v2 = Noise(integer_X + 1, integer_Y,     integer_Z + 1)
  v3 = Noise(integer_X,     integer_Y + 1, integer_Z + 1)
  v4 = Noise(integer_X + 1, integer_Y + 1, integer_Z + 1)
  i1 = Interpolate(v1 , v2 , fractional_X)
  i2 = Interpolate(v3 , v4 , fractional_X)
  n2 = Interpolate(i1 , i2 , fractional_Y)

  ProcedureReturn Interpolate(n1, n2, fractional_Z)
  ;ProcedureReturn n1*(1-fractional_Z) + n2*fractional_Z
EndProcedure

Procedure.d PerlinNoise_3D(x.d, y.d, z.d, Array Noise.Noise(1))
  Protected total.d, p.d, i, frequency.d, amplitude.d, count
  total = 0
  p = 1 / 1.4142
  count = ArraySize(Noise()) + 1
  For i = 0 To count - 1
    If Noise(i)
      frequency = Pow(2.0, i)
      amplitude = Pow(p, i)
      total + InterpolatedNoise(Noise(i)\Noise, x * frequency, y * frequency, z * frequency) * amplitude
    Else
      Break
    EndIf
  Next

  ProcedureReturn 1 / (1 + Pow(2.718281828459045, -total.d))
EndProcedure

;- Noises
Procedure.d Noise1(x.d, y.d, z.d)
  Protected n
  n = x * 13 + y * 57 + z * 14
  n = (n << 13) ! n
  n = ( (n * (n * n * 15731 + 789221) + 1376312589) & $7FFFFFFF)
  ProcedureReturn ( 1.0 - n / 1073741824.0)
EndProcedure

Procedure.d Noise2(x.d, y.d, z.d)
  Protected n
  n = x * 12 + y * 25 + z * 24
  n = (n << 13) ! n
  n = ( (n * (n * n * 15727 + 789221) + 1376312589) & $7FFFFFFF)
  ProcedureReturn ( 1.0 - n / 1073741824.0)
EndProcedure

Procedure.d Noise3(x.d, y.d, z.d)
  Protected n
  n = x * 22 + y * 13 + z * 15
  n = (n << 13) ! n
  n = ( (n * (n * n * 15727 + 789221) + 1376312589) & $7FFFFFFF)
  ProcedureReturn ( 1.0 - n / 1073741824.0)
EndProcedure

#img = 1
#win = 0

Procedure.d CloudExpCurve(v.d)
  #CloudCover = 110 ; 0-255
  #CloudSharpness = 0.97 ; 0-1
  Protected c.d
  c = v - #CloudCover
  If c < 0
    c = 0
  EndIf

  ProcedureReturn 255 - ((Pow(#CloudSharpness, c)) * 255)
EndProcedure

Procedure CalcPerlin(Width, Height, i.d)
  Protected x, y, h.d
  Static z.d = 10.1

  Dim N.Noise(2)
  N(0)\Noise = @Noise1()
  N(1)\Noise = @Noise2()
  N(2)\Noise = @Noise3()

  CreateImage(#img, Width, Height)
  StartDrawing(ImageOutput(#img))
  Width-1 : Height-1 ; <<<< Without this line, caused Plot () a "outside the drawing range" error
  For x = 0 To Width
    For y = 0 To Height
      h = CloudExpCurve(PerlinNoise_3D(x/Width*2, y/Height*2, z, N()) * 255)
      Plot(x, y, h)
    Next
  Next
  DrawText(0, 0, StrD(z))
  StopDrawing()
  z + 0.03 * i
EndProcedure

;-Example
CompilerIf #PB_Compiler_IsMainFile
  OpenWindow(#win,0,0,200,200,"Window",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
  CalcPerlin(200, 200, 1)
  
  ImageGadget(#img, 0, 0, 200, 200, ImageID(#img))
  
  Define EventID
  Repeat
    EventID = WaitWindowEvent()
  
    If GetAsyncKeyState_(#VK_UP) & 32768
      CalcPerlin(WindowWidth(#win), WindowHeight(#win), 1)
      SetGadgetState(#img, ImageID(#img))
    ElseIf GetAsyncKeyState_(#VK_DOWN) & 32768
      CalcPerlin(WindowWidth(#win), WindowHeight(#win), -1)
      SetGadgetState(#img, ImageID(#img))
    EndIf
  
    Select EventID
      Case #PB_Event_SizeWindow
        CalcPerlin(WindowWidth(#win), WindowHeight(#win), 0)
        ResizeGadget(#img, 0, 0, WindowWidth(#win), WindowHeight(#win))
        SetGadgetState(#img, ImageID(#img))
    EndSelect
  
  Until EventID = #PB_Event_CloseWindow
  
  CloseWindow(#win)
CompilerEndIf
; IDE Options = PureBasic 5.42 LTS (Linux - x64)
; EnableUnicode
; EnableXP
; EnablePurifier
