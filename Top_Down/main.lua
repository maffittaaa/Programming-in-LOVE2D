require "vector2"
Camera = require "Camera"

local jumps_left = 2
local player
local world
local ground


function love.keypressed(e)
    if e == 'escape' then
        love.event.quit()
    end
    if e == 'space' and jumps_left > 0 then
        local jumpForce = vector2.new(0, -1000)
        player.body:applyLinearImpulse(jumpForce.x, jumpForce.y)
        player.jumped = true
        jumps_left = jumps_left - 1
    end
end

function love.load()
    love.physics.setMeter(30)
    world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), true)

    loadGround()
    loadPlayer()
    camera = Camera()
end

function love.update(dt)
    world:update(dt)
    camera:update(dt)
    camera:follow(player.body:getX(), player.body:getY())
    camera:setFollowLerp(0.2)
    camera:setFollowLead(0)
    camera:setFollowStyle('SCREEN_BY_SCREEN')
    --camera:fade(1, { 0, 0, 0, 0 }) (UTIL PARA MUDANCA DE NIVEL)



    local playerGravityForce = vector2.new(0, 1200)
    player.body:applyForce(playerGravityForce.x, playerGravityForce.y)

    local playerVelocity = vector2.new(player.body:getLinearVelocity())

    --player movement
    if (love.keyboard.isDown("d")) then
        player.body:setLinearVelocity(300, playerVelocity.y)
    elseif (love.keyboard.isDown("a")) then
        player.body:setLinearVelocity(-300, playerVelocity.y)
    else
        player.body:setLinearVelocity(0, playerVelocity.y)
    end

    --max velocity
    local velocity = vector2.new(player.body:getLinearVelocity())
    if (velocity.x > 0) then
        player.body:setLinearVelocity(math.min(velocity.x, player.maxvelocity), velocity.y)
    else
        player.body:setLinearVelocity(math.max(velocity.x, -player.maxvelocity), velocity.y)
    end

    --check if player is on ground
    local contacts = player.body:getContacts()
    if (#contacts == 0) then
        player.onground = false
    elseif (player.jumped == false) then
        player.onground = true
        jumps_left = 2
    end
end

function love.keyreleased(key)
    if (key == "space") then
        player.jumped = false
    end
end

function loadPlayer()
    player = {}
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 70)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.onground = false
    player.jumped = false
    player.fixture:setFriction(1)
    player.body:setFixedRotation(true)
end

function loadGround()
    ground = {}
    ground.body = love.physics.newBody(world, 20, 575, "static")
    ground.shape = love.physics.newRectangleShape(1700, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setFriction(2)
end

function love.draw()
    camera:attach()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
    camera:detach()
end
