--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ), --320 480
      height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ), --480 320 
      scale = "letterbox",
      fps = 60,

      imageSuffix = {
         ["@2x"] = 2.0,
         ["@4x"] = 4.0,
      },
   },
   license = {
      google = {
         key = "reallylonggooglelicensekeyhere",
         policy = "serverManaged", 
      },
   },
}
