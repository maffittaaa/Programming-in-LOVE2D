vector2 = {}

function vector2.new(px, py)
    return {x = px, y = py}
end

function vector2.add(vec, plus)
    local result = vector2.new(0, 0)
    result.x = vec.x + plus.x
    result.y = vec.y + plus.y
    return (result)
end

function vector2.sub(vec, minus)
    local result = vector2.new(0, 0)
    result.x = vec.x - minus.x
    result.y = vec.y - minus.y
    return (result)
end

function vector2.mult(vec, n)
    local result = vector2.new(0, 0)
    result.x = vec.x * n
    result.y = vec.y * n
    return (result)
end

function vector2.div(vec, n)
    local result = vector2.new(0, 0)
    result.x = vec.x / n
    result.y = vec.y / n
    return (result)
end

function vector2.mag(vec) -- magnitude
    return ((math.sqrt((vec.x * vec.x) + (vec.y * vec.y))))
end

function vector2.norm(vec) -- norm
    local m = vector2.mag(vec)
    if m ~= 0 then
        return (vector2.div(vec, m))
    end
    return (vec)
end