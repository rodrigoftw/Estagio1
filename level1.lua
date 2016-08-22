-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require( "physics" )

-- physics.setDrawMode( "debug" )
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.setGravity( 0, 1 )

	function changeGravity()
		physics.setGravity( math.random(-1, 1), math.random(-1, 1) )
	end
	Timertimer = timer.performWithDelay(500, changeGravity, -1)

	--physics.pause()

	--Create global screen boundaries
	local leftWall = display.newRect(-45,0,1, display.contentHeight*2 )
	local rightWall = display.newRect (display.contentWidth+45, 0, 1, display.contentHeight*2)
	local topWall = display.newRect (0, -1, ((display.contentWidth*2)+90), 1)
	local bottomWall = display.newRect (0, display.contentHeight+1, ((display.contentWidth*2)+90), 1)

	physics.addBody (leftWall, "static", { bounce = 1} )
	physics.addBody (rightWall, "static", { bounce = 1} )
	physics.addBody (topWall, "static", { bounce = 1} )
	physics.addBody (bottomWall, "static", { bounce = 1} )

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newImageRect( "plane.png", 570, 320 ) --screenW, screenH )
	background.x = -45
	background.y = 0
	background.anchorX = 0
	background.anchorY = 0
	-- background:setFillColor( .5 )
	
	-- make a crate (off-screen), position it, and rotate slightly
	-- local crate = display.newImageRect( "crate.png", 90, 90 )
	-- crate.x, crate.y = 160, -100
	-- crate.rotation = 15

	-- -- add physics to the crate
	-- physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	
	-- create a grass object and add physics (with custom shape)
	-- local grass = display.newImageRect( "grass.png", screenW, 82 )
	-- grass.anchorX = 0
	-- grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	-- grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	-- local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	-- physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	function dragBody( event, params )
		local body = event.target
		local phase = event.phase
		local stage = display.getCurrentStage()

		if "began" == phase then            
			stage:setFocus( body, event.id )
			body.isFocus = true
			
			if params and params.center then
				body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
			else
				body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
			end
			
			if params then
				local maxForce, frequency, dampingRatio

				if params.maxForce then				
					body.tempJoint.maxForce = params.maxForce
				end
				
				if params.frequency then				
					body.tempJoint.frequency = params.frequency
				end
				
				if params.dampingRatio then				
					body.tempJoint.dampingRatio = params.dampingRatio
				end
			end
		
		elseif body.isFocus then
			if "moved" == phase then								
				body.tempJoint:setTarget( event.x, event.y )
			elseif "ended" == phase or "cancelled" == phase then
				stage:setFocus( body, nil )
				body.isFocus = false								
				body.tempJoint:removeSelf()			
			end
		end	
		return true
	end
	
	local text1 = display.newText( "Hello", 50, 50, native.systemFont, 28)
	text1:setTextColor( 255,255,255 )
	text1.x = halfW
	text1.y = 0
	text1.rotation = 15

	physics.addBody( text1, "dynamic", { density=1.0, friction=0.3, bounce=0.3 } )
	text1:addEventListener( "touch", dragBody )

	local text2 = display.newText( "World!", 50, 50, native.systemFont, 28)
	text1:setTextColor( 255,255,255 )
	text2.x = halfW
	text2.y = 50
	text2.rotation = -15

	physics.addBody( text2, "dynamic", { density=1.0, friction=0.3, bounce=0.3 } )
	text2:addEventListener( "touch", dragBody )

	function changeColor()
    	local r = math.random( 0, 100 )
    	local g = math.random( 0, 100 )
    	local b = math.random( 0, 100 )
    	text1:setFillColor( r/100, g/100, b/100 )
    	text2:setFillColor( r/100, g/100, b/100 )
	end
	colorTimer = timer.performWithDelay(100, changeColor, -1)

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( text1 )
	sceneGroup:insert( text2 )
	-- sceneGroup:insert( grass )
	-- sceneGroup:insert( crate )
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