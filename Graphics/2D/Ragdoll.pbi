;    Description: Ragdoll simulation
;         Author: Feindflug
;           Date: 2014-01-22
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=27669&sid=8e1fe21b5d0d81ef74199fbc5a9f0814
; -----------------------------------------------------------------------------



;//////////////////////////////////////////////////////////
;// Math
;//////////////////////////////////////////////////////////

DeclareModule Math
  
  Declare.f fmax(val1.f, val2.f)
  Declare.f fmin(val1.f, val2.f)
  
EndDeclareModule

Module Math
  Procedure.f fmax(val1.f, val2.f)
    If (val1 < val2)
      ProcedureReturn val2
    Else
      ProcedureReturn val1
    EndIf
  EndProcedure
  
  Procedure.f fmin(val1.f, val2.f)
    If (val1 < val2)
      ProcedureReturn val1
    Else
      ProcedureReturn val2
    EndIf
  EndProcedure
  
EndModule

DeclareModule Vector2
  Structure Type
    x.f
    y.f
  EndStructure
  
  Structure TypeInt
    x.i
    y.i
  EndStructure
  
  Declare.f dot(*vector.Type)
  Declare.f length(*vector.Type)
  Declare   normalize(*vector.Type)
  
  Macro ADD(__RESULT, __VEC1, __VEC2)
    __RESULT\x = __VEC1\x + __VEC2\x
    __RESULT\y = __VEC1\y + __VEC2\y
  EndMacro
  
  Macro ADDSCALAR(__RESULT, __VEC1, __SCALAR)
    __RESULT\x = __VEC1\x + __SCALAR
    __RESULT\y = __VEC1\y + __SCALAR
  EndMacro
  
  
  Macro SUB(__RESULT, __VEC1, __VEC2)
    __RESULT\x = __VEC1\x - __VEC2\x
    __RESULT\y = __VEC1\y - __VEC2\y
  EndMacro
  
  Macro SUBSCALAR(__RESULT, __VEC1, __SCALAR)
    __RESULT\x = __VEC1\x - __SCALAR
    __RESULT\y = __VEC1\y - __SCALAR
  EndMacro
  
  Macro MULSCALAR(__RESULT, __VEC1, __SCALAR)
    __RESULT\x = __VEC1\x * __SCALAR
    __RESULT\y = __VEC1\y * __SCALAR
  EndMacro
  
  Macro DIVSCALAR(__RESULT, __VEC1, __SCALAR)
    If (__SCALAR <> 0.0)
      __RESULT\x = __VEC1\x / __SCALAR
      __RESULT\y = __VEC1\y / __SCALAR
    EndIf
  EndMacro
  
  Macro ASSIGN(__DEST, __SOURCE)
    __DEST\x = __SOURCE\x
    __DEST\y = __SOURCE\y
  EndMacro
  
  Macro CREATE(__NAME, __X, __Y)
    Define.Vector2::Type __NAME
    __NAME\x = __X
    __NAME\y = __Y
  EndMacro
  
  Macro CREATEINT(__NAME, __X, __Y)
    Define.Vector2::TypeInt __NAME
    __NAME\x = __X
    __NAME\y = __Y
  EndMacro
  
  Macro CREATECOPY(__NAME, __OTHER)
    Define.Vector2::Type __NAME
    __NAME\x = __OTHER\x
    __NAME\y = __OTHER\y
  EndMacro
  
EndDeclareModule

Module Vector2
  
  
  Procedure.f dot(*vector.Type)
    ProcedureReturn *vector\x * *vector\x + *vector\y * *vector\y
  EndProcedure
  
  Procedure.f length(*vector.Type)
    ProcedureReturn Sqr(dot(*vector))
  EndProcedure
  
  Procedure normalize(*vector.Type)
    Define.f vecLength = length(*vector)
    DIVSCALAR(*vector, *vector, vecLength)
  EndProcedure
  
EndModule

;//////////////////////////////////////////////////////////
;// Screen
;//////////////////////////////////////////////////////////

DeclareModule Screen
  
  Macro TRANSFORM2SCREEN(__RESULT, __SOURCE)
    __RESULT\x = Int(__SOURCE\x * ScreenWidth())
    __RESULT\y = Int(__SOURCE\y * ScreenHeight())
  EndMacro
  
  Macro TRANSFORM2WORLD(__RESULT, __SOURCE)
    __RESULT\x = __SOURCE\x / ScreenWidth()
    __RESULT\y = __SOURCE\y / ScreenHeight()
  EndMacro
  
  
EndDeclareModule


Module Screen
EndModule

