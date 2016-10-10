local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local physics = require( "physics" )
local myData = require( "mydata" )
local sheetInfo = require("images.player.spritesheet")

physics.start()
physics.setGravity( 0, 10 )

-- physics.setDrawMode( "hybrid" )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

-- local background = display.newRect( 0, 0, 570, 360 )
-- background.x = display.contentCenterX
-- background.y = display.contentCenterY
-- display.setDefault( "background", 0, 0, 1 )
-- sceneGroup:insert( background )

background = display.newImage( "images/background/07.png", _W, _H )
background:scale(0.5, 0.5)
background.x = centerX + 132
background.y = centerY - 15
-- sceneGroup:insert( background )

background2 = display.newImage( "images/background/07.png", _W, _H )
background2:scale(0.5, 0.5)
background2.x = (background.width/2) + centerX + 132
background2.y = centerY - 15
-- sceneGroup:insert( background2 )

speed = 1

function movebg()
  background.x = background.x - speed
  background2.x = background2.x - speed
    -- if(background.x == -360)then 
    --     background.x = 840 - speed
    -- elseif(background2.x == -360)then 
    --     background2.x = 840 - speed
    -- end
    if (background.x + centerX) < (display.contentWidth - display.contentWidth - 130) then
        background:translate(display.contentWidth + display.contentWidth + 300, 0)
    elseif (background2.x + centerX) < (display.contentWidth - display.contentWidth - 130) then
        background2:translate(display.contentWidth + display.contentWidth + 300, 0)
    end
end
Runtime:addEventListener( "enterFrame", movebg )

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
        left = _W - 180,
        top = centerY,
        id = "collisionButton",
        label = "Ver Colisões",
        labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
        onEvent = handlePhysicsButtonEvent
    }
)

-- set the background image
-- local background = display.newImage( "images/background/bg1200800.png", _W, _H )
-- background:scale(0.5, 0.5)
-- background.x = centerX
-- background.y = centerY - 40

-- local background2 = display.newImage( "images/background/bg1200800.png", _W, _H )
-- background2:scale(0.5, 0.5)
-- background2.x = background.width - 360
-- background2.y = centerY - 40

groundCollisionFilter = { categoryBits = 2, maskBits = 3 }

local ground = display.newRect(centerX, _H, _W, 20)--ImageRect("images/background/ground.png", 580, 32)
ground.width = 580
ground:setFillColor(0.5)
ground.x = centerX
ground.y = centerY + 145
physics.addBody(ground, "static", {density=0, bounce=0.1, friction=.2, filter = groundCollisionFilter})
ground.type = "ground"
ground.collision = onCollision


wallCollisionFilter = { categoryBits = 8, maskBits = 1 } 
-- walls collide with mario only

local leftwall = display.newRect( -50, centerY, 10, _H )
physics.addBody(leftwall, "static", { filter = wallCollisionFilter })
leftwall.alpha = 0
local rightwall = display.newRect( _W + 50, centerY, 10, _H )
physics.addBody(rightwall, "static", { filter = wallCollisionFilter })
rightwall.alpha = 0


local obstacle = display.newRect( centerX, (_H - 50), 10, 50 )
obstacle:setFillColor( 0.5 )
physics.addBody(obstacle, "static", { filter = wallCollisionFilter })

-- init the image sheet

local spritesheet = graphics.newImageSheet( "images/player/spritesheet.png", sheetInfo:getSheet() )

local sequenceData = {
    -- set up anmiation
    { 
        name="run",                                     -- name of the animation (used with setSequence)
        sheet=spritesheet,                              -- the image sheet
        start=sheetInfo:getFrameIndex("spritesheet3"),  -- name of the first frame
        count=3,                                        -- number of frames
        time=300,                                       -- speed
        loopCount=0                                     -- repeat
    },
    { 
        name="jump",                                    -- name of the animation (used with setSequence)
        sheet=spritesheet,                              -- the image sheet
        start=sheetInfo:getFrameIndex("spritesheet1"),  -- name of the first frame
        count=2,                                        -- number of frames
        time=1000,                                      -- speed
        loopCount=1                                     -- repeat
    },
}

marioCollisionFilter = { categoryBits = 1, maskBits = 14 }
    -- mario collides with (2, 4 and 8) only
mario = display.newSprite( spritesheet, sequenceData )
mario.type = "player"

-- set initial position and direction
mario.x = centerX
mario.y = centerY + 95
direction = 1
mario:scale(1.3, 1.3)
physics.addBody(mario, "dynamic", {bounce = 0.1, friction = 10, filter = marioCollisionFilter})
mario.isFixedRotation = true
mario.collision = onCollision

-- start running animation
mario:setSequence("run")
mario:play()

local jump_completed = false

local function onTouch(event)
    if (event.phase == "began" and jump_completed == false)then
        if(event.x < mario.x) then
            -- start jumping animation
            -- jump left
            mario:setSequence("jump")
            mario:play()
            direction = -1
            mario:setLinearVelocity((event.x-mario.x), -200)
        elseif(event.x > mario.x) then
            -- start jumping animation
            -- jump right
            mario:setSequence("jump")
            mario:play()
            direction = 1
            mario:setLinearVelocity((event.x-mario.x), -200)
        elseif((event.x >= (mario.x + 10)) or (event.x <= (mario.x - 10))) then
            mario:setSequence("jump")
            mario:play()
            direction = 0
            mario:setLinearVelocity(0, -200)
        end
        jump_completed = true
    end
    
    if(event.y < (mario.y + 30)) then
        if(event.x < mario.x) then
            
        end
    end
    
    if(event.phase == "ended" and jump_completed == false)then
            jump_completed = true
            mario:setSequence("run")
            mario:play()
    end
