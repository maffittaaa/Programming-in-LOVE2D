require "vector2"
require "player"
require "ghost"
require "healthbar"
require "sprites"
require "player_sword"
Camera = require "Camera"

local world
local ground
local speed
local height
local width

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
            enemy.timer = 1 -- tempo de cooldown para perseguir outra vez
            player.health = player.health - 1
            print("Player health = " .. player.health)
            PushPlayerBack()
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
            -- Testes
            if enemy.health <= 0 then
                    enemy.isChasing = false
                    enemy.patroling = false
                    -- enemy.fixture:destroy()
                    -- trigger.fixture:destroy()
                    -- enemy.body:destroy()
                    print('Morreu :')
            end
            -- End testes
            print("Enemy health = " .. enemy.health)
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

function love.draw()
    camera:attach()
    love.graphics.draw(sprites.background, 0, 0)
    DrawPlayer()
    DrawPlayerAttack()
    DrawHealthBars()
    DrawEnemy()
    camera:detach()
end
