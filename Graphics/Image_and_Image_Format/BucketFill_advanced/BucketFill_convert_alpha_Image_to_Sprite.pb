XIncludeFile("./BucketFill_Image.pb")

; - Demo - convert a image with alpha channel to a masked sprite -

UseJPEGImageDecoder() : UsePNGImageDecoder() : UseJPEGImageEncoder()

path$=OpenFileRequester("Select a picture with alpha channel", "", "", 0) ; Available gtk warning on linux you can ignore
If path$="" : End : EndIf

image_ID=LoadImage(#PB_Any, path$)
mode=0 ; mode=0 = Create the mask with BucketFill - mode=1 = create the mask with FloodFill
mask_color=$FF00FF ; Set a color for the sprite mask - different from the picture content
percent_color_distance=20; You can set a color distance for the background color in percent

; As sample for fine tuning, 20.3 percent works also

; The FloodFill mode works from the corners inward - the BucketFill mode over all 

result=BucketFill_Image::CreateSprite_from_AlphaImage_BF(mode, image_ID, mask_color, percent_color_distance)
BucketFill_Image::ErrorCheck_BF(result)

SaveImage(result, Left(path$, Len(path$)-4)+".jpg", #PB_ImagePlugin_JPEG, 10, 24)

; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 12
; EnableXP