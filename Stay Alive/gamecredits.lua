local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" ) 

local params

local function handleButtonEvent( event )

    if ( event.phase == "began" ) then
        audio.play(buttonToggle, { channel = 7 } )
    elseif ( event.phase == "ended" ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
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

    -- clouds = display.newImageRect( "maps/clouds.png", _W, _H )
    -- clouds.x = display.contentCenterX
    -- clouds.y = display.contentCenterY
    -- clouds:toFront()
    -- sceneGroup:insert( clouds )

    local title = display.newText( "Créditos", 100, 32, "Roboto-Regular.ttf", 32)
    title.x = display.contentCenterX
    title.y = display.contentCenterY - 120
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local background = display.newImageRect( "maps/background_ui.png", _W, _H )
    background.x = centerX
    background.y = centerY - 5
    sceneGroup:insert( background )

    local coronasdk = display.newText( "Criação do jogo", 250, 250, "Roboto-Regular.ttf", 16 )
    coronasdk:setFillColor( 0 )
    coronasdk.x = centerX - 180
    coronasdk.y = centerY - 70
    sceneGroup:insert(coronasdk)

    local coronasdk2 = display.newText( "Corona SDK", 250, 250, "Roboto-Regular.ttf", 12 )
    coronasdk2:setFillColor( 0 )
    coronasdk2.x = centerX - 180
    coronasdk2.y = centerY - 50
    sceneGroup:insert(coronasdk2)

    local devBy = display.newText( "Desenvolvimento", 250, 250, "Roboto-Regular.ttf", 16 )
    devBy:setFillColor( 0 )
    devBy.x = centerX
    devBy.y = centerY - 70
    sceneGroup:insert(devBy)

    local devBy2 = display.newText( "Rodrigo Andrade", 250, 250, "Roboto-Regular.ttf", 12 )
    devBy2:setFillColor( 0 )
    devBy2.x = centerX
    devBy2.y = centerY - 50
    sceneGroup:insert(devBy2)

    local levelcreation = display.newText( "Criação dos levels", 250, 250, "Roboto-Regular.ttf", 16 )
    levelcreation:setFillColor( 0 )
    levelcreation.x = centerX + 170
    levelcreation.y = centerY - 70
    sceneGroup:insert(levelcreation)

    local tiled = display.newText( "Tiled Map Editor", 250, 250, "Roboto-Regular.ttf", 12 )
    tiled:setFillColor( 0 )
    tiled.x = centerX + 170
    tiled.y = centerY - 50
    sceneGroup:insert(tiled)

    local gameart = display.newText( "Criação da arte do jogo, ícones e interface", 250, 250, "Roboto-Regular.ttf", 16 )
    gameart:setFillColor( 0 )
    gameart.x = centerX
    gameart.y = centerY - 10
    sceneGroup:insert(gameart)

    local graphics = display.newText( "GraphicsGale", 250, 250, "Roboto-Regular.ttf", 12 )
    graphics:setFillColor( 0 )
    graphics.x = centerX
    graphics.y = centerY + 10
    sceneGroup:insert(graphics)

    local sounds = display.newText( "Sons", 250, 250, "Roboto-Regular.ttf", 16 )
    sounds:setFillColor( 0 )
    sounds.x = centerX
    sounds.y = centerY + 50
    sceneGroup:insert(sounds)

    local dusk = display.newText( "Motor do jogo", 250, 250, "Roboto-Regular.ttf", 16 )
    dusk:setFillColor( 0 )
    dusk.x = centerX - 170
    dusk.y = centerY + 50
    sceneGroup:insert(dusk)

    local engine = display.newText( "Dusk Engine", 250, 250, "Roboto-Regular.ttf", 12 )
    engine:setFillColor( 0 )
    engine.x = centerX - 170
    engine.y = centerY + 70
    sceneGroup:insert(engine)

    local bfxr = display.newText( "Bfxr", 250, 250, "Roboto-Regular.ttf", 12 )
    bfxr:setFillColor( 0 )
    bfxr.x = centerX
    bfxr.y = centerY + 70
    sceneGroup:insert(bfxr)

    local music = display.newText( "Músicas", 250, 250, "Roboto-Regular.ttf", 16 )
    music:setFillColor( 0 )
    music.x = centerX + 170
    music.y = centerY + 50
    sceneGroup:insert(music)

    local youtube = display.newText( "Youtube Audio Library", 250, 250, "Roboto-Regular.ttf", 12 )
    youtube:setFillColor( 0 )
    youtube.x = centerX + 170
    youtube.y = centerY + 70
    sceneGroup:insert(youtube)

    local function handleGithubButtonEvent( event )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
        elseif ( event.phase =="ended" ) then

            local url = "https://github.com/rodrigoftw/Estagio1/tree/master/Stay%20Alive"--https://github.com/rodrigoftw/"

            if ( system.canOpenURL( url ) ) then
                system.openURL( url )
            else
                -- Handler that gets notified when the alert closes
                local function onComplete( event )
                    if ( event.action == "clicked" ) then
                        local i = event.index
                        if ( i == 1 ) then
                            -- Do nothing; dialog will simply dismiss
                        end
                    end
                end     
                -- Show alert with two buttons
                local alert = native.showAlert( "Erro!", "Página não encontrada! :(", { "Voltar" }, onComplete )

                -- Dismisses alert after 10 seconds
                local function cancelAlert()
                    native.cancelAlert( alert )
                end

                timer.performWithDelay( 10000, cancelAlert )
            end
        end
    end

    -- Create the widget
    local githubButton = widget.newButton({
        id = "github",
        label = "Veja meu Github ;)",
        font = "Roboto-Regular.ttf",
        labelColor = { default={13/255,87/255,136/255,1}, over={13/255,87/255,136/255,1} },
        width = 170,
        height = 32,
        emboss = false,
        shape = "roundedRect",
        cornerRadius = 2,
        fillColor = { default={255/255,127/255,39/255,0.5}, over={72/255,183/255,177/255,0.5} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        onEvent = handleGithubButtonEvent
    })
    githubButton.x = centerX - 50
    githubButton.y = centerY + 110
    githubButton:toFront()
    sceneGroup:insert( githubButton )

    -- http://www.freesfx.co.uk
    -- http://www.freesound.org

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
    backButton.x = centerX + 90
    backButton.y = centerY + 110
    sceneGroup:insert( backButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
        print("_________________________")
        print("        Créditos")
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
