require "vector2"
require "player"
require "ghost"

sword = {}

function LoadPlayerAttack(world)
    sword.body = love.physics.newBody(world, player.body:getX() - 40, 100, "dynamic")
    sword.shape = love.physics.newRectangleShape(sprites.sword:getWidth(), sprites.sword:getHeight())
    sword.fixture = love.physics.newFixture(sword.body, sword.shape, 2)
    sword.body:setFixedRotation(true)
    sword.fixture:setUserData("melee weapon")
    sword.body:setActive(false)
    sword.fixture:setCategory(2)
    sword.fixture:setMask(2)
end

function UpdatePlayerAttack()
    sword.position = vector2.new(player.body:getPosition())
    sword.body:setPosition(player.position.x - 40, player.position.y)
end

function DrawPlayerAttack()
    if sword.body:isActive() and player.health <= 5 and player.health > 0 then
        love.graphics.draw(sprites.sword, sword.body:getX(), sword.body:getY(), sword.body:getAngle(),
            1, 1, sprites.sword:getWidth() / 2, sprites.sword:getHeight() / 2)
    end
end