;//////////////////////////////////////////////////////////
;// Primitives
;//////////////////////////////////////////////////////////

DeclareModule Primitive
  
  Prototype protDrawPrimitive(*primitive)
  Prototype protConstraint(*primitive)
  Prototype protIntegrate(*primitive, elapsedTime.d, dT.d)
  
  Structure Type
    oldPosition.Vector2::Type
    position.Vector2::Type
    fixed.b
    
    draw.protDrawPrimitive
    constraint.protConstraint
    integrate.protIntegrate
  EndStructure
  
  Macro FILL(__PRIMITIVE, __POSITION, __FIXED, __DRAWSTRATEGY, __CONSTRAINT, __INTEGRATE)
    Vector2::ASSIGN(__PRIMITIVE\oldPosition, __POSITION)
    Vector2::ASSIGN(__PRIMITIVE\position, __POSITION)
    __PRIMITIVE\fixed = __FIXED
    __PRIMITIVE\draw = __DRAWSTRATEGY
    __PRIMITIVE\constraint = __CONSTRAINT
    __PRIMITIVE\integrate = __INTEGRATE
  EndMacro
  
  Declare drawPrimitiveCircle(*primitive.Type)
  Declare boxedConstraint(*primitive.Type)
  Declare gravityIntegration(*primitive.Type, elapsedTime.d, dT.d)
  
EndDeclareModule


Module Primitive
  
  Procedure gravityIntegration(*primitive.Type, elapsedTime.d, dT.d)
    If *primitive\fixed = #True
      *primitive\position = *primitive\oldPosition
      ProcedureReturn
    EndIf
    
    Define.Vector2::Type newPosition
    Vector2::ASSIGN(newPosition, *primitive\position)
    Vector2::MULSCALAR(newPosition, newPosition, 2)
    Vector2::SUB(newPosition, newPosition, *primitive\oldPosition)
    
    Vector2::CREATE(gravity, 0.0, 9.81)
    Define.f dT2 = dT * dT
    Vector2::MULSCALAR(gravity, gravity, dT * dT)
    
    Vector2::ADD(newPosition, newPosition, gravity)
    
    Vector2::ASSIGN(*primitive\oldPosition, *primitive\position)
    Vector2::ASSIGN(*primitive\position, newPosition)
  EndProcedure
  
  
  Procedure boxedConstraint(*primitive.Type)
    Define.Vector2::Type *position = @*primitive\position
    
    *position\x = Math::fmax(0.0, *position\x)
    *position\y = Math::fmax(0.0, *position\y)
    
    *position\x = Math::fmin(1.0, *position\x)
    *position\y = Math::fmin(1.0, *position\y)
    
  EndProcedure
  
  
  Procedure drawPrimitiveCircle(*primitive.Type)
    Define.Vector2::TypeInt screenVec
    Screen::TRANSFORM2SCREEN(screenVec, *primitive\position)
    Define.Vector2::Type testVec
    Vector2::ASSIGN(testVec, *primitive\position)
    Screen::TRANSFORM2SCREEN(testVec, *primitive\position)
    
    Circle(screenVec\x, screenVec\y, 4, RGB(255,255,255))   
  EndProcedure
  
EndModule

;//////////////////////////////////////////////////////////
;// Links
;//////////////////////////////////////////////////////////

DeclareModule Link
  
  Prototype protDrawLink(*Link)
  Prototype protConstraint(*Link)
  
  Structure Type
    *from.Primitive::Type
    *to.Primitive::Type
    
    distance.f
    damping.f
    
    draw.protDrawLink
    constraint.protConstraint
  EndStructure
  
  Macro FILL(__LINK, __FROM, __TO, __DISTANCE, __DAMPING, __DRAWSTRATEGY, __CONSTRAINT)
    __LINK\from = __FROM
    __LINK\to = __TO
    __LINK\distance = __DISTANCE
    __LINK\draw = __DRAWSTRATEGY
    __LINK\constraint = __CONSTRAINT
    __LINK\damping = __DAMPING
  EndMacro
  
  Declare drawLinkLine(*link)
  
  Declare constraintElastic(*link)
  
EndDeclareModule


Module Link
  
  Procedure drawLinkLine(*link.Link::Type)
    Define.Vector2::Type fromPos
    Screen::TRANSFORM2SCREEN(fromPos, *link\from\position)
    Define.Vector2::Type toPos
    Screen::TRANSFORM2SCREEN(toPos, *link\to\position)
    
    LineXY(fromPos\x, fromPos\y, toPos\x, toPos\y, RGB(150,150,150))     
    
  EndProcedure
  
  Procedure constraintElastic(*link.Link::Type)
    Define.Vector2::Type *fromPos = @*link\from\position
    Define.Vector2::Type *toPos = @*link\to\position
    
    ;CallDebugger
    
    Define.Vector2::Type difference
    Vector2::SUB(difference, *toPos, *fromPos)
    
    Define.f dDist = Vector2::length(difference) - *link\distance
    dDist * *link\damping
    dDist * 0.5
    
    Vector2::normalize(@difference)
    Vector2::MULSCALAR(difference, difference, dDist)
    
    If (*link\to\fixed = #False)
      Vector2::SUB(*toPos, *toPos, difference)
    EndIf
    
    If (*link\from\fixed = #False)
      Vector2::ADD(*fromPos, *fromPos, difference)
    EndIf
    
  EndProcedure
  
  
EndModule

;//////////////////////////////////////////////////////////
;// Entity
;//////////////////////////////////////////////////////////

DeclareModule Entity
  
  Prototype protDrawEntity(*entity)
  Prototype protUpdateConstraint(*entity)
  Prototype protIntegrate(*entity, elapsedTime.d, dT.d)
  
  Structure Container
    Array linkList.Link::Type(1)
    Array primitiveList.Primitive::Type(1)
  EndStructure
  
  Structure Type
    *data.Container
    
    draw.protDrawEntity
    update.protUpdateConstraint
    integrate.protIntegrate
  EndStructure
  
  Declare defaultDraw(*entity.Type)
  Declare defaultConstraint(*entity.Type)
  Declare defaultIntegrate(*entity.Type, elapsedTime.d, dT.d)
  
  Declare createNet(*newEntity.Type, *min.Vector2::Type, *max.Vector2::Type, *dimension.Vector2::TypeInt)
  
EndDeclareModule


Module Entity
  
  Procedure defaultIntegrate(*entity.Type, elapsedTime.d, dT.d)
    Define.Entity::Container *container = *entity\data
    Define.i arrSize = ArraySize(*container\primitiveList())
    For i = 0 To arrSize
      *container\primitiveList(i)\Integrate(*container\primitiveList(i), elapsedTime, dT)
    Next
    
  EndProcedure
  
  
  Procedure defaultConstraint(*entity.Type)
    Define.Entity::Container *container = *entity\data
    Define.i iterations = 2*Int(Sqr(ArraySize(*container\linkList())))+1
    
    For i=0 To iterations
      Define.i arrSize = ArraySize(*container\linkList())
      For i = 0 To arrSize
        *container\linkList(i)\constraint(*container\linkList(i))
      Next
      
      arrSize = ArraySize(*container\primitiveList())
      For i = 0 To arrSize
        *container\primitiveList(i)\constraint(*container\primitiveList(i))
      Next
    Next
    
  EndProcedure
  
  
  Procedure defaultDraw(*entity.Type)
    Define.Entity::Container *container = *entity\data
    Define.i arrSize
    
    ;CallDebugger
    arrSize = ArraySize(*container\linkList())
    For i = 0 To arrSize
      *container\linkList(i)\draw(*container\linkList(i))
    Next
    
    arrSize = ArraySize(*container\primitiveList())
    For i = 0 To arrSize
      *container\primitiveList(i)\draw(*container\primitiveList(i))
    Next
    
  EndProcedure
  
  
  Procedure createNet(*newEntity.Type, *min.Vector2::Type, *max.Vector2::Type, *dimension.Vector2::TypeInt)
    
    *data.Container = AllocateMemory(SizeOf(Container))
    InitializeStructure(*data, Container)
    *newEntity\data = *data
    *newEntity\draw = Entity::@defaultDraw()
    *newEntity\update = Entity::@defaultConstraint()
    *newEntity\integrate = Entity::@defaultIntegrate()
    Define.Vector2::TypeInt reducedDim
    Vector2::SUBSCALAR(reducedDim, *dimension, 1)
    
    Define.i size = *dimension\x * *dimension\y
    Define.i linkSize = *dimension\x * *dimension\y * 2 - *dimension\x - *dimension\y
    ReDim *data\linkList(linkSize - 1)
    ReDim *data\primitiveList(size - 1)
    
    Define.Vector2::Type netSize
    Vector2::SUB(netSize, *max, *min)
    
    Define.f dX = netSize\x / reducedDim\x
    Define.f dY = netSize\y / reducedDim\y
    
    Define.i offset = 0
    For y = 0 To reducedDim\y
      For x = 0 To reducedDim\x
        
        Vector2::CREATE(primPos, x * dX, y * dY)
        Vector2::ADD(primPos, primPos, *min)
        Define fixed = Bool(y=0)
        
        Primitive::FILL(*Data\primitiveList(offset),
                        primPos,
                        fixed,
                        Primitive::@drawPrimitiveCircle(),
                        Primitive::@boxedConstraint(),
                        Primitive::@gravityIntegration())
        
        offset + 1
      Next
      
    Next
    
    Define.i counter = 0
    For y = 0 To reducedDim\y
      For x = 0 To reducedDim\x
        
        offset = x + y * *dimension\x
        If (y <> reducedDim\y)
          Link::FILL(*data\linkList(counter),
                     *data\primitiveList(offset),
                     *data\primitiveList(offset+*dimension\y),
                     dY,
                     1.0,
                     Link::@drawLinkLine(),
                     Link::@constraintElastic())
          counter+1   
        EndIf
        
        If (x <> reducedDim\x)
          Link::FILL(*data\linkList(counter),
                     *data\primitiveList(offset),
                     *data\primitiveList(offset+1),
                     dX,
                     0.3,
                     Link::@drawLinkLine(),
                     Link::@constraintElastic())
          counter+1   
        EndIf
      Next
    Next
  EndProcedure
  
EndModule

;-Example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  ;//////////////////////////////////////////////////////////
  ;// Main
  ;//////////////////////////////////////////////////////////
  
  DeclareModule Main
    
    Declare start()
    
  EndDeclareModule
  
  
  Module Main
    
    Global NewList entityList.Entity::Type()
    
    Global.i running = #True
    
    Global elapsedTime.d
    
    Procedure init()
      InitSprite()
      OpenWindow(0, 0, 0, 600, 400, "Ragdoll", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      OpenWindowedScreen(WindowID(0), 0, 0, 600, 400)
      
      ;CallDebugger
      
      Vector2::CREATE(netMin, 0.2, 0.2)
      Vector2::CREATE(netMax, 0.8, 0.8)
      Vector2::CREATEINT(dimension, 10, 10)
      AddElement(entityList())
      
      Entity::createNet(entityList(), @netMin, @netMax, @dimension)
      
    EndProcedure
    
    
    Procedure draw()
      
      ClearScreen(RGB(0,0,0))
      StartDrawing(ScreenOutput())
      
      ForEach entityList()
        entityList()\draw(entityList())
      Next
      
      StopDrawing()
      FlipBuffers()
    EndProcedure
    
    
    Procedure processWindowEvent()
      Define.i event = #PB_Event_None
      Repeat
        event = WindowEvent()
        
        Select event
          Case #PB_Event_None:
            ;onIdle()
            
          Case #PB_Event_CloseWindow:
            running = false
        EndSelect
      Until event = #PB_Event_None
    EndProcedure
    
    
    Procedure update()
      Define.d currentTime = ElapsedMilliseconds() * 0.001
      If elapsedTime = 0.0
        elapsedTime = currentTime
      EndIf
      
      Define.d dT = currentTime - elapsedTime
      
      ForEach entityList()
        entityList()\integrate(entityList(), currentTime, dT)
        entityList()\update(entityList())
      Next
      
      elapsedTime = currentTime
    EndProcedure
    
    
    Procedure user()
      ForEach entityList()
        Define.Entity::Container *dataContainer = entityList()\data
        
        Define.i arrSize = ArraySize(*dataContainer\primitiveList())
        For i = 0 To arrSize - 1
          Define.Vector2::Type *position = @*dataContainer\primitiveList(i)\position
          
          Vector2::CREATE(mouse, WindowMouseX(0), WindowMouseY(0))
          Screen::TRANSFORM2WORLD(mouse, mouse)
          
          Vector2::CREATECOPY(difference, mouse)
          Vector2::SUB(difference, difference, *position)
          
          Define.f distance = Vector2::length(difference)
          If (distance < 0.2)
            distance = 0.2 - distance
            distance * 0.1
            Vector2::normalize(difference)
            Vector2::MULSCALAR(difference, difference, distance)
            Vector2::SUB(*position, *position, difference)
          EndIf
        Next
        
      Next
      
    EndProcedure
    
    
    Procedure done()
    EndProcedure
    
    
    Procedure start()
      init()
      
      While (running)
        processWindowEvent()
        update()
        draw()
        user()
      Wend
      
      done()
    EndProcedure
    
  EndModule
  
  ;//////////////////////////////////////////////////////////
  ;// START
  ;//////////////////////////////////////////////////////////
  
  
  Main::start()
  
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; Folding = ----------
; EnableUnicode
; EnableXP
; Executable = sdfgsdfg.exe
; CompileSourceDirectory
; EnableCompileCount = 1
; EnableBuildCount = 1
; EnableExeConstant