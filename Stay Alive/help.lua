local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
 
local params 

local scrollView
local icons = {}


local function handleButtonEvent( event )

    if ( event.phase == "began" ) then
        audio.play(buttonToggle, { channel = 7 } )
    elseif ( event.phase == "ended" ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
    end
    return true
end

local function buttonListener( event )
    local id = event.target.id

    if event.phase == "moved" then
        local dx = math.abs( event.x - event.xStart ) -- Get the x-transition of the touch-input
        if dx > 5 then
            scrollView:takeFocus( event ) -- If the x- or y-transition is more than 5 put the focus to your scrollview
        end
    elseif event.phase == "ended" then
        -- do whatever you need to do if the object was touched
        print("object",id, "was touched")
        timer.performWithDelay( 10, function() scrollView:removeSelf(); scrollView = nil; end)
    end
    return true
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    -- local background = display.newRect( 0, 0, 570, 360 )
    -- background.x = display.contentCenterX
    -- background.y = display.contentCenterY
    -- sceneGroup:insert(background)
    -- sceneGroup:insert( background )
    -- sceneGroup:insert( background2 )

    --local title = display.newBitmapText( titleOptions )
    local title = display.newText("Ajuda", 125, 32, native.systemFontBold, 32)
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local backButton = widget.newButton({
        id = "button1",
        label = "Voltar",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentCenterY + 110
    sceneGroup:insert( backButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
