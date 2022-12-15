local line_to_look_at = 2000000

local function table_count(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

local function readSensors(input_string)
    local sensor_line_map = {}
    local sensor_line_blocked = {}
    for s_x, s_y, b_x, b_y in input_string:gmatch("Sensor at x=(-?%d+), y=(-?%d+): closest beacon is at x=(-?%d+), y=(-?%d+)") do
        s_x, s_y, b_x, b_y = tonumber(s_x), tonumber(s_y), tonumber(b_x), tonumber(b_y)
        local manhatten_dist = math.abs(s_x - b_x) + math.abs(s_y - b_y)
        local straight_strength = manhatten_dist - math.abs(s_y - line_to_look_at) + 1
        if s_y == line_to_look_at then table.insert(sensor_line_blocked, s_x) end
        if b_y == line_to_look_at then table.insert(sensor_line_blocked, b_x) end
        for i=0, straight_strength - 1 do
            sensor_line_map[s_x + i] = straight_strength - i
            sensor_line_map[s_x - i] = straight_strength - i
        end
    end

    for _, x in pairs(sensor_line_blocked) do
        sensor_line_map[x] = nil
    end

    -- for x, strength in pairs(sensor_line_map) do
    --     print(x, strength)
    -- end
    print(table_count(sensor_line_map))
end

local input_file = fs.open("/input.txt", "r")
local sensor_map = readSensors(input_file.readAll())