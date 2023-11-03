require "vector2"

-- What is the difference between linear damping and angular damping?
-- The angular field indicates the amount of damping that must be applied to the body's angular motion. 
-- The linear damping can be used, e.g., to slow down a vehicle by simulating air or water friction. 
-- The angular damping can be used, e.g., to slow down the rotation of a rolling ball or the spin of a coin.


local player

function CreatePlayer(world)
    player = {}
    player.sprite = love.graphics.newImage("spaceship.png")
    player.body = love.physics.newBody(world, 400, 300, "dynamic")
    player.shape = love.physics.newRectangleShape(player.sprite:getWidth() * 0.3, player.sprite:getHeight() * 0.3)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.body:setLinearDamping(0.3)
end

function UpdatePlayer(dt)
    local mouseposition = vector2.new(love.mouse.getX(), love.mouse.getY())
    local mousedirection = vector2.sub(mouseposition, vector2.new(player.body:getPosition()))

    mousedirection = vector2.norm(mousedirection)
    ----------
    local rotation = math.atan2(mousedirection.y, mousedirection.x)
    player.body:setAngle(rotation)

    if (love.mouse.isDown(1)) then
        local engineForce = vector2.mult(mousedirection, 800)
        player.body:applyForce(engineForce.x, engineForce.y)
    end
end

function DrawPlayer()
    love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), player.body:getAngle(),
                        0.3, 0.3, player.sprite:getWidth() / 2, player.sprite:getHeight() / 2)
end

function GetPlayerPosition()
    return vector2.new(player.body:getPosition())
end