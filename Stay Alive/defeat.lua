-------------------------------------------------------------------------------
--
-- victory.lua
--
-------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local dusk = require("Dusk.Dusk")
local myData = require( "mydata" )

local params

-------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

    -- local background = display.newRect( centerX, centerY, 260, 250 )
    -- background:setFillColor( 1 )

    local background = display.newImageRect( "maps/background_ui_small.png", _W, _H + 40 )
    background.x = centerX
    background.y = centerY + 5
    background:toFront()
    sceneGroup:insert( background )

    local losetitle = display.newText("Você perdeu!", 100, 32, "Roboto-Regular.ttf", 26 )
    losetitle.x = centerX
    losetitle.y = centerY - 50--80
    losetitle:setFillColor( 0 )
    losetitle.alpha = 1
    losetitle:toFront()
    sceneGroup:insert( losetitle )
    
    -- local endedTimeText = display.newText("Seu tempo foi de: ", 100, 32, "Roboto-Regular.ttf", 14 )
    -- endedTimeText.x = centerX
    -- endedTimeText.y = centerY - 50--80
    -- endedTimeText:setFillColor( 0 )
    -- endedTimeText:toFront()

    function blink()
        if(losetitle.alpha > 0) then
            transition.to( losetitle, {time=50, alpha=0})
        else
            transition.to( losetitle, {time=50, alpha=1})
        end
    end
    local tmr = timer.performWithDelay( 300, blink, 0 )

    -------------------------------------------------------------------------------
    -- Buttons
    -------------------------------------------------------------------------------

    local menuButton = display.newImageRect( "images/ui/MenuButton.png", 56, 56 )
    menuButton.x = centerX
    menuButton.y = centerY + 72
    menuButton:toFront()
    sceneGroup:insert( menuButton )

    -- local restartButton = display.newImageRect( "images/ui/RestartButton.png", 56, 56 )
    -- restartButton.x = centerX
    -- restartButton.y = centerY + 72
    -- restartButton:toFront()
    -- sceneGroup:insert( restartButton )

    -- local nextButton = display.newImageRect( "images/ui/NextButton.png", 56, 56 )
    -- nextButton.x = centerX + 72
    -- nextButton.y = centerY + 72
    -- nextButton:toFront()
    -- sceneGroup:insert( nextButton )

    -------------------------------------------------------------------------------
    -- Functions
    -------------------------------------------------------------------------------

    function toMenu(event)
        if (event.phase == "began") then
            
            audio.play(buttonToggle, { channel = 7 } )
            audio.stop( 2 )
            audio.dispose( 2 )
            -- background:toBack()
            -- losetitle:toBack()
            -- endedTimeText:toBack()
            -- menuButton:toBack()
            -- restartButton:toBack()
            -- nextButton:toBack()
            -- background:removeSelf()
            -- losetitle:removeSelf()
            -- endedTimeText:removeSelf()
            -- menuButton:removeSelf()
            -- restartButton:removeSelf()
            -- nextButton:removeSelf()
            -- endedTimeText:removeSelf()
        elseif (event.phase == "ended") then
            -- map.destroy()
            composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
        end
    end
    menuButton:addEventListener("touch", toMenu)

    -- function restartLevel(event)
    --     if (event.phase == "began") then
        
    --         audio.play(buttonToggle, { channel = 7 } )
    --         audio.stop( 2 )
    --         audio.dispose( 2 )
    --     elseif (event.phase == "ended") then

    --     composer.gotoScene( "levels.level1", { effect = "crossFade", time = 333 } )

    --         -- background:removeSelf()
    --         -- losetitle:removeSelf()
    --         -- endedTimeText:removeSelf()
    --         -- menuButton:removeSelf()
    --         -- restartButton:removeSelf()
    --         -- nextButton:removeSelf()
    --         -- endedTimeText:removeSelf()
    --         -- composer.gotoScene( "reload_game", { effect = "crossFade", time = 333 } )
    --     end
    -- end
    -- restartButton:addEventListener("touch", restartLevel)

    -- function nextLevel(event)
    --     if (event.phase == "began") then
            
    --         audio.play(buttonToggle, { channel = 7 } )
    --         audio.stop( 2 )
    --         audio.dispose( 2 )
    --     elseif (event.phase == "ended") then

    --         background:removeSelf()
    --         losetitle:removeSelf()
    --         endedTimeText:removeSelf()
    --         menuButton:removeSelf()
    --         restartButton:removeSelf()
    --         nextButton:removeSelf()
    --         map.destroy()
    --         composer.gotoScene( "levels.level2", { effect = "crossFade", time = 333 } )
    --     end
    -- end
    -- nextButton:addEventListener("touch", nextLevel)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)

    elseif phase == "did" then
        -- Called when the scene is now off screen
        -- menuButton:removeSelf()
        -- restartButton:removeSelf()
        -- nextButton:removeSelf()
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
    background = nil
    losetitle = nil
    endedTimeText = nil
    menuButton = nil
    -- restartButton = nil
    -- nextButton = nil
end

-------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-------------------------------------------------------------------------------

return scene