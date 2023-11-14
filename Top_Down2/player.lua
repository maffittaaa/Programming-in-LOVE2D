require "vector2"
player = {}

function LoadPlayer(world)
    --player.sprite = love.graphics.newImage("Main_character2.jpg")
    player.body = love.physics.newBody(world, 400, 100, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.maxvelocity = 200
    player.fixture:setFriction(1)
    player.body:setFixedRotation(true)
end

function UpdatePlayer(dt)
    player.position = vector2.new(player.body:getPosition())
    local playerVelocity = vector2.new(0, 0)

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        playerVelocity.x = playerVelocity.x + 250
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerVelocity.x = playerVelocity.x - 250
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        playerVelocity.y = playerVelocity.y - 250
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        playerVelocity.y = playerVelocity.y + 250
    end

    player.body:setLinearVelocity(playerVelocity.x, playerVelocity.y)
end

function DrawPlayer()
    love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
end