end

Runtime:addEventListener("touch", onTouch)

-- _G.stage = display.getCurrentStage()

-- function getWall(w, h)
--     local wall = display.newRect(0, 0, w, h)
--     physics.addBody(wall, "static")
--     return wall
-- end

-- local floor = getWall(700, 30)
-- floor.y = stage.height

-- local  wall1 = getWall(30, 700)
-- local  wall2 = getWall(30, 700)
-- wall2.x = stage.width - 15

local function on_hit(event)
    if(event.phase == "began")then

        jump_completed = false
        mario:setSequence("run")
        mario:play()
        
    end
end

mario:addEventListener("collision", on_hit)

-- 
-- define local variables here
--
local currentScore          -- used to hold the numeric value of the current score
local currentScoreDisplay   -- will be a display.newText() that draws the score on the screen
local levelText             -- will be a display.newText() to let you know what level you're on
local spawnTimer            -- will be used to hold the timer for the spawning engine

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

local function handleEnemyTouch( event )
    --
    -- When you touch the enemy:
    --    1. Increment the score
    --    2. Update the onscreen text that shows the score
    --    3. Kill the object touched
    --
    if event.phase == "began" then
        currentScore = currentScore + 10
        currentScoreDisplay.text = string.format( "%06d", currentScore )
        event.target:removeSelf()
        return true
    end
end

local function spawnEnemy( )
    -- make a local copy of the scene's display group.
    -- since this function isn't a member of the scene object,
    -- there is no "self" to use, so access it directly.
    local sceneGroup = scene.view  

    -- generate a starting position on the screen, y will be off screne
    local x = math.random(50, display.contentCenterX - 50)
    local enemy = display.newCircle(x, -50, 25)
    enemy:setFillColor( 1, 0, 0 )
    -- 
    -- must be inserted into the the group to be managed
    --
    sceneGroup:insert( enemy )
    --
    -- Add the physics body and the touch handler
    --
    physics.addBody( enemy, "dynamic", { radius = 25 } )
    --
    -- Since the touch handler is on an "object" and not the whole screen, 
    -- you don't need to remove it. When Composer hides the scene, it can't be
    -- interacted with and doesn't need removed. 
    -- when the scene is destroyed any display objects will be removed and that
    -- will remove this listener.
    enemy:addEventListener( "touch", handleEnemyTouch )

    --
    -- Not needed in this implementation, but you may want to call spawnEnemy() to create one 
    -- and you might want to pass that enemy back to the caller.
    return enemy
end

local function spawnEnemies()
    --
    -- Spawn a new enemy every second until canceled.
    -- spawnTimer holds the handle to the timer so we can cancel it later later.
    --
    -- spawnTimer = timer.performWithDelay( 1000, spawnEnemy, -1 )
end

--
-- This function gets called when composer.gotoScene() gets called an either:
--    a) the scene has never been visited before or
--    b) you called composer.removeScene() or composer.removeHidden() from some other
--       scene.  It's possible (and desirable in many cases) to call this once, but 
--       show it multiple times.
--
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

    --
    -- create your objects here
    --
    
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
    levelText = display.newText(myData.settings.currentLevel, 0, 0, native.systemFontBold, 48 )
    levelText:setFillColor( 0 )
    levelText.x = display.contentCenterX
    levelText.y = display.contentCenterY
    --
    -- Insert it into the scene to be managed by Composer
    --
    sceneGroup:insert( levelText )

    -- 
    -- because we want to access this in multiple functions, we need to forward declare the variable and
    -- then create the object here in scene:create()
    --
    currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
    sceneGroup:insert( currentScoreDisplay )

    --
    -- these two buttons exist as a quick way to let you test
    -- going between scenes (as well as demo widget.newButton)
    --

    -- local iWin = widget.newButton({
    --     label = "I Win!",
    --     onEvent = handleWin
    -- })
    -- sceneGroup:insert(iWin)
    -- iWin.x = display.contentCenterX - 100
    -- iWin.y = display.contentHeight - 60

    -- local iLoose = widget.newButton({
    --     label = "I Loose!",
    --     onEvent = handleLoss
    -- })
    -- sceneGroup:insert(iLoose)
    -- iLoose.x = display.contentCenterX + 100
    -- iLoose.y = display.contentHeight - 60

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
        transition.to( levelText, { time = 500, alpha = 0 } )
        -- spawnTimer = timer.performWithDelay( 500, spawnEnemies )
    else -- event.phase == "will"
        -- The "will" phase happens before the scene transitions on screen.  This is a great
        -- place to "reset" things that might be reset, i.e. move an object back to its starting
        -- position. Since the scene isn't on screen yet, your users won't see things "jump" to new
        -- locations. In this case, reset the score to 0.
        currentScore = 0
        currentScoreDisplay.text = string.format( "%06d", currentScore )
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
        timer.cancel( spawnTimer )
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
