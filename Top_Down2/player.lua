require "vector2"
require "sprites"
player = {}
local force = 500

destroy_player_fixture = false


function LoadPlayer(world)
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(sprites.player:getWidth(), sprites.player:getHeight())
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.fixture:setFriction(0.5)
    player.body:setFixedRotation(true)
    player.fixture:setCategory(2)
    player.fixture:setMask(2) 
    player.health = 5
    player.knockX = 0
    player.knockY = 0
    player.fixture:setUserData("player")
end

function UpdatePlayer(dt)
    player.position = vector2.new(player.body:getPosition())

    local playerVelocity = vector2.new(0, 0)
    if player.health <= 0 then
        return
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        playerVelocity.x = playerVelocity.x + 250
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerVelocity.x = playerVelocity.x - 250
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        playerVelocity.y = playerVelocity.y - 250
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        playerVelocity.y = playerVelocity.y + 250
    end

    -- Passar isto para uma funcao no futuro :(
    if player.knockX > 0 then
        player.knockX = player.knockX - dt * force
    elseif player.knockY < 0 then
        player.knockX = player.knockX + dt * force
    end
    if player.knockY > 0 then
        player.knockY = player.knockY - dt * force
    elseif player.knockY < 0 then
        player.knockY = player.knockY + dt * force
    end
    player.body:setLinearVelocity(player.knockX + playerVelocity.x, player.knockY + playerVelocity.y)
end

function DrawPlayer()
    if player.health <= 5 and player.health > 0 then
        local velx, vely =  player.body:getLinearVelocity()
        if velx >= 0 then
            love.graphics.draw(sprites.player, player.body:getX(), player.body:getY(), player.body:getAngle(),
            1, 1, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)
        else
            love.graphics.draw(sprites.player, player.body:getX(), player.body:getY(), player.body:getAngle(),
            -1, 1, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)
        end
    elseif player.health <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("LOSER! YOU ARE DEAD", 500, 500)
        if destroy_player_fixture == false then
            player.fixture:destroy()
            destroy_player_fixture = true
        end
        player.body:setLinearVelocity(0, 0)
    end
end

function PushPlayerBack()
    local playerDiretion = vector2.sub(player.position, vector2.new(enemy.body:getPosition()))
    playerDiretion = vector2.norm(playerDiretion)
                    
    local force = vector2.mult(playerDiretion, force)
    player.knockX = force.x
    player.knockY = force.y
end