require "vector2"

local world
local player
local ground
local platform1
local trigger1
local jumps_left = 2

local endgame = false

function love.load()
    love.physics.setMeter(30)
    world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), true)
    world:setCallbacks(BeginContact, nil, nil, nil)

    ground = {}
    ground.body = love.physics.newBody(world, 400, 575, "static")
    ground.shape = love.physics.newRectangleShape(800, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setUserData("platform")

    platform1 = {}
    platform1.body = love.physics.newBody(world, 700, 275, "static")
    platform1.shape = love.physics.newRectangleShape(150, 25)
    platform1.fixture = love.physics.newFixture(platform1.body, platform1.shape, 2)
    platform1.fixture:setUserData("platform")

    trigger1 = {}
    trigger1.body = love.physics.newBody(world, 700, 275, "static")
    trigger1.shape = love.physics.newRectangleShape(50, 550)
    trigger1.fixture = love.physics.newFixture(trigger1.body, trigger1.shape, 2)
    trigger1.fixture:setSensor(true)
    trigger1.fixture:setUserData("endlevel")

    player = {}
    player.body = love.physics.newBody(world, 200, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    player.maxvelocity = 200
    player.onground = false
    player.fixture:setFriction(1)
    player.fixture:setUserData("player")
    player.body:setFixedRotation(true)
end

function BeginContact()
    if fixtureA:getUserData() == "endlevel" and fixtureB:getUserData() == "player" then
        endgame = true
    end
    if fixtureA:getUserData() == "platform" and fixtureB:getUserData() == "player" then
        local normal = vector.new(contact:getNormal())
        if normal.y == -1 then
            player.onground = true
        end
    end
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

function love.draw()
    if not endgame then
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

        love.graphics.setColor(0, 1, 0)
        love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
        love.graphics.polygon("fill", platform1.body:getWorldPoints(platform1.shape:getPoints()))

        love.graphics.setColor(0, 0, 1)
        love.graphics.polygon("fill", trigger1.body:getWorldPoints(trigger1.shape:getPoints()))
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Game Completed!", 350, 300)
    end
end
