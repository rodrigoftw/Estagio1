-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- local StickLib = require("lib_analog_stick")
local composer = require ("composer")
composer.gotoScene( "game" )

display.setStatusBar( display.HiddenStatusBar )

-- local dusk = require("Dusk.Dusk")

-- local physics = require ("physics")
-- -- local tiledMap = require ("tiled")
-- physics.start()
-- physics.setDrawMode("hybrid")

-- local currMap = "Teste1.json"

-- local map = dusk.buildMap("maps/" .. currMap)
-- -- map:scale( 0.5, 0.5 )
-- map.setTrackingLevel(0.3) -- "Fluidity" of the camera movement; numbers closer to 0 mean more fluidly and slowly (but 0 itself will disable the camera!)

-- local mapX, mapY


-- --------------------------------------------------------------------------------
-- -- Set Map
-- --------------------------------------------------------------------------------
-- local function setMap(mapName)
-- 	mapX, mapY = map.getViewpoint()
-- 	Runtime:removeEventListener("enterFrame", map.updateView)
-- 	map.destroy()
-- 	map = dusk.buildMap("maps/" .. mapName)
-- 	currMap = mapName
-- 	map.setViewpoint(mapX, mapY)
-- 	map.snapCamera()
-- 	map.setTrackingLevel(0.3)
-- 	map:addEventListener("touch", mapTouch)
-- 	Runtime:addEventListener("enterFrame", map.updateView)
-- end

-- local screenW = display.contentWidth
-- local screenH = display.contentHeight
-- -- local Text = display.newText( " ", screenW*.6, screenH-20, native.systemFont, 15 )
-- local posX = display.contentWidth/2
-- local posY = display.contentHeight/2
-- -- local hero
-- local localGroup = display.newGroup() -- remember this for farther down in the code
-- 	motionx = 0; -- Variable used to move character along x axis
-- 	motiony = 0; -- Variable used to move character along y axis
-- 	speed = 2; -- Set Walking Speed 
 
-- -- Criação do controle analógico
-- MyStick = StickLib.NewStick( 
--     {
--         x             = screenW*.15,
--         y             = screenH*.85,
--         thumbSize     = 16,
--         borderSize    = 32, 
--         snapBackSpeed = .2, 
--         R             = 25,
--         G             = 255,
--         B             = 255
--     }
-- )
-- MAIN LOOP
----------------------------------------------------------------
-- local function main( event )
    
--     -- Mover o personagem
--     MyStick:move(hero, 2.5, false) -- se a opção for true o objeto se move com o joystick

--     -- -- SHOW STICK INFO
--     -- Text.text = "ANGLE = "..MyStick:getAngle().."   DIST = "..math.ceil(MyStick:getDistance()).."   PERCENT = "..math.ceil(MyStick:getPercent()*100).."%"
	
-- 	-- print("MyStick:getAngle = "..MyStick:getAngle())
-- 	-- print("MyStick:getDistance = "..MyStick:getDistance())
-- 	-- print("MyStick:getPercent = "..MyStick:getPercent()*100)
-- 	-- print("POSICAO X / Y  " ..hero.x,hero.y)
	
-- 	angle = MyStick:getAngle() 
-- 	moving = MyStick:getMoving()

-- 	-- Determinar qual animação mostrar baseada na direção do controle analógico

-- 	-- TODO: Aumentar a quantidade das direções

-- 	if(angle <= 45 or angle > 315) then
-- 		seq = "forward"
-- 	elseif(angle <= 135 and angle > 45) then
-- 		seq = "right"
-- 	elseif(angle <= 225 and angle > 135) then 
-- 		seq = "back" 
-- 	elseif(angle <= 315 and angle > 225) then 
-- 		seq = "left" 
-- 	end
	
-- 	-- Mudar a sequência apenas se outra sequência não estiver rodando ainda
-- 	if(not (seq == hero.sequence) and moving) then
-- 		hero:setSequence(seq)
-- 	end

-- 	if( seq == "forward" ) and (not moving) then
-- 			hero:setSequence("attackForward")
-- 		elseif(seq == "back" ) and (not moving) then
-- 			hero:setSequence("attackBackward")
-- 		elseif(seq == "right" ) and (not moving) then
-- 			hero:setSequence("attackRight")
-- 		elseif(seq == "left" ) and (not moving) then
-- 			hero:setSequence("attackLeft")
-- 	end

-- 	-- Se o controle analógico estiver se movendo, animar o sprite
-- 	if(moving) then 
-- 		hero:play()
-- 		map.updateView()
-- 	end
	
-- end
--  timer.performWithDelay(2000, function()
--  --MyStick:delete()
--  end, 1)
-- Runtime:addEventListener( "enterFrame", main )
 
