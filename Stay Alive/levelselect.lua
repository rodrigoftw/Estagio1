local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local params

local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.removeScene( "menu", false )
        composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
    end
end

local function handleLevelSelect( event )

    if ( "ended" == event.phase ) then
        -- set the current level to the ID of the selected level
        myData.settings.currentLevel = event.target.id
        composer.removeScene( "game", false )
        composer.gotoScene( "game", { effect = "crossFade", time = 333 } )
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
    local background = display.newRect( 0, 0, 570, 360)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    local selectLevelText = display.newText("Select a level", 125, 32, native.systemFontBold, 32)
    selectLevelText:setFillColor( 0 )
    selectLevelText.x = display.contentCenterX
    selectLevelText.y = 50
    sceneGroup:insert(selectLevelText)

    --local x = 90
    --local y = 115
    local x = 0
    local y = 0
    local buttons = {}
    local buttonBackgrounds = {}
    local buttonGroups = {}
    local levelSelectGroup = display.newGroup()
    local cnt = 1
    for i = 1, myData.maxLevels do
        buttonGroups[i] = display.newGroup()
        buttonBackgrounds[i] = display.newRoundedRect( x, y, 42, 32, 8 )
        buttonBackgrounds[i]:setFillColor( 1, 0, 1, 0.333 )
        buttonBackgrounds[i]:setStrokeColor( 1, 0, 1, 0.667 )
        buttonBackgrounds[i].strokeWidth = 1
        buttonGroups[i]:insert(buttonBackgrounds[i])
        buttonGroups[i].id = i
        if myData.settings.unlockedLevels == nil then
            myData.settings.unlockedLevels = 10
        end
        
        if i <= myData.settings.unlockedLevels then
            buttonGroups[i].alpha = 1.0
            buttonGroups[i]:addEventListener( "touch", handleLevelSelect )
        else
            buttonGroups[i].alpha = 0.5
        end
        buttons[i] = display.newText(tostring(i), 0, 0, native.systemFontBold, 28)
        buttons[i].x = x
        buttons[i].y = y
        buttonGroups[i]:insert(buttons[i])

        x = x + 55
        cnt = cnt + 1
        if cnt > 5 then
            cnt = 1
            x = 0
            y = y + 42
        end
        levelSelectGroup:insert(buttonGroups[i])
    end
    sceneGroup:insert(levelSelectGroup)
    levelSelectGroup.x = display.contentCenterX - 100
    levelSelectGroup.y = 120

    local doneButton = widget.newButton({
        id = "button1",
        label = "Done",
        width = 100,
        height = 32,
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )
end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
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
