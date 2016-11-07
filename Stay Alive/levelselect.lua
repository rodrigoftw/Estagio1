local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local params

local function handleBackButtonEvent( event )
    if ( event.phase == "began" ) then
        audio.play(buttonToggle)
    elseif ( event.phase == "ended" ) then
        composer.removeScene( "menu", false )
        composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
    end
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
    -- local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    -- background.x = display.contentCenterX
    -- background.y = display.contentCenterY
    -- sceneGroup:insert(background)

    local selectLevelText = display.newText("Selecione um level", 125, 32, native.systemFontBold, 32)
    selectLevelText:setFillColor( 0 )
    selectLevelText.x = display.contentCenterX + 10
    selectLevelText.y = 50
    sceneGroup:insert(selectLevelText)

    local x = 0
    local y = 0
    local buttons = {}
    local buttonBackgrounds = {}
    local buttonGroups = {}
    local levelSelectGroup = display.newGroup()
    local cnt = 1
    for i = 1, myData.maxLevels do
        buttonGroups[i] = display.newGroup()
        buttonBackgrounds[i] = display.newRect( x, y, 42, 32, 8 )--Rounded
        buttonBackgrounds[i]:setFillColor(72/255,183/255,177/255,0.5)--0, 0, 0, 0.5)--1, 0, 1, 0.333 )
        buttonBackgrounds[i]:setStrokeColor(72/255,183/255,177/255,0.5)--0, 0, 0, 0.667)--1, 0, 1, 0.667 )
        buttonBackgrounds[i].strokeWidth = 1
        buttonGroups[i]:insert(buttonBackgrounds[i])
        buttonGroups[i].id = i
        if myData.settings.unlockedLevels == nil then
            myData.settings.unlockedLevels = 1
        end

        local function handleLevelSelect( event )
            if ( event.phase == "began" ) then
                audio.play(buttonToggle, { channel = 7 } )
                buttonBackgrounds[i]:setFillColor(255/255,127/255,39/255,0.5)
            elseif ( event.phase =="moved" ) then
                buttonBackgrounds[i]:setFillColor(72/255,183/255,177/255,0.5)
            elseif ( event.phase == "ended" ) then
                audio.fadeOut( { channel=1, time=1500 } )
                -- audio.stop( 1 )
                -- audio.dispose( 1 )
                -- set the current level to the ID of the selected level
                myData.settings.currentLevel = event.target.id

                local levNumber = tonumber(event.target.id)

                -- if (levNumber == 1) then
                --     audio.stop(titleMusic)
                --     audio.play(levels1_10)
                -- elseif (levNumber == 11) then
                --     audio.stop(levels1_10)
                --     audio.play(levels11_20)
                -- elseif (levNumber == 21) then
                --     audio.stop(levels11_20)
                --     audio.play(levels21_29)
                -- elseif (levNumber == 30) then
                --     audio.stop(levels21_29)
                --     audio.play(level30)
                -- end

                -- audio.stop(titleMusic)
                -- for levNumber = 1, 10 do
                --     audio.play(levels1_10)
                -- end

                -- audio.stop(levels1_10)
                -- for levNumber = 11, 20 do
                --     audio.play(levels11_20)
                -- end

                -- audio.stop(levels11_20)
                -- for levNumber = 21, 29 do
                --     audio.play(levels21_29)
                -- end

                -- if (levNumber == 30) then
                --     audio.stop(levels21_29)
                --     audio.play(level30)
                -- end

                local scene = "levels.level"..levNumber
         
                composer.removeScene( scene, false )
                composer.gotoScene( scene, { effect="crossFade", time=333 } )

                -- composer.removeScene( "game", false )
                -- composer.gotoScene( "game", { effect = "crossFade", time = 333 } )
            end
        end
        
        if i <= myData.settings.unlockedLevels then
            buttonGroups[i].alpha = 1.0
            buttonGroups[i]:addEventListener( "touch", handleLevelSelect )
        else
            buttonGroups[i].alpha = 0.5
        end
        buttons[i] = display.newText(tostring(i), 0, 0, native.systemFontBold, 28)
        buttons[i].x = x
        buttons[i].y = y
        buttonGroups[i]:insert(buttons[i])

        x = x + 55
        cnt = cnt + 1
        if cnt > 5 then
            cnt = 1
            x = 0
            y = y + 42
        end
        levelSelectGroup:insert(buttonGroups[i])
    end
    sceneGroup:insert(levelSelectGroup)
    levelSelectGroup.x = display.contentCenterX - 100
    levelSelectGroup.y = 110

    local backButton = widget.newButton({
        id = "backButton",
        label = "Voltar",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleBackButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentCenterY + 110
    sceneGroup:insert( backButton )
end

function scene:show( event )
    local sceneGroup = self.view
    phase = event.phase
    params = event.params

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
    end
end

function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc


    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
