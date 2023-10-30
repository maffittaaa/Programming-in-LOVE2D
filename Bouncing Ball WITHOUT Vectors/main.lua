local x = 100
local y = 100
-- sendo x, y a coordenada centro da bola (meio da bola)
local xspeed = 300
local yspeed = 500
local radius = 30

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.update(dt)
    x = x + (xspeed * dt)
    y = y + (yspeed * dt)

    if (x > love.graphics.getWidth() - radius or (x < radius)) then
        xspeed = xspeed * -1
    elseif (y > love.graphics.getHeight()- radius or ( y < radius)) then
        yspeed = yspeed * -1
    end
end

function love.draw()
    love.graphics.circle("fill", x, y, radius, 30)
end