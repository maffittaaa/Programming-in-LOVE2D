require "vector2"
require "gary"

ghost = {}
trigger = {}
local ghostRange
local ghostx_patrolling
local is_forward_backwards --11
local lastPposition
local time = 0

local destroy_ghost_fixture = false

function LoadGhost(world)
    ghostx_patrolling = 50

    ghost.body = love.physics.newBody(world, ghostx_patrolling, 100, "dynamic")
    ghost.shape = love.physics.newRectangleShape(30, 60)
    ghost.fixture = love.physics.newFixture(ghost.body, ghost.shape, 1)
    ghost.maxvelocity = 200
    ghost.isChasing = false
    ghost.lostGary = false
    ghost.patroling = true
    ghost.garyInSight = true
    ghost.fixture:setFriction(10)
    ghost.body:setFixedRotation(true)
    ghost.position = vector2.new(ghost.body:getPosition())
    ghost.health = 4
    ghost.timer = 2

    ghostRange = {}
    ghostRange.body = love.physics.newBody(world, ghost.body:getX(), ghost.body:getY(), "dynamic")
    ghostRange.shape = love.physics.newCircleShape(300)

    trigger.body = love.physics.newBody(world, ghost.body:getX() - 30, 100, "static")
    trigger.shape = love.physics.newRectangleShape(40, 70)
    trigger.fixture = love.physics.newFixture(trigger.body, trigger.shape, 2)
    trigger.fixture:setSensor(true)
    trigger.fixture:setUserData("attack") -- trigger de lado
end

function UpdateGhost(dt, world)
    ghost.position = vector2.new(ghost.body:getPosition())
    trigger.body:setPosition(ghost.position.x, ghost.position.y)

    ghostRange.body:destroy()
    ghostRange.body = love.physics.newBody(world, ghost.body:getX(), ghost.body:getY(), "dynamic")
    ghost.range = vector2.mag(vector2.sub(ghost.position, gary.position))
    print(gary.position.x, gary.position.y)

    if ghost.timer > 0 then
        ghost.timer = ghost.timer - dt
    end

    if destroy_gary_fixture == true then
        ghost.patroling = true
        ghost.garyInSight = false
    end

    if ghost.patroling == true then
        --Check if Gary in sight
        if ghost.range < 300 then
            ghost.garyInSight = true
            ghost.patroling = false
        end
        --If not in Sight, Patrol
        ghostx_patrolling = ghost.body:getX()

        if ghostx_patrolling >= 1900 then
            is_forward_backwards = -1
        end

        if ghostx_patrolling <= 100 then
            is_forward_backwards = 1
        end
        ghostx_patrolling = ghostx_patrolling + (dt * 200 * is_forward_backwards)

        if 95 < ghost.body:getY() and ghost.body:getY() < 105 then
            ghost.body:setPosition(ghost.position.x, 100)
        elseif ghost.body:getY() > 100 then
            ghost.body:setLinearVelocity(0, -200)
        elseif ghost.body:getY() < 100 then
            ghost.body:setLinearVelocity(0, 200)
        end

        ghost.body:setPosition(ghostx_patrolling, ghost.body:getY())
    elseif ghost.garyInSight == true then
        --check again if gary in sight
        if ghost.range > 300 then
            ghost.isChasing = false
        else
            ghost.isChasing = true
        end

        if ghost.isChasing == false then
            --go to last location of gary
            local lastPos = vector2.mag(vector2.sub(ghost.position, lastPposition))

            if lastPos < 1 then
                time = time + dt
                ghost.body:setLinearVelocity(0, 0)
                if time > 2 then
                    ghost.patroling = true
                    ghost.garyInSight = false
                    time = 0
                    return
                end
                return
            elseif lastPos > 1 then
                local garyDiretion = vector2.sub(lastPposition, vector2.new(ghost.body:getPosition()))
                garyDiretion = vector2.norm(garyDiretion)
                local force = vector2.mult(garyDiretion, 200)
                ghost.body:setLinearVelocity(force.x, force.y)
            end
        elseif ghost.isChasing == true then
            --Follow gary
            time = 0
            lastPposition = gary.position
            local garyDiretion = vector2.sub(gary.position, vector2.new(ghost.body:getPosition()))
            garyDiretion = vector2.norm(garyDiretion)
            local force = vector2.mult(garyDiretion, 200)
            ghost.body:setLinearVelocity(force.x, force.y)
        end
    end
end

function DrawGhost()
    if ghost.health <= 4 and ghost.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(sprites.ghost, ghost.body:getX(), ghost.body:getY(), ghost.body:getAngle(),
            1, 1, sprites.ghost:getWidth() / 2, sprites.ghost:getHeight() / 2)

        love.graphics.setColor(0, 1, 0)
        love.graphics.polygon("line", trigger.body:getWorldPoints(trigger.shape:getPoints()))

        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", ghostRange.body:getX(), ghostRange.body:getY(), ghostRange.shape:getRadius())
    elseif ghost.health <= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("WINNER! YOU STAYED ALIVE", 500, 500)
        ghost.body:setLinearVelocity(0, 0)
        if destroy_ghost_fixture == true then
            ghost.isChasing = false
            ghost.patroling = false
            ghost.body.setPosition(-999999, -9999999)
            ghost.fixture:destroy()
            trigger.fixture:destroy()
            ghost.body:destroy()
            print('Morreu :')
            destroy_ghost_fixture = false
        end
    end
end
