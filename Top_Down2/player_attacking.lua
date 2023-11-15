require "vector2"
require "player"
require "ghost"

function GetSwordRotation(direction)
    if direction == "right" or direction == "d" then
        return 0
    elseif direction == "left" or direction == "a" then
        return math.pi
    elseif direction == "up" or direction == "w" then
        return (math.pi / 2) * 3
    elseif direction == "down" or direction == "s" then
        return math.pi / 2
    end
end

function love.mousekeypressed(button)
    if button == 1 then
        
    end
    if button == 2 then
        
    end

end

function LoadPlayerAttack()
    
end