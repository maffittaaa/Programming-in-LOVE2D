require "vector2"

local position = vector2.new(100, 100)
local velocity = vector2.new(300, 500)
local radius = 30

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.update(dt)
    position = vector2.add(position, vector2.mult(velocity, dt))

    if ((position.x > love.graphics.getWidth() - radius) or (position.x < radius)) then
        velocity.x = velocity.x * -1
    end
    if ((position.y > love.graphics.getHeight() - radius) or (position.y < radius)) then
        velocity.y = velocity.y * -1
    end
end

function love.draw()
    love.graphics.circle("fill", position.x, position.y, radius, 30)
end   