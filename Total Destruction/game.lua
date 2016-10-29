-----------------------------------------------------------------------------------------
--
-- Game.lua
--
-----------------------------------------------------------------------------------------

local dusk = require("Dusk.Dusk")
local composer = require("composer")
local scene = composer.newScene()
local StickLib = require("libs.lib_analog_stick")
local Player = require("player")
local physics = require("physics")
local widget = require ("widget")
system.activate( "multitouch" )
physics.start() 
physics.setGravity( 0, 0 )
-- physics.setDrawMode("hybrid")

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

-- local screenW = display.contentWidth
-- local screenH = display.contentHeight
local posX = display.contentWidth/2
local posY = display.contentHeight/2



--------------------------------------------

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- Mapa
	local currMap = "Teste1.tmx"
	map = dusk.buildMap("maps/"..currMap)

	dusk.setPreference("virtualObjectsVisible", true)

	-- local songMenu = audio.loadStream("sound/songs/Beat_Your_Competition.mp3", -1)
	-- audio.play(songMenu)
	-- audio.setVolume( 0.005 )

	--------------------------------------------------------------------------------
	-- Set Map
	--------------------------------------------------------------------------------
	local function setMap(mapName)
		mapX, mapY = map.getViewpoint()
		Runtime:removeEventListener("enterFrame", map.updateView)
		map.destroy()
		map = dusk.buildMap("maps/" .. mapName)
		currMap = mapName
		map.setViewpoint(mapX, mapY)
		map.snapCamera()
		-- map.setTrackingLevel(0.3)
		map:addEventListener("touch", mapTouch)
		Runtime:addEventListener("enterFrame", map.updateView)
	end

	--------------------------------------------------------------------------------
	-- Map Touch Event
	--------------------------------------------------------------------------------
	function mapTouch(event)
		local viewX, viewY = map.getViewpoint()
		local eventX, eventY = map:contentToLocal(event.x, event.y)
		if "began" == event.phase then
			display.getCurrentStage():setFocus(map)
			map.isFocus = true
			map._x, map._y = eventX + viewX, eventY + viewY
		elseif map.isFocus then
			if "moved" == event.phase then
				map.setViewpoint(map._x - eventX, map._y - eventY)
				map.updateView() -- Update the map's camera and culling directly after changing position
			elseif "ended" == event.phase then
				display.getCurrentStage():setFocus(nil)
				map.isFocus = false
			end
		end
	end

	local x = 1
	physics.setDrawMode("normal")
	-- Function to handle button events
	local function handleButtonEvent( event )
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
	local button1 = widget.newButton(
	    {
	        left = _W*0.75,
	        top = _H*0.85,
	        id = "collisionButton",
	        label = "Ver Colisões",
			labelColor = { default = { 0, 0, 0 }, over = { 1, 1, 1, 0.5 } },
	        onEvent = handleButtonEvent
	    }
	)

	-- local function restartLevel( event )
 --    -- When you tap the "I Win" button, reset the "nextlevel" scene, then goto it.
 --    -- Using a button to go to the nextlevel screen isn't realistic, but however you determine to 
 --    -- when the level was successfully beaten, the code below shows you how to call the gameover scene.
	--     if event.phase == "ended" then
	--         -- composer.removeScene("game")
	--         -- composer.gotoScene("game", { time= 500, effect = "crossFade" })
	--         native.requestExit()
	--     end
	--     return true
	-- end

	-- local restart = widget.newButton(
	-- 	{
	-- 		id = "restartButton",
	-- 		label = "Sair",
	-- 		labelColor = { default = { 1, 1, 1 }, over = { 0, 0, 0, 0.5 } },
	-- 	    left = _W*0.5,
	--         top = _H*0.85,
	-- 		onEvent = restartLevel
	-- 	}
	-- )

	-- local function QuitButtonHit(event)
	-- 	native.requestExit()
	-- 	return true
	-- end

	-- local quitbutton = display.newImageRect("quitbutton.png", 174, 42 )
	-- quitbutton.x = display.contentWidth * 0.5
	-- quitbutton.y = 280
	-- quitbutton.gotoScene = "quit"
	-- restart:addEventListener("tap", QuitButtonHit)

	function onCollision(event)
    	if event.phase == "began" then
			if event.target.type == "player" and event.other.type == "wall" then
				-- Como fazer o player se encostar contra a parece e não atravessá-la?
			elseif event.target.type == "player" and event.other.type == "object" then
				-- O player toca a bandeira e a fase acaba.
				timer.cancel(Timer)
				-- composer.gotoScene( "results" )
			elseif event.target.type == "player" and event.other.type == "bomb" then
				-- O player morre por uma explosão.
				hero:removeSelf()
				hero = nil
			end
		end
		return true
	end

	-- numberBombs = 2

	-- local function spawnBombs()
	--    for i = 1, numberBombs do
	--     	local bomb = display.newImageRect( "maps/DefBomb.png", 16, 12 )
	--     	bomb.alpha = 0
	--       	bomb.x = hero.x
	-- 		bomb.y = hero.y
	-- 		bomb.type = "bomb"
	-- 		physics.addBody( bomb, "static", { density=1.5, friction=5, bounce=0.5 } )
	-- 		bomb.alpha = 1
	--       	transition.to( bomb, {x=event.x, y=event.y, time = 2000, transition=easing.outExpo, onComplete=clearBombs });

	--     	-- Adding touch event
	--     	bomb:addEventListener( "touch", onTouch );
	--    end
	-- end

	-- timer.performWithDelay( 2000, spawnBombs, 0 )  -- fire every 10 seconds

	-- local function clearBombs( bomb )
	-- 	display.remove( bomb );
	-- 	bomb = nil
	-- end
	
	map:scale( 0.5, 0.5 )
	-- map.updateView()
	-- map.setTrackingLevel(0.3) -- "Fluidity" of the camera movement; numbers closer to 0 mean more fluidly and slowly (but 0 itself will disable the camera!)


	map.layer["Shadows"].alpha = 0.45
	map.layer["Hero"].type = player
	map.layer["DestructableWalls"].type = wall

	-- local block = display.newRect(352,416,64,64)
	-- block.type = "wall"
	-- physics.addBody(block, "static", {isSensor = true})
	-- map.layer["DestructableWalls"]:insert(block)
	-- map.layer["DestructableCeilings"]:insert(block)

	local tile = map.layer["DestructableWalls"].tileByPixels(352, 416)

	for tile in map.layer["DestructableWalls"].tilesInRange(0, 0, _W, _H) do
		tile.type = "wall"
		physics.addBody(tile, "static", {isSensor = true})
		map.layer["DestructableWalls"]:insert(tile)
		map.layer["DestructableCeilings"]:insert(tile)
	end
	
	-- map.layer["Objects"].type = finishline
	-- local finish = display.newRect(888,624,12,48)
	-- finish.type = "finishline"
	-- finish.alpha = 0
	-- physics.addBody(finish,"static",{isSensor = true})
	-- map.layer["Objects"]:insert(finish)
	-- finish:addEventListener("collision", finish)
	-- map.layer["DestructableWalls"].collision = onCollision
	-- map.layer["DestructableWalls"].type = wall
	
	
	-- wallCollisionFilter = { categoryBits = 2, maskBits = 5 }

	-- local block = display.newRect(352,416,32,32)
	-- block.type = "wall"
	-- block.bodyType = "static"
	-- -- physics.addBody(block,"static",{filter = wallCollisionFilter, isSensor = true})
	-- map.layer["Collision"]:insert(block)
	-- block:addEventListener("collision", block)
	-- map.layer["DestructableCeilings"].collision = onCollision
	-- map.layer["DestructableCeilings"].type = wall
	-- block.isSleepingAllowed = false
	-- block.isBodyActive=true

	-- local block2 = display.newRect(736,608,32,32)
	-- block2.type = "wall"
	-- block2.bodyType = "static"
	-- physics.addBody(block2,"static",{filter = wallCollisionFilter, isSensor = true})
	-- map.layer["Collision"]:insert(block2)
	-- block2:addEventListener("collision", block2)
	-- block2.isSleepingAllowed = false
	-- block2.isBodyActive=true

	-- map.layer["Collision"]:insert(hero)
	map.layer["Collision"].alpha = 0
	-- map.layer["Hero"]:insert(hero)
	-- map.setCameraFocus(hero)

	-----------Timer-----------
	-- Contar o tempo em segundos
	local secondsPassed = 00 * 00-- * 00  -- Exemplo: 2 minutos * 30 segundos
 
	local clockText = display.newText("00:00", ((display.contentCenterX*2) - (display.contentCenterX*0.05)), 15, native.systemFontBold, 20) -- display.contentCenterX + 170
	clockText:setFillColor( 1, 1, 1 )
	
	-- Dar um update no timer a cada segundo passado
	local function updateTime()
		-- Incrementar o número de segundos
		secondsPassed = secondsPassed + 1
	
		-- O tempo é contado em segundos.  Converter o tempo para minutos e segundos
		local seconds = secondsPassed % 60
		local minutes = math.floor( secondsPassed / 60 )
		-- local hours   = math.floor( minutes / 60 )

		-- Transformar o resultado em uma string usando string.format
		timeDisplay = string.format( "%02d:%02d", minutes, seconds )
		clockText.text = timeDisplay
		clockText.alpha = 1

		map.setDamping(1)
		map.setCameraFocus(hero)
		map.updateView()
	end

	-- local reloadMap = timer.performWithDelay( 1, map.updateView(), seconds )
	
	-- Rodar timer
	local Timer = timer.performWithDelay( 1, updateTime, secondsPassed )

	if minutes == 1 and timeDisplay == ("01:00") then
		timer.cancel(Timer)
		function blink()
		if(clockText.alpha < 1) then
			transition.to( clockText, {time=50, alpha=1})
		else 
			transition.to( clockText, {time=50, alpha=0})
		end
		-- if(scoreText.alpha < 1) then
		-- 	transition.to( scoreText, {time=100, alpha=1})
		-- else 
		-- 	transition.to( scoreText, {time=100, alpha=0})
		-- end
		-- if(scoreTxt.alpha < 1) then
		-- 	transition.to( scoreTxt, {time=100, alpha=1})
		-- else 
		-- 	transition.to( scoreTxt, {time=100, alpha=0})
		-- end
	end
	local blinkTimer = timer.performWithDelay( 300, blink, 0 )
	end

	local centerX, centerY = map.getViewpoint()
	local top = centerY - display.contentCenterY
	local bottom = centerY + display.contentCenterY
	local left = centerX - display.contentCenterX
	local right = centerX + display.contentCenterX

	map.layer["Hero"]:insert(hero)
	map.setCameraBounds({
		xMin = display.contentCenterX,
		yMin = display.contentCenterY,
		xMax = map.data.width / 1.48,
		yMax = map.data.height - display.contentCenterY
		-- Use map.data.width because that's the "real" width of the map - 
		-- map.width changes when culling kicks inyMax = map.data.height - display.contentCenterY -- Same here
	})
 

	-- local bomb = display.newImageRect( "maps/DefBomb.png", 16, 12 )
	-- bomb.x = hero.x
	-- bomb.y = hero.y
	-- bomb.type = "bomb"
	-- physics.addBody( bomb, "static", { density=1.5, friction=5, bounce=0.5 } )
	-- -- bomb:scale( 0.5, 0.5 )
	-- bomb.alpha = 0
	
	local function onTouch(event)
		if(event.phase == "began") then
			-- bomb.alpha = 1
		elseif(event.phase == "ended") then
			-- transition.to( bomb, {x=event.x, y=event.y, time = 2000, transition=easing.outExpo})
		end
	end
	Runtime:addEventListener( "touch", onTouch )

	-- function reloadPosition()
	-- 	bomb.x = hero.x
	-- 	bomb.y = hero.y
	-- end
	-- positionTimer = timer.performWithDelay(100, reloadPosition, -1)

	sceneGroup:insert(map)
	-- sceneGroup:insert(bomb)
 	
end
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- S
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

		physics.start()
		physics.setGravity( 0, 0 )
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
		--physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		audio.stop(songMenu)
		map.destroy()
		--composer.removeScene( "game" )
	end	
	
end


function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	--package.loaded[physics] = nil
	--physics = nil
end

---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene