application =
{

	content =
	{
		width = 320,
		height = 480, 
		scale = "letterBox",
		fps = 30, -- 60 fps para uma experiência INSANA e cheia de bugs :P
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
