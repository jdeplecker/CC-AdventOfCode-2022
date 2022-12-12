local orthogonal = {
    {["x"] =  0, ["y"] = -1},
    {["x"] = -1, ["y"] =  0},
    {["x"] =  1, ["y"] =  0},
    {["x"] =  0, ["y"] =  1},
  }

local function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting, v)
        end
    end
end

local function readInTopography(input_string)
    local topography = {}

    for line in (input_string.."\n"):gmatch("(.-)\n") do
        local row = {}
        for char in line:gmatch("(.)") do
            local special = ""
            local code = string.byte(char)
            if code == 83 then
                special = "start"
                code = string.byte("a")
            end
            if code == 69 then
                special = "end"
                code = string.byte("z")
            end

            table.insert(row, {["code"] = code, ["special"] = special, ["visited"] = "ready"})
        end
        table.insert(topography, row)
    end

    return topography
end

local function exists(topography, x, y)
    return not ((topography[x] == nil) or (topography[x][y] == nil))
end

local function isOneStepAway(topography, currX, currY, nexX, newY)
    return topography[currX][currY]["code"] + 2 > topography[nexX][newY]["code"]
end

local function solvePath(topography)
    local squares_to_visit = {}

    for y, row in pairs(topography) do
        for x, square in pairs(row) do
            if square["special"] == "start" then
                table.insert(squares_to_visit, {["x"] = x, ["y"] = y, ["depth"] = 0})
                topography[x][y]["visited"] = "waiting"
                break
            end
        end
    end

    while #squares_to_visit > 0 do
        local current_square = table.remove(squares_to_visit, 1)
        local cx, cy, depth = current_square["x"], current_square["y"], current_square["depth"]

        if topography[cx] and topography[cx][cy] and topography[cx][cy]["visited"] == "waiting" then
            if topography[cx][cy]["special"] == "end" then
                print("We found the top", depth)
                break
            end

            topography[cx][cy]["visited"] = "visited"

            for _, axis in ipairs(orthogonal) do
                local dx, dy = cx + axis["x"], cy + axis["y"]
                if exists(topography, dx, dy) and isOneStepAway(topography, cx, cy, dx, dy) and topography[dx][dy]["visited"] == "ready" then
                    table.insert(squares_to_visit, {["x"] = dx, ["y"] = dy, ["depth"] = depth + 1})
                    topography[dx][dy]["visited"] = "waiting"
                end
            end
            -- print(cx, cy)
            -- os.pullEvent("key")
        end
    end

end

local input_file = fs.open("/input.txt", "r")
local topography = readInTopography(input_file.readAll())
solvePath(topography)