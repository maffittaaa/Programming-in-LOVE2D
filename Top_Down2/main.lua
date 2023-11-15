require "vector2"
require "player"
require "ghost"
require "healthbar"
require "sprites"
require "player_attacking"
Camera = require "Camera"

local world
local ground
local speed
local height
local width

enemy_alive = true
player_alive = true

function love.keypressed(e)
    if e == 'escape' then
        love.event.quit()
    end
    if e == 'e' then
        if sword.body:isAwake(true) then
            sword.body:setAwake(false)
        else
            sword.body:setAwake(true)
        end
    end
end

function love.load()
    love.physics.setMeter(30)
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(BeginContact, nil, nil, nil)

    -- love.window.setMode(1920, 1080)
    -- height = love.graphics.getHeight()
    -- width = love.graphics.getWidth()

    LoadSprites()
    LoadPlayer(world)
    LoadPlayerAttack(world)
    LoadEnemy(world)

    camera = Camera()
end

function BeginContact(fixtureA, fixtureB)
    if enemy.isChasing == true and enemy.playerInSight == true then
        if fixtureA:getUserData() == "player" and fixtureB:getUserData() == "melee attack" and player.health <= 5 and player.health > 0 then
            print(fixtureA:getUserData(), fixtureB:getUserData())
            player.health = player.health - 1
            print("Player health = " .. player.health)
            if player.health <= 0 then
                enemy.isChasing = false
                player.patroling = true
                enemy_alive = true
                player_alive = false
            end
        end
    end
    print(fixtureA:getUserData(), fixtureB:getUserData())
    if fixtureA:getUserData() == "melee weapon" and fixtureB:getUserData() == "melee attack" and enemy.health <= 4 and enemy.health > 0 then
        enemy.health = enemy.health - 1
        print("Enemy health = " .. enemy.health)
        if enemy.health <= 0 then
            player_alive = true
            enemy_alive = false
        end
    end
end

function love.update(dt)
    world:update(dt)
    camera:update(dt)
    camera:follow(player.body:getX(), player.body:getY())
    camera:setFollowLerp(0.2)
    camera:setFollowLead(0)
    camera:setFollowStyle('TOPDOWN')
    UpdateHealthBars()
    UpdatePlayer(dt)
    UpdatePlayerAttack()
    UpdateEnemy(dt, world)
end

-- function love.keyreleased(key)
--     if (key == "e") then
--         sword.body:setAwake(false)
--     end
-- end

function love.draw()
    camera:attach()
    love.graphics.draw(sprites.background, 0, 0)
    DrawPlayer()
    DrawHealthBars()
    DrawPlayerAttack()
    DrawEnemy()
    camera:detach()
end
