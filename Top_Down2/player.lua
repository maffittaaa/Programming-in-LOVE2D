require "vector2"
player = {}

destroy_fixture = false


function LoadPlayer(world)
    player.sprite = love.graphics.newImage("Main_character2.jpg")
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(player.sprite:getWidth(), player.sprite:getHeight())
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.fixture:setFriction(1)
    player.body:setFixedRotation(true)
    player.health = 5
    player.fixture:setUserData("player")
    -- if player_alive == true then
    --     player.healthbar = vector2.new(player.body:getX(), player.body:getY() + 60)
    -- end
end

function UpdatePlayer(dt)
    player.position = vector2.new(player.body:getPosition())
    -- if player_alive == true then
    --     -- player.healthbar = vector2.new(player.body:getX() - 35, player.body:getY() - 60)
    --     -- else
    --     --     player.healthbar:destroy_fixture()
    -- end

    local playerVelocity = vector2.new(0, 0)

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        playerVelocity.x = playerVelocity.x + 250
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerVelocity.x = playerVelocity.x - 250
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        playerVelocity.y = playerVelocity.y - 250
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        playerVelocity.y = playerVelocity.y + 250
    end

    player.body:setLinearVelocity(playerVelocity.x, playerVelocity.y)
end

function DrawPlayer()
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.rectangle("fill", player.healthbar.x, player.healthbar.y, 14 * player.health, 5)
    if player.health <= 5 and player.health > 0 then
        love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), player.body:getAngle(),
            1, 1, player.sprite:getWidth() / 2, player.sprite:getHeight() / 2)
    elseif player.health <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("LOSER! YOU ARE DEAD", 500, 500)
        if destroy_fixture == false then
            player.fixture:destroy()
            destroy_fixture = true
        end
    end
end
