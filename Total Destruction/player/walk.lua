--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4300f3cd9eae1cd68f9751d45baef3ad:452f629db2e1f8f9e3b764ea4d668398:82be497a8efde3899dfa252b51785f7f$
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
            -- walk
            x=1,
            y=1,
            width=140,
            height=64,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 139,
            sourceHeight = 64
        },
    },
    
    sheetContentWidth = 142,
    sheetContentHeight = 66
}

SheetInfo.frameIndex =
{

    ["walk"] = 1,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
