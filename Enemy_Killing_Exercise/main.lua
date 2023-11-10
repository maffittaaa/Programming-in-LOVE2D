require "vector2"

local world
local player
local ground
local enemy1
local trigger1
local trigger2
local jumps_left = 2

local dead_enemy = false --player not on top of the enemy
local player_alive = true

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
    world:setCallbacks(BeginContact, nil, nil, nil)

    ground = {}
    ground.body = love.physics.newBody(world, 400, 575, "static")
    ground.shape = love.physics.newRectangleShape(800, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)
    ground.fixture:setUserData("platform")

    enemy1 = {}
    enemy1.body = love.physics.newBody(world, 700, 500, "static")
    enemy1.shape = love.physics.newRectangleShape(150, 100)
    enemy1.fixture = love.physics.newFixture(enemy1.body, enemy1.shape, 2)
    enemy1.fixture:setUserData("platform")

    trigger1 = {}
    trigger1.body = love.physics.newBody(world, 700, enemy1.body:getY() - 50, "static") -- 
    trigger1.shape = love.physics.newRectangleShape(150, 10)
    trigger1.fixture = love.physics.newFixture(trigger1.body, trigger1.shape, 2)
    trigger1.fixture:setSensor(true)
    trigger1.fixture:setUserData("endlevel1") -- trigger na cabeça

    trigger2 = {}
    trigger2.body = love.physics.newBody(world, enemy1.body:getX() - 75, 500, "static")
    trigger2.shape = love.physics.newRectangleShape(10, 150)
    trigger2.fixture = love.physics.newFixture(trigger2.body, trigger2.shape, 2)
    trigger2.fixture:setSensor(true)
    trigger2.fixture:setUserData("endlevel2") -- trigger de lado

    player = {}
    player.body = love.physics.newBody(world, 200, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.onground = false
    player.fixture:setFriction(1)
    player.fixture:setUserData("player")
    player.body:setFixedRotation(true)
end

function BeginContact(fixtureA, fixtureB, contact)
    if fixtureA:getUserData() == "platform" and fixtureB:getUserData() == "player" then
        local normal = vector2.new(contact:getNormal())
        if normal.y == -1 then
            player.onground = true
        end
    end
        if fixtureA:getUserData() == "endlevel1" and fixtureB:getUserData() == "player" then
            dead_enemy = true
            player_alive = true
        elseif fixtureA:getUserData() == "endlevel2" and fixtureB:getUserData() == "player" then
            dead_enemy = false
            player_alive = false
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

function love.keyreleased(key)
    if (key == "space") then
        player.jumped = false
    end
end

function love.draw()
    if not dead_enemy and player_alive then
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))

        love.graphics.setColor(0, 1, 0)
        love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

        love.graphics.setColor(0.871, 0.051, 0.024)
        love.graphics.polygon("fill", enemy1.body:getWorldPoints(enemy1.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        -- love.graphics.polygon("fill", trigger1.body:getWorldPoints(trigger1.shape:getPoints()))
        -- love.graphics.polygon("fill", trigger2.body:getWorldPoints(trigger2.shape:getPoints()))
    end
    if dead_enemy == true and player_alive == true then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("You Win!", 350, 300)
    elseif not dead_enemy and player_alive == false then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("You Lose!", 350, 300)
    end
end