--  	-- Declarar e configurar o spritesheet e a sequência de animações
-- 	spriteOptions = {	
-- 		height = 64, 
-- 		width = 64, 
-- 		numFrames = 273, 
-- 		sheetContentWidth = 832, 
-- 		sheetContentHeight = 1344 
-- 	}
-- 	mySheet = graphics.newImageSheet("rectSmall.png", spriteOptions) 
-- 	sequenceData = {
-- 		{name = "forward", frames={105,106,107,108,109,110,111,112}, time = 500, loopCount = 1},
-- 		{name = "left", frames={118,119,120,121,122,123,124,125,126}, time = 500, loopCount = 1},
-- 		{name = "back", frames= {131,132,133,134,135,136,137,138,139}, time = 500, loopCount = 1},
-- 		{name = "right", frames={144,145,146,147,148,149,150,151,152}, time = 500, loopCount = 1},
		
		
-- 		{name = "attackForward", frames={157,158,159,160,161,162,157}, time = 400, loopCount = 1},
-- 		{name = "attackLeft", frames={170,171,172,173,174,175,170}, time = 400, loopCount = 1},
-- 		{name = "attackBack", frames={183,184,185,186,187,188,183}, time = 400, loopCount = 1},
-- 		{name = "attackRight", frames={196,197,198,199,200,201,196}, time = 400, loopCount = 1},


-- 		{name = "atkForward", frames={205,206,207,208,209,210,211}, time = 400, loopCount = 1},
-- 		{name = "atkRight", frames={219,220,221,222,223,224,225}, time = 400, loopCount = 1},
-- 		{name = "atkBack", frames={230,231,232,233,234,235,236}, time = 400, loopCount = 1},
-- 		{name = "atkLeft", frames={248,249,250,251,252,253,254}, time = 400, loopCount = 1},

-- 		{name = "death", frames={261,262,263,264,265,266}, time = 500, loopCount = 1}
-- 	}	
	
-- -- local bg = display.newImage("background.png")
-- -- bg.x = posX
-- -- bg.y = posY


-- -- Mostrar o novo sprite nas coordenadas passadas
-- hero = display.newSprite(mySheet, sequenceData)
-- hero:setSequence("forward")
-- hero.x = posX
-- hero.y = posY

-- local function onTouch(event)
-- 	if(event.phase == "ended") then
-- 		if( seq == hero.sequence ) and (event.y < hero.y) and (not moving) then
-- 			hero:setSequence("atkForward")
-- 		elseif(seq == hero.sequence ) and (event.y > hero.y) and (not moving) then
-- 			hero:setSequence("atkBack")
-- 		elseif(seq == hero.sequence ) and (event.x > hero.x) and (not moving) then
-- 			hero:setSequence("atkRight")
-- 		elseif(seq == hero.sequence ) and (event.x < hero.x) and (not moving) then
-- 			hero:setSequence("atkLeft")
-- 		end
-- 	end
-- end
-- Runtime:addEventListener( "touch", onTouch )

--[[
local bomb = display.newImageRect( "DefBomb.png", 31, 23 )
-- bomb.x = hero.x
-- bomb.y = hero.y
physics.addBody( bomb, "dynamic", { density=1.5, friction=5, bounce=0.3 } )
bomb.alpha = 0
--]]


-- local function onTouch(event)
-- 	if(event.phase == "began") then 
-- 		bomb.alpha = 1
-- 	elseif(event.phase == "ended") then
-- 		transition.to( bomb, {x=event.x, y=event.y, time = 2500, transition=easing.outExpo})
-- 	end
-- end
-- Runtime:addEventListener( "touch", onTouch )

-- localGroup:insert(bg)
-- localGroup:insert(bomb)
-- localGroup:insert(hero)


























































----------------------------------------------------------------------------------------------------


-- -- -- include the Corona "composer" module
-- -- local composer = require "composer"

-- -- -- load menu screen
-- -- composer.gotoScene( "menu" )

-- display.setStatusBar( display.HiddenStatusBar )

-- -- local math2d = require("plugin.math2d")
-- -- local dusk = require("Dusk.Dusk")
-- local StickLib   = require("lib_analog_stick")
-- system.activate( "multitouch" )
-- local physics = require ("physics")
-- physics.start()
-- physics.setDrawMode("hybrid")

-- local screenW = display.contentWidth
-- local screenH = display.contentHeight
-- -- local Text = display.newText( " ", screenW*.6, screenH-20, native.systemFont, 15 )
-- local posX = display.contentWidth/2
-- local posY = display.contentHeight/2
-- -- local hero
-- local localGroup = display.newGroup() -- remember this for farther down in the code
-- 	motionx = 0; -- Variable used to move character along x axis
-- 	motiony = 0; -- Variable used to move character along y axis
-- 	speed = 2; -- Set Walking Speed
 
