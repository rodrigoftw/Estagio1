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

    --------------------------------------------------------------------------------
    -- Background
    --------------------------------------------------------------------------------

    background = display.newImageRect( "maps/menu_grass.png", _W, _H )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    clouds = display.newImageRect( "maps/clouds.png", _W, _H )
    clouds.x = display.contentCenterX * 3
    clouds.y = display.contentCenterY
    clouds:toFront()
    sceneGroup:insert( clouds )

    local speed = 0

    function moveClouds()

        speed = 1

        clouds.x = clouds.x - speed
        if (clouds.x < -(_W/2)) then
            clouds.x = _W + (1.1 * _W)
        end
    end
    Runtime:addEventListener( "enterFrame", moveClouds )

    local endingtitle = display.newText("                                         Parabéns!\nVocê finalizou a versão de demonstração do Stay Alive!", 100, 32, "Roboto-Regular.ttf", 16 )
    endingtitle.x = centerX
    endingtitle.y = centerY - 50--80
    endingtitle:setFillColor( 0 )
    endingtitle.alpha = 1
    endingtitle:toFront()
    sceneGroup:insert( endingtitle )

    local endingtitle2 = display.newText("O final só será exibido quando o jogo estiver pronto. :)", 100, 32, "Roboto-Regular.ttf", 16 )
    endingtitle2.x = centerX
    endingtitle2.y = centerY - 20
    endingtitle2:setFillColor( 0 )
    endingtitle2.alpha = 1
    endingtitle2:toFront()
    sceneGroup:insert( endingtitle2 )

    -------------------------------------------------------------------------------
    -- Buttons
    -------------------------------------------------------------------------------

    local menuButton = display.newImageRect( "images/ui/MenuButton.png", 56, 56 )
    menuButton.x = centerX
    menuButton.y = centerY + 72
    menuButton:toFront()
    sceneGroup:insert( menuButton )

    function titleBlink()
        if(endingtitle.alpha > 0) then
            transition.to( endingtitle, {time=400, alpha=0})
            transition.to( endingtitle2, {time=400, alpha=0})
        else
            transition.to( endingtitle, {time=250, alpha=1})
            transition.to( endingtitle2, {time=250, alpha=1})
        end
    end
    local titleTimer = timer.performWithDelay( 300, titleBlink, 0 )

    -------------------------------------------------------------------------------
    -- Functions
    -------------------------------------------------------------------------------

    function toMenu(event)
        if (event.phase == "began") then
            
            audio.play(buttonToggle, { channel = 7 } )
            audio.stop( 2 )
            audio.dispose( 2 )
            -- background:toBack()
            -- endingtitle:toBack()
            -- endedTimeText:toBack()
            -- menuButton:toBack()
            -- restartButton:toBack()
            -- nextButton:toBack()
            -- background:removeSelf()
            -- endingtitle:removeSelf()
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
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is off screen and is about to move on screen
        audio.stop( 1 )
        audio.dispose( 1 )
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
        audio.play( ending, { channel = 6, loops = 0 } )
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

        audio.stop( 6 )
        audio.dispose( 6 )

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
    speed = nil
    background = nil
    endingtitle = nil
    menuButton = nil
end

-------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-------------------------------------------------------------------------------

return scene