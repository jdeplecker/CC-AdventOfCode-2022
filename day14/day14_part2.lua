
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

local function readRocks(input_string)
    local rocks = {}
    local biggest_y = 0
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        local prev_coord = nil
        for x, y in line:gmatch("(%d+),(%d+)") do
            x, y = tonumber(x), tonumber(y)
            local orig_x, orig_y = x, y
            if prev_coord ~= nil then
                if y > biggest_y then biggest_y = y end
                if x == prev_coord[1] then
                    if y < prev_coord[2] then prev_coord[2], y = y, prev_coord[2] end
                    for i=prev_coord[2], y do
                        if rocks[i] == nil then rocks[i] = {} end
                        rocks[i][x] = true
                    end
                else
                    if x < prev_coord[1] then prev_coord[1], x = x, prev_coord[1] end
                    if rocks[y] == nil then rocks[y] = {} end
                    for i=prev_coord[1], x do
                        rocks[y][i] = true
                    end
                end
            end
            prev_coord = {orig_x, orig_y}
        end
    end

    print("building floor")
    biggest_y = biggest_y + 2
    rocks[biggest_y] = {}
    for i=300,700 do
        rocks[biggest_y][i] = true
    end

    print("floor build")
    return rocks, biggest_y
end

local function makeSandFall(rocks, biggest_y)

    local start_x, start_y = 500, 0
    local current_x, current_y = start_x, start_y
    local end_reached = false
    while true do
        if rocks[current_y + 1] == nil or rocks[current_y + 1][current_x] ~= true then
            -- fall straight down
        elseif rocks[current_y + 1][current_x - 1] == nil then
            -- move left
            current_x = current_x - 1
        elseif rocks[current_y + 1][current_x + 1] == nil then
            -- move right
            current_x = current_x + 1
        else
            -- nowhere to fall
            if rocks[current_y] == nil then rocks[current_y] = {} end
            rocks[current_y][current_x] = true
            if current_x == start_x and current_y == start_y then end_reached = true end
            break
        end
        current_y = current_y + 1
    end

    -- print("sand ended in ", current_x, current_y)
    return end_reached
end

local function printRocks(rocks, biggest_y, keep_current, block_type)
    if not keep_current then
        commands.exec("fill ~-3 ~ ~-100 ~-3 ~"..biggest_y.." ~100 minecraft:air")
    end
    for y, row in pairs(rocks) do
        for x, _ in pairs(row) do
            commands.exec("setblock ~-3 ~"..(biggest_y - y).." ~"..(500-x).." "..block_type.." keep")
        end
    end
end

local input_file = fs.open("/input.txt", "r")
local count = 0
local rocks, biggest_y = readRocks(input_file.readAll())
-- printRocks(rocks, biggest_y, false, "minecraft:red_concrete")
while not makeSandFall(rocks, biggest_y) do
    count = count + 1
end
-- printRocks(rocks, biggest_y, true, "minecraft:yellow_concrete")
print(count + 1)