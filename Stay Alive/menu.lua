local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
local dusk = require("Dusk.Dusk")
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local ads = require( "ads" )

local params

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- local TOP_REF = 0
-- local BOTTOM_REF = 1
-- local LEFT_REF = 0
-- local RIGHT_REF = 1
-- local CENTER_REF = 0.5

-- physics.start()
-- physics.setGravity( 0, 9.8 )

display.setDefault("minTextureFilter", "nearest")
display.setDefault("magTextureFilter", "nearest")

wallCollisionFilter = { categoryBits = 2, maskBits = 1 }

local myData = require( "mydata" )

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
    -- sceneGroup:insert( background )

    -- set the background image
    -- background = display.newImage( "images/background/07.png", _W, _H )
    -- background:scale(0.5, 0.5)
    -- background.x = centerX + 132
    -- background.y = centerY - 15
    -- sceneGroup:insert( background )

    -- background2 = display.newImage( "images/background/07.png", _W, _H )
    -- background2:scale(0.5, 0.5)
    -- background2.x = (background.width/2) + centerX + 132
    -- background2.y = centerY - 15
    -- sceneGroup:insert( background2 )

    -- speed = 1

    -- function movebg()
    --   background.x = background.x - speed
    --   background2.x = background2.x - speed
    --     -- if(background.x == -360)then 
    --     --     background.x = 840 - speed
    --     -- elseif(background2.x == -360)then 
    --     --     background2.x = 840 - speed
    --     -- end
    --     if (background.x + centerX) < (display.contentWidth - display.contentWidth - 130) then
    --         background:translate(display.contentWidth + display.contentWidth + 300, 0)
    --     elseif (background2.x + centerX) < (display.contentWidth - display.contentWidth - 130) then
    --         background2:translate(display.contentWidth + display.contentWidth + 300, 0)
    --     end
    -- end
    -- Runtime:addEventListener( "enterFrame", movebg )

    -- local ground = display.newImageRect("images/background/ground.png", 580, 32)
    -- ground.width = 580
    -- ground.x = centerX
    -- ground.y = centerY + 145
    -- physics.addBody(ground, "static", {density=0, bounce=0.1, friction=.2, filter = groundCollisionFilter})
    -- ground.type = "ground"
    -- ground.collision = onCollision
    -- sceneGroup:insert( ground )

    -- local ground2 = display.newImageRect("images/background/ground.png", 580, 32)
    -- ground2.width = 580
    -- ground2.x = ground.width + 240
    -- ground2.y = centerY + 145
    -- physics.addBody(ground2, "static", {density=0, bounce=0.1, friction=.2, filter = groundCollisionFilter})
    -- ground2.type = "ground"
    -- ground2.collision = onCollision
    -- sceneGroup:insert( ground2 )


    -- local gspeed = 2

    -- function moveg()
    --   ground.x = ground.x - gspeed
    --   ground2.x = ground2.x - gspeed
    --     -- if(ground.x == -(1.4*centerX))then 
    --     --     ground.x = (4*centerX) - 35*gspeed
    --     -- elseif(ground2.x ==  -(1.4*centerX))then 
    --     --     ground2.x = (4*centerX) - 35*gspeed
    --     -- end
    --     if (ground.x + centerX) < (display.contentWidth - display.contentWidth - 90) then
    --         ground:translate(display.contentWidth + display.contentWidth + 384, 0)
    --     elseif (ground2.x + centerX) < (display.contentWidth - display.contentWidth - 90) then
    --         ground2:translate(display.contentWidth + display.contentWidth + 384, 0)
    --     end
    -- end
    -- Runtime:addEventListener( "enterFrame", moveg )

    --------------------------------------------------------------------------------
    -- Mapa
    --------------------------------------------------------------------------------

    local currMap = "menu_grass.json"
    map = dusk.buildMap("maps/"..currMap)
    map:toBack()

    -- dusk.setPreference("virtualObjectsVisible", true)
    dusk.setPreference("enableTileCulling", false)
    dusk.setPreference("scaleCameraBoundsToScreen", true)
    dusk.setPreference("enableCamera", true)
    dusk.setPreference("detectMapPath", true)

    --------------------------------------------------------------------------------
    -- Set Map
    --------------------------------------------------------------------------------
    local function setMap(mapName)
        mapX, mapY = map.getViewpoint()
        Runtime:removeEventListener("enterFrame", map.updateView)
        map.destroy()
        map = dusk.buildMap("maps/" .. mapName)
        currMap = mapName
        map.setViewpoint(mapX, mapY)
        map.snapCamera()
        map.setTrackingLevel(0.3)
        map:addEventListener("touch", mapTouch)
        Runtime:addEventListener("enterFrame", map.updateView)
    end

    playerCollisionFilter = { categoryBits = 1, maskBits = 2 }

    local player = map.layer["Player"].tile(2, 9)--11, 7) -- Level 2: (2, 4) -- Level 3: (2, 4) -- Level 4: (2, 7)
    player.bodyType = "dynamic"
    player.bounce = 0
    player.friction = 10
    player.collision = onCollision
    player.isFixedRotation = true

    local centerX, centerY = map.getViewpoint()
    local top = centerY - display.contentCenterY
    local bottom = centerY + display.contentCenterY
    local left = centerX - display.contentCenterX
    local right = centerX + display.contentCenterX

    map.setCameraBounds({
        xMin = display.contentCenterX,
        yMin = display.contentCenterY,
        xMax = map.data.width - display.contentCenterX,
        yMax = map.data.height - display.contentCenterY
        -- Use map.data.width because that's the "real" width of the map - 
        -- map.width changes when culling kicks in yMax = map.data.height - display.contentCenterY -- Same here
    })

    local tile = {
        map.layer["Clouds"].tile(3, 3),
        map.layer["Clouds"].tile(3, 4),
        map.layer["Clouds"].tile(4, 3),
        map.layer["Clouds"].tile(3, 4),
        map.layer["Clouds"].tile(5, 4),

        map.layer["Clouds"].tile(8, 6),
        map.layer["Clouds"].tile(8, 7),

        map.layer["Clouds"].tile(10, 2),
        map.layer["Clouds"].tile(11, 2),
        map.layer["Clouds"].tile(10, 3),
        map.layer["Clouds"].tile(11, 3),
        map.layer["Clouds"].tile(12, 3),

        map.layer["Clouds"].tile(16, 3),
        map.layer["Clouds"].tile(17, 3)
    } 
    
    for tile in map.layer["Clouds"].tilesInRect(centerX, centerY, left, bottom) do
        if (tile.x > display.contentCenterX) then
            tile.x = tile.x -1
        elseif (tile.x < display.contentCenterX / 2 ) then
            tile.x = xMax
        end
    end

    local function handlePlayButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle)
        elseif ( event.phase =="ended" ) then
            map.destroy()
            composer.removeScene( "levelselect", false )
            composer.gotoScene("levelselect", { effect = "crossFade", time = 333 })
        end
    end

    local function handleHelpButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle)
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("help", { effect = "crossFade", time = 333, isModal = true })
        end
    end

    local function handleCreditsButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle)
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
        end
    end

    local function handleSettingsButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle)
        elseif ( event.phase =="ended" ) then
            composer.gotoScene("gamesettings", { effect = "crossFade", time = 333 })
        end
    end

    local function handleQuitButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle)
        elseif ( event.phase =="ended" ) then
            native.requestExit()
        end
    end


    local title = display.newText("Stay Alive!", 100, 32, native.systemFontBold, 56 )
    title.x = display.contentCenterX
    title.y = 80
    title:setFillColor( 0 )
    title:toFront()
    sceneGroup:insert( title )

    -- Create the widget
    local playButton = widget.newButton({
        id = "button1",
        label = "Jogar",
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

    params = event.params
    utility.print_r(event)

    -- if params then
    --     print(params.someKey)
    --     print(params.someOtherKey)
    -- end

    if event.phase == "did" then
        composer.removeScene( "game" ) 
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
        physics.start()
        physics.stop()
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
