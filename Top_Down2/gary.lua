require "vector2"
require "sprites"
gary = {}
local force = 500

destroy_gary_fixture = false


function LoadGary(world)
    gary.body = love.physics.newBody(world, 400, 100, "dynamic")
    gary.shape = love.physics.newRectangleShape(sprites.gary:getWidth(), sprites.gary:getHeight())
    gary.fixture = love.physics.newFixture(gary.body, gary.shape, 1)
    gary.maxvelocity = 200
    gary.fixture:setFriction(1)
    gary.body:setFixedRotation(true)
    gary.fixture:setCategory(2)
    gary.fixture:setMask(2)
    gary.health = 5
    gary.knockX = 0
    gary.knockY = 0
    gary.fixture:setUserData("player")
end

function UpdateGary(dt)
    gary.position = vector2.new(gary.body:getPosition())

    local garyVelocity = vector2.new(0, 0)
    if gary.health <= 0 then
        return
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        garyVelocity.x = garyVelocity.x + 250
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        garyVelocity.x = garyVelocity.x - 250
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        garyVelocity.y = garyVelocity.y - 250
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        garyVelocity.y = garyVelocity.y + 250
    end

    -- Passar isto para uma funcao no futuro :(
    if gary.knockX > 0 then
        gary.knockX = gary.knockX - dt * force
    elseif gary.knockY < 0 then
        gary.knockX = gary.knockX + dt * force
    end
    if gary.knockY > 0 then
        gary.knockY = gary.knockY - dt * force
    elseif gary.knockY < 0 then
        gary.knockY = gary.knockY + dt * force
    end
    gary.body:setLinearVelocity(gary.knockX + garyVelocity.x, gary.knockY + garyVelocity.y)
    -- gary.body:setLinearVelocity(garyVelocity.x, garyVelocity.y)
end

function DrawGary()
    if gary.health <= 5 and gary.health > 0 then
        local velx, vely = gary.body:getLinearVelocity()
        if velx >= 0 then
            love.graphics.draw(sprites.gary, gary.body:getX(), gary.body:getY(), gary.body:getAngle(),
                1, 1, sprites.gary:getWidth() / 2, sprites.gary:getHeight() / 2)
        else
            love.graphics.draw(sprites.gary, gary.body:getX(), gary.body:getY(), gary.body:getAngle(),
                -1, 1, sprites.gary:getWidth() / 2, sprites.gary:getHeight() / 2)
        end
    elseif gary.health <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("LOSER! YOU ARE DEAD", 500, 500)
        if destroy_gary_fixture == false then
            gary.fixture:destroy()
            destroy_gary_fixture = true
        end
        gary.body:setLinearVelocity(0, 0)
    end
end

function PushGaryBack()
    local garyDiretion = vector2.sub(gary.position, vector2.new(ghost.body:getPosition()))
    garyDiretion = vector2.norm(garyDiretion)

    local force = vector2.mult(garyDiretion, force)
    gary.knockX = force.x
    gary.knockY = force.y
end

function GetPlayerPosition()
    return vector2.new(gary.body:getX(), gary.body:getY())
end
