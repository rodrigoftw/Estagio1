local composer = require( "composer" )
local widget = require( "widget" )
local ads = require( "ads" )
local store = require( "store" )
local gameNetwork = require("gameNetwork")
local utility = require( "utility" )
local myData = require( "mydata" )
local device = require( "device" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

if device.isAndroid then
	-- widget.setTheme( "widget_theme_android_holo_light" )
    store = require("plugin.google.iap.v3")
end

--
-- Load saved in settings
--
myData.settings = utility.loadTable("settings.json")
if myData.settings == nil then
	myData.settings = {}
	myData.settings.soundOn = true
	myData.settings.musicOn = true
    myData.settings.isPaid = false
	myData.settings.currentLevel = 1
	myData.settings.unlockedLevels = 9
    myData.settings.bestScore = 0
	myData.settings.levels = {}
	utility.saveTable(myData.settings, "settings.json")
end
if myData.settings.bestScore == nil then
    myData.settings.bestScore = 0
end

--
-- Initialize ads
--

--
-- Put your Ad listener and init code here
--

--
-- Initialize in app purchases
--

--
-- Put your IAP code here
--


--
-- Initialize gameNetwork
--

--
-- Put your gameNetwork login handling code here
--

--
-- Load your global sounds here

-------------------------------------------------------------------------------
-- Sounds
-------------------------------------------------------------------------------

buttonToggle = audio.loadSound( "audio/sound/player/ButtonToggle.wav" )
buttonToggle2 = audio.loadSound( "audio/sound/player/ButtonToggle2.wav" )
gravitySound2 = audio.loadSound( "audio/sound/player/Gravity2.wav" )
gravitySound = audio.loadSound( "audio/sound/player/Gravity.wav" )
deathSound2 = audio.loadSound( "audio/sound/player/Death2.wav" )
deathSound = audio.loadSound( "audio/sound/player/Death.wav" )
jumpSound = audio.loadSound( "audio/sound/player/Jump.wav" )
winSound = audio.loadSound( "audio/sound/player/Win.wav" )

-- Load scene specific sounds in the scene
--
-- myData.splatSound = audio.load("audio/splat.wav")
--

--
-- Other system events
--
local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName
    print( event.phase, event.keyName )

    if ( "back" == keyName and phase == "up" ) then
        if ( composer.getCurrentSceneName() == "menu" ) then
            native.requestExit()
        else
            composer.gotoScene( "menu", { effect="crossFade", time=500 } )
        end
        return true
    end
    return false
end

--add the key callback
if device.isAndroid then
    Runtime:addEventListener( "key", onKeyEvent )
end

--
-- handle system events
--
local function systemEvents(event)
    print("systemEvent " .. event.type)
    if event.type == "applicationSuspend" then
        utility.saveTable( myData.settings, "settings.json" )
    elseif event.type == "applicationResume" then
        -- 
        -- login to gameNetwork code here
        --
    elseif event.type == "applicationExit" then
        utility.saveTable( myData.settings, "settings.json" )
    elseif event.type == "applicationStart" then
        --
        -- Login to gameNetwork code here
        --
        --
        -- Go to the menu
        --
        composer.gotoScene( "menu", { time = 250, effect = "fade" } )
    end
    return true
end
Runtime:addEventListener("system", systemEvents)
