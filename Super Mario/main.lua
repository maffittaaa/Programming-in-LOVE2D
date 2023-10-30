local ground
local background
local cloud
local pipe

function love.keypressed(e)
    if (e == 'escape') then
        love.event.quit()
    end
end

function love.load()
    ground = love.graphics.newImage("mario_ground.png")
    background = love.graphics.newImage("mario_background.png")
    cloud = love.graphics.newImage("mario_cloud.png")
    pipe = love.graphics.newImage("mario_pipe.png")
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0.749, 1)
    for x = 0, (love.graphics.getWidth() / background:getWidth()), 1 do
        love.graphics.draw(background, x * background:getWidth(), 245)
    end
    love.graphics.draw(pipe, 475, 430)
    for x = 0, (love.graphics.getWidth() / ground:getWidth()), 1 do
        love.graphics.draw(ground, x * ground:getWidth(), 500)
    end
    love.graphics.draw(cloud, 175, 25)
end