local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
local dusk = require("Dusk.Dusk")
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
-- local ads = require( "ads" )

local params

-- local TOP_REF = 0
-- local BOTTOM_REF = 1
-- local LEFT_REF = 0
-- local RIGHT_REF = 1
-- local CENTER_REF = 0.5

-- physics.start()
-- physics.setGravity( 0, 9.8 )

display.setDefault("minTextureFilter", "nearest")
display.setDefault("magTextureFilter", "nearest")

local myData = require( "mydata" )

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.

    --------------------------------------------------------------------------------
    -- Background
    --------------------------------------------------------------------------------

    background = display.newImageRect( "maps/menu_grass.png", _W, _H )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    --------------------------------------------------------------------------------
    -- Clouds
    --------------------------------------------------------------------------------

    clouds = display.newImageRect( "maps/clouds.png", _W, _H )
    clouds.x = display.contentCenterX
    clouds.y = display.contentCenterY
    clouds:toFront()
    sceneGroup:insert( clouds )

    -- speed = 1

    -- function moveClouds()

    --     clouds.x = clouds.x - speed
    --     if (clouds.x < -(_W/2)) then
    --         clouds.x = _W + (1.1 * _W)
    --     end
    -- end
    -- Runtime:addEventListener( "enterFrame", moveClouds )


    -- --------------------------------------------------------------------------------
    -- -- Mapa
    -- --------------------------------------------------------------------------------

    -- local currMap = "menu_grass.json"
    -- map = dusk.buildMap("maps/"..currMap)
    -- map:toBack()

    -- -- dusk.setPreference("virtualObjectsVisible", true)
    -- dusk.setPreference("enableTileCulling", false)
    -- dusk.setPreference("scaleCameraBoundsToScreen", true)
    -- dusk.setPreference("enableCamera", true)
    -- dusk.setPreference("detectMapPath", true)

    -- --------------------------------------------------------------------------------
    -- -- Set Map
    -- --------------------------------------------------------------------------------
    -- local function setMap(mapName)
    --     mapX, mapY = map.getViewpoint()
    --     Runtime:removeEventListener("enterFrame", map.updateView)
    --     map.destroy()
    --     map = dusk.buildMap("maps/" .. mapName)
    --     currMap = mapName
    --     map.setViewpoint(mapX, mapY)
    --     map.snapCamera()
    --     map.setTrackingLevel(0.3)
    --     map:addEventListener("touch", mapTouch)
    --     Runtime:addEventListener("enterFrame", map.updateView)
    -- end

    -- playerCollisionFilter = { categoryBits = 1, maskBits = 2 }
    -- wallCollisionFilter = { categoryBits = 2, maskBits = 1 }

    -- -- local player = map.layer["Player"].tile(2, 9)--11, 7) -- Level 2: (2, 4) -- Level 3: (2, 4) -- Level 4: (2, 7)
    -- -- player.bodyType = "dynamic"
    -- -- player.bounce = 0
    -- -- player.friction = 10
    -- -- player.collision = onCollision
    -- -- player.isFixedRotation = true

    -- -------------------------------------------------------------------------------
    -- -- Start
    -- -------------------------------------------------------------------------------

    -- local start = map.layer["Start"].tile(2, 7)
    -- -- start.bodyType = "static"
    -- -- start.bounce = 0
    -- -- start.alpha = 0.75
    -- -- start.type = "start"
    -- -- start.collision = onCollision
    -- -- start.isFixedRotation = true

    -- -------------------------------------------------------------------------------
    -- -- End
    -- -------------------------------------------------------------------------------

    -- local ending = map.layer["End"].tile(17, 7)
    -- ending.bodyType = "static"
    -- ending.bounce = 0
    -- ending.alpha = 0.75
    -- ending.type = "end"
    -- ending.collision = onCollision
    -- ending.isFixedRotation = true

    -- local centerX, centerY = map.getViewpoint()
    -- local top = centerY - display.contentCenterY
    -- local bottom = centerY + display.contentCenterY
    -- local left = centerX - display.contentCenterX
    -- local right = centerX + display.contentCenterX

    -- map.setCameraBounds({
    --     xMin = display.contentCenterX,
    --     yMin = display.contentCenterY,
    --     xMax = map.data.width - display.contentCenterX,
    --     yMax = map.data.height - display.contentCenterY
    --     -- Use map.data.width because that's the "real" width of the map - 
    --     -- map.width changes when culling kicks in yMax = map.data.height - display.contentCenterY -- Same here
    -- })

    -- local tile = {
    --     map.layer["Clouds"].tile(3, 3),
    --     map.layer["Clouds"].tile(3, 4),
    --     map.layer["Clouds"].tile(4, 3),
    --     map.layer["Clouds"].tile(3, 4),
    --     map.layer["Clouds"].tile(5, 4),

    --     map.layer["Clouds"].tile(8, 6),
    --     map.layer["Clouds"].tile(8, 7),

    --     map.layer["Clouds"].tile(10, 2),
    --     map.layer["Clouds"].tile(11, 2),
    --     map.layer["Clouds"].tile(10, 3),
    --     map.layer["Clouds"].tile(11, 3),
    --     map.layer["Clouds"].tile(12, 3),

    --     map.layer["Clouds"].tile(16, 3),
    --     map.layer["Clouds"].tile(17, 3)
    -- } 

    -- map.layer["Player"].xParallax = 1
    -- map.layer["End"].xParallax = 1
    -- map.layer["Start"].xParallax = 1
    -- map.layer["Walls"].xParallax = 1
    -- map.layer["Floors"].xParallax = 1
    -- map.layer["Background"].xParallax = 1

    -- speed = 1

    -- function moveClouds()
    --     for tile in map.layer["Clouds"].tilesInRect(0, 0, _W, _H) do
    --         tile.x = tile.x - speed
    --         -- tile.xParallax = 2
    --         -- repeat--081120167015806
    --         -- until tile.x < -20
            
    --             -- tile:translate(_W + 20, 0)
    --             -- tile.x = _W + 20
    --             -- tile.x = tile.x -1
    --             -- tile.x:translate(display.contentWidth + display.contentWidth, 0)
            
    --         if (tile.x < -20) then
    --             tile.x = _W + 20
    --         end
    --     end
    -- end
    -- Runtime:addEventListener( "enterFrame", moveClouds )

    local function handlePlayButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then
            --map.destroy()
            composer.removeScene( "levelselect", false )
            composer.gotoScene("levelselect", { effect = "crossFade", time = 333 })
        end
    end

    local function handleHelpButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("help", { effect = "crossFade", time = 333, isModal = true })
        end
    end

    local function handleCreditsButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
        end
    end

    local function handleSettingsButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("gamesettings", { effect = "crossFade", time = 333 })
        end
    end

    local function handleQuitButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then
            -- Handler that gets notified when the alert closes
            local function onComplete( event )
                if ( event.action == "clicked" ) then
                    local i = event.index
                    if ( i == 1 ) then
                        -- Do nothing; dialog will simply dismiss
                    elseif ( i == 2 ) then
                        -- Quit game
                        native.requestExit()
                    end
                end
            end     
            -- Show alert with two buttons
            local alert = native.showAlert( "Deseja realmente sair?", "Que tal jogar mais um pouco? :)", { "Continuar Jogando", "Sair" }, onComplete )

            -- Dismisses alert after 10 seconds
            local function cancelAlert()
                native.cancelAlert( alert )
            end
            timer.performWithDelay( 10000, cancelAlert )
        end
    end

    local title = display.newText("Stay Alive!", 100, 32, "Roboto-Regular.ttf", 56 )
    title.x = display.contentCenterX
    title.y = 80
    title:setFillColor( 0 )
    title:toFront()
    sceneGroup:insert( title )

    -- Create the widget
    local playButton = widget.newButton({
        id = "button1",
        label = "Jogar",
        font = "Roboto-Regular.ttf",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handlePlayButtonEvent
    })
    playButton.x = display.contentCenterX - 80
    playButton.y = display.contentCenterY + 40
    playButton:toFront()
    sceneGroup:insert( playButton )

    -- Create the widget
    local settingsButton = widget.newButton({
        id = "button2",
        font = "Roboto-Regular.ttf",
        label = "Opções",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleSettingsButtonEvent
    })
    settingsButton.x = display.contentCenterX + 80
    settingsButton.y = display.contentCenterY + 40
    settingsButton:toFront()
    sceneGroup:insert( settingsButton )

    -- Create the widget
    local helpButton = widget.newButton({
        id = "button3",
        font = "Roboto-Regular.ttf",
        label = "Ajuda",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleHelpButtonEvent
    })
    helpButton.x = display.contentCenterX - 170
    helpButton.y = display.contentCenterY + 110
    helpButton:toFront()
    sceneGroup:insert( helpButton )

    -- Create the widget
    local creditsButton = widget.newButton({
        id = "button4",
        font = "Roboto-Regular.ttf",
        label = "Créditos",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleCreditsButtonEvent
    })
    creditsButton.x = display.contentCenterX + 170
    creditsButton.y = display.contentCenterY + 110
    creditsButton:toFront()
    sceneGroup:insert( creditsButton )

    local quitButton = widget.newButton({
        id = "button5",
        font = "Roboto-Regular.ttf",
        label = "Sair",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleQuitButtonEvent
    })
    quitButton.x = display.contentCenterX
    quitButton.y = display.contentCenterY + 110
    quitButton:toFront()
    sceneGroup:insert( quitButton )

end

function scene:show( event )
    local sceneGroup = self.view
    phase = event.phase

    params = event.params
    utility.print_r(event)
    audio.play( titleMusic, { channel = 1, loops = -1 } )

    -- if params then
    --     print(params.someKey)
    --     print(params.someOtherKey)
    -- end
    if phase == "will" then
        -- Called when the scene is off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc

        print("_________________________")
        print("          Menu")
        print("_________________________")
        
        -- audio.stop( 2 )
        -- audio.dispose( 2 )
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

        physics.start()
        physics.stop()

        -- audio.stop( 2 )
        -- audio.dispose( 2 )
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

    -- audio.stop( 2 )
    -- audio.dispose( 2 )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
