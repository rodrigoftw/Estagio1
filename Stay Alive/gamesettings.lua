local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myData = require( "mydata" )
local utility = require( "utility" ) 
local device = require( "device" )

local params
if device.isAndroid then
    widget.setTheme( "widget_theme_android_holo_dark" )
end
-- elseif deviceisApple then
--     widget.setTheme()
-- end

-- -- Handle press events for the switches
-- local function onSoundSwitchPress( event )
--     local soundSwitch = event.target

--     if soundSwitch.isOn then
--         myData.settings.soundOn = false
--         audio.stop( 2 )
--         -- buttonToggle = nil
--         -- audio.dispose( 2 )
--         audio.setVolume( 0, { channel = 2 }  )
--     else
--         myData.settings.soundOn = true
--         audio.play(buttonToggle)
--         audio.setVolume( 1, { channel = 2 }  )
--     end
--     utility.saveTable(myData.settings, "settings.json")
-- end

-- local function onMusicSwitchPress( event )
--     local musicSwitch = event.target

--     if musicSwitch.isOn then
--         myData.settings.musicOn = false
--         audio.play(titleMusic)
--         audio.setVolume( 1, { channel = 1 } )
--     else
--         myData.settings.musicOn = true
--         audio.stop( 1 )
--         audio.setVolume( 0 )

--     end
--     utility.saveTable(myData.settings, "settings.json")
-- end

