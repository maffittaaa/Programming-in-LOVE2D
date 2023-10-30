local world
local ball
local wall_left
local wall_right
local wall_top
local wall_bottom

--newBody(world, x, y, type)
--newRectangleShape(width, height)
--newFixture(body, shape, density)

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.load()
    world = love.physics.newWorld(0, 0, true)

    ball = {}
    ball.body = love.physics.newBody(world, 100, 100, "dynamic") -- bodies are objects with velocity and position
    ball.shape = love.physics.newCircleShape(30)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(1)
    ball.fixture:setFriction(0)

    wall_left = {}
    wall_left.body = love.physics.newBody(world, 5, 300, "static")
    wall_left.shape = love.physics.newRectangleShape(10, 600)
    wall_left.fixture = love.physics.newFixture(wall_left.body, wall_left.shape, 1)

    wall_right = {}
    wall_right.body = love.physics.newBody(world, 795, 300, "static")
    wall_right.shape = love.physics.newRectangleShape(10, 600)
    wall_right.fixture = love.physics.newFixture(wall_right.body, wall_right.shape, 1)

    wall_bottom = {}
    wall_bottom.body = love.physics.newBody(world, 400, 595, "static")
    wall_bottom.shape = love.physics.newRectangleShape(800, 10)
    wall_bottom.fixture = love.physics.newFixture(wall_bottom.body, wall_bottom.shape, 1)

    wall_top = {}
    wall_top.body = love.physics.newBody(world, 400, 5, "static")
    wall_top.shape = love.physics.newRectangleShape(800, 10)
    wall_top.fixture = love.physics.newFixture(wall_top.body, wall_top.shape, 1)

    ball.body:setLinearVelocity(400, 400)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
    love.graphics.polygon("fill", wall_left.body:getWorldPoints(wall_left.shape:getPoints()))
    love.graphics.polygon("fill", wall_right.body:getWorldPoints(wall_right.shape:getPoints()))
    love.graphics.polygon("fill", wall_bottom.body:getWorldPoints(wall_bottom.shape:getPoints()))
    love.graphics.polygon("fill", wall_top.body:getWorldPoints(wall_top.shape:getPoints()))
end