require "vector2"

local world
local ball
local ground
local windforce

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), true)

    ball = {}
    ball.body = love.physics.newBody(world, 100, 100, "dynamic")
    ball.shape = love.physics.newCircleShape(30)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 5)
    ball.fixture:setRestitution(0.6)
    ball.fixture:setFriction(0.8)

    ground = {}
    ground.body = love.physics.newBody(world, 400, 575, "static")
    ground.shape = love.physics.newRectangleShape(800, 50)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape, 1)

    windforce = vector2.new(10, 0)
end

function love.update(dt)
    world:update(dt)
    ball.body:applyForce(windforce.x, windforce.y)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
end
