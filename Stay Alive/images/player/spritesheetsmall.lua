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
            -- spritesheet
            x=2,
            y=2,
            width=45,
            height=16,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 45,
            sourceHeight = 16
        },
    },
    
    sheetContentWidth = 49,
    sheetContentHeight = 20
}

SheetInfo.frameIndex =
{

    ["spritesheet"] = 1,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
