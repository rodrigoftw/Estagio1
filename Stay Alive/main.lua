local device = require( "device" )
local composer = require( "composer" )
local gameNetwork = require("gameNetwork")
local store = require( "store" )
local myData = require( "mydata" )
local utility = require( "utility" )
local ads = require( "ads" )
local widget = require( "widget" )

io.output():setvbuf("no") -- Don't use buffer for console messages
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
-------------------------------------------------------------------------------
-- Screen Variables
-------------------------------------------------------------------------------

centerX = display.contentCenterX
centerY = display.contentCenterY
_W = display.contentWidth
_H = display.contentHeight

--
-- Load your global sounds here

-------------------------------------------------------------------------------
-- Channels
-------------------------------------------------------------------------------

-- Master Audio Volume - No Channel Specified
-- Title Music - Channel 1
-- Levels 1-10 - Channel 2
-- Levels 11-20 - Channel 3
-- Levels 21-29 - Channel 4
-- Level 30 - Channel 5
-- Ending - Channel 6
-- Button Toggle Sound - Channel 7
-- Jump Sound - Channel 8
-- Death Sound - Channel 9
-- Winning Sound - Channel 10
-- Jump Sound - Channel 11
-- Gravity Sound - Channel 12

-------------------------------------------------------------------------------
-- Sounds
-------------------------------------------------------------------------------

buttonToggle = audio.loadSound( "audio/sound/player/used/ButtonToggle.wav" )
buttonToggle2 = audio.loadSound( "audio/sound/player/unused/ButtonToggle2.wav" )
gravitySound2 = audio.loadSound( "audio/sound/player/unused/Gravity2.wav" )
gravitySound = audio.loadSound( "audio/sound/player/used/Gravity.wav" )
deathSound2 = audio.loadSound( "audio/sound/player/unused/Death2.wav" )
deathSound = audio.loadSound( "audio/sound/player/used/Death.wav" )
jumpSound = audio.loadSound( "audio/sound/player/used/Jump.wav" )
winSound = audio.loadSound( "audio/sound/player/used/Win.wav" )

-------------------------------------------------------------------------------
-- Music
-------------------------------------------------------------------------------

titleMusic = audio.loadStream("audio/music/Beat_Your_Competition.mp3")
levels1_10 = audio.loadStream("audio/music/Righteous.mp3")
levels11_20 = audio.loadStream("audio/music/Invisible.mp3")
levels21_29 = audio.loadStream("audio/music/TFB9.mp3")
level30 = audio.loadStream("audio/music/Galactic_Damages.mp3")
ending = audio.loadStream("audio/music/Secret_Conversations.mp3")

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
