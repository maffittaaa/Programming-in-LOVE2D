require "vector2"
require "player"
require "enemy"
Camera = require "Camera"

local world
local ground
local sprites
local speed
local height
local width


function love.keypressed(e)
    if e == 'escape' then
        love.event.quit()
    end
end

function love.load()
    love.physics.setMeter(30)
    world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), true)

    love.window.setMode(1920, 1080)
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    sprites = {}
    sprites.background = love.graphics.newImage("background5.jpg")

    LoadPlayer(world)
    LoadEnemy(world)

    camera = Camera()
end

function love.update(dt)
    world:update(dt)
    camera:update(dt)
    camera:follow(player.body:getX(), player.body:getY())
    camera:setFollowLerp(0.2)
    camera:setFollowLead(0)
    camera:setFollowStyle('TOPDOWN')
    UpdatePlayer(dt)
    UpdateEnemy(dt, world)
end

function love.draw()
    camera:attach()
    love.graphics.draw(sprites.background, 0, 0)
    DrawPlayer()
    DrawEnemy()
    camera:detach()
end
