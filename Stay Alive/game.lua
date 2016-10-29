local composer = require( "composer" )
local scene = composer.newScene()

local dusk = require("Dusk.Dusk")
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local physics = require( "physics" )
local myData = require( "mydata" )
-- local sheetInfo = require("images.player.spritesheet")
system.activate( "multitouch" )

physics.start()
physics.setGravity( 0, 9.8 )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

display.setDefault("minTextureFilter", "nearest")
display.setDefault("magTextureFilter", "nearest")

wallCollisionFilter = { categoryBits = 2, maskBits = 1 }
-- walls collide with player only

-- local leftwall = display.newRect( -50, centerY, 10, _H )
-- physics.addBody(leftwall, "static", { filter = wallCollisionFilter })
-- leftwall.alpha = 0
-- local rightwall = display.newRect( _W + 50, centerY, 10, _H )
-- physics.addBody(rightwall, "static", { filter = wallCollisionFilter })
-- rightwall.alpha = 0


-- local obstacle = display.newRect( centerX, (_H - 50), 10, 50 )
-- obstacle:setFillColor( 0.5 )
-- physics.addBody(obstacle, "static", { filter = wallCollisionFilter })



-- 
-- define local variables here
--
-- local currentScore          -- used to hold the numeric value of the current score
-- local currentScoreDisplay   -- will be a display.newText() that draws the score on the screen
-- local levelText             -- will be a display.newText() to let you know what level you're on
-- local spawnTimer            -- will be used to hold the timer for the spawning engine

--
-- define local functions here
--
-- local function handleWin( event )
--     --
--     -- When you tap the "I Win" button, reset the "nextlevel" scene, then goto it.
--     --
--     -- Using a button to go to the nextlevel screen isn't realistic, but however you determine to 
--     -- when the level was successfully beaten, the code below shows you how to call the gameover scene.
--     --
--     if event.phase == "ended" then
--         composer.removeScene("nextlevel")
--         composer.gotoScene("nextlevel", { time= 500, effect = "crossFade" })
--     end
--     return true
-- end

-- local function handleLoss( event )
--     --
--     -- When you tap the "I Loose" button, reset the "gameover" scene, then goto it.
--     --
--     -- Using a button to end the game isn't realistic, but however you determine to 
--     -- end the game, the code below shows you how to call the gameover scene.
--     --
--     if event.phase == "ended" then
--         composer.removeScene("gameover")
--         composer.gotoScene("gameover", { time= 500, effect = "crossFade" })
--     end
--     return true
-- end

