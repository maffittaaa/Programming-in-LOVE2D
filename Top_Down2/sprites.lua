require "vector2"

sprites = {}

function LoadSprites()
    sprites.background = love.graphics.newImage("background5.jpg")
    sprites.gary = love.graphics.newImage("gary.png")
    sprites.sword = love.graphics.newImage("sword.png")
    sprites.ghost = love.graphics.newImage("ghost.png")
    sprites.valkyrie = love.graphics.newImage("valkyrie.png")
    sprites.key = love.graphics.newImage("Key.png")
    sprites.life = love.graphics.newImage("life.png")
end
