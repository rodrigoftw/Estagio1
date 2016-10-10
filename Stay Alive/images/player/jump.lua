--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:89a1bf7f13d902c90f503bb2c531b4b3:1322872e560ec0da9abcc67bdaedad35:7d98ba9467eea5163282f4663ed7a5c6$
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
            -- jump1
            x=2,
            y=2,
            width=31,
            height=60,

        },
        {
            -- jump2
            -- x=40,
			x=2,
            y=2,
            width=32,
            height=56,

        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 60
}

SheetInfo.frameIndex =
{

    ["jump1"] = 1,
    ["jump2"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
