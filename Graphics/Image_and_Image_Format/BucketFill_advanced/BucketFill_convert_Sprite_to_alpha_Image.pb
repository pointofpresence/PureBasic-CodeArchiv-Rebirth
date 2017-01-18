XIncludeFile("./BucketFill_Image.pb")

; - Demo - Create a image with alpha channel from a sprite -

UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()

EnableExplicit

Define path$=OpenFileRequester("Select a picture", "", "", 0)
If path$="" : End : EndIf

Define image_ID=LoadImage(#PB_Any, path$)

Define percent_color_distance=26 ; Set here a color distance for deleting mask artefacts

Define result=BucketFill_Image::CreateAlphaImage_from_Sprite_BF(image_ID,
                                                                percent_color_distance)
BucketFill_Image::ErrorCheck_BF(result)

SaveImage(result, Left(path$, Len(path$)-4)+".png", #PB_ImagePlugin_PNG)
BucketFill_Image::ErrorCheck_BF(result)

; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 15
; EnableXP