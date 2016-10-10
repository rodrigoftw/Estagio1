local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
local widget = require( "widget" )
local utility = require( "utility" )
local ads = require( "ads" )

local params

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

physics.start()

local myData = require( "mydata" )

local function handlePlayButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "levelselect", false )
        composer.gotoScene("levelselect", { effect = "crossFade", time = 333 })
    end
end

local function handleHelpButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene("help", { effect = "crossFade", time = 333, isModal = true })
    end
end

local function handleCreditsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
    end
end

local function handleSettingsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("gamesettings", { effect = "crossFade", time = 333 })
    end
end

local function handleQuitButtonEvent( event )

    if ( "began" == event.phase ) then
        -- audio.play(pressedButton)
    elseif ( "ended" == event.phase ) then
        native.requestExit()
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
    -- local background = display.newRect( 0, 0, 570, 360 )
    -- background.x = display.contentCenterX
    -- background.y = display.contentCenterY
    -- sceneGroup:insert( background )

    -- set the background image
    background = display.newImage( "images/background/07.png", _W, _H )
    background:scale(0.5, 0.5)
    background.x = centerX + 132
    background.y = centerY - 15
    sceneGroup:insert( background )

    background2 = display.newImage( "images/background/07.png", _W, _H )
    background2:scale(0.5, 0.5)
    background2.x = (background.width/2) + centerX + 132
    background2.y = centerY - 15
    sceneGroup:insert( background2 )

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



    local title = display.newText("Stay Alive!", 100, 32, native.systemFontBold, 56 )
    title.x = display.contentCenterX
    title.y = 80
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    -- Create the widget
    local playButton = widget.newButton({
        id = "button1",
        label = "Jogar",
        width = 100,
        height = 32,
        onEvent = handlePlayButtonEvent
    })
    playButton.x = display.contentCenterX - 80
    playButton.y = display.contentCenterY + 40
    sceneGroup:insert( playButton )

    -- Create the widget
    local settingsButton = widget.newButton({
        id = "button2",
        label = "Opções",
        width = 100,
        height = 32,
        onEvent = handleSettingsButtonEvent
    })
    settingsButton.x = display.contentCenterX + 80
    settingsButton.y = display.contentCenterY + 40
    sceneGroup:insert( settingsButton )

    -- Create the widget
    local helpButton = widget.newButton({
        id = "button3",
        label = "Ajuda",
        width = 100,
        height = 32,
        onEvent = handleHelpButtonEvent
    })
    helpButton.x = display.contentCenterX - 170
    helpButton.y = display.contentCenterY + 110
    sceneGroup:insert( helpButton )

    -- Create the widget
    local creditsButton = widget.newButton({
        id = "button4",
        label = "Créditos",
        width = 100,
        height = 32,
        onEvent = handleCreditsButtonEvent
    })
    creditsButton.x = display.contentCenterX + 170
    creditsButton.y = display.contentCenterY + 110
    sceneGroup:insert( creditsButton )

    local quitButton = widget.newButton({
        id = "button5",
        label = "Sair",
        width = 100,
        height = 32,
        onEvent = handleQuitButtonEvent
    })
    quitButton.x = display.contentCenterX
    quitButton.y = display.contentCenterY + 110
    sceneGroup:insert( quitButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params
    utility.print_r(event)

    if params then
        print(params.someKey)
        print(params.someOtherKey)
    end

    if event.phase == "did" then
        composer.removeScene( "game" ) 
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
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
