require "vector2"

local world
local player
local ground
local box1, box2, box3
local jumps_left = 2

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

    ground = {}
    ground.body = love.physics.newBody(world, 400, 575, "static")
    ground.shape = love.physics.newRectangleShape(800, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setFriction(2)

    box1 = {}
    box1.body = love.physics.newBody(world, 600, 525, "dynamic")
    box1.shape = love.physics.newRectangleShape(50, 50)
    box1.fixture = love.physics.newFixture(box1.body, box1.shape, 2)

    box2 = {}
    box2.body = love.physics.newBody(world, 600, 475, "dynamic")
    box2.shape = love.physics.newRectangleShape(50, 50)
    box2.fixture = love.physics.newFixture(box2.body, box2.shape, 2)

    box3 = {}
    box3.body = love.physics.newBody(world, 600, 425, "dynamic")
    box3.shape = love.physics.newRectangleShape(50, 50)
    box3.fixture = love.physics.newFixture(box3.body, box3.shape, 2)

    player = {}
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.onground = false
    player.jumped = false
    player.fixture:setFriction(1)
    player.body:setFixedRotation(true) -- significa que nunca vai tombar para o lado por exemplo
end

function love.update(dt)
    world:update(dt)

    local playerGravityForce = vector2.new(0, 1200)
    player.body:applyForce(playerGravityForce.x, playerGravityForce.y)

    local playerVelocity = vector2.new(player.body:getLinearVelocity())

    --player movement
    if (love.keyboard.isDown("right")) then
        --local moveForce = vector2.new(700, 0)
        --player.body:applyForce(moveForce.x, moveForce.y)
        player.body:setLinearVelocity(300, playerVelocity.y)
    elseif (love.keyboard.isDown("left")) then
        --local moveForce = vector2.new(-700, 0)
        --player.body:applyForce(moveForce.x, moveForce.y)
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

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", box1.body:getWorldPoints(box1.shape:getPoints()))

    love.graphics.polygon("fill", box2.body:getWorldPoints(box2.shape:getPoints()))

    love.graphics.polygon("fill", box3.body:getWorldPoints(box3.shape:getPoints()))
end