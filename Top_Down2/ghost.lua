require "vector2"
require "player"

enemy = {}
trigger = {}
local enemyRange
local enemyx_patrolling
local is_forward_backwards --11
local lastPposition
local time = 0

local destroy_enemy_fixture = false

function LoadEnemy(world)
    enemy.body = love.physics.newBody(world, enemyx_patrolling, 100, "dynamic")
    enemy.shape = love.physics.newRectangleShape(30, 60)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
    enemy.maxvelocity = 200
    enemy.isChasing = false
    enemy.lostPlayer = false
    enemy.patroling = true
    enemy.playerInSight = true
    enemy.fixture:setFriction(10)
    enemy.body:setFixedRotation(true)
    enemy.fixture:setRestitution(3)
    enemy.position = vector2.new(enemy.body:getPosition())
    enemy.health = 4

    enemyRange = {}
    enemyRange.body = love.physics.newBody(world, enemy.body:getX(), enemy.body:getY(), "dynamic")
    enemyRange.shape = love.physics.newCircleShape(300)

    trigger.body = love.physics.newBody(world, enemy.body:getX() - 30, 100, "static")
    trigger.shape = love.physics.newRectangleShape(40, 70)
    trigger.fixture = love.physics.newFixture(trigger.body, trigger.shape, 2)
    trigger.fixture:setSensor(true)
    trigger.fixture:setUserData("attack") -- trigger de lado
end

function UpdateEnemy(dt)
    enemy.position = vector2.new(enemy.body:getPosition())
    trigger.body:setPosition(enemy.position.x, enemy.position.y)

    enemyRange.body:setPosition(enemy.body:getX(), enemy.body:getY())
    enemy.range = vector2.mag(vector2.sub(enemy.position, player.position))
    if destroy_player_fixture == true then
        enemy.patroling = true
        enemy.playerInSight = false
    end

    if enemy.patroling == true then
        --Check if Player in sight
        if enemy.range < 300 then
            enemy.playerInSight = true
            enemy.patroling = false
        end
        --If not in Sight, Patrol
        enemyx_patrolling = enemy.body:getX()

        if enemyx_patrolling >= 1900 then
            is_forward_backwards = -1
        end

        if enemyx_patrolling <= 100 then
            is_forward_backwards = 1
        end
        enemyx_patrolling = enemyx_patrolling + (dt * 200 * is_forward_backwards)

        if 95 < enemy.body:getY() and enemy.body:getY() < 105 then
            enemy.body:setPosition(enemy.position.x, 100)
        elseif enemy.body:getY() > 100 then
            enemy.body:setLinearVelocity(0, -200)
        elseif enemy.body:getY() < 100 then
            enemy.body:setLinearVelocity(0, 200)
        end

        enemy.body:setPosition(enemyx_patrolling, enemy.body:getY())
    elseif enemy.playerInSight == true then
        --check again if player in sight
        if enemy.range > 300 then
            enemy.isChasing = false
        else
            enemy.isChasing = true
        end

        if enemy.isChasing == false then
            --go to last location of player
            local lastPos = vector2.mag(vector2.sub(enemy.position, lastPposition))

            if lastPos < 1 then
                time = time + dt
                if time > 2 then
                    enemy.patroling = true
                    enemy.playerInSight = false
                    time = 0
                    return
                end
                return
            elseif lastPos > 1 then
                if timer < 10 then
                playerDiretion = vector2.sub(lastPposition, vector2.new(enemy.body:getPosition()))
                playerDiretion = vector2.norm(playerDiretion)
                local force = vector2.mult(playerDiretion, 200)
                enemy.body:setLinearVelocity(force.x, force.y)
                elseif timer > 10 and hitplayer == true then
                    playerDiretion = vector2.sub(lastPposition, vector2.new(enemy.body:getPosition()))
                    playerDiretion = vector2.norm(playerDiretion)
                    local force = vector2.mult(playerDiretion, 200)
                    enemy.body:setLinearVelocity(-force.x, -force.y)
                end
            end
        elseif enemy.isChasing == true then
            --Follow player
            lastPposition = player.position
            local playerDiretion = vector2.sub(player.position, vector2.new(enemy.body:getPosition()))
            playerDiretion = vector2.norm(playerDiretion)
            local force = vector2.mult(playerDiretion, 200)
            enemy.body:setLinearVelocity(force.x, force.y)
        end
    end
end

function DrawEnemy()
    if enemy.health <= 4 and enemy.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))

        love.graphics.setColor(0, 1, 0)
        love.graphics.polygon("line", trigger.body:getWorldPoints(trigger.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", enemyRange.body:getX(), enemyRange.body:getY(), enemyRange.shape:getRadius())
    elseif enemy.health <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("WINNER! YOU STAYED ALIVE", 500, 500)
        enemy.body:setLinearVelocity(0, 0)
        if destroy_enemy_fixture == true then
            enemy.isChasing = false
            enemy.patroling = false
            enemy.fixture:destroy()
            trigger.fixture:destroy()
            enemy.body:destroy()
            destroy_enemy_fixture = false
        end
    end
end
