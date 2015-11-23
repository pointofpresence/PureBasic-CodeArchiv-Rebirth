;    Description: ImageGadget handling
;         Author: silversurfer
;           Date: 03-12-2014
;     PB-Version: 5.40
;             OS: Windows, Linux, Mac
;  English-Forum: 
;   French-Forum: 
;   German-Forum: http://www.purebasic.fr/german/viewtopic.php?f=8&t=28565
;-----------------------------------------------------------------------------

;-Example
DeclareModule	Image_gadget
  ;ImageGadgetModul v0.8
  ;erstellt von Thies Jeske @Silbersurfer
  ;------------------------------
  ; 	Befehlsübersicht
  ;
  ; 	Im_SetSliderValue				    (Slider,Maximum,Page[,Minimum])
  ; 	Im_SetSliderPos					    (Slider,Position)
  ;	Im_GetSliderPos				    (Slider)
  ; 	
  ;	Im_NewImageGadget				(X Position, Y Position,Breite,Höhe[,Image, Scrollbar,Rahmen])
  ;	Im_SetFactorToGadget			(Gadget,Scalierung[,flag]) Flag=#PB_Image_Raw/#PB_Image_Smooth
  
  ;	Im_SetImageToGadget			(Gadget,Image[,flags])
  ;	1=setzt Image Propotional 2=fit Image to Gadget 3=fit Gadget to Image 4=cut Image to Gadget
  ;
  ;	Im_GraImagetoGadget			(Gadget,Image,X Position,Y Position[,Breite,Höhe])
  ;	Breite und Höhe sind Optional wenn diese gesetzt werden passt sich das Gadget der größe an 
  
  ;	Im_LinkImageToGadget			(Gadget,Image)
  ;	verlinkt ein Image zum Gadget, wird für Slider oder Zoom benötigt
  
  ;	Im_HideImageGadget			(Gadget,flags) 0/1=Sichtbar/versteckt
  ;
  ;	Im_ResizeImageGadget			(Gadget,X Position,Y Position ,Breite,Höhe)
  ;	wenn die breite oder  höhe <> #PB_Ignore ist Muß das Image wieder neu gesetzt werden
  ;	mit Im_SetImageToGadget ausser es wurde Im_LinkImageToGadget benutzt
  
  ;	Im_SetBackcolorGadget			(Gadget,Color)
  ;	Im_UpdateImageGadget		(Gadget)
  ;	Im_GetSliderImageGadget		(Gadget,Slider)    Slider=#SliderH\#SliderV
  
  ; Slider Proceduren
  Declare Im_SetSliderValue				(*Id,Max.f,Page.f,Min.f=0)
  Declare Im_SetSliderPos				(*id,pos.f)
  Declare.f Im_GetSliderPos				(*Id)
  ;ImageGadget Proceduren
  Declare Im_NewImageGadget		(Gadget,x, y, b, h, img = 0, scroll = 0,border=0)
  Declare Im_SetScaleToGadget		(Gadget,scale.f,flag=#PB_Image_Smooth)
  Declare Im_SetImageToGadget		(Gadget,Image,flags=1)
  Declare Im_GraImageToGadget		(Gadget,Image,x,y,b=#PB_Ignore,h=#PB_Ignore)
  Declare Im_LinkImageToGadget	(Gadget,Image)
  Declare Im_HideImageGadget		(Gadget,flags)
  Declare Im_ResizeImageGadget	(Gadget,x,y,b,h)
  Declare Im_SetBackcolorGadget	(Gadget,color)
  Declare Im_GetImageGadgetSlider(Gadget,Slider)
  Declare Im_UpdateImageGadget	(Gadget,flag=#PB_Image_Smooth)
  ;ImageGadgetSlider Konstanten
  Enumeration
    #SliderH
    #SliderV
  EndEnumeration
  
EndDeclareModule
Module 				Image_gadget
  EnableExplicit
  Structure Slider
    Slider.i
    Pos.f :Sichtbar.f : Min.f : Max.f : Size.i
  EndStructure
  
  Structure Image
    Image.i
    x.i : y.i : Width.i : Hight.i
  EndStructure
  
  Structure GadgetImage
    Gadget.i : factor.f : color.i :border.i
    x.i : y.i : Width.i : Hight.i : QuellImage.i
    frame.i :rb.i
    Image.Image
    SliderH.slider : SliderV.slider
  EndStructure
  
  
  Procedure 	Rahmen3D(*this.GadgetImage)	
    With *this
      ;If Not \rb 
      If StartDrawing(ImageOutput(\Image\Image))
        Select \border
          Case  #PB_Image_Raised
            Line(0,\Hight-1,\Width,1,$757575)
            Line(\Width-1,0,1,\Hight,$757575)
            SetGadgetState(\Gadget, ImageID(\Image\Image))
            
          Case #PB_Image_Border
            Line(0,\Hight-1,\Width,1,$B8B8B8)
            Line(\Width-1,0,1,\Hight,$B8B8B8)
            SetGadgetState(\Gadget, ImageID(\Image\Image))
        EndSelect
        StopDrawing()
      EndIf
      ;EndIf 
    EndWith	
  EndProcedure	
  
  Procedure 	ImageGadgetSliderEvent()
    ; Event daten für das ImageGadget holen
    Protected *this.GadgetImage = GetGadgetData(EventGadget())
    Static PosX.f,Posy.f
    If *this
      Select EventGadget()
        Case *this\SliderH\Slider
          *this\SliderH\Pos=GetGadgetState(*this\SliderH\Slider)
          
        Case *this\SliderV\Slider
          *this\SliderV\Pos=GetGadgetState(*this\SliderV\Slider) 
          
      EndSelect
      
      Im_UpdateImageGadget(*this\Gadget)
    EndIf
  EndProcedure	
  
  Procedure 	Im_SetSliderValue				(*this.slider,Max.f,Page.f,Min.f=0)
    With *this
      \Max=max
      \Sichtbar=Page
      \Min=Min
      SetGadgetAttribute(\Slider,#PB_ScrollBar_Minimum,\Min)
      SetGadgetAttribute(\Slider,#PB_ScrollBar_Maximum,\Max)
      SetGadgetAttribute(\Slider,#PB_ScrollBar_PageLength,\Sichtbar)
    EndWith	
  EndProcedure
  
  Procedure 	Im_SetSliderPos					(*this.slider,pos.f)
    *this\Pos=pos
    SetGadgetState(*this	\Slider,*this\Pos)
  EndProcedure
  
  Procedure.f	Im_GetSliderPos				(*this.slider)
    ProcedureReturn *this\Pos
  EndProcedure
  
  Procedure 	NewSlider							(x, y, b, h, Sichtbar.f, Maximum.f, flags)
    Protected *this.slider	=	AllocateMemory(SizeOf(slider))
    If (Not *this)
      ProcedureReturn #False
    EndIf 		
    With *this
      \Slider   = ScrollBarGadget(#PB_Any, x, y, b, h, 0, Maximum, Sichtbar, flags)
      \Pos      = 0
      \Sichtbar = Sichtbar
      \Max      = Maximum
      \Min      = 0
      If Flags
        \size = b + 4
      Else
        \size = h + 4
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure 	Im_UpdateImageGadget	(Gadget,flag=#PB_Image_Smooth)
    Protected dummyimage.i,check.i
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    With *dummy
      If IsImage(\Image\Image)
        If IsImage(\QuellImage)<>0  And \SliderH\Slider<>-1 And \SliderV\Slider<>-1
          ;deactivieren des SliderH wenn QuellImage< oder = Groß wie Imagegadget ist
          If ImageWidth(\QuellImage)*\factor<=\Image\Width
            DisableGadget(\SliderH\Slider,1)
            \SliderH\Pos=0
            check=1
          Else
            ; SliderH neu anpassen an dem QuellImage
            Im_SetSliderValue(\SliderH,ImageWidth(\QuellImage)*\factor,\Image\Width)
            SetGadgetState(\SliderH\Slider,\SliderH\Pos)
            \SliderH\Pos=GetGadgetState(\SliderH\Slider)
          EndIf
          ;deactivieren des SliderV wenn QuellImage< oder = Groß wie Imagegadget ist
          If ImageHeight(\QuellImage)*\factor<=\Image\Hight
            DisableGadget(\SliderV\Slider,1)
            \SliderV\Pos=0
            check+2
          Else
            ; SliderV neu anpassen an dem QuellImage
            Im_SetSliderValue(\SliderV,ImageHeight(\QuellImage)*\factor,\Image\Hight)
            SetGadgetState(\SliderV\Slider,\SliderV\Pos)
            \SliderV\Pos=GetGadgetState(\SliderV\Slider)
          EndIf
          ;Image Freigeben
          FreeImage(\Image\Image)	
          ;Image Neu erstellen
          \Image\Image=CreateImage(#PB_Any,\Image\Width,\Image\Hight)
          ;eine Image Copy vom OrginalImage erstellen 
          dummyimage=CopyImage(\QuellImage,#PB_Any) 	 					
          ;größe des quellImage vergleichen mit Imagegadgetgröße
          If ImageWidth(\QuellImage)*\factor> \Image\Width Or ImageHeight(\QuellImage)*\factor>\Image\Hight				
            Select check
              Case 1
                dummyimage=GrabImage(\QuellImage,#PB_Any,0,\SliderV\Pos/\factor,ImageWidth(\QuellImage),(\Hight-1)/\factor)
              Case 2
                dummyimage=GrabImage(\QuellImage,#PB_Any,\SliderH\Pos/\factor,0,(\Width-1)/\factor,ImageHeight(\QuellImage))		
              Default 
                dummyimage=GrabImage(\QuellImage,#PB_Any,\SliderH\Pos/\factor,\SliderV\Pos/\factor,(\Width-1)/\factor,(\Hight-1)/\factor)
            EndSelect		
          Else
            dummyimage=CopyImage(\QuellImage,#PB_Any) 	 
          EndIf 
          ;In das Image Zeichen 
          ResizeImage(dummyimage,ImageWidth(dummyimage)* \factor,ImageHeight(dummyimage)* \factor)
          If StartDrawing(ImageOutput(\Image\Image))
            Box(0,0,\Image\Width,\Image\Hight,\color)
            DrawImage(ImageID(dummyimage),(\Image\Width-ImageWidth(dummyimage))/2,(\Image\Hight-ImageHeight(dummyimage))/2)
            StopDrawing()
            FreeImage(dummyimage)
            ;ausgeben an das ImageGadget
            SetGadgetState(\Gadget, ImageID(\Image\Image))
          EndIf 										
        Else 				
          ;deactivieren der Slider wenn kein QuellImage exsitiert
          If \SliderH\Slider<>-1  Or \SliderV\Slider<>-1 
            DisableGadget(\SliderH\Slider,1)
            DisableGadget(\SliderV\Slider,1)
          EndIf 
        EndIf 
      EndIf 
    EndWith	
  EndProcedure	
  
  Procedure 	Im_SetScaleToGadget		(Gadget,scale.f,flag=#PB_Image_Smooth)
    Protected CenterX.f,CenterY.f,dummyimage
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    With *dummy
      
      ;Sliderposition = (Sliderposition+SichbarerBereich/2) / alterFaktor * neuerFaktor - SichbarerBereich/2
      If \SliderH\Slider<>-1 And \SliderV\Slider<>-1
        CenterX=(GetGadgetState(\SliderH\Slider)+\Image\Width/2)/\factor*scale-\Image\Width/2
        CenterY=(GetGadgetState(\SliderV\Slider)+\Image\Hight/2)/\factor*scale-\Image\Hight/2			
        Im_SetSliderPos(\SliderH,CenterX)
        Im_SetSliderPos(\SliderV,CenterY)
      Else 
        
      EndIf 	
      \factor =scale
    EndWith
    Im_UpdateImageGadget(*dummy\Gadget,flag)
  EndProcedure
  
  Procedure 	Im_SetImageToGadget		(Gadget,Image,flags=1)	
    Protected b.f,h.f,multi.f,dummyimage.i,posx.i,posy.i
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    If Not IsImage(image)
      ProcedureReturn #False
    EndIf 	
    With *dummy
      Select flags
        Case 1 ; Resize Image mit beibehaltung des verhältnis Prozentual
               ;Image erstellen falls nicht vorhanden
          If Not IsImage(\Image\Image)
            \Image\Image=CreateImage(#PB_Any,\Width,\Hight,32)
            \Image\x=0 : \Image\y=0
            \Image\Width=\Width : \Image\Hight=\Hight
          EndIf 
          ;eine Image Copy vom OrginalImage erstellen 
          dummyimage=CopyImage(image,#PB_Any)
          ;größe Proportional berechnen
          b=\Image\Width/ImageWidth(image)
          h=\Image\Hight/ImageHeight(image)
          If b<h : multi=b : Else : multi=h : EndIf
          ; Neue Größe erstellen 
          ResizeImage(dummyimage,ImageWidth(image)*multi,ImageHeight(image)*multi)
          ; Zentriert Zeichnen im Gadget Image
          If StartDrawing(ImageOutput(\Image\Image))
            Box(0,0,\Image\Width,\Image\Hight,\color)
            DrawImage(ImageID(dummyimage),(\Image\Width-ImageWidth(dummyimage))/2,(\Image\Hight-ImageHeight(dummyimage))/2)
            StopDrawing()
            FreeImage(dummyimage)
          EndIf
          ; Im ImageGadget anzeigen
          SetGadgetState(\Gadget, ImageID(\Image\Image))
          
        Case 2 ; Resize Image ohne beibehaltung des verhältnis	(auf größe des ImageGadget)
          If IsImage(\Image\Image)
            FreeImage(\Image\Image)	
          EndIf 	
          \Image\Image=CopyImage(image,#PB_Any)
          ResizeImage(\Image\Image,\Width,\Hight)
          SetGadgetState(\Gadget, ImageID(\Image\Image))
          
        Case 3 ; Resize das ImageGadget auf die größe des Images
          If IsImage(\Image\Image)
            FreeImage(\Image\Image)	
          EndIf 	
          \Image\Image=CopyImage(image,#PB_Any)
          \Image\Width=ImageWidth(image)
          \Image\Hight=ImageHeight(image)
          \Width=\Image\Width
          \Hight=\Image\Hight	
          SetGadgetState(\Gadget, ImageID(\Image\Image))
          
        Case 4	; schneidet das Image auf ImageGadgetgröße am ende ab 
          If IsImage(\Image\Image)
            FreeImage(\Image\Image)	
          EndIf 	
          \Image\Image=GrabImage(image,#PB_Any,0,0,\Width,\Hight)
          \Image\Width=\Width
          \Image\Hight=\Hight
          SetGadgetState(\Gadget, ImageID(\Image\Image))
          
      EndSelect
      If \border
        Rahmen3D(*dummy)
      EndIf 	
    EndWith	
  EndProcedure
  
  Procedure	Im_GraImageToGadget		(Gadget,Image,x,y,b=#PB_Ignore,h=#PB_Ignore)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    Protected check.i
    If IsImage(Image)
      With *dummy
        If IsImage(\Image\Image)
          FreeImage(\Image\Image)
        EndIf
        If b=#PB_Ignore : check=1 : EndIf 
        If h=#PB_Ignore : check+2 : EndIf 
        If \rb
          b-4 : h-4
        EndIf	
        Select check
          Case 0
            \Image\Image=GrabImage(image,#PB_Any,x,y,b,h)
          Case 1	
            \Image\Image=GrabImage(image,#PB_Any,x,y,\Image\Width,h)
          Case 2	
            \Image\Image=GrabImage(image,#PB_Any,x,y,b,\Image\Hight)
          Case 3
            \Image\Image=GrabImage(image,#PB_Any,x,y,\Image\Width,\Image\Hight)
        EndSelect		
        SetGadgetState(\Gadget, ImageID(\Image\Image))
        Rahmen3D(*dummy)
      EndWith
    EndIf 		
  EndProcedure	
  
  Procedure 	Im_LinkImageToGadget		(Gadget,Image)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    *dummy\QuellImage=Image
    Im_UpdateImageGadget(*dummy\Gadget)
  EndProcedure
  
  Procedure 	Im_HideImageGadget		(Gadget,flags)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    With *dummy
      If \rb
        HideGadget(\frame,flags)
      EndIf 	
      HideGadget(\Gadget,flags)
      If \SliderH\Slider<>-1
        HideGadget(\SliderH\Slider,flags)
      EndIf 
      If \SliderV\Slider<>-1
        HideGadget(\SliderV\Slider,flags)
      EndIf 	
    EndWith	
  EndProcedure
  
  Procedure 	Im_ResizeImageGadget		(Gadget,x,y,b,h)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    With *dummy
      If Not x=#PB_Ignore : \x=x : EndIf 
      If Not y=#PB_Ignore  : \y=y : EndIf 			
      If Not b=#PB_Ignore : \Width=b : EndIf 
      If Not h=#PB_Ignore  : \Hight=h : EndIf 				
      If \rb
        If Not x=#PB_Ignore : \x=x+2 : EndIf 
        If Not y=#PB_Ignore  : \y=y +2: EndIf 					
        If Not b=#PB_Ignore : \Width=b-2 : EndIf 
        If Not h=#PB_Ignore  : \Hight=h-2 : EndIf 
        ResizeGadget(\frame,\x-2,\y-2,\Width+2,\Hight+2)
      EndIf 	
      ; Slider an die neue größe anpassen wenn vorhanden
      If \SliderH\Slider<>-1 And \SliderV\Slider<>-1
        If \rb
          If Not b=#PB_Ignore : \Width=b-22 : EndIf 
          If Not h=#PB_Ignore : \Hight=h-22  : EndIf 					
          ResizeGadget(\SliderH\Slider, \x, \y+\Hight+2, \Width, 16)
          ResizeGadget(\SliderV\Slider, \x+\Width+2, \y, 16, \Hight)					
        Else
          If Not b=#PB_Ignore : \Width=b-20 : EndIf 
          If Not h=#PB_Ignore : \Hight=h-20  : EndIf 
          ResizeGadget(\SliderH\Slider, \x, \y+\Hight + 2, \Width, 16)
          ResizeGadget(\SliderV\Slider, \x+\Width + 2, \y, 16, \Hight)					
        EndIf 	
        
        ;Slider Inhalt an QuellImage neu anpassen
        If IsImage(\QuellImage)
          Im_SetSliderValue(\SliderH,ImageWidth(\QuellImage),\Width,\SliderH\Min)
          Im_SetSliderValue(\SliderV,ImageHeight(\QuellImage),\Hight,\SliderV\Min)
        EndIf 				
      EndIf 
      ; Gadget Image löschen und mit der neuen größe wieder erstellen 
      If IsImage(\Image\Image)
        If Not b=#PB_Ignore Or Not h=#PB_Ignore
          FreeImage(\Image\Image)
          \Image\Image=CreateImage(#PB_Any,\Width,\Hight,32) 
          \Image\Width=\Width
          \Image\Hight=\Hight
          If StartDrawing(ImageOutput(\Image\Image))
            Box(0,0,\Image\Width,\Image\Hight,\color)
            StopDrawing()
          EndIf 						
        EndIf
        If IsImage(\QuellImage)
          Im_UpdateImageGadget(*dummy\Gadget)
        Else 	
          SetGadgetState(\Gadget, ImageID(\Image\Image))
        EndIf 	
      EndIf 	
      If \border
        ResizeGadget(\Gadget,\x,\y,\Width+4,\Hight+4)
      Else
        ResizeGadget(\Gadget,\x,\y,\Width,\Hight)
      EndIf 			
    EndWith
    
  EndProcedure
  
  Procedure	Im_SetBackcolorGadget		(Gadget,color)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    With *dummy
      If IsImage(\Image\Image)			
        If StartDrawing(ImageOutput(\Image\Image))
          Box(0,0,\Image\Width,\Image\Hight,color)
          StopDrawing()
          SetGadgetState(\Gadget, ImageID(\Image\Image))
          If \border
            Rahmen3D(*dummy)
          EndIf 	
        EndIf
        \color=color
      EndIf 	
    EndWith	
  EndProcedure
  
  Procedure 	Im_GetImageGadgetSlider	(Gadget,Slider)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    If Slider=0
      ProcedureReturn *dummy\SliderH
    Else
      ProcedureReturn *dummy\SliderV
    EndIf 	
  EndProcedure	
  
  Procedure 	Im_GetSliderVGadget			(Gadget)
    Protected *dummy.GadgetImage=GetGadgetData(Gadget)
    ProcedureReturn *dummy\SliderV
  EndProcedure
  
  Procedure 	Im_NewImageGadget			(Gadget,x, y, b, h, img = 0, scroll = 0,border=0)
    ;Speicher reservieren
    Protected *this.GadgetImage	=	AllocateMemory(SizeOf(GadgetImage))
    ; Dummy Slider Variable als Zwischenspeicher Definieren
    Protected *dummy.slider
    If (Not *this)
      ProcedureReturn #False
    EndIf 
    ;Structuren bereitstellen 
    InitializeStructure(*this,image)
    InitializeStructure(*this,slider)
    ;erstellen des Imagegadget
    With *this
      \x			= x
      \y				= y
      \Width		= b
      \hight		= h
      \factor		= 1.0
      \color		=$BFC5CD
      \border	=border
      If scroll And border
        \x			= x+2
        \y				= y+2				
        \Width		= b - 22
        \Hight		= h - 22
        \rb			=2
        CompilerSelect #PB_Compiler_Version 
          CompilerCase 521	
            \frame		= Frame3DGadget(#PB_Any,x,y,b,h,"",#PB_Frame3D_Double )
          CompilerDefault
            \frame		= FrameGadget(#PB_Any,x,y,b,h,"",#PB_Frame_Double )
        CompilerEndSelect	
        If Gadget=#PB_Any 
          \Gadget	= ImageGadget(#PB_Any, x+2, y+2, b-2, h-2,0)
          SetGadgetData(\Gadget,*this)
        Else  
          ImageGadget(Gadget, x+2, y+2, b-2, h-2,0)
          \Gadget=Gadget
          SetGadgetData(Gadget,*this)
        EndIf 	
      Else
        If Gadget=#PB_Any
          \Gadget	= ImageGadget(#PB_Any, x, y, b, h,0,border)
          SetGadgetData(\Gadget,*this)
        Else
          \Gadget=Gadget
          ImageGadget(Gadget, x, y, b, h,0,border)
          SetGadgetData(Gadget,*this)
        EndIf 	
      EndIf 				
      ;Slider erstellen wenn erwünscht
      If scroll 
        If  \rb
          ;Slider erstellen,zwischenspeichern und im ImageGadget speichern
          *dummy=NewSlider(\x, \y+\Hight + 2 , \Width, 16, \Width,0, 0)
          \SliderH\Slider=*dummy\Slider
          *dummy=NewSlider(\x+\Width + 2 , \y, 16, \Hight, \Hight,0, 1)
          \SliderV\Slider=*dummy\Slider
        Else 
          \Width	= b - 20
          \Hight	= h - 20					
          *dummy=NewSlider(\x, \y+\Hight + 2, \Width, 16, \Width,0, 0)
          \SliderH\Slider=*dummy\Slider
          *dummy=NewSlider(\x+\Width +2, \y, 16, \Hight, \Hight,0, 1)
          \SliderV\Slider=*dummy\Slider				
        EndIf 
        ;Event Infomation an das ImageGadget heften
        SetGadgetData(\SliderH\Slider, *this)
        SetGadgetData(\SliderV\Slider, *this)
        ;Event auslöser an eine Procedure heften
        BindGadgetEvent(\SliderH\Slider, @ImageGadgetSliderEvent())				
        BindGadgetEvent(\SliderV\Slider, @ImageGadgetSliderEvent())
      Else 
        \SliderH\Slider=-1
        \SliderV\Slider=-1
      EndIf
      ; Image erstellen wenn erwünscht
      If Img
        \Image\Image	= CreateImage(#PB_Any, \Width, \Hight, 32)	
        \Image\Width	= \Width
        \Image\Hight	= \Hight
        \Image\x			= 0
        \Image\y			= 0		
        ; Hintergrundfarbe Zeichenen
        If StartDrawing(ImageOutput(\Image\Image))
          Box(0,0,\Image\Width,\Image\Hight,\color)
          StopDrawing()
        EndIf
        ;image im ImageGadget anzeigen
        SetGadgetState(\Gadget, ImageID(\Image\Image))
        If \border
          Rahmen3D(*this)
        EndIf 				
      EndIf	
    EndWith
    
    ProcedureReturn *this\Gadget
  EndProcedure	
  
EndModule	

;-Example
CompilerIf #PB_Compiler_IsMainFile
  UseModule			Image_gadget
  
  
  EnableExplicit
  
  UseJPEGImageDecoder() 
  ;hier ein Image Laden (Minimum 1024*768)
  Define Bild.s=OpenFileRequester("Bild Datei Laden Minimum 1024*768 größe !", "", "*.jpg",0)
  Define OrginalImage=LoadImage(#PB_Any,Bild.s)
  ;Define OrginalImage=LoadImage(#PB_Any,"d:\Grafik\Bilder&Filme\unreal.bmp")
  
  Dim sGadget(5)
  
  If OpenWindow(0, 0, 0, 855, 600, "ImageGadget Modul v0.8 ", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;Gadget 1
    sGadget(0)= Im_NewImageGadget(#PB_Any,10,30, 200,200,1,0,#PB_Image_Raised)
    TextGadget(0, 10,  0, 200, 30, "ImageGadget mit erhobenen Rahmen und SetImageToGadget=1 (Fit Proportional)", #PB_Text_Center)
    ;Im_ResizeImageGadget(sGadget(0),0,30,100,#PB_Ignore)
    Im_SetImageToGadget(sGadget(0),OrginalImage,1)
    ; Gadget 2
    sGadget(1)= Im_NewImageGadget(#PB_Any,220,30, 200,200,1,0,#PB_Image_Border)
    TextGadget(1, 220,  0, 200, 30, "ImageGadget mit vertieften Rahmen und SetImageToGadget=2 (Fit to Gadget)", #PB_Text_Center)
    Im_SetImageToGadget(sGadget(1),OrginalImage,2)
    ; Gadget 3 
    sGadget(2)= Im_NewImageGadget(#PB_Any,430,30, 202,202,1,0)
    TextGadget(2, 430,  0, 200, 30, "ImageGadget ohne Rahmen und GrabImageToGadget ", #PB_Text_Center)
    Im_GraImagetoGadget(sGadget(2),OrginalImage,700,0)
    ; Gadget 4
    sGadget(3)= Im_NewImageGadget(#PB_Any,640,30, 80,80,1)
    TextGadget(3, 640,  0, 200, 30, "ImageGadget ohne Rahmen und GrabImageToGadget mit Breite/höhe ", #PB_Text_Center)
    Im_GraImagetoGadget(sGadget(3),OrginalImage,700,200,202,202)
    ; Gadget 5
    sGadget(4)= Im_NewImageGadget(#PB_Any,10,270, 410,300,1,1)
    TextGadget(4, 10,  250, 410, 30, "ImageGadget ohne Rahmen mit Slider und LinkImageToGadget ", #PB_Text_Center)
    Im_LinkImageToGadget(sGadget(4),OrginalImage)
    Im_ResizeImageGadget(sGadget(4),10,270,#PB_Ignore,#PB_Ignore)
    ; Gadget 6
    Define scale.f=2.0
    sGadget(5)= Im_NewImageGadget(#PB_Any,430,270, 410,300,1,1,#PB_Image_Raised)
    TextGadget(5, 430,  250, 410, 30, "ImageGadget mit Rahmen sowie Slider und LinkImageToGadget mit Scale=2", #PB_Text_Center)
    Im_LinkImageToGadget(sGadget(5),OrginalImage)	
    Im_SetScaleToGadget(sGadget(5),scale)	
    ButtonGadget(6, 430,574, 200, 20, "Zoom In")
    ButtonGadget(7, 640,574, 200, 20, "Zoom Out")
  EndIf 
  
  Repeat
    Define Event=WaitWindowEvent()	
    If event = #PB_Event_CloseWindow
      Define Quit=#True
    EndIf 
    If event=#PB_Event_Gadget
      Select EventGadget()
        Case sGadget(0)
          Debug "GadgetID="+sGadget(0)
        Case sGadget(1)
          Debug "GadgetID="+sGadget(1)
        Case 6 ;button Zoom In
          scale+0.1 
          If scale>40 : scale=40 : EndIf
          Im_SetScaleToGadget(sGadget(5),scale)
        Case 7	;button Zoom Out
          scale-0.1
          If scale<0.1 : scale=0.1 : EndIf 
          Im_SetScaleToGadget(sGadget(5),scale)	
      EndSelect 
    EndIf 
    
  Until  Quit=#True
CompilerEndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 608
; FirstLine = 586
; Folding = -----
; EnableUnicode
; EnableXP
; EnableCompileCount = 2
; EnableBuildCount = 0
; EnableExeConstant