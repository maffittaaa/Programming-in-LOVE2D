require "vector2"
require "player"
require "ghost"

sword = {}

-- function GetSwordRotation(direction)
--     if direction == "right" or direction == "d" then
--         return 0
--     elseif direction == "left" or direction == "a" then
--         return math.pi
--     elseif direction == "up" or direction == "w" then
--         return (math.pi / 2) * 3
--     elseif direction == "down" or direction == "s" then
--         return math.pi / 2
--     end
-- end

function LoadPlayerAttack(world)
    sword.body = love.physics.newBody(world, player.body:getX() - 40, 100, "dynamic")
    sword.shape = love.physics.newRectangleShape(sprites.sword:getWidth(), sprites.sword:getHeight())
    sword.fixture = love.physics.newFixture(sword.body, sword.shape, 2)
    sword.body:setFixedRotation(true)
    sword.fixture:setUserData("melee weapon")
    sword.body:setActive(false)
end

function UpdatePlayerAttack()
    sword.position = vector2.new(player.body:getPosition())
    sword.body:setPosition(player.position.x - 40, player.position.y)
    -- sword.body:setAngle(direction)
end

function DrawPlayerAttack()
    if sword.body:isActive() then
        love.graphics.draw(sprites.sword, sword.body:getX(), sword.body:getY(), sword.body:getAngle(),
            1, 1, sprites.sword:getWidth() / 2, sprites.sword:getHeight() / 2)
    end
end
