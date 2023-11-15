require "vector2"

sprites = {}

function LoadSprites()
    sprites.background = love.graphics.newImage("background5.jpg")
    sprites.player = love.graphics.newImage("Main_character2.jpg")
    sprites.sword = love.graphics.newImage("sword.jpg")
end
