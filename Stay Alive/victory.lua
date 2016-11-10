-------------------------------------------------------------------------------
--
-- victory.lua
--
-------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

-------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

    local background = display.newRect( centerX, centerY, 260, 250 )
    background:setFillColor( 0 )
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

        local menuButton = display.newRect( centerX - 72, centerY + 72, 56, 56 )
        menuButton.alpha = 0.5

        function toMenu(event)
            if (event.phase == "began") then
                audio.play(buttonToggle, { channel = 7 } )
                audio.stop( 2 )
                audio.dispose( 2 )
            elseif (event.phase == "ended") then
                map.destroy()
                composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
            end
        end
        menuButton:addEventListener("touch", toMenu)

        local restartButton = display.newRect( centerX, centerY + 72, 56, 56 )
        restartButton.alpha = 0.5

        function restartLevel(event)
            if (event.phase == "began") then
                audio.play(buttonToggle, { channel = 7 } )
                audio.stop( 2 )
                audio.dispose( 2 )
            elseif (event.phase == "ended") then
                composer.gotoScene( "reload_game", { effect = "crossFade", time = 333 } )
            end
        end
        restartButton:addEventListener("touch", restartLevel)

        local nextButton = display.newRect( centerX + 72, centerY + 72, 56, 56 )
        nextButton.alpha = 0.5

        function nextLevel(event)
            if (event.phase == "began") then
                audio.play(buttonToggle, { channel = 7 } )
                audio.stop( 2 )
                audio.dispose( 2 )
            elseif (event.phase == "ended") then
                map.destroy()
                composer.gotoScene( "levels.level2", { effect = "crossFade", time = 333 } )
            end
        end
        nextButton:addEventListener("touch", nextLevel)

    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

-------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-------------------------------------------------------------------------------

return scene