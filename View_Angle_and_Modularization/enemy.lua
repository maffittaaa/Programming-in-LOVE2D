require "vector2"

local enemy

function CreateEnemy(world)
    enemy = {}
    enemy.sprite = love.graphics.newImage("spaceship.png")
    enemy.body = love.physics.newBody(world, 700, 500, "dynamic")
    enemy.shape = love.physics.newRectangleShape(enemy.sprite:getWidth() * 0.3, enemy.sprite:getHeight() * 0.3)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
    enemy.body:setLinearDamping(0.3)
    enemy.direction = vector2.new(-1, 0)
    enemy.body:setAngle(math.atan2(enemy.direction.y, enemy.direction.x))
    enemy.viewangle = 30
    enemy.chasing = false
end

function UpdateEnemy(dt, playerposition)
    enemy.direction = vector2.new(math.cos(enemy.body:getAngle()), math.sin(enemy.body:getAngle()))
    

    print("GetPosition:", enemy.body:getPosition())
    print("Playpos:" , playerposition)
    if (CanSee(vector2.new(enemy.body:getPosition()), enemy.direction, playerposition, enemy.viewangle)) then
        enemy.chasing = true
    end
    if enemy.chasing then
        print("PlayerPosition ", playerposition)
        print("Func: ", vector2.new(enemy.body:getPosition()))
        local playerdirection = vector2.norm(vector2.sub(playerposition, vector2.new(enemy.body:getPosition())))
        local engineForce = vector2.mult(playerdirection, 800)

        enemy.body:applyForce(engineForce.x, engineForce.y)

        local enemyvelocity = vector2.new(enemy.body:getLinearVelocity())

        enemy.body:setAngle(math.atan2(enemyvelocity.y, enemyvelocity.x))
    end
end

function DrawEnemy()
    love.graphics.draw(enemy.sprite, enemy.body:getX(), enemy.body:getY(), enemy.body:getAngle(), 0.3, 0.3, enemy.sprite:getWidth() / 2, enemy.sprite:getHeight() / 2)
end

function CanSee(p1, p1lookdirection, p2, viewangle)
    local direction = vector2.norm(vector2.sub(p2, p1))
    local angle = math.acos(vector2.dot(p1lookdirection, direction))

    if (math.deg(angle) < viewangle) then
        return true
    end
    return false
end