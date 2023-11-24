require "vector2"

sprites = {}

function LoadSprites()
    sprites.background = love.graphics.newImage("background5.jpg")
    sprites.player = love.graphics.newImage("main_character.png")
    sprites.sword = love.graphics.newImage("Sword_left.png")
    sprites.ghost = love.graphics.newImage("Ghost.png")
end
