-------------------------------------------------------------------------------
-- level1.lua
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Lib Requirements
-------------------------------------------------------------------------------
local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene()

local dusk = require("Dusk.Dusk")
local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local physics = require( "physics" )
local myData = require( "mydata" )
system.activate( "multitouch" )

-------------------------------------------------------------------------------
-- Local Screen Variables
-------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

-------------------------------------------------------------------------------
-- Collision Filters
-------------------------------------------------------------------------------
playerCollisionFilter = { categoryBits = 1, maskBits = 2 }
wallCollisionFilter = { categoryBits = 2, maskBits = 1 }

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

     physics.start()
     physics.pause()

    local thisLevel = myData.settings.currentLevel

    -------------------------------------------------------------------------------
    -- Map
    -------------------------------------------------------------------------------
    local currMap = "level1_grass.json"
    map = dusk.buildMap("maps/"..currMap)

    -- dusk.setPreference("virtualObjectsVisible", true)
    dusk.setPreference("enableTileCulling", true)
    dusk.setPreference("scaleCameraBoundsToScreen", true)
    dusk.setPreference("enableCamera", false)
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

    -------------------------------------------------------------------------------
    -- Dusk Camera Configurations
    -------------------------------------------------------------------------------

    display.setDefault("minTextureFilter", "nearest")
    display.setDefault("magTextureFilter", "nearest")

    -- local centerX, centerY = map.getViewpoint()
    -- local top = centerY - display.contentCenterY
    -- local bottom = centerY + display.contentCenterY
    -- local left = centerX - display.contentCenterX
    -- local right = centerX + display.contentCenterX

    map.setCameraBounds({
        xMin = display.contentCenterX,
        yMin = display.contentCenterY,
        xMax = map.data.width - display.contentCenterX,
        yMax = map.data.height - display.contentCenterY
        -- Use map.data.width because that's the "real" width of the map - 
        -- map.width changes when culling kicks in yMax = map.data.height - display.contentCenterY -- Same here
    })

    -------------------------------------------------------------------------------
    -- Player
    -------------------------------------------------------------------------------

    local player = map.layer["Player"].tile(2, 7)
    player.bodyType = "dynamic"
    player.bounce = 0
    player.friction = 10
    player.collision = onCollision
    player.isFixedRotation = false --true

    -------------------------------------------------------------------------------
    -- Movement Buttons
    -------------------------------------------------------------------------------

    local leftButton = display.newImageRect( "images/ui/LeftButtonNew.png", 40, 40 )
    leftButton.alpha = 0.5
    leftButton.x = 27
    leftButton.y = _H - 27

    local rightButton = display.newImageRect( "images/ui/RightButtonNew.png", 40, 40 )
    rightButton.alpha = 0.5
    rightButton.x = 70
    rightButton.y = _H - 27

    local jumpButton = display.newImageRect( "images/ui/JumpButtonNew.png", 40, 40 )
    jumpButton.alpha = 0.5
    jumpButton.x = _W - 27
    jumpButton.y = _H - 27

    -------------------------------------------------------------------------------
    -- Movement Functions
    -------------------------------------------------------------------------------

    local jump_completed = true

    function moveLeft(event)
        if (event.phase == "began") then
            leftButton.alpha = 1
            player:setLinearVelocity(-100, 0)
        elseif (event.phase == "ended") then
            leftButton.alpha = 0.5
            player:setLinearVelocity(0, 0)
        end
        -- jump_completed = false
    end
    leftButton:addEventListener("touch", moveLeft)

    function moveRight(event)
        if (event.phase == "began") then
            rightButton.alpha = 1
            player:setLinearVelocity(100, 0)
        elseif (event.phase == "ended") then
            rightButton.alpha = 0.5
            player:setLinearVelocity(0, 0)
        end
        -- jump_completed = false
    end
    rightButton:addEventListener("touch", moveRight)

    function jump(event)
        if (event.phase == "began" and jump_completed == false) then
            jumpButton.alpha = 1
            audio.play( jumpSound )
            player:setLinearVelocity(0, -200)
        elseif (event.phase == "ended") then
            jumpButton.alpha = 0.5
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

    -------------------------------------------------------------------------------
    -- Keyboard Buttons
    -------------------------------------------------------------------------------

    -- Keyboard input configuration
    local keyUp = "up"
    local keyLeft = "left"
    local keyRight = "right"

    -- Called when a key event has been received
    local function onKeyEvent( event )
        local keyName = event.keyName
        local phase = event.phase

        -- local vx,vy = player:getLinearVelocity()
        -- player:setLinearVelocity( vx,0 )

        vx = 0
        vy = -200

        if ( keyUp == keyName ) then
            audio.play( jumpSound )
            player:setLinearVelocity(vx, vy)
        end
        jump_completed = true
        vy = 0
        if ( keyLeft == keyName ) then
            vx = -100
            player:setLinearVelocity(vx, vy)
        end
        if ( keyRight == keyName ) then
            vx = 100
            player:setLinearVelocity(vx, vy)
        end

        -- end
        -- if ( "right" == phase ) then
        --     if ( keyRight == keyName ) then
        --         player:setLinearVelocity(100, 0)
        --     end
        -- end
        -- if ( "up" == phase ) then
        --     if ( keyUp == keyName ) then
        --         player:setLinearVelocity(0, -200)
        --     end
        -- end

        return false
    end
    Runtime:addEventListener( "key", onKeyEvent )

    -------------------------------------------------------------------------------
    -- Debug Buttons and Functions
    -------------------------------------------------------------------------------

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

    local collisionButton = widget.newButton(
        {
            left = centerX - 95,
            top = 0,
            -- width = 90,
            height = 35,
            id = "collisionButton",
            label = "Ver Colisões",
            --labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
            labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
            width = 100,
            -- height = 32,
            emboss = false,
            shape = "roundedRect",
            cornerRadius = 2,
            fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            onEvent = handlePhysicsButtonEvent
        }
    )

    -- Function to quit game
    local function handleMenuButtonEvent( event )
        if ( event.phase == "began" ) then
            timer.cancel(Timer)
            audio.play(buttonToggle)
        elseif ( event.phase == "ended" ) then
            map:destroy()
            composer.removeScene( "menu", false )
            composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
            composer.removeScene( "level1", false )
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
            labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
            -- width = 100,
            -- height = 32,
            emboss = false,
            shape = "roundedRect",
            cornerRadius = 2,
            fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            onEvent = handleMenuButtonEvent
        }
    )

    local y = 1
    -- Function to toggle debug options on/off
    local function handleToggleButtonEvent( event )
        if ( "began" == event.phase ) then
            audio.play(buttonToggle)
        elseif ( "ended" == event.phase ) then          
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
            labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
            -- width = 100,
            -- height = 32,
            emboss = false,
            shape = "roundedRect",
            cornerRadius = 2,
            fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            onEvent = handleToggleButtonEvent
        }
    )

    -------------------------------------------------------------------------------
    -- Timer
    -------------------------------------------------------------------------------
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
        map.setCameraFocus(player)
        map.updateView()
    end
    
    -- Rodar timer
    local Timer = timer.performWithDelay( 1, updateTime, secondsPassed )

    -- -------------------------------------------------------------------------------
    -- -- Collisions
    -- -------------------------------------------------------------------------------

    -- function onCollision(self, event)
    --     if event.phase == "began" then
    --         if event.target.type == "player" and event.other.type == "end" then
    --             print("Fim da fase")
    --             audio.play(buttonToggle)
                
    --         -- elseif event.target.type == "player" and event.other.type == "spike" then
    --         --     timer.cancel(Timer)
    --         --     audio.play(deathsound)
    --         --     audio.stop(deathsound)
    --         --     function blink()
    --         --         if(clockText.alpha < 1) then
    --         --             transition.to( clockText, {time=50, alpha=1})
    --         --         else
    --         --             transition.to( clockText, {time=50, alpha=0})
    --         --         end
    --         --     end
    --         --     local tmr = timer.performWithDelay( 300, blink, 0 )
    --         --     player:removeSelf()
    --         --     player = nil
    --         --     print("oh no")
    --         end
    --     elseif ( event.phase == "ended" ) then
    --         if ( event.target.type == "player" and event.other.type == "end" ) then
    --             -- Options table for the overlay scene "endofphase.lua"
    --             local options = {
    --                 isModal = true,
    --                 effect = "fade",
    --                 time = 333,
    --                 params = {
    --                     sampleVar = "my sample variable"
    --                 }
    --             }

    --             composer.showOverlay( "endofphase", options )
    --         end
    --     end
    --     return true
    -- end

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

        physics.start()
        physics.setGravity( 0, 9.8 )

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

    map.destroy()

    --audio.dispose( audioHandle )
end

-------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-------------------------------------------------------------------------------

return scene