-- Function to handle button events
local function handleBackButtonEvent( event )

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

    clouds = display.newImageRect( "maps/clouds.png", _W, _H )
    clouds.x = display.contentCenterX
    clouds.y = display.contentCenterY
    clouds:toFront()
    sceneGroup:insert( clouds )

    -------------------------------------------------------------------------------
    -- Title
    -------------------------------------------------------------------------------
    local title = display.newText("Opções", 100, 32, "Roboto-Regular.ttf", 32 )
    title.x = display.contentCenterX 
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    -------------------------------------------------------------------------------
    -- Music Volume Controller
    -------------------------------------------------------------------------------

    local volumeMusicLabel
    local audioMusicVolume = 50 -- Variable to hold music states.

    local musicLabel = display.newText("Músicas", 100, 32, "Roboto-Regular.ttf", 18 )
    musicLabel.x = display.contentCenterX / 1.5 --/ 5.5
    musicLabel.y = display.contentCenterY * 0.65 --180
    musicLabel:setFillColor( 0 )
    sceneGroup:insert( musicLabel )

    -- Set the initial volume to match our initial audio volume variable
    audio.setVolume( audioMusicVolume, { channel = 1 } )

    --Handle slider events
    local function sliderMusicListener( event )
        local value = event.value
                            
        --Convert the value to a floating point number we can use it to set the audio volume
        audioMusicVolume = value / 100
        -- audioMusicVolume = string.format('%.02f', audioMusicVolume )
        
        --Update the volume text to reflect the new value
        volumeMusicLabel.text = audioMusicVolume * 100 .."%"
                    
        --Set the audio volume at the current level
        audio.setVolume( audioMusicVolume, { channel = 1 } )
        audio.setVolume( audioMusicVolume, { channel = 2 } )
        audio.setVolume( audioMusicVolume, { channel = 3 } )
        audio.setVolume( audioMusicVolume, { channel = 4 } )
        audio.setVolume( audioMusicVolume, { channel = 5 } )
        audio.setVolume( audioMusicVolume, { channel = 6 } )
        if ( event.phase == "began" ) then
            volumeMusicLabel.alpha = 1
        elseif ( event.phase =="ended" ) then
            volumeMusicLabel.alpha = 0
        end
        utility.saveTable(myData.settings, "settings.json")
    end

    --Create a slider to control the volume level
    local volumeMusicSlider = widget.newSlider
    {
        left = musicLabel.x + 40,
        top = musicLabel.y - 15,
        width = 180,--_W - 80,
        orientation = "horizontal",
        listener = sliderMusicListener
    }
    sceneGroup:insert( volumeMusicSlider )

    --Create our volume label to display the current volume on screen
    volumeMusicLabel = display.newText( audioMusicVolume, (volumeMusicSlider.x + 120), musicLabel.y, "Roboto-Regular.ttf", 18 )
    volumeMusicLabel:setFillColor( 0 )
    volumeMusicLabel.alpha = 0

    -------------------------------------------------------------------------------
    -- Button Sound Volume Controller
    -------------------------------------------------------------------------------

    local soundLabel = display.newText("Botões", 100, 32, "Roboto-Regular.ttf", 18 )
    soundLabel.x = display.contentCenterX / 1.5 --/ 5.5 --- 75
    soundLabel.y = display.contentCenterY * 0.85 --130
    soundLabel:setFillColor( 0 )
    sceneGroup:insert( soundLabel )

    local volumeSoundLabel
    local audioSoundVolume = 50 -- Variable to hold sound states.

    -- Set the initial volume to match our initial audio volume variable
    audio.setVolume( audioSoundVolume, { channel = 7 } )

    --Handle slider events
    local function sliderSoundListener( event )
        local value = event.value
                            
        --Convert the value to a floating point number we can use it to set the audio volume
        audioSoundVolume = value / 100
        --audioSoundVolume = string.format('%.02f', audioSoundVolume )
        
        --Update the volume text to reflect the new value
        volumeSoundLabel.text = audioSoundVolume * 100 .."%"
                    
        --Set the audio volume at the current level
        audio.setVolume( audioSoundVolume, { channel = 7 } )
        if ( event.phase == "began" ) then
            audio.play(buttonToggle, { channel = 7 } )
            volumeSoundLabel.alpha = 1
        -- elseif ( event.phase == "moved" ) then
        --     audio.play(buttonToggle, { fadein = 200 } )
        elseif ( event.phase =="ended" ) then
            audio.play(buttonToggle, { channel = 7 } )
            volumeSoundLabel.alpha = 0
        end
        utility.saveTable(myData.settings, "settings.json")
    end

    --Create a slider to control the volume level
    local volumeSoundSlider = widget.newSlider
    {
        left = soundLabel.x + 40,
        top = soundLabel.y - 15,
        width = 180,--_W - 80,
        orientation = "horizontal",
        listener = sliderSoundListener
    }
    sceneGroup:insert( volumeSoundSlider )

    --Create our volume label to display the current volume on screen
    volumeSoundLabel = display.newText( audioSoundVolume, (volumeSoundSlider.x + 120), soundLabel.y, "Roboto-Regular.ttf", 18 )
    volumeSoundLabel:setFillColor( 0 )
    volumeSoundLabel.alpha = 0

    -------------------------------------------------------------------------------
    -- Player Sound Volume Controller
    -------------------------------------------------------------------------------

    local playerLabel = display.newText("Jogador", 100, 32, "Roboto-Regular.ttf", 18 )
    playerLabel.x = display.contentCenterX / 1.5 --/ 5.5 --- 75
    playerLabel.y = display.contentCenterY * 1.05 --130
    playerLabel:setFillColor( 0 )
    sceneGroup:insert( playerLabel )

    local volumePlayerLabel
    local audioPlayerVolume = 50 -- Variable to hold sound states.

    -- Set the initial volume to match our initial audio volume variable
    audio.setVolume( audioPlayerVolume, { channel = 11 } )

    --Handle slider events
    local function sliderPlayerListener( event )
        local value = event.value
                            
        --Convert the value to a floating point number we can use it to set the audio volume
        audioPlayerVolume = value / 100
        --audioPlayerVolume = string.format('%.02f', audioPlayerVolume )
        
        --Update the volume text to reflect the new value
        volumePlayerLabel.text = audioPlayerVolume * 100 .."%"
                    
        --Set the audio volume at the current level
        audio.setVolume( audioPlayerVolume, { channel = 11 } )
        if ( event.phase == "began" ) then
            audio.play(jumpSound, { channel = 11 } )
            volumePlayerLabel.alpha = 1
        -- elseif ( event.phase == "moved" ) then
        --     audio.play(jumpSound, { fadein = 200 } )
        elseif ( event.phase =="ended" ) then
            audio.play(jumpSound, { channel = 11 } )
            volumePlayerLabel.alpha = 0
        end
        utility.saveTable(myData.settings, "settings.json")
    end

    --Create a slider to control the volume level
    local volumePlayerSlider = widget.newSlider
    {
        left = playerLabel.x + 40,
        top = playerLabel.y - 15,
        width = 180,--_W - 80,
        orientation = "horizontal",
        listener = sliderPlayerListener
    }
    sceneGroup:insert( volumePlayerSlider )

    --Create our volume label to display the current volume on screen
    volumePlayerLabel = display.newText( audioPlayerVolume, (volumePlayerSlider.x + 120), playerLabel.y, "Roboto-Regular.ttf", 18 )
    volumePlayerLabel:setFillColor( 0 )
    volumePlayerLabel.alpha = 0

    -- local soundOnOffSwitch = widget.newSwitch({
    --     style = "onOff",
    --     id = "soundOnOffSwitch",
    --     initialSwitchState = myData.settings.soundOn,
    --     onPress = onSoundSwitchPress
    -- })
    -- soundOnOffSwitch.x = display.contentCenterX + 100
    -- soundOnOffSwitch.y = soundLabel.y
    -- sceneGroup:insert( soundOnOffSwitch )

    -- local musicOnOffSwitch = widget.newSwitch({
    --     style = "onOff",
    --     id = "musicOnOffSwitch",
    --     initialSwitchState = myData.settings.musicOn,
    --     onPress = onMusicSwitchPress
    -- })
    -- musicOnOffSwitch.x = display.contentCenterX + 100
    -- musicOnOffSwitch.y = musicLabel.y
    -- sceneGroup:insert( musicOnOffSwitch )

    -- Create the widget
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
        onEvent = handleBackButtonEvent
    })
    backButton.x = display.contentCenterX 
    backButton.y = display.contentCenterY + 110
    sceneGroup:insert( backButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
        print("_________________________")
        print("         Opções")
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
