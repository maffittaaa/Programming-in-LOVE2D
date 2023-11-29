require "vector2"
require "gary"
-- require "ghost"
-- require "healthbar"
require "sprites"
require "gary_sword"
require "valkyrie"
Camera = require "Camera"

local world
local ground
local speed
height = love.graphics.getHeight()
width = love.graphics.getWidth()
inventory = { key = false, life = false }

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
    if e == "f" then
        inventory.key = true
        inventory.life = true
    end
end

function love.load()
    love.physics.setMeter(30)
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(BeginContact, EndContact, nil, nil)

    love.window.setMode(1920, 1080)

    LoadSprites()
    LoadGary(world)
    LoadGaryAttack(world)
    -- LoadGhost(world)
    LoadValquiria(world)

    camera = Camera()
end

-- function BeginContact(fixtureA, fixtureB)
--     if ghost.isChasing == true and ghost.garyInSight == true then
--         if fixtureA:getUserData() == "gary" and fixtureB:getUserData() == "attack" and gary.health <= 5 and gary.health > 0 then
--             print(fixtureA:getUserData(), fixtureB:getUserData())
--             ghost.timer = 1 -- tempo de cooldown para perseguir outra vez
--             gary.health = gary.health - 1
--             print("Gary health = " .. gary.health)
--             PushGaryBack()
--             if gary.health <= 0 then
--                 ghost.isChasing = false
--                 gary.patroling = true
--             end
--         end
--     end
--     if ghost.health <= 4 and ghost.health > 0 then
--         if fixtureA:getUserData() == "attack" and fixtureB:getUserData() == "melee weapon" then
--             print(fixtureA:getUserData(), fixtureB:getUserData())
--             ghost.health = ghost.health - 1
--             -- Testes
--             if ghost.health <= 0 then
--                 ghost.isChasing = false
--                 ghost.patroling = false
--                 -- ghost.fixture:destroy()
--                 -- trigger.fixture:destroy()
--                 -- ghost.body:destroy()
--                 print('Morreu :')
--             end
--             -- End testes
--             print("Ghost health = " .. ghost.health)
--         end
--     end
-- end


function BeginContact(fixtureA, fixtureB)
    print(fixtureA:getUserData(), fixtureB:getUserData())

    if fixtureA:getUserData() == "player" and fixtureB:getUserData() == "MelleAttack" then
        valkyrie.isRanging = true
        valkyrie.isMeleeing = true
        print("startMelee")
    elseif fixtureA:getUserData() == "player" and fixtureB:getUserData() == "RangedAttack" then
        valkyrie.playerInSight = true
        valkyrie.isRanging = true
        valkyrie.patroling = false
        print("StartRanged")
    end

    if fixtureA:getUserData() == "MelleAttack" and fixtureB:getUserData() == "player" then
        valkyrie.isRanging = true
        valkyrie.isMeleeing = true
        print("starMelee")
    elseif fixtureA:getUserData() == "RangedAttack" and fixtureB:getUserData() == "player" then
        valkyrie.playerInSight = true
        valkyrie.patroling = false
        valkyrie.isRanging = false
        print("StartRanged")
    end
end

function EndContact(fixtureA, fixtureB)
    if fixtureA:getUserData() == "player" and fixtureB:getUserData() == "MelleAttack" then
        valkyrie.isMeleeing = false
        valkyrie.isRanging = true
        print("EndMelee")
    end

    if fixtureA:getUserData() == "player" and fixtureB:getUserData() == "RangedAttack" then
        valkyrie.isRanging = false
        valkyrie.isMeleeing = false
        print("EndRanged")
    end

    if fixtureA:getUserData() == "MelleAttack" and fixtureB:getUserData() == "player" then
        valkyrie.isMeleeing = false
        valkyrie.isRanging = true
        print("EndMelee")
    end

    if fixtureA:getUserData() == "RangedAttack" and fixtureB:getUserData() == "player" then
        valkyrie.isRanging = false
        valkyrie.isMeleeing = false
        print("EndRanged")
    end
end

function love.update(dt)
    world:update(dt)

    camera:update(dt)
    camera:follow(gary.body:getX(), gary.body:getY())
    camera:setFollowLerp(0.2)
    camera:setFollowLead(0)
    camera:setFollowStyle('TOPDOWN')
    -- UpdateHealthBars()
    UpdateGary(dt)
    UpdateGaryAttack()
    -- UpdateGhost(dt, world)
    UpdateValquiria(dt, GetPlayerPosition())
end

function love.draw()
    camera:attach()
    love.graphics.draw(sprites.background, 0, 0)
    if inventory.key == false and inventory.life == false then
        love.graphics.draw(sprites.key, 500, 250)
        love.graphics.draw(sprites.life, 700, 450)
    end
    DrawGary()
    DrawGaryAttack()
    -- DrawHealthBars()
    -- DrawGhost()
    DrawValquiria()
    camera:detach()
end