function scene:create( event )
    --
    -- self in this case is "scene", the scene object for this level. 
    -- Make a local copy of the scene's "view group" and call it "sceneGroup". 
    -- This is where you must insert everything (display.* objects only) that you want
    -- Composer to manage for you.
    local sceneGroup = self.view

    -- 
    -- You need to start the physics engine to be able to add objects to it, but...
    --
    physics.start()
    --
    -- because the scene is off screen being created, we don't want the simulation doing
    -- anything yet, so pause it for now.
    --
    physics.pause()

    --
    -- make a copy of the current level value out of our
    -- non-Global app wide storage table.
    --
    local thisLevel = myData.settings.currentLevel

    -- if (thisLevel == 1) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level1" )
    -- elseif (thisLevel == 2) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level2" )
    -- elseif (thisLevel == 3) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level3" )
    -- elseif (thisLevel == 4) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level4" )
    -- elseif (thisLevel == 5) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level5" )
    -- elseif (thisLevel == 6) then
    --     composer.removeScene( "game", false )
    --     composer.gotoScene( "level6" )
    -- end

    --
    -- create your objects here
    --

    -- Mapa
    local currMap = "level3.json" --"level2.json" --"level3.json"
    map = dusk.buildMap("maps/"..currMap)

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

    --------------------------------------------------------------------------------
    -- Map Touch Event
    --------------------------------------------------------------------------------
    function mapTouch(event)
        local viewX, viewY = map.getViewpoint()
        local eventX, eventY = map:contentToLocal(event.x, event.y)
        if "began" == event.phase then
            display.getCurrentStage():setFocus(map)
            map.isFocus = true
            map._x, map._y = eventX + viewX, eventY + viewY
        elseif map.isFocus then
            if "moved" == event.phase then
                map.setViewpoint(map._x - eventX, map._y - eventY)
                map.updateView() -- Update the map's camera and culling directly after changing position
            elseif "ended" == event.phase then
                display.getCurrentStage():setFocus(nil)
                map.isFocus = false
            end
        end
    end

    -- Runtime:addEventListener( "touch", mapTouch )

    playerCollisionFilter = { categoryBits = 1, maskBits = 2 }
    -- player = display.newSprite( spritesheet, sequenceData )
    -- player.type = "player"

    local player = map.layer["Player"].tile(2, 4)--11, 7) -- Level 2: (2, 4) -- Level 3: (2, 4) -- Level 4: (2, 7)
    player.bodyType = "dynamic"
    player.bounce = 0
    player.friction = 10
    player.collision = onCollision
    player.isFixedRotation = true

    -- local jump_completed = false

    -- local function onTouch(event)
    --     if (event.phase == "began" and jump_completed == false)then
    --         if(event.x < player.x) then
    --             -- jump left
    --             -- direction = -1
    --             player:setLinearVelocity((event.x-player.x), -200)
    --         elseif(event.x > player.x) then
    --             -- jump right
    --             direction = 1
    --             player:setLinearVelocity((event.x-player.x), -200)
    --         elseif((event.x >= (player.x + 10)) or (event.x <= (player.x - 10))) then
    --             direction = 0
    --             player:setLinearVelocity(0, -200)
    --         end
    --         jump_completed = true
    --     end
        
    --     -- if(event.y < (player.y + 30)) then
    --     --     if(event.x < player.x) then
                
    --     --     end
    --     -- end
        
    --     if(event.phase == "ended" and jump_completed == false)then
    --         jump_completed = true
    --     end
    -- end

    -- Runtime:addEventListener("touch", onTouch)

    -- local function on_hit(event)
    --     if(event.phase == "began")then
    --         jump_completed = false
    --     end
    -- end

    -- player:addEventListener("collision", on_hit)

    local leftButton = display.newImageRect( "images/ui/LeftButton.png", 55, 55 )
    leftButton.x = 25
    leftButton.y = _H - 27

    local rightButton = display.newImageRect( "images/ui/RightButton.png", 55, 55 )
    rightButton.x = 80
    rightButton.y = _H - 27

    local jumpButton = display.newImageRect( "images/ui/JumpButton.png", 55, 55 )
    jumpButton.x = _W - 25
    jumpButton.y = _H - 25

    local jump_completed = true

    function moveLeft(event)
        if (event.phase == "began") then
            player:setLinearVelocity(-100, 0)
        elseif (event.phase == "ended") then
            player:setLinearVelocity(0, 0)
        end
        -- jump_completed = false
    end
    leftButton:addEventListener("touch", moveLeft)

    function moveRight(event)
        if (event.phase == "began") then
            player:setLinearVelocity(100, 0)
        elseif (event.phase == "ended") then
            player:setLinearVelocity(0, 0)
        end
        -- jump_completed = false
    end
    rightButton:addEventListener("touch", moveRight)

    function jump(event)
        if (event.phase == "began" and jump_completed == false) then
            player:setLinearVelocity(0, -200)
        elseif (event.phase == "ended") then
            -- player:setLinearVelocity(0, 0)
            jump_completed = true
        end
    end
    jumpButton:addEventListener("touch", jump)

    local function on_hit(event)
        if(event.phase == "began") then
            jump_completed = false
        elseif(event.phase == "ended") then
            player.isFixedRotation = false
        end
    end

    player:addEventListener("collision", on_hit)

    local x = 1
    physics.setDrawMode("normal")
    -- Function to handle button events
    local function handlePhysicsButtonEvent( event )
        if ( "ended" == event.phase ) then          
            if (x%2 == 0) then
                physics.setDrawMode("normal")
                x = x + 1
            elseif (x%2 ~= 0) then
                physics.setDrawMode("hybrid")
                x = x + 1
            end
        end
    end

    -- Create the widget
    local collisionButton = widget.newButton(
        {
            left = centerX - 80,
            top = 0,
            width = 90,
            height = 35,
            id = "collisionButton",
            label = "Ver Colisões",
            labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
            onEvent = handlePhysicsButtonEvent
        }
    )

    -- Function to quit game
    local function handleMenuButtonEvent( event )
        -- if ( "began" == event.phase ) then
        --     audio.play(pressedButton)
        if ( "ended" == event.phase ) then
            -- composer.removeScene( "menu", false )
            -- composer.removeScene( "game", false )
            -- composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
            native.requestExit()
        end
    end

    local menuButton = widget.newButton(
         {
            left = centerX + 10,
            top = 0,
            width = 60,
            height = 35,
            id = "menuButton",
            label = "Menu",
            labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
            onEvent = handleMenuButtonEvent
        }
    )

    local y = 1
    -- Function to toggle debug options on/off
    local function handleToggleButtonEvent( event )
        -- if ( "began" == event.phase ) then
        --     audio.play(pressedButton)
         if ( "ended" == event.phase ) then          
            if (y%2 == 0) then
                collisionButton.alpha = 1
                menuButton.alpha = 1
                y = y + 1
            elseif (y%2 ~= 0) then
                collisionButton.alpha = 0
                menuButton.alpha = 0
                y = y + 1
            end
        end
    end

    local toggleButton = widget.newButton(
         {
            left = centerX - 40,
            top = _H - 35,
            width = 60,
            height = 35,
            id = "toggleButton",
            label = "On/Off",
            labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
            onEvent = handleToggleButtonEvent
        }
    )

    local centerX, centerY = map.getViewpoint()
    local top = centerY - display.contentCenterY
    local bottom = centerY + display.contentCenterY
    local left = centerX - display.contentCenterX
    local right = centerX + display.contentCenterX

    map.setCameraBounds({
        xMin = display.contentCenterX,
        yMin = display.contentCenterY,
        xMax = map.data.width + display.contentCenterX,
        yMax = map.data.height - display.contentCenterY
        -- Use map.data.width because that's the "real" width of the map - 
        -- map.width changes when culling kicks in yMax = map.data.height - display.contentCenterY -- Same here
    })

    -----------Timer-----------
    -- Contar o tempo em segundos
    local secondsPassed = 00 * 00-- * 00  -- Exemplo: 2 minutos * 30 segundos
 
    local clockText = display.newText("00:00", ((display.contentCenterX*2) - (display.contentCenterX*0.12)), 15, native.systemFontBold, 20) -- display.contentCenterX + 170
    clockText:setFillColor( 1, 1, 1 )

    -- Dar um update no timer a cada segundo passado
    local function updateTime()
        -- Incrementar o número de segundos
        secondsPassed = secondsPassed + 1
    
        -- O tempo é contado em segundos.  Converter o tempo para minutos e segundos
        local seconds = secondsPassed % 60
        local minutes = math.floor( secondsPassed / 60 )
        local hours   = math.floor( minutes / 60 )

        -- Transformar o resultado em uma string usando string.format
        timeDisplay = string.format( "%02d:%02d", minutes, seconds )
        clockText.text = timeDisplay
        clockText.alpha = 1

        map.setDamping(0.3)
        -- map.setCameraFocus(player)
        map.updateView()
    end

    -- local reloadMap = timer.performWithDelay( 1, map.updateView(), seconds )
    
    -- Rodar timer
    local Timer = timer.performWithDelay( 1, updateTime, secondsPassed )

    -- local function updateTimer( event )
    --     -- map.setDamping(0.3)
    --     map.setTrackingLevel(0.3)
    --     map.setCameraFocus(player)
    --     map.updateView()
    -- end 
    -- Runtime:addEventListener( "enterFrame", updateTimer )
    
    
    --
    -- These pieces of the app only need created.  We won't be accessing them any where else
    -- so it's okay to make it "local" here
    --
    -- local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    -- background:setFillColor( 0.6, 0.7, 0.3 )
    --
    -- Insert it into the scene to be managed by Composer
    --
    -- sceneGroup:insert(background)

    --
    -- levelText is going to be accessed from the scene:show function. It cannot be local to
    -- scene:create(). This is why it was declared at the top of the module so it can be seen 
    -- everywhere in this module
    -- levelText = display.newText(myData.settings.currentLevel, 0, 0, native.systemFontBold, 48 )
    -- levelText:setFillColor( 0 )
    -- levelText.x = display.contentCenterX
    -- levelText.y = display.contentCenterY
    --
    -- Insert it into the scene to be managed by Composer
    --
    -- sceneGroup:insert( levelText )

    -- 
    -- because we want to access this in multiple functions, we need to forward declare the variable and
    -- then create the object here in scene:create()
    --
    -- currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
    -- sceneGroup:insert( currentScoreDisplay )

