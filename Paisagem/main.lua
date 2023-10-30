local cloudx
local cloudy
local cloudscale
local iscloudy
local sunx
local suny
local sunscale

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.load()
    love.graphics.setBackgroundColor(0.855, 0.988, 0.988)
    cloudscale = 1
    cloudx = love.graphics.getWidth() / 2
    cloudy = 75
    iscloudy = false
    sunx = 100
    suny = 75
    sunscale = 1
end

function DrawGround(height)
    love.graphics.setColor(0.561, 0.922, 0.506)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - height, love.graphics.getWidth(), height)
end

-- única variável escalável é a altura, então:
-- largura tronco = 30 (largura default ) / 240 (altura default) = 0.125 * height
-- alturs tronco = 110 / 240 = 0.458 * height
-- raio folhas = 70 ( raio default ) / 240 ( altuta default ) = 0.292 * height
-- diff altura folhas e tronco - com altura 240 = 60 = 60 / 240 = 0.25 * height

function DrawTree(x, y, scale)
    scale = scale * 275
    love.graphics.setColor(0.588, 0.38, 0.027)
    love.graphics.rectangle("fill", x, y, 0.125 * scale, 0.458 * scale)                    -- tronco
    love.graphics.setColor(0.561, 0.922, 0.506)
    love.graphics.circle("fill", x + 0.0625 * scale, y - 0.25 * scale, 0.292 * scale, 192) -- folhas
end

function DrawCloud(x, y, scale)
    love.graphics.setColor(1, 1, 1)
    for i = 1, 4, 1 do
        love.graphics.circle("fill", x, y, 50 * scale, 64 * scale)
        x = x + 50 * scale
    end
end

-- única variável escalável é a scale, default scale é200, então:
-- x da porta = 110 ( valor default) / 200  = 0.55 ( valor proporcional a scale) -- xp = 0.55 * scale + x
-- y da porta = 80 (valor default) / 200  = 0.4 ( valor proporcional a scale) -- yp = 0.4 * scale + y
-- largura da porta = 60 (largura porta default) / 200  = 0.3 (valor proporcional a scale) --lp = 0.3 * scale
-- altura da porta = 120 ( altura default) / 200  = 0.6 ( valor proporcional a scale) -- ap = 0.6 * scale

-- x da janela = 30 (valor default) / 200  = 0.15 ( valor proporcional a scale) -- xj = 0.15 * scale + x
-- y da janela = 95 (valor default) / 200  = 0.475 (valor proporcional a scale) -- yj = 0.475 * scale + y
-- largura da janela = 50 (valor default) / 200  = 0.25 (valor proporcional a scale) -- lj = 0.25 * scale
-- altura da janela = 60 (valor default) / 200  = 0.3 (valor proporcional a scale) -- aj = 0.3 * scale

-- x1 = x da casa
-- y1 = y da casa
-- x2 = x da casa + largura da casa -- x2 = x da casa + scale
-- y2 = y da casa
-- x3 = x da casa + metade da largura da casa -- x3 = x da casa + 0.5 * scale
-- y3 = y da casa - 150 (valor default) / 200 = 0.75(valor proporcional a scale) -- y3 = y da casa - 0.75 * scale

function DrawHouse(x, y, scale)
    scale = scale * 200
    love.graphics.setColor(0.651, 0.647, 0.647)
    love.graphics.rectangle("fill", x, y, scale, scale)                                             -- casa
    love.graphics.setColor(0.588, 0.380, 0.027)
    love.graphics.rectangle("fill", 0.55 * scale + x, 0.4 * scale + y, 0.3 * scale, 0.6 * scale)    -- porta
    love.graphics.setColor(0.118, 0.02, 0.451)
    love.graphics.rectangle("fill", 0.15 * scale + x, 0.475 * scale + y, 0.25 * scale, 0.3 * scale) -- janela
    love.graphics.setColor(0.890, 0.467, 0)
    love.graphics.polygon("fill", x, y, x + scale, y, x + 0.5 * scale, y - 0.75 * scale)            -- telhado
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 0.6 * scale + x, y + 0.7 * scale, 0.03 * scale, 0.25 * scale)      -- maçaneta
end

-- repeat process

function DrawSun(x, y, scale)
    scale = scale * 40
    love.graphics.setColor(0.99, 0.99, 0)
    love.graphics.circle("fill", x, y, scale, 64 * scale)
    love.graphics.line(x, y, x, y - scale * 2)
    love.graphics.line(x, y, x - scale * 1.4, y - scale * 1.4)
    love.graphics.line(x, y, x - scale * 2, y)
    love.graphics.line(x, y, x - scale * 1.4, y + scale * 1.4)
    love.graphics.line(x, y, x, y + scale * 2)
    love.graphics.line(x, y, x + scale * 1.4, y + scale * 1.4)
    love.graphics.line(x, y, x + scale * 2, y)
    love.graphics.line(x, y, x + scale * 1.4, y - scale * 1.4)
end

function love.update(dt)
    cloudx = cloudx + (100 * dt)

    if (cloudx - 50 * cloudscale > love.graphics.getWidth()) then
        cloudx = -4 * (50 * cloudscale)
    end

    if ((cloudx - 50 * cloudscale) >= sunx or suny - 40 * sunscale >= cloudy or suny + 40 * sunscale <= cloudy) then
        iscloudy = false
    elseif ((cloudx - 50 * cloudscale) + 4 * (50 * cloudscale) >= sunx and (suny - 40 * sunscale <= cloudy and suny + 40 * sunscale >= cloudy)) then
        iscloudy = true
    end
    if (love.keyboard.isDown("right") and sunx + sunscale * 80 <= love.graphics.getWidth()) then
        sunx = sunx + (100 * dt)
    elseif (love.keyboard.isDown("left") and sunx - sunscale * 80 >= 0) then
        sunx = sunx - (100 * dt)
    elseif (love.keyboard.isDown("up") and suny - sunscale * 80 >= 0) then
        suny = suny - (100 * dt)
    elseif (love.keyboard.isDown("down") and suny + sunscale * 80 <= love.graphics.getHeight()) then
        suny = suny + (100 * dt)
    end

    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()

    if (love.mouse.isDown(1) and mousex + sunscale * 80 <= love.graphics.getWidth()
            and mousex - sunscale * 80 >= 0 and mousey - sunscale * 80 >= 0
            and mousey + sunscale * 80 <= love.graphics.getHeight()) then
        sunx = mousex
        suny = mousey
    end
end

function love.draw()
    if (iscloudy) then
        love.graphics.setColor(0.5, 0.5, 0.65)
    else
        love.graphics.setColor(0.855, 0.988, 0.988)
    end
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    DrawSun(sunx, suny, sunscale)
    DrawCloud(cloudx, cloudy, cloudscale)
    DrawTree(575, 375, 1)
    DrawHouse(200, 300, 1)
    DrawGround(100)
end
