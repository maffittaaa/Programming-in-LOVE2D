--Hello world moving

local array_px = {}
local array_speed = {}

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.load()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setBackgroundColor(1, 1, 1)
    for y = 1, 20, 1 do
        array_px[y] = love.math.random(0, 600)
        array_speed[y] = love.math.random (1, 20)
    end
end

function love.update(dt)
    for y = 1, 20, 1 do
        array_px[y] = array_px[y] + (100 * dt *array_speed[y])
        if (array_px[y] > love.graphics.getWidth()) then
            array_px[y] = 0
        end
    end
end

function love.draw()
    for y = 1, 20, 1 do
        love.graphics.print("Hello World", array_px[y], y * 50)
    end
end