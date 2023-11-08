require "vector2"

local enemies

function CreateEnemy(x, y)
    local enemy = {}
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.width = 64
    enemy.height = 64
    enemy.removed = false
    table.insert(enemies, enemy)
end

function LoadEnemy()
    CreateEnemy(500, 500)
    CreateEnemy(700, 500)
    CreateEnemy(800, 500)
end

function UpdateEnemy(dt)
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if not enemy.removed then
            UpdateEnemy(dt)
        else
            table.remove(enemies, i)
        end
    end
end

function DrawEnemy()
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end
end
