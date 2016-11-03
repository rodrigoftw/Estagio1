-------------------------------------------------------------------------------
-- endofphase.lua
-------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        -- parent:resumeGame()
    end
end

local function handleRestartButtonEvent( event )
    if ( event.phase == "began" ) then
        audio.play(buttonToggle)
    elseif ( event.phase =="ended" ) then
        map.destroy()
        composer.removeScene( parent, false )
        composer.gotoScene( parent, { effect = "crossFade", time = 333 })
        -- By some method (a "restart" button, for example), hide the overlay
		composer.hideOverlay( "fade", 400 )
    end
end

local function handleMenuButtonEvent( event )
    if ( event.phase == "began" ) then
        audio.play(buttonToggle)
    elseif ( event.phase =="ended" ) then
        map.destroy()
        composer.removeScene( parent, false )
        composer.gotoScene( parent, { effect = "crossFade", time = 333 })
        -- By some method (a "restart" button, for example), hide the overlay
		composer.hideOverlay( "fade", 400 )
    end
end

-- Create the widget
local restartButton = widget.newButton({
    id = "restartButton",
    label = "Reiniciar",
    labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
    width = 100,
    height = 32,
    emboss = false,
    shape = "roundedRect",
    cornerRadius = 2,
    fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
    strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
    onEvent = handleRestartButtonEvent
})
restartButton.x = display.contentCenterX - 80
restartButton.y = display.contentCenterY + 40
restartButton:toFront()
sceneGroup:insert( restartButton )

-- Create the widget
local menuButton = widget.newButton({
    id = "menuButton",
    label = "Reiniciar",
    labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
    width = 100,
    height = 32,
    emboss = false,
    shape = "roundedRect",
    cornerRadius = 2,
    fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
    strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
    onEvent = handleMenuButtonEvent
})
menuButton.x = display.contentCenterX + 80
menuButton.y = display.contentCenterY + 40
menuButton:toFront()
sceneGroup:insert( menuButton )

scene:addEventListener( "hide", scene )
return scene