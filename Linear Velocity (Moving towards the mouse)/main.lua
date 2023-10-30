require "vector2"

local world
local ball

function love.load()
    world = love.physics.newWorld(0, 0, true)
    ball = {}
    ball.body = love.physics.newBody(world, 100, 100, "dynamic")
    ball.shape = love.physics.newCircleShape(30)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setFriction(0)
end

function love.update(dt)
    local mouseposition = vector2.new(love.mouse.getX(), love.mouse.getY())
    local mousedirection = vector2.sub(mouseposition, vector2.new(ball.body:getPosition())) -- vetor da direção

    if vector2.mag(mousedirection) > 2 then -- ??
        mousedirection = vector2.norm(mousedirection)
        local velocity = vector2.mult(mousedirection, 600)
        ball.body:setLinearVelocity(velocity.x, velocity.y)
    else
        ball.body:setLinearVelocity(0, 0)
    end

    world:update(dt)
end

function love.draw()
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
end