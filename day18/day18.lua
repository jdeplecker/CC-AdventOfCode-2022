local function printBlocks(blocks)
    commands.exec("fill ~-2 ~ ~ ~-32 ~30 ~30 minecraft:air")
    for x, layer in pairs(blocks) do
        for y, row in pairs(layer) do
            for z, _ in pairs(row) do
                commands.exec("setblock ~-"..(32 - x).." ~"..(y).." ~"..z.." minecraft:magma_block")
            end
        end
    end
end

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

local function countAdjacent(x, y, z, blocks)
    local dirs = {{1, 0, 0},{-1, 0, 0},{0, 1, 0},{0, -1, 0},{0, 0, 1},{0, 0, -1}}
    local count = 0
    for _, dir in pairs(dirs) do
        local ax, ay, az = x + dir[1], y + dir[2], z + dir[3]

        if blocks[ax] ~= nil then
            if blocks[ax][ay] ~= nil then
                if blocks[ax][ay][az] then
                    count = count + 1
                end
            end
        end
    end
    return count
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
        free_sides  = free_sides + 6
        local adjacent = countAdjacent(x, y, z, blocks)
        free_sides = free_sides - adjacent * 2
    end

    print(free_sides)

    return blocks
end

local input_file = fs.open("/input.txt", "r")
os.sleep(10)
printBlocks(readBlocks(input_file.readAll()))