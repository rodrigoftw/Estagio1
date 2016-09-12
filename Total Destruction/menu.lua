-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local screenW = display.contentWidth
local screenH = display.contentHeight

local posX = display.contentWidth/2
local posY = display.contentHeight/2

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease(e)
	local eventName = e.phase
	local targetName = e.target.id
	-- go to level1.lua scene
	if eventName == "began" then
		if targetName == "play" then
			composer.gotoScene( "game", "fade", 500 )
		elseif	targetName == "opcoes" then
			composer.gotoScene( "opcoes", "fade", 500 )
		end
    end
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	-- create/position logo/title image on upper-half of the screen
	-- local musicMenu = audio.loadSound("audios/Lines of Code.mp3")
	-- audio.play(musicMenu)

	-- local displayText = display.newText( "Relic Hunter", centerX, 70, "_imagem/Achafexp.ttf", 60 )

	-- create buttons
	local bg = display.newImage("bg2.png")
	bg.x = posX
	bg.y = posY
	-- bg.anchorX = 0
	-- bg.anchorY = 0
	--Play
	local btnPlay = widget.newButton(
	    {
	        id = "play",
	        width = 90,
	        height = 50,
	        defaultFile = "_imagem/espaco.png",
	        overFile = "_imagem/espaco.png",
	        label = "play",
	        font = "_imagem/Achafexp.ttf",
	        fontSize = 30,
	        onEvent = onPlayBtnRelease
	    }
	)
	local btnOpicoes = widget.newButton(
	    {
	        id = "opicoes",
	        width = 90,
	        height = 50,
	        defaultFile = "_imagem/espaco.png",
	        overFile = "_imagem/espaco.png",
	        label = "creditos",
	        font = "_imagem/Achafexp.ttf",
	        fontSize = 30,
	        onEvent = onPlayBtnRelease
	    }
	)
	btnPlay.x = centerX
	btnPlay.y = 140

	btnOpicoes.x = centerX
	btnOpicoes.y = 200

	sceneGroup:insert(background)
	sceneGroup:insert(btnPlay)
	sceneGroup:insert(btnOpicoes)
	sceneGroup:insert(displayText)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene