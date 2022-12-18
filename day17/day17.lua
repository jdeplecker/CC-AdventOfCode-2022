-- x, y
local shapes = {
    [1] = {{0,0}, {1,0}, {2,0}, {3,0}},
    [2] = {{1,0}, {0,1}, {1,1}, {2,1}, {1,2}},
    [3] = {{0,0}, {1,0}, {2,0}, {2,1}, {2,2}},
    [4] = {{0,0}, {0,1}, {0,2}, {0,3}},
    [5] = {{0,0}, {1,0}, {1,1}, {0,1}}
}

local max_rocks = 2022

local function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep(" ", indent) .. k .. ":"
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting, v)
        end
    end
end

local function readStreams(input_string)
    local directions = {}
    for dir in input_string:gmatch("([<>])") do
        table.insert(directions, dir)
    end
    return directions
end

local function rockHitsNothing(cave, rock)
    for _, rock_square in pairs(rock) do
        if rock_square[2] < 2 then
            -- print("rock hits bottom")
            return false 
        end
        if cave[rock_square[2]] == nil then cave[rock_square[2]] = {} end
        if cave[rock_square[2]][rock_square[1]] == true then
            -- print("rock hits something else", rock_square[1], rock_square[2])
            return false
        end
    end
    -- print("rock hits nothing")
    return true
end

local function moveDown(rock)
    local new_rock = {}
    for _, rock_square in pairs(rock) do
        table.insert(new_rock, {rock_square[1], rock_square[2] -1})
    end

    return new_rock
end

local function moveLateral(rock, dir)

    for _, rock_square in pairs(rock) do
        if dir == "<" and rock_square[1] == 1 then
            -- print("couldn't move left")
            return rock
        elseif dir == ">" and rock_square[1] == 7 then
            -- print("couldn't move right")
            return rock
        end
    end

    local new_rock = {}
    for _, rock_square in pairs(rock) do
        if dir == "<" then
            table.insert(new_rock, {rock_square[1] - 1, rock_square[2]})
        elseif dir == ">" then
            table.insert(new_rock, {rock_square[1] + 1, rock_square[2]})
        end
    end

    return new_rock
end

local function letRocksFall(streams)
    local cave = {}
    local highest_y = 1
    local current_shape = 1
    local current_stream = 1
    local rock_count = 0

    while rock_count < max_rocks do
        -- print("spawning rock")
        local rock = {}
        for _, rock_square in pairs(shapes[current_shape]) do
            table.insert(rock, {rock_square[1] + 2, rock_square[2] + highest_y + 4})
        end

        local has_just_fallen = true
        local last_non_hitting_rock = {}
        while rockHitsNothing(cave, rock) do
            last_non_hitting_rock = rock
            if has_just_fallen then
                print("moving rock " .. streams[current_stream])
                -- tprint(rock)
                rock = moveLateral(rock, streams[current_stream])
                -- tprint(rock)
                current_stream = (current_stream % #streams) + 1
                -- os.pullEvent("key")
            else
                print("moving rock down")
                rock = moveDown(rock)
            end

            has_just_fallen = not has_just_fallen
        end

        -- tprint(cave)
        for _, rock_square in pairs(last_non_hitting_rock) do
            print("Solidifying", rock_square[1], rock_square[2])
            if cave[rock_square[2]] == nil then cave[rock_square[2]] = {} end
            cave[rock_square[2]][rock_square[1]] = true
            highest_y = math.max(rock_square[2], highest_y)
        end
        -- tprint(cave)

        current_shape = (current_shape % 5) + 1
        rock_count = rock_count + 1
        -- os.pullEvent("key")

    end
    print(highest_y)
end

local input_file = fs.open("/test_input.txt", "r")
letRocksFall(readStreams(input_file.readAll()))