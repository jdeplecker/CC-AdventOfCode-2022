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

local function contains(x, y, z, blocks)
    if blocks[x] ~= nil then
        if blocks[x][y] ~= nil then
            return blocks[x][y][z] == true
        end
    end
end

local function countAdjacent(x, y, z, blocks)
    local dirs = {{1, 0, 0},{-1, 0, 0},{0, 1, 0},{0, -1, 0},{0, 0, 1},{0, 0, -1}}
    local count = 0
    for _, dir in pairs(dirs) do
        local ax, ay, az = x + dir[1], y + dir[2], z + dir[3]

        if contains(ax, ay, az, blocks) then
            count = count + 1
        end
    end
    return count
end

local function isInBounds(block)
    if block[1] < -1 or block[2] < -1 or block[3] < -1 then return false end
    if block[1] >30 or block[2] > 30 or block[3] > 30 then return false end
    return true
end

local function createWaterTable(blocks)
    local dirs = {{1, 0, 0},{-1, 0, 0},{0, 1, 0},{0, -1, 0},{0, 0, 1},{0, 0, -1}}
    local water = {}
    water[1] = {}
    water[1][1] = {}
    water[1][1][1] = true
    local water_to_grow = {}
    table.insert(water_to_grow, {1,1,1})
    while #water_to_grow > 0 do
        local current_water = table.remove(water_to_grow, 1)
        -- print("currentW", current_water[1], current_water[2], current_water[3])
        for _, dir in pairs(dirs) do
            local grown_water = {current_water[1] + dir[1], current_water[2] + dir[2], current_water[3] + dir[3]}
            -- print("grownW", grown_water[1], grown_water[2], grown_water[3])
            -- print("isInBounds", isInBounds(grown_water))
            -- print("blockContains", contains(grown_water[1], grown_water[2], grown_water[3], blocks))
            -- print("waterContains", contains(grown_water[1], grown_water[2], grown_water[3], water))
            if isInBounds(grown_water) and not contains(grown_water[1], grown_water[2], grown_water[3], water) and not contains(grown_water[1], grown_water[2], grown_water[3], blocks) then
                if water[grown_water[1]] == nil then water[grown_water[1]] = {} end
                if water[grown_water[1]][grown_water[2]] == nil then water[grown_water[1]][grown_water[2]] = {} end
                water[grown_water[1]][grown_water[2]][grown_water[3]] = true
                table.insert(water_to_grow, grown_water)
            end
        end
    end

    return water
end

local function readBlocks(input_string)
    local blocks = {}
    local free_sides = 0
    for x, y, z in input_string:gmatch("(%d+),(%d+),(%d+)") do
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        -- print("block", x, y, z)
        if blocks[x] == nil then blocks[x] = {} end
        if blocks[x][y] == nil then blocks[x][y] = {} end
        blocks[x][y][z] = true
    end

    local water = createWaterTable(blocks)
    for i=-1, 30 do
        for j=-1, 30 do
            local row = ""
            for k=-1, 30 do
                if contains(i, j, k, water) then
                    free_sides = free_sides + countAdjacent(i, j, k, blocks)
                    row = row .. "W"
                else
                    row = row .. "."
                end
            end
            -- print(row)
        end
        -- print("----")
    end
    print(free_sides)

    return blocks
end

local input_file = fs.open("/input.txt", "r")
readBlocks(input_file.readAll())