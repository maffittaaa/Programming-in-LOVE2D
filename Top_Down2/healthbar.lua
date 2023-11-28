require "vector2"
require "gary"
require "ghost"

healthbar = {}

function LoadHealthBars()
    healthbar.ghost = vector2.new(ghost.body:getX(), ghost.body:getY() + 60)
    healthbar.gary = vector2.new(gary.body:getX(), gary.body:getY() + 60)
end

function UpdateHealthBars()
    healthbar.ghost = vector2.new(ghost.body:getX() - 35, ghost.body:getY() - 60)
    healthbar.gary = vector2.new(gary.body:getX() - 35, gary.body:getY() - 60)
end

function DrawHealthBars()
    if gary.health <= 5 and gary.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", healthbar.gary.x, healthbar.gary.y, 70, 10)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", healthbar.gary.x, healthbar.gary.y, 14 * gary.health, 5)
    else
        for i = #healthbar, 1, -1 do
            local num = healthbar[i]
            if num == 1 and num == 2 then
                table.remove(healthbar, i)
                print("healthbar on", healthbar[i])
            end
        end
    end
    if ghost.health <= 4 and ghost.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", healthbar.ghost.x, healthbar.ghost.y, 70, 10)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", healthbar.ghost.x, healthbar.ghost.y, 17.5 * ghost.health, 4)
    else
        for i = #healthbar, 1, -1 do
            local num = healthbar[i]
            if num == 1 and num == 2 then
                table.remove(healthbar, i)
                print("healthbar on", healthbar[i])
            end
        end
    end
end
