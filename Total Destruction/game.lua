-----------------------------------------------------------------------------------------
--
-- Game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include libraries
local StickLib = require("lib_analog_stick")
local physics = require ("physics")
physics.start() 
--physics.pause();
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")
local dusk = require("Dusk.Dusk")
--------------------------------------------

local screenW = display.contentWidth
local screenH = display.contentHeight

local posX = display.contentWidth/2
local posY = display.contentHeight/2

-- function onCollision(event)
--     if ( event.phase == "began" ) then               
--     	-- Check if body still exists before removing!
--     	if (event.target.myName == "dardo" and event.other.myName == "player") then
--         	fireTrapsGroup:remove(event.target)
--             event.target = nil             
--             display.remove(detector)
--             Runtime:removeEventListener("enterFrame",update)
--             timer.cancel(timerImpact)
--             --limparButtons()
--             playerMorrer()
--         elseif (event.target.myName == "dardo" and event.other.myName == "linha") then
--           	fireTrapsGroup:remove(event.target)
--             event.target = nil
--         elseif(event.target.actived == true and event.other.myName =="player") then
--         	event.target.actived = false
--         	event.target:setSequence("block_desativado")
--         	coletedRelics = coletedRelics + 1
--         	print(coletedRelics)
--         elseif(event.target.myName == "gold" and event.other.myName =="player") then
--         	event.target.actived = false
--         	coletedRelics = coletedRelics + 1
--         	local alert = native.showAlert("Parabéns", "Suba as Escadas e vá para próximo nivel", {"Ok", "Cancelar"})
--         	print(coletedRelics)
--         end
--     end
-- end




