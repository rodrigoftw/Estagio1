-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local physics = require "physics"
physics.start()
physics.setGravity( 0, 10 )

-- physics.setDrawMode( "hybrid" )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

-- set the background image
local background = display.newImage( "bg1200800.png", _W, _H )
background:scale(0.5, 0.5)
background.x = centerX
background.y = centerY - 40

local background2 = display.newImage( "bg1200800.png", _W, _H )
background2:scale(0.5, 0.5)
background2.x = background.width - 360
background2.y = centerY - 40

local rlbullet = {}
local lrbullet = {}
local udbullet = {}
local dubullet = {}
local n = 0

--local function throwBullet()

	bulletCollisionFilter = { categoryBits = 4, maskBits = 5 }
	n = n + 1
	rlbullet[n] = display.newImage( "bullet.png", (_W + 20), 200 )
	rlbullet[n].height = 20
	rlbullet[n].width = 20
	rlbullet[n].x = _W + 50
	rlbullet[n].y = _H - 45
	-- bullet[n]:scale(0.7,0.7)
	rlbullet[n].isAwake = true
	
	physics.addBody( rlbullet[n], "static", { friction=0, bounce=0, filter = bulletCollisionFilter } )
	--rlbullet[n].GravityScale = 0

	-- remove the "isBullet" setting below to see the bullet pass through everything without colliding!
	rlbullet[n].isBullet = true
	--rlbullet[n]:applyLinearImpulse(-100, 0)
	--rlbullet[n].SetlinearVelocity = 5
	--local vx, vy = rlbullet[n]:getLinearVelocity()
	--rlbullet[n]:setLinearVelocity(-vx, - vy)
	rlbullet[n]:applyForce( -1, 0, rlbullet[n].x, rlbullet[n].y )
	--rlbullet.gravityScale = 0
	--rlbullet[n]:setLinearVelocity( -100, 0 )
	--rlbullet[n].linearDamping = 0
	--rlbullet[n].angularDamping = 0
	--rlbullet[n].angularVelocity = 0

	udbullet[n] = display.newImage( "bullet.png" )
	udbullet[n].height = 20
	udbullet[n].width = 20
	udbullet[n].x = centerX + 50
	udbullet[n].y = 50
	udbullet[n].rotation = 285
	udbullet[n].isAwake = true
	physics.addBody( udbullet[n], "static", { friction=0, bounce=0, filter = bulletCollisionFilter } )
	udbullet[n].isBullet = true
	udbullet[n]:applyForce( 0, 1, udbullet[n].x, udbullet[n].y )

local bulletspeed = 5

function moverlbullet1()
	rlbullet[1].x = rlbullet[1].x - bulletspeed
	if (rlbullet[1].x <= -100) then
		rlbullet[1].x = _W + 100
	end
end
timer.performWithDelay( 1, moverlbullet1, -1 )
--Runtime:addEventListener( "enterFrame", movebullet )

function moveudbullet1()
	udbullet[n].x = udbullet[n].x - 1
	udbullet[n].y = udbullet[n].y + bulletspeed
	if ((udbullet[n].y >= _H + 100) and (udbullet[n].x <= centerX)) then
		udbullet[n].y = -100
		udbullet[n].x = centerX + 50		
	end
end
timer.performWithDelay( 1, moveudbullet1, -1 )

function moveudbullet2()
	udbullet[n].x = udbullet[n].x - 1
	udbullet[n].y = udbullet[n].y + bulletspeed
	if ((udbullet[n].y >= _H + 100) and (udbullet[n].x <= centerX - 50)) then
		udbullet[n].y = -100
		udbullet[n].x = centerX
	end
end
timer.performWithDelay( 1, moveudbullet2, -1 )

function moveudbullet3()
	udbullet[n].x = udbullet[n].x - 1
	udbullet[n].y = udbullet[n].y + bulletspeed
	if ((udbullet[n].y >= _H + 100) and (udbullet[n].x <= centerX - 100)) then
		udbullet[n].y = -100
		udbullet[n].x = centerX -50
	end
end
timer.performWithDelay( 1, moveudbullet3, -1 )



--end



local function start()
	-- throw infinite bullets
	timer.performWithDelay( 1000, throwBullet, -1 )
end

-- wait 1000 milliseconds, then call start function above
timer.performWithDelay( 1000, start )

groundCollisionFilter = { categoryBits = 2, maskBits = 3 }

local ground = display.newImageRect("ground.png", 580, 32)
ground.width = 580
ground.x = centerX
ground.y = centerY + 145
physics.addBody(ground, "static", {density=0, bounce=0.1, friction=.2, filter = groundCollisionFilter})
ground.type = "ground"
ground.collision = onCollision

local ground2 = display.newImageRect("ground.png", 580, 32)
ground2.width = 580
ground2.x = ground.width + 240
ground2.y = centerY + 145
physics.addBody(ground2, "static", {density=0, bounce=0.1, friction=.2, filter = groundCollisionFilter})
ground2.type = "ground"
ground2.collision = onCollision

local speed = 1.5

function movebg()
  background.x = background.x - speed
  background2.x = background2.x - speed
	if(background.x == -360)then 
		background.x = 840 - speed
	elseif(background2.x == -360)then 
		background2.x = 840 - speed
	end
end
Runtime:addEventListener( "enterFrame", movebg )

local gspeed = 4