end

--
-- This gets called twice, once before the scene is moved on screen and again once
-- afterwards as a result of calling composer.gotoScene()
--
function scene:show( event )
    --
    -- Make a local reference to the scene's view for scene:show()
    --
    local sceneGroup = self.view

    --
    -- event.phase == "did" happens after the scene has been transitioned on screen. 
    -- Here is where you start up things that need to start happening, such as timers,
    -- tranistions, physics, music playing, etc. 
    -- In this case, resume physics by calling physics.start()
    -- Fade out the levelText (i.e start a transition)
    -- Start up the enemy spawning engine after the levelText fades
    --
    if event.phase == "did" then
        physics.start()
        -- transition.to( levelText, { time = 500, alpha = 0 } )
        -- spawnTimer = timer.performWithDelay( 500, spawnEnemies )
    else -- event.phase == "will"
        -- The "will" phase happens before the scene transitions on screen.  This is a great
        -- place to "reset" things that might be reset, i.e. move an object back to its starting
        -- position. Since the scene isn't on screen yet, your users won't see things "jump" to new
        -- locations. In this case, reset the score to 0.
        -- currentScore = 0
        -- currentScoreDisplay.text = string.format( "%06d", currentScore )
    end
end

--
-- This function gets called everytime you call composer.gotoScene() from this module.
-- It will get called twice, once before we transition the scene off screen and once again 
-- after the scene is off screen.
function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
        -- The "will" phase happens before the scene is transitioned off screen. Stop
        -- anything you started elsewhere that could still be moving or triggering such as:
        -- Remove enterFrame listeners here
        -- stop timers, phsics, any audio playing
        --
        physics.stop()
        -- timer.cancel( spawnTimer )
    end

end

--
-- When you call composer.removeScene() from another module, composer will go through and
-- remove anything created with display.* and inserted into the scene's view group for you. In
-- many cases that's sufficent to remove your scene. 
--
-- But there may be somethings you loaded, like audio in scene:create() that won't be disposed for
-- you. This is where you dispose of those things.
-- In most cases there won't be much to do here.
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
