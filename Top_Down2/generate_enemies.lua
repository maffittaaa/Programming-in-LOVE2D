require "valkyrie"
require "ghost"

enemies = {}
enemies.types = {valkyrie, ghost}
enemies.timer = 0
enemies.timerLimit = math.random (3, 5)
enemies.mediumCounter = 0
enemies.side = math.random (1, 4)
enemies.chosen_type = {}

function EnemyGenerator(dt)
    enemies.timer = enemies.timer + dt
    if enemies.timer > enemies.timerLimit then
        -- Spawns the enemies
        if enemies.mediumCounter < 3 then -- chosing 3 ghosts before chosing 1 valkyrie
            enemies.mediumCounter = enemies.mediumCounter + 1
            enemies.chosen_type = enemies.types[ghost]
        else
            enemies.chosen_type = enemies.types[valkyrie]
            enemies.mediumCounter = 0 -- reset ghost counter
        end

        if enemies.side == 1 then --left
            EnemySpawner(-50, height / 2 - 25)
        elseif enemies.side == 2 then -- top
            EnemySpawner(width / 2 - 25, -50)
        elseif enemies.side == 3 then -- right
            EnemySpawner(width, height / 2 - 25)
        elseif enemies.side == 4 then -- bottom
            EnemySpawner(width / 2 - 25, height)
        end
        enemies.side = math.random(1, 4)

        enemies.timerLimit = math.random(3, 5)
        enemies.timer = 0 -- reset timer
    end
end

function EnemySpawner(x, y, enemy)
    table.insert(enemy, {x = valkyrie.body:getX(), y = valkyrie.body:getY()})
end