function moveg()
  ground.x = ground.x - gspeed
  ground2.x = ground2.x - gspeed
	if(ground.x == -(1.4*centerX))then 
		ground.x = (4*centerX) - 35*gspeed
	elseif(ground2.x ==  -(1.4*centerX))then 
		ground2.x = (4*centerX) - 35*gspeed
	end
end
Runtime:addEventListener( "enterFrame", moveg )

wallCollisionFilter = { categoryBits = 8, maskBits = 1 } 
-- walls collide with mario only

local leftwall = display.newRect( -50, centerY, 10, _H )
physics.addBody(leftwall, "static", { filter = wallCollisionFilter })
leftwall.alpha = 0
local rightwall = display.newRect( _W + 50, centerY, 10, _H )
physics.addBody(rightwall, "static", { filter = wallCollisionFilter })
rightwall.alpha = 0


local sheetInfo = require("spritesheet")

-- init the image sheet

local spritesheet = graphics.newImageSheet( "spritesheet.png", sheetInfo:getSheet() )

local sequenceData = {
	-- set up anmiation
	{ 
		name="run",										-- name of the animation (used with setSequence)
		sheet=spritesheet,								-- the image sheet
		start=sheetInfo:getFrameIndex("spritesheet3"),	-- name of the first frame
		count=3,										-- number of frames
		time=300,										-- speed
		loopCount=0										-- repeat
	},
	{ 
		name="jump",									-- name of the animation (used with setSequence)
		sheet=spritesheet,								-- the image sheet
		start=sheetInfo:getFrameIndex("spritesheet1"), 	-- name of the first frame
		count=2,										-- number of frames
		time=1000,										-- speed
		loopCount=1										-- repeat
    },
}

marioCollisionFilter = { categoryBits = 1, maskBits = 14 }
	-- mario collides with (2, 4 and 8) only
mario = display.newSprite( spritesheet, sequenceData )
mario.type = "player"

-- set initial position and direction
mario.x = centerX
mario.y = centerY + 95
direction = 1
mario:scale(1.3, 1.3)
physics.addBody(mario, "dynamic", {bounce = 0, friction = 10, filter = marioCollisionFilter})
mario.isFixedRotation = true
mario.collision = onCollision

-- start running animation
mario:setSequence("run")
mario:play()

local jump_completed = false

local function onTouch(event)
    if (event.phase == "began" and jump_completed == false)then
		if(event.x < mario.x) then
			-- start jumping animation
			-- jump left
			mario:setSequence("jump")
			mario:play()
			direction = -1
			mario:setLinearVelocity((event.x-mario.x), -200)
		elseif(event.x > mario.x) then
			-- start jumping animation
			-- jump right
			mario:setSequence("jump")
			mario:play()
			direction = 1
			mario:setLinearVelocity((event.x-mario.x), -200)
		elseif((event.x >= (mario.x + 10)) or (event.x <= (mario.x - 10))) then
			mario:setSequence("jump")
			mario:play()
			direction = 0
			mario:setLinearVelocity(0, -200)
		end
		jump_completed = true
	end
	
	if(event.y < (mario.y + 30)) then
		if(event.x < mario.x) then
			
		end
	end
	
	if(event.phase == "ended" and jump_completed == false)then
			jump_completed = true
			mario:setSequence("run")
			mario:play()
	end
end

Runtime:addEventListener("touch", onTouch)

local function on_hit(event)
	if(event.phase == "began")then

		jump_completed = false
		mario:setSequence("run")
		mario:play()
		
	end
end

mario:addEventListener("collision", on_hit)

-- local bullet = display.newImageRect("bullet.png", 17, 17)
-- bullet.x = _W + 40
-- bullet.y = centerY

-- bullet.speed = math.random(2,6)
-- bullet.initY = bullet.y
-- bullet.amp = math.random(20,100)
-- bullet.angle = math.random(1,360)  
-- physics.addBody(bullet, "static", {density=.1, bounce=0.1, friction=.2, radius=7.5})

-- local function shoot( event )
    -- if event.phase == 'began' then
        -- bullet = display.newImageRect("bullet.png", 17, 17)
		-- bullet.x = 3*centerX
		-- bullet.y = centerY
        -- physics.addBody( bullet, 'dynamic' )
        -- bullet.gravityScale = 0
        -- bullet.isSensor = true
        -- bullet.isBullet = true
        -- bullet.type = 'bullet'
        -- bullet:setLinearVelocity( -300, 0 )
    -- end
-- end

-- local bullettimer = timer.performWithDelay( 1000, shoot, 0 )


-- local function MarioEntersFrame(event)
	-- if ( mario.x < centerX )  then
		-- mario.x = mario.x + 10
	-- elseif ( mario.x > centerX )  then
		-- mario.x = mario.x - 10
	-- end
-- end
-- Runtime:addEventListener("enterFrame", MarioEntersFrame)


-- local function onCollision(self, event)

	-- if event.phase == "began" then
		-- if event.target.type == "player" and event.other.type == "ground" then
			-- mario:setSequence("run")
			-- mario:play()
			
			-- goodCollisionFilter = { categoryBits = 1, maskBits = 14 } 
			-- goodcell collides with (2, 4 and 8) only
			
			-- elseif event.target.type == "mario" and event.other.type == "bullet" then
		
			-- function blink()
				-- if(clockText.alpha < 1) then
					-- transition.to( clockText, {time=50, alpha=1})
				-- else 
					-- transition.to( clockText, {time=50, alpha=0})
				-- end
			-- end
			-- local tmr = timer.performWithDelay( 300, blink, 0 )
		-- end
	-- end
	-- return true
-- end