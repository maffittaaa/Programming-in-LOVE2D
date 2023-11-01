require "vector2"

local world
local player
local ground
local jumps_left = 2
--love.physics.setMeter: Sets the pixels to meter scale factor;
-- All coordinates in the physics module are divided by this number and converted to meters,
--  and it creates a convenient way to draw the objects directly to the screen without the need for graphics transformations.
-- It is recommended to create shapes no larger than 10 times the scale.
-- This is important because Box2D is tuned to work well with shape sizes from 0.1 to 10 meters. The default meter scale is 30.

-- love.physics.newWorld: This function creates a new World with the given size, no gravity and sleeping turned on.

function love.keypressed(e)
    if e == 'escape' then
        love.event.quit()
    end
    if e == 'up' and jumps_left > 0 then
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

    player = {}
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.onground = false
    player.jumped = false
    player.fixture:setFriction(1)
    player.body:setFixedRotation(true)
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
    if (key == "up") then
        player.jumped = false
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

    love.graphics.setColor(1, 1, 1)
    -- if player.onground then
    --     love.graphics.print("true")
    -- else
    --     love.graphics.print("false")
    -- end
    love.graphics.print(jumps_left)
end