-- -- Criação do controle analógico
-- MyStick = StickLib.NewStick(  
--         {
--         x             = screenW*.15,
--         y             = screenH*.85,
--         thumbSize     = 16,
--         borderSize    = 32, 
--         snapBackSpeed = .2, 
--         R             = 25,
--         G             = 255,
--         B             = 255
--         } )
--  -- MAIN LOOP
-- ----------------------------------------------------------------
-- local function main( event )

-- 		-- local map = dusk.buildMap("/maps/teste2.json")
        
--         -- Mover o personagem
--         MyStick:move(hero, 4.5, false) -- se a opção for true o objeto se move com o joystick

-- 		-- print("MyStick:getAngle = "..MyStick:getAngle())
-- 		-- print("MyStick:getDistance = "..MyStick:getDistance())
-- 		-- print("MyStick:getPercent = "..MyStick:getPercent()*100)
-- 		-- print("POSICAO X / Y  " ..hero.x,hero.y)
		
-- 		angle = MyStick:getAngle() 
-- 		moving = MyStick:getMoving()
	
-- 		-- Determinar qual animação mostrar baseada na direção do controle analógico

-- 		-- TODO: Aumentar a quantidade das direções

-- 		if(angle <= 45 or angle > 315) then
-- 			seq = "forward"
-- 		elseif(angle <= 135 and angle > 45) then
-- 			seq = "right"
-- 		elseif(angle <= 225 and angle > 135) then 
-- 			seq = "back" 
-- 		elseif(angle <= 315 and angle > 225) then 
-- 			seq = "left" 
-- 		end
		
-- 		-- Mudar a sequência apenas se outra sequência não estiver rodando ainda

-- 		if(not (seq == hero.sequence) and moving) then
-- 			hero:setSequence(seq)
-- 		end
		
-- 		-- Se o controle analógico estiver se movendo, animar o sprite
-- 		if(moving) then 
-- 			hero:play() 
-- 		end
	
-- end
--  timer.performWithDelay(2000, function()
--  --MyStick:delete()
--  end, 1)
-- Runtime:addEventListener( "enterFrame", main )
 
-- 	-- Declarar e configurar o spritesheet e a sequência de animações
-- 	spriteOptions = {	
-- 		height = 64, 
-- 		width = 64, 
-- 		numFrames = 273, 
-- 		sheetContentWidth = 832, 
-- 		sheetContentHeight = 1344 
-- 	}
-- 	mySheet = graphics.newImageSheet("rectSmall.png", spriteOptions) 
-- 	sequenceData = {
-- 		{name = "forward", frames={105,106,107,108,109,110,111,112}, time = 500, loopCount = 1},
-- 		{name = "right", frames={144,145,146,147,148,149,150,151,152}, time = 500, loopCount = 1}, 
-- 		{name = "back", frames= {131,132,133,134,135,136,137,138,139}, time = 500, loopCount = 1}, 
-- 		{name = "left", frames={118,119,120,121,122,123,124,125,126}, time = 500, loopCount = 1},
-- 		{name = "attackForward", frames={157,158,159,160,161,162,157}, time = 400, loopCount = 1},
-- 		{name = "attackRight", frames={196,197,198,199,200,201,196}, time = 400, loopCount = 1},
-- 		{name = "attackBack", frames={183,184,185,186,187,188,183}, time = 400, loopCount = 1},
-- 		{name = "attackLeft", frames={170,171,172,173,174,175,170}, time = 400, loopCount = 1},
-- 		{name = "death", frames={261,262,263,264,265,266}, time = 500, loopCount = 1}
-- 	}	
	
-- local bg = display.newImage("background.png")
-- bg.x = posX
-- bg.y = posY


-- -- Mostrar o novo sprite nas coordenadas passadas
-- hero = display.newSprite(mySheet, sequenceData)
-- hero:setSequence("forward")
-- hero.x = posX
-- hero.y = posY
-- --[[
-- local bomb = display.newImageRect( "DefBomb.png", 31, 23 )
-- -- bomb.x = hero.x
-- -- bomb.y = hero.y
-- physics.addBody( bomb, "dynamic", { density=1.5, friction=5, bounce=0.3 } )
-- bomb.alpha = 0
-- --]]


-- -- local function onTouch(event)
-- -- 	if(event.phase == "began") then 
-- -- 		bomb.alpha = 1
-- -- 	elseif(event.phase == "ended") then
-- -- 		transition.to( bomb, {x=event.x, y=event.y, time = 2500, transition=easing.outExpo})
-- -- 	end
-- -- end
-- -- Runtime:addEventListener( "touch", onTouch )

-- localGroup:insert(bg)
-- -- localGroup:insert(bomb)
-- localGroup:insert(hero)



