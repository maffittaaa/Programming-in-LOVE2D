require "vector2"

local world
local player
local ground
local platform1, platform2, platform3, platform4
local box1, box2, box3, box4
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
    ground.body = love.physics.newBody(world, 20, 575, "static")
    ground.shape = love.physics.newRectangleShape(1700, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setFriction(2)

    platform1 = {}
    platform1.body = love.physics.newBody(world, 175, 530, "static")
    platform1.shape = love.physics.newRectangleShape(125, 40)
    platform1.fixture = love.physics.newFixture(platform1.body, platform1.shape, 2)

    platform2 = {}
    platform2.body = love.physics.newBody(world, 350, 450, "static")
    platform2.shape = love.physics.newRectangleShape(100, 40)
    platform2.fixture = love.physics.newFixture(platform2.body, platform2.shape, 2)

    platform3 = {}
    platform3.body = love.physics.newBody(world, 500, 515, "static")
    platform3.shape = love.physics.newRectangleShape(40, 70)
    platform3.fixture = love.physics.newFixture(platform3.body, platform3.shape, 2)

    platform4 = {}
    platform4.body = love.physics.newBody(world, 650, 450, "static")
    platform4.shape = love.physics.newRectangleShape(100, 40)
    platform4.fixture = love.physics.newFixture(platform4.body, platform4.shape, 2)

    box1 = {}
    box1.body = love.physics.newBody(world, 50, 532, "dynamic")
    box1.shape = love.physics.newRectangleShape(30, 90)
    box1.fixture = love.physics.newFixture(box1.body, box1.shape, 2)
    box1.fixture:setFriction(2)

    box2 = {}
    box2.body = love.physics.newBody(world, 370, 400, "dynamic")
    box2.shape = love.physics.newRectangleShape(30, 30)
    box2.fixture = love.physics.newFixture(box2.body, box2.shape, 2)
    box2.fixture:setFriction(2)

    box3 = {}
    box3.body = love.physics.newBody(world, 670, 400, "dynamic")
    box3.shape = love.physics.newRectangleShape(30, 30)
    box3.fixture = love.physics.newFixture(box3.body, box3.shape, 2)
    box3.fixture:setFriction(2)

    box4 = {}
    box4.body = love.physics.newBody(world, 665, 530, "dynamic")
    box4.shape = love.physics.newRectangleShape(30, 30)
    box4.fixture = love.physics.newFixture(box4.body, box4.shape, 2)
    box4.fixture:setFriction(2)

    player = {}
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 70)
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

    love.graphics.setColor(0.569, 0.569, 0.557)
    love.graphics.polygon("fill", platform1.body:getWorldPoints(platform1.shape:getPoints()))
    love.graphics.polygon("fill", platform2.body:getWorldPoints(platform2.shape:getPoints()))
    love.graphics.polygon("fill", platform3.body:getWorldPoints(platform3.shape:getPoints()))
    love.graphics.polygon("fill", platform4.body:getWorldPoints(platform4.shape:getPoints()))

    love.graphics.setColor(0.871, 0.051, 0.024)
    love.graphics.polygon("fill", box1.body:getWorldPoints(box1.shape:getPoints()))
    love.graphics.polygon("fill", box2.body:getWorldPoints(box2.shape:getPoints()))
    love.graphics.polygon("fill", box3.body:getWorldPoints(box3.shape:getPoints()))
    love.graphics.polygon("fill", box4.body:getWorldPoints(box4.shape:getPoints()))
end
