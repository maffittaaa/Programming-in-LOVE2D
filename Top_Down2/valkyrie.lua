require "vector2"
require "gary"

valkyrie = {}
local meleeRange
local rangedAttack
local valkyriex_patrolling
local is_forward_backwards
local lastPposition
local time = 0

function LoadValquiria(world)
  valkyriex_patrolling = 50

  valkyrie.body = love.physics.newBody(world, valkyriex_patrolling, 100, "dynamic")
  valkyrie.shape = love.physics.newRectangleShape(30, 60)
  valkyrie.fixture = love.physics.newFixture(valkyrie.body, valkyrie.shape, 1)
  valkyrie.maxvelocity = 200
  valkyrie.isMeleeing = false
  valkyrie.isRanging = false
  valkyrie.patroling = true
  valkyrie.playerInSight = false
  valkyrie.fixture:setFriction(10)
  valkyrie.body:setFixedRotation(true)
  valkyrie.position = vector2.new(valkyrie.body:getPosition())

  meleeRange = {}
  meleeRange.body = love.physics.newBody(world, valkyrie.body:getX(), valkyrie.body:getY(), "dynamic")
  meleeRange.shape = love.physics.newCircleShape(150)
  meleeRange.fixture = love.physics.newFixture(meleeRange.body, meleeRange.shape, 2)
  meleeRange.range = meleeRange.shape:getRadius()
  meleeRange.fixture:setSensor(true)
  meleeRange.fixture:setUserData("MelleAttack")

  rangedAttack = {}
  rangedAttack.body = love.physics.newBody(world, valkyrie.body:getX(), valkyrie.body:getY(), "dynamic")
  rangedAttack.shape = love.physics.newCircleShape(300)
  rangedAttack.fixture = love.physics.newFixture(rangedAttack.body, rangedAttack.shape, 2)
  rangedAttack.range = rangedAttack.shape:getRadius()
  rangedAttack.fixture:setSensor(true)
  rangedAttack.fixture:setUserData("RangedAttack")
end

function UpdateValquiria(dt, playerPosition)
  valkyrie.position = vector2.new(valkyrie.body:getPosition())

  meleeRange.body:setPosition(valkyrie.body:getX(), valkyrie.body:getY())
  rangedAttack.body:setPosition(valkyrie.body:getX(), valkyrie.body:getY())

  valkyrie.range = vector2.mag(vector2.sub(valkyrie.position, playerPosition))

  if valkyrie.patroling == true then
    --If not in Sight, Patrol
    valkyriex_patrolling = valkyrie.body:getX()

    if valkyriex_patrolling >= 1900 then
      is_forward_backwards = -1
    end

    if valkyriex_patrolling <= 100 then
      is_forward_backwards = 1
    end
    valkyriex_patrolling = valkyriex_patrolling + (dt * 200 * is_forward_backwards)

    if 95 < valkyrie.body:getY() and valkyrie.body:getY() < 105 then
      valkyrie.body:setPosition(valkyrie.position.x, 400)
    elseif valkyrie.body:getY() > 100 then
      valkyrie.body:setLinearVelocity(0, -200)
    elseif valkyrie.body:getY() < 100 then
      valkyrie.body:setLinearVelocity(0, 200)
    end

    valkyrie.body:setPosition(valkyriex_patrolling, valkyrie.body:getY())
  elseif valkyrie.playerInSight == true then
    if valkyrie.isRanging == true then
      --stop velocity, while in rangedAttack

      time = 0
      lastPposition = playerPosition

      if valkyrie.isMeleeing == true then
        local playerDiretion = vector2.sub(playerPosition, vector2.new(valkyrie.body:getPosition()))
        playerDiretion = vector2.norm(playerDiretion)
        local force = vector2.mult(playerDiretion, 200)
        valkyrie.body:setLinearVelocity(force.x, force.y)
        return
      end
      valkyrie.body:setLinearVelocity(0, 0)
      --if not meleeAttacking, do rangedAttack
    elseif valkyrie.isRanging == false then
      --go to last location of player
      local lastPos = vector2.mag(vector2.sub(valkyrie.position, lastPposition))

      if lastPos < 1 then
        time = time + dt
        valkyrie.body:setLinearVelocity(0, 0)
        if time > 2 then
          valkyrie.patroling = true
          valkyrie.playerInSight = false
          time = 0
          return
        end
        return
      elseif lastPos > 1 then
        local playerDiretion = vector2.sub(lastPposition, vector2.new(valkyrie.body:getPosition()))
        playerDiretion = vector2.norm(playerDiretion)
        local force = vector2.mult(playerDiretion, 200)
        valkyrie.body:setLinearVelocity(force.x, force.y)
      end
    end
  end
end

function DrawValquiria()
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon("fill", valkyrie.body:getWorldPoints(valkyrie.shape:getPoints()))



  love.graphics.circle("line", meleeRange.body:getX(), meleeRange.body:getY(), meleeRange.shape:getRadius())
  love.graphics.circle("line", rangedAttack.body:getX(), rangedAttack.body:getY(), rangedAttack.shape:getRadius())

  if valkyrie.isChasing == false and lastPposition ~= nil and valkyrie.patroling == false then
    love.graphics.line(valkyrie.body:getX(), valkyrie.body:getY(), lastPposition.x, lastPposition.y)
  end
end

function GetValquiriaPosition()
  return vector2.new(valkyrie.body:getX(), valkyrie.body:getY())
end
