-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
-- physics.setDrawMode( "hybrid" )

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.setGravity(0,0)
	-- physics.pause()

	-- local dusk = require("Dusk.Dusk")
	-- local map = dusk.buildMap("Teste1.json")

	--Create global screen boundaries
	local leftWall = display.newRect(-45,0,1, display.contentHeight*2 )
	local rightWall = display.newRect (display.contentWidth+45, 0, 1, display.contentHeight*2)
	local topWall = display.newRect (0, -1, ((display.contentWidth*2)+90), 1)
	local bottomWall = display.newRect (0, display.contentHeight+1, ((display.contentWidth*2)+90), 1)

	physics.addBody (leftWall, "static", { bounce = 1} )
	physics.addBody (rightWall, "static", { bounce = 1} )
	physics.addBody (topWall, "static", { bounce = 1} )
	physics.addBody (bottomWall, "static", { bounce = 1} )

	
	-- set the background image
	-- local background = display.newImage( "bg1200800.png", _W, _H )
	-- background:scale(0.5, 0.5)
	-- background.x = centerX
	-- background.y = centerY - 40
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1 )

	-- make a bomb and position it
	local bomb = display.newImageRect( "DefBomb.png", 31, 23 )
	bomb.x = centerX
	bomb.y = centerY
	-- add physics to the bomb
	physics.addBody( bomb, "dynamic", { density=1.5, friction=5, bounce=0.3 } )

	-- Function useful for dragging stuff around, not much precise though
	-- function map:touch( event )
	-- 	if event.phase == "began" then
	-- 		self.markX = self.x
	-- 		self.markY = self.y
	-- 	elseif event.phase == "moved" then
	-- 		local x = (event.x - event.xStart) + self.markX
	-- 		local y = (event.y - event.yStart) + self.markY
	-- 		self.x, self.y = x, y
	-- 	end
	-- 	return true
	-- end
	
	-- map:addEventListener( "touch",  map )

	-- Touch anywhere on the screen and the bomb will be "thrown" in the desired direction
	-- No way realistic, I gotta improve that
	local function onTouch(event)
		if(event.phase == "ended") then 
			transition.to( bomb, {x=event.x, y=event.y, time = 2500, transition=easing.outExpo})
			-- bomb:setLinearVelocity((event.x-bomb.x), (event.y-bomb.y))
		end
	end
	Runtime:addEventListener( "touch", onTouch )

	function fall( event )
    	falling = transition.to( bomb, {time=800, y=bomb.y-500, transition=easing.inSine} )
	end

	-- all display objects must be inserted into group
	sceneGroup:insert( leftWall )
	sceneGroup:insert( rightWall )
	sceneGroup:insert( topWall )
	sceneGroup:insert( bottomWall )
	sceneGroup:insert( background )
	-- sceneGroup:insert( map )
	sceneGroup:insert( bomb )
	
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
		physics.start()

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
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene