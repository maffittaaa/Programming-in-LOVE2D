require "vector2"
require "player"
require "ghost"

healthbar = {}

function LoadHealthBars()
    healthbar.enemy = vector2.new(enemy.body:getX(), enemy.body:getY() + 60)
    healthbar.player = vector2.new(player.body:getX(), player.body:getY() + 60)
end

function UpdateHealthBars()
    healthbar.enemy = vector2.new(enemy.body:getX() - 35, enemy.body:getY() - 60)
    healthbar.player = vector2.new(player.body:getX() - 35, player.body:getY() - 60)
end

function DrawHealthBars()
    if player.health <= 5 and player.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", healthbar.player.x, healthbar.player.y, 70, 10)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", healthbar.player.x, healthbar.player.y, 14 * player.health, 5)
    else
        for i = #healthbar, 1, -1 do
            local num = healthbar[i]
            if num == 1 and num == 2 then
                table.remove(healthbar, i)
                print("healthbar on", healthbar[i])
            end
        end
    end
    if enemy.health <= 5 and enemy.health > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", healthbar.enemy.x, healthbar.enemy.y, 70, 10)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", healthbar.enemy.x, healthbar.enemy.y, 17.5 * enemy.health, 4)
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
