require "enemy"
require "player"

local world

function love.load()
    world = love.physics.newWorld(0, 0, true)
    CreatePlayer(world)
    CreateEnemy(world)
end

function love.update(dt)
    world:update(dt)
    UpdatePlayer(dt)
    UpdateEnemy(dt, GetPlayerPosition())
end

function love.draw()
    DrawPlayer()
    DrawEnemy()
end