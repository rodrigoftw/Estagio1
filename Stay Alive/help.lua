local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
 
local params 

local scrollView
local icons = {}

local function handleButtonEvent( event )

    if ( event.phase == "began" ) then
        audio.play(buttonToggle, { channel = 7 } )
    elseif ( event.phase == "ended" ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
    end
    return true
end

local function buttonListener( event )
    local id = event.target.id

    if event.phase == "moved" then
        local dx = math.abs( event.x - event.xStart ) -- Get the x-transition of the touch-input
        if dx > 5 then
            scrollView:takeFocus( event ) -- If the x- or y-transition is more than 5 put the focus to your scrollview
        end
    elseif event.phase == "ended" then
        -- do whatever you need to do if the object was touched
        print("object",id, "was touched")
        timer.performWithDelay( 10, function() scrollView:removeSelf(); scrollView = nil; end)
    end
    return true
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

    --local title = display.newBitmapText( titleOptions )
    local title = display.newText("Ajuda", 125, 32, "Roboto-Regular.ttf", 32)
    title.x = centerX
    title.y = centerY - 120
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    -- local background = display.newRect( centerX, centerY, (_W * 0.8), (_H * 0.575) )
    -- background:setFillColor( 1 )
    -- background.alpha = 0.7
    -- sceneGroup:insert( background )

    local background = display.newImageRect( "maps/background_ui.png", _W, _H )
    background.x = centerX
    background.y = centerY
    sceneGroup:insert( background )

    local controller1Text = display.newText("   Use os direcionais\npara se mover e pular.", 125, 32, "Roboto-Regular.ttf", 10)
    controller1Text.x = centerX - 195
    controller1Text.y = centerY + 70
    controller1Text:setFillColor( 0 )
    sceneGroup:insert( controller1Text )

    local jumpButton = display.newImageRect( "images/ui/JumpButtonNew.png", 40, 40 )
    jumpButton.alpha = 1
    jumpButton.x = centerX - 198
    jumpButton.y = centerY - 50
    sceneGroup:insert( jumpButton )

    local leftButton = display.newImageRect( "images/ui/LeftButtonNew.png", 40, 40 )
    leftButton.alpha = 1
    leftButton.x = centerX - 220
    leftButton.y = centerY
    sceneGroup:insert( leftButton )

    local rightButton = display.newImageRect( "images/ui/RightButtonNew.png", 40, 40 )
    rightButton.alpha = 1
    rightButton.x = centerX - 175
    rightButton.y = centerY
    sceneGroup:insert( rightButton )

    local playerText = display.newText("Você é este quadrado.", 125, 32, "Roboto-Regular.ttf", 10)
    playerText.x = centerX - 70
    playerText.y = centerY - 30
    playerText:setFillColor( 0 )
    sceneGroup:insert( playerText )

    local player = display.newImageRect( "maps/Tiles/player_16.png", 16, 16 )
    player.alpha = 1
    player.x = centerX - 70
    player.y = centerY - 50
    sceneGroup:insert( player )

    local startText = display.newText("Você vem deste portal.", 125, 32, "Roboto-Regular.ttf", 10)
    startText.x = centerX - 70
    startText.y = centerY + 20
    startText:setFillColor( 0 )
    sceneGroup:insert( startText )

    local start = display.newImageRect( "maps/Tiles/start.png", 16, 16 )
    start.alpha = 1
    start.x = centerX - 70
    start.y = centerY
    sceneGroup:insert( start )

    local endingText = display.newText("Você deve entrar\n     neste portal.", 125, 32, "Roboto-Regular.ttf", 10)
    endingText.x = centerX - 70
    endingText.y = centerY + 70
    endingText:setFillColor( 0 )
    sceneGroup:insert( endingText )

    local ending = display.newImageRect( "maps/Tiles/ending.png", 16, 16 )
    ending.alpha = 1
    ending.x = centerX - 70
    ending.y = centerY + 45
    sceneGroup:insert( ending )

    local gravityText = display.newText("Utilize a gravidade\n      a seu favor.", 125, 32, "Roboto-Regular.ttf", 10)
    gravityText.x = centerX + 70
    gravityText.y = centerY + 70
    gravityText:setFillColor( 0 )
    sceneGroup:insert( gravityText )

    local gravity = display.newImageRect( "maps/Tiles/Gravity.png", 40, 40 )
    gravity.alpha = 1
    gravity.x = centerX + 70
    gravity.y = centerY
    sceneGroup:insert( gravity )

    local spikesText = display.newText("        Cuidado com os\nobstácultos no caminho!", 125, 32, "Roboto-Regular.ttf", 10)
    spikesText.x = centerX + 190
    spikesText.y = centerY + 70
    spikesText:setFillColor( 0 )
    sceneGroup:insert( spikesText )

    local spikes = display.newImageRect( "maps/Tiles/spikes_up.png", 40, 40 )
    spikes.alpha = 1
    spikes.x = centerX + 190
    spikes.y = centerY
    sceneGroup:insert( spikes )

    local backButton = widget.newButton({
        id = "button1",
        font = "Roboto-Regular.ttf",
        label = "Voltar",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 100,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentCenterY + 112
    sceneGroup:insert( backButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then

        print("_________________________")
        print("          Ajuda")
        print("_________________________")

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
