-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

-- local dusk = require("Dusk.Dusk")
local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
-- local widget = require "widget"

--------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

local screenW = display.contentWidth
local screenH = display.contentHeight
local posX = _W/2
local posY = _H/2



-- 'onRelease' event listener for playBtn
-- local function onPlayBtnRelease(e)
-- 	local eventName = e.phase
-- 	local targetName = e.target.id
-- 	-- go to level1.lua scene
-- 	if eventName == "began" then
-- 		if targetName == "play" then
-- 			composer.gotoScene( "level_game", "fade", 500 )  
-- 		elseif	targetName == "opicoes" then
-- 			composer.gotoScene( "opicoes", "fade", 500 )  
-- 		end
            
--     end
	
-- end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- Mostrar duas imagens de background para fazer um efeito de movimento infinito

	-- Mapa
	-- local currMap = "Background.json"
	-- map = dusk.buildMap("bg/"..currMap)

	--------------------------------------------------------------------------------
	-- Set Map
	--------------------------------------------------------------------------------
	-- local function setMap(mapName)
	-- 	mapX, mapY = map.getViewpoint()
	-- 	Runtime:removeEventListener("enterFrame", map.updateView)
	-- 	map.destroy()
	-- 	map = dusk.buildMap("maps/" .. mapName)
	-- 	currMap = mapName
	-- 	map.setViewpoint(mapX, mapY)
	-- 	map.snapCamera()
	-- 	-- map.setTrackingLevel(0.3)
	-- 	map:addEventListener("touch", mapTouch)
	-- 	Runtime:addEventListener("enterFrame", map.updateView)
	-- end

	local background = display.newImageRect("bg/DefBackground.png", _W, _H )
	background:scale(1, 1.2)
	background.x = 0
	background.y = centerY
	background.anchorX = 0
	-- background.anchorY = 0

	local background2 = display.newImageRect("bg/DefBackground.png", _W, _H )
	background2:scale(1, 1.2)
	background2.x = background.width
	background2.y = centerY
	background2.anchorX = 0
	-- background2.anchorY = 0

	-- create/position logo/title image on upper-half of the screen
	-- local songMenu = audio.loadStream("sound/songs/Beat_Your_Competition.mp3")
	-- audio.play(songMenu, -1)

	-- local displayText = display.newText( "Relic Hunter", centerX, 70, "_imagem/Achafexp.ttf", 60 )

	local speed = 1

	function movebg()
		background.x = background.x - speed
		background2.x = background2.x - speed
		if (background.x == -1536) then
			background.x = (2*_W) - speed
		elseif (background2.x == -1536) then --background.width
			background2.x = (2*_W) - speed
		end
	end
	Runtime:addEventListener( "enterFrame", movebg )

	-- create buttons
	-- --Play
	-- local btnPlay = widget.newButton(
	--     {
	--         id = "play",
	--         width = 90,
	--         height = 50,
	--         defaultFile = "_imagem/espaco.png",
	--         overFile = "_imagem/espaco.png",
	--         label = "play",
	--         font = "_imagem/Achafexp.ttf",
	--         fontSize = 30,
	--         onEvent = onPlayBtnRelease
	--     }
	-- )
	-- local btnOpicoes = widget.newButton(
 --    	{
	--         id = "opicoes",
	--         width = 90,
	--         height = 50,
	--         defaultFile = "_imagem/espaco.png",
	--         overFile = "_imagem/espaco.png",
	--         label = "creditos",
	--         font = "_imagem/Achafexp.ttf",
	--         fontSize = 30,
	--         onEvent = onPlayBtnRelease
	--     }
	-- )
	-- btnPlay.x = centerX
	-- btnPlay.y = 140

	-- btnOpicoes.x = centerX
	-- btnOpicoes.y = 200

	-- sceneGroup:insert(map)
	sceneGroup:insert(background)
	sceneGroup:insert(background2)
	-- sceneGroup:insert(btnPlay)
	-- sceneGroup:insert(btnOpicoes)
	-- sceneGroup:insert(displayText)
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