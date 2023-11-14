require "vector2"
require "player"

enemy = {}
local enemyRange
local enemyx_patrolling
local verify_forward_backwards
local lastPposition
local time = 0


function LoadEnemy(world)
    enemy.body = love.physics.newBody(world, ex, 100, "dynamic")
    enemy.shape = love.physics.newRectangleShape(30, 60)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
    enemy.maxvelocity = 200
    enemy.isChasing = false
    enemy.lostPlayer = false
    enemy.patroling = true
    enemy.playerInSight = true
    enemy.fixture:setFriction(10)
    enemy.body:setFixedRotation(true)
    enemy.position = vector2.new(enemy.body:getPosition())

    enemyRange = {}
    enemyRange.body = love.physics.newBody(world, enemy.body:getX(), enemy.body:getY(), "dynamic")
    enemyRange.shape = love.physics.newCircleShape(300)
end

function UpdateEnemy(dt, world)
    enemy.position = vector2.new(enemy.body:getPosition())

    enemyRange.body:setPosition(enemy.body:getX(), enemy.body:getY())
    enemyRange.body = love.physics.newBody(world, enemy.body:getX(), enemy.body:getY(), "dynamic")
    enemy.range = vector2.mag(vector2.sub(enemy.position, player.position))

    if enemy.patroling == true then
        --Check if Player in sight
        if enemy.range < 300 then
            enemy.playerInSight = true
            enemy.patroling = false
        end
        --If not in Sight, Patrol
        enemyx_patrolling = enemy.body:getX()

        if enemyx_patrolling >= 1900 then
            verify_forward_backwards = -1
        end

        if enemyx_patrolling <= 100 then
            verify_forward_backwards = 1
        end
        enemyx_patrolling = enemyx_patrolling + (dt * 200 * verify_forward_backwards)

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
                local playerDiretion = vector2.sub(lastPposition, vector2.new(enemy.body:getPosition()))
                playerDiretion = vector2.norm(playerDiretion)
                local force = vector2.mult(playerDiretion, 200)
                enemy.body:setLinearVelocity(force.x, force.y)
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
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))

    love.graphics.circle("line", enemyRange.body:getX(), enemyRange.body:getY(), enemyRange.shape:getRadius())
end
