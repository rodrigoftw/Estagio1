--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:6da63bbed352d4e2823d5ab54d8336ec:11df32a4d99c9647724c5d89aa98bfd3:ece0d2ef682b236c674b564b3d9a2535$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- spritesheet1
            x=4,
            y=4,
            width=16,
            height=31,

            sourceX = 0,
            sourceY = 0,
            -- sourceWidth = 90,
			sourceWidth = 16,
            sourceHeight = 31
        },
		{
            -- spritesheet2
            x=21,
            y=5,
            width=16,
            height=29,
				
            sourceX = 0,
            sourceY = 0,
            -- sourceWidth = 90,
			sourceWidth = 16,
            sourceHeight = 31
        },
		{
            -- spritesheet3
            x=38,
            y=7,
            width=18,
            height=28,

            sourceX = 0,
            sourceY = 0,
            -- sourceWidth = 90,
			sourceWidth = 16,
            sourceHeight = 31
        },
		{
            -- spritesheet4
            x=57,
            y=7,
            width=18,
            height=28,

            sourceX = 0,
            sourceY = 0,
            -- sourceWidth = 90,
			sourceWidth = 16,
            sourceHeight = 31
        },
		{
            -- spritesheet5
            x=76,
            y=7,
            width=18,
            height=27,

            sourceX = 0,
            sourceY = 0,
            -- sourceWidth = 90,
			sourceWidth = 16,
            sourceHeight = 31
        },
    },
    
    sheetContentWidth = 98,
    sheetContentHeight = 40
}

SheetInfo.frameIndex =
{

    ["spritesheet1"] = 1,
	["spritesheet2"] = 2,
	["spritesheet3"] = 3,
	["spritesheet4"] = 4,
	["spritesheet5"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
