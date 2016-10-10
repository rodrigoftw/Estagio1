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
            -- run1
            x=2,
            y=2,
            width=36,
            height=56,

        },
        {
            -- run2
            -- x=40,
			x=2,
            y=2,
            width=36,
            height=56,

        },
        {
            -- run3
            -- x=78,
			x=2,
            y=2,
            width=36,
            height=56,

        },
    },
    
    sheetContentWidth = 116,
    sheetContentHeight = 60
}

SheetInfo.frameIndex =
{

    ["run1"] = 1,
    ["run2"] = 2,
    ["run3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