-- local hero
local localGroup = display.newGroup() -- remember this for farther down in the code
	motionx = 0; -- Variable used to move character along x axis
	motiony = 0; -- Variable used to move character along y axis
	speed = 2; -- Set Walking Speed

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	local currMap = "Teste1.json"

	local map = dusk.buildMap("maps/" .. currMap)

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
		map.setTrackingLevel(0.3)
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

	map:scale( 0.5, 0.5 )
	map.updateView()
	-- map.setTrackingLevel(0.3) -- "Fluidity" of the camera movement; numbers closer to 0 mean more fluidly and slowly (but 0 itself will disable the camera!)

	local mapX, mapY

	map.layer["Shadows"].alpha = 0.45
	map.layer[""]

 	 
	-- Criação do controle analógico
	MyStick = StickLib.NewStick( 
	    {
	        x             = screenW*.15,
	        y             = screenH*.85,
	        thumbSize     = 16,
	        borderSize    = 32, 
	        snapBackSpeed = .2, 
	        R             = 25,
	        G             = 255,
	        B             = 255
	    }
	)

	-- Declarar e configurar o spritesheet e a sequência de animações
	spriteOptions = {	
		height = 64, 
		width = 64, 
		numFrames = 273, 
		sheetContentWidth = 832, 
		sheetContentHeight = 1344 
	}

	mySheet = graphics.newImageSheet("rectSmall.png", spriteOptions) 
	sequenceData = {
		{name = "forward", frames={105,106,107,108,109,110,111,112}, time = 500, loopCount = 1},
		{name = "left", frames={118,119,120,121,122,123,124,125,126}, time = 500, loopCount = 1},
		{name = "back", frames= {131,132,133,134,135,136,137,138,139}, time = 500, loopCount = 1},
		{name = "right", frames={144,145,146,147,148,149,150,151,152}, time = 500, loopCount = 1},
		
		
		{name = "attackForward", frames={157,158,159,160,161,162,157}, time = 400, loopCount = 1},
		{name = "attackLeft", frames={170,171,172,173,174,175,170}, time = 400, loopCount = 1},
		{name = "attackBack", frames={183,184,185,186,187,188,183}, time = 400, loopCount = 1},
		{name = "attackRight", frames={196,197,198,199,200,201,196}, time = 400, loopCount = 1},


		{name = "atkForward", frames={205,206,207,208,209,210,211}, time = 400, loopCount = 1},
		{name = "atkRight", frames={219,220,221,222,223,224,225}, time = 400, loopCount = 1},
		{name = "atkBack", frames={230,231,232,233,234,235,236}, time = 400, loopCount = 1},
		{name = "atkLeft", frames={248,249,250,251,252,253,254}, time = 400, loopCount = 1},

		{name = "death", frames={261,262,263,264,265,266}, time = 500, loopCount = 1}
	}

	-- Mostrar o novo sprite nas coordenadas passadas
	hero = display.newSprite(mySheet, sequenceData)
	hero:setSequence("forward")
	hero.x = posX - 110
	hero.y = posY + 15
	hero:scale(0.7, 0.7)

	-- Mover o personagem
    MyStick:move(hero, 2.5, false) -- se a opção for true o objeto se move com o joystick

    -- -- SHOW STICK INFO
    -- Text.text = "ANGLE = "..MyStick:getAngle().."   DIST = "..math.ceil(MyStick:getDistance()).."   PERCENT = "..math.ceil(MyStick:getPercent()*100).."%"
	
	-- print("MyStick:getAngle = "..MyStick:getAngle())
	-- print("MyStick:getDistance = "..MyStick:getDistance())
	-- print("MyStick:getPercent = "..MyStick:getPercent()*100)
	-- print("POSICAO X / Y  " ..hero.x,hero.y)
	
	angle = MyStick:getAngle() 
	moving = MyStick:getMoving()

	-- Determinar qual animação mostrar baseada na direção do controle analógico

	-- TODO: Aumentar a quantidade das direções

	if(angle <= 45 or angle > 315) then
		seq = "forward"
	elseif(angle <= 135 and angle > 45) then
		seq = "right"
	elseif(angle <= 225 and angle > 135) then 
		seq = "back" 
	elseif(angle <= 315 and angle > 225) then 
		seq = "left" 
	end
	
	-- Mudar a sequência apenas se outra sequência não estiver rodando ainda
	if(not (seq == hero.sequence) and moving) then
		hero:setSequence(seq)
	end

	if( seq == "forward" ) and (not moving) then
			hero:setSequence("attackForward")
		elseif(seq == "back" ) and (not moving) then
			hero:setSequence("attackBackward")
		elseif(seq == "right" ) and (not moving) then
			hero:setSequence("attackRight")
		elseif(seq == "left" ) and (not moving) then
			hero:setSequence("attackLeft")
	end

	-- Se o controle analógico estiver se movendo, animar o sprite
	if(moving) then 
		hero:play()
		map.setCameraFocus(hero)
		map.updateView()
	end
	
	-- timer.performWithDelay(2000, function()
	-- --MyStick:delete()
	-- end, 1)
	-- Runtime:addEventListener( "enterFrame", main )

	
	-- local bg = display.newImage("background.png")
	-- bg.x = posX
	-- bg.y = posY

	-- local function onTouch(event)
	-- 	if (event.phase == "began" ) then
	-- 		-- Mover o personagem ao segurar a tela
	-- 		-- map:addEventListener("touch", mapTouch)
	-- 	end
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

	
	local bomb = display.newImageRect( "DefBomb.png", 31, 23 )
	bomb.x = hero.x
	bomb.y = hero.y
	physics.addBody( bomb, "dynamic", { density=1.5, friction=5, bounce=0.3 } )
	bomb:scale( 0.5, 0.5 )
	bomb.alpha = 0
	

	
	local function onTouch(event)
		if(event.phase == "began") then
			bomb.alpha = 1
		elseif(event.phase == "ended") then
			transition.to( bomb, {x=event.x, y=event.y, time = 2500, transition=easing.outExpo})
		end
	end
	Runtime:addEventListener( "touch", onTouch )
	

	-- localGroup:insert(bg)
	sceneGroup:insert(localGroup)
	localGroup:insert(map)
	localGroup:insert(bomb)
	localGroup:insert(hero)

	-- -- Linha de colissões
	-- local linha1 = display.newRect(1252,954,10,50)
	-- linha1.myName = "linha"
	-- physics.addBody(linha1,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha1)

	-- local linha2 = display.newRect(1244,1150,10,50)
	-- linha2.myName = "linha"
	-- physics.addBody(linha2,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha2)

	-- local linha3 = display.newRect(1726,1888,50,10)
	-- linha3.myName = "linha"
	-- physics.addBody(linha3,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha3)

	-- local linha4 = display.newRect(1304,1884,50,10)
	-- linha4.myName = "linha"
	-- physics.addBody(linha4,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha4)

	-- local linha5 = display.newRect(30,1708,10,50)
	-- linha5.myName = "linha"
	-- physics.addBody(linha5,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha5)

	-- local linha6 = display.newRect(32,1340,10,50)
	-- linha6.myName = "linha"
	-- physics.addBody(linha6,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha6)

	-- local linha7 = display.newRect(1728,450,50,10)
	-- linha7.myName = "linha"
	-- physics.addBody(linha7,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha7)

	-- local linha8 = display.newRect(220,400,50,10)
	-- linha8.myName = "linha"
	-- physics.addBody(linha8,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha8)

	-- local linha9 = display.newRect(704,766,50,10)
	-- linha9.myName = "linha"
	-- physics.addBody(linha9,"static",{isSensor = true})
	-- map.layer["colisao"]:insert(linha9)

	--Player
	-- 	player = display.newSprite(playerSheet,playerSequenceData)
	-- 	player:setSequence("idleRigth")
	-- 	playerGroup:insert( player )
	-- 	physics.addBody( playerGroup,"dinamic",{density=3.0, friction=0.5, bounce=0.3})
	-- 	playerGroup.isFixedRotation = true
	-- 	playerGroup.x = 0	
	-- 	playerGroup.y = 925
	-- 	playerGroup.myName = "player"
	-- 	map.layer["player"]:insert(playerGroup)

	-- 	coletedRelics = 0
		
	-- 	relic = {}
		
	-- 	relic[1] = display.newSprite(rosaSheet,rosaSequenceData)
	-- 	relic[1].x,relic[1].y = 98,164
	-- 	physics.addBody(relic[1],"static",{density=3.0, friction=0.5, bounce=0.3})
	-- 	relic[1].actived = true
	-- 	relic[1]:setSequence("block_ativado")

	-- 	relic[2] = display.newSprite(azulSheet,azulSequenceData)
	-- 	relic[2].x,relic[2].y = 1787,1757
	-- 	physics.addBody(relic[2],"static",{density=3.0, friction=0.5, bounce=0.3})
	-- 	relic[2].actived = true
	-- 	relic[2]:setSequence("block_ativado")
		
	-- 	relic[3] = display.newSprite(amareloSheet,amareloSequenceData)
	-- 	relic[3].x,relic[3].y = 161,1761
	-- 	physics.addBody(relic[3],"static",{density=3.0, friction=0.5, bounce=0.3})
	-- 	relic[3].actived = true
	-- 	relic[3]:setSequence("block_ativado")
		
	-- 	relic[4] = display.newSprite(verdeSheet,verdeSequenceData)
	-- 	relic[4].x,relic[4].y = 1789,289
	-- 	physics.addBody(relic[4],"static",{density=3.0, friction=0.5, bounce=0.3})
	-- 	relic[4].actived = true
	-- 	relic[4]:setSequence("block_ativado")
		
	-- 	relic[5] = display.newSprite(verdeSheet,verdeSequenceData)
	-- 	relic[5].x,relic[5].y = 1789,289
	-- 	physics.addBody(relic[4],"static",{density=3.0, friction=0.5, bounce=0.3})
	-- 	relic[5].actived = true
	-- 	relic[5].myName = "gold"
	-- 	relic[5]:setSequence("block_ativado")
		
	-- 	local i = 1
	-- 	for i=1,#relic do
	-- 		relic[i]:addEventListener("collision",onCollision)
	-- 		map.layer["relics"]:insert(relic[i])
	-- 	end

	--  	local sensor1 = display.newImageRect("crate.png",30,30)
	--  	sensor1.x = 1330
	--  	sensor1.y = 800
	-- 	physics.addBody(sensor1,"static",{isSensor = true})
	-- 	sensor1.actived = false
	-- 	sensor1.myName = "sensor"
	-- 	sensor1:addEventListener("collision", start1)
	-- 	map.layer[1]:insert(sensor1)

	--  	local sensor2 = display.newImageRect("crate.png",30,30)
	--  	sensor2.x = 1330
	--  	sensor2.y = 1010
	-- 	physics.addBody(sensor2,"static",{isSensor = true})
	-- 	sensor2.actived = false
	-- 	sensor2.myName = "sensor"
	-- 	sensor2:addEventListener("collision", start2)
	-- 	map.layer[1]:insert(sensor2)
	 
	--  	local sensor3 = display.newImageRect("crate.png",30,30)
	--  	sensor3.x = 1615
	--  	sensor3.y = 1813
	-- 	physics.addBody(sensor3,"static",{isSensor = true})
	-- 	sensor3.actived = false
	-- 	sensor3.myName = "sensor"
	-- 	sensor3:addEventListener("collision", start3)
	-- 	map.layer[1]:insert(sensor3)
	 
	--  	local sensor4 = display.newImageRect("crate.png",30,30)
	--  	sensor4.x = 1220
	--  	sensor4.y = 1753
	-- 	physics.addBody(sensor4,"static",{isSensor = true})
	-- 	sensor4.actived = false
	-- 	sensor4.myName = "sensor"
	-- 	sensor4:addEventListener("collision", start4)
	-- 	map.layer[1]:insert(sensor4)
	 

	-- 	local sensor5 = display.newImageRect("crate.png",30,30)
	--  	sensor5.x = 280
	--  	sensor5.y = 1580
	-- 	physics.addBody(sensor5,"static",{isSensor = true})
	-- 	sensor5.actived = false
	-- 	sensor5.myName = "sensor"
	-- 	sensor5:addEventListener("collision", start5)
	-- 	map.layer[1]:insert(sensor5)
	 
	 		
	-- 	local sensor6 = display.newImageRect("crate.png",30,30)
	--  	sensor6.x = 197
	--  	sensor6.y = 1344
	-- 	physics.addBody(sensor6,"static",{isSensor = true})
	-- 	sensor6.actived = false
	-- 	sensor6.myName = "sensor"
	-- 	sensor6:addEventListener("collision", start6)
	-- 	map.layer[1]:insert(sensor6)
	 

	-- 	local sensor7 = display.newImageRect("crate.png",30,30)
	--  	sensor7.x = 1627
	--  	sensor7.y = 344
	-- 	physics.addBody(sensor7,"static",{isSensor = true})
	-- 	sensor7.actived = false
	-- 	sensor7.myName = "sensor"
	-- 	sensor7:addEventListener("collision", start7)
	-- 	map.layer[1]:insert(sensor7)


	-- 	local sensor8 = display.newImageRect("crate.png",30,30)
	--  	sensor8.x = 324
	--  	sensor8.y = 368
	-- 	physics.addBody(sensor8,"static",{isSensor = true})
	-- 	sensor8.actived = false
	-- 	sensor8.myName = "sensor"
	-- 	sensor8:addEventListener("collision", start8)
	-- 	map.layer[1]:insert(sensor8)

	-- 	local sensor9 = display.newImageRect("crate.png",30,30)
	--  	sensor9.x = 881
	--  	sensor9.y = 692
	-- 	physics.addBody(sensor9,"static",{isSensor = true})
	-- 	sensor9.actived = false
	-- 	sensor9.myName = "sensor"
	-- 	sensor9:addEventListener("collision", start9)
	-- 	map.layer[1]:insert(sensor9)
		

	--  	local chegada = display.newImage("_imagem/escada.png")
	--  	chegada.x = map.data.width/2 + 230
	--  	chegada.y = map.data.height/2 - 150
	--  	physics.addBody(chegada,"static",{isSensor = true})
	--     chegada:addEventListener("collision", chegadaGame)

	    	
		   
	--  	detector =display.newImageRect("_imagem/detector.png",40,40)
	--  	detector.x,detector.y = 50,260 
	--  	detector.actived = false
	--  	detector:addEventListener("touch",radar)

	-- criaButtons()

	--  sceneGroup:insert(chegada)
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