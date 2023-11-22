require "vector2"
require "player"
require "ghost"
require "healthbar"
require "sprites"
require "player_sword"
-- require "ghost_attack"
Camera = require "Camera"

local world
local ground
local speed
local height
local width
timer = 10
hitplayer = false

function love.keypressed(e)
    if e == 'escape' then
        love.event.quit()
    end
    if e == 'e' then
        if sword.body:isActive() then
            sword.body:setActive(false)
        else
            sword.body:setActive(true)
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
        if fixtureA:getUserData() == "player" and fixtureB:getUserData() == "attack" and player.health <= 5 and player.health > 0 then
            print(fixtureA:getUserData(), fixtureB:getUserData())
            hitplayer = true
            player.health = player.health - 1
            print("Player health = " .. player.health)
            if player.health <= 0 then
                enemy.isChasing = false
                player.patroling = true
            end
        end
    end
    if enemy.health <= 4 and enemy.health > 0 then
        if fixtureA:getUserData() == "attack" and fixtureB:getUserData() == "melee weapon" then
            print(fixtureA:getUserData(), fixtureB:getUserData())
            enemy.health = enemy.health - 1
            print("Enemy health = " .. enemy.health)
        end
        if fixtureA:getUserData() == "attack" and fixtureB:getUserData() == "player" then
            local force = vector2.mult(playerDiretion, 200)
            enemy.body:setLinearVelocity(-force.x, -force.y)
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
    if hitplayer == true then        
        timer = timer - (1 * dt)
    end
    UpdateHealthBars()
    UpdatePlayer(dt)
    UpdatePlayerAttack()
    UpdateEnemy(dt, world)
    -- UpdateGhostAttack()
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
    DrawPlayerAttack()
    DrawHealthBars()
    DrawEnemy()
    camera:detach()
end
