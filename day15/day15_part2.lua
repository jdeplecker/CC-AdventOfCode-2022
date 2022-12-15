local highest_x = 4000000

local function table_count(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

local function contains(range, number)
    return range[1] <= number and range[2] >= number
end

local function merge(list_ranges, range)
    
    local index_to_remove = 0
    for i, existing_range in pairs(list_ranges) do
        if contains(existing_range, range[1]) or contains(existing_range, range[2]) or contains(range, existing_range[1]) or contains(range, existing_range[2]) then
            index_to_remove = i
            break
        end
    end
    if index_to_remove ~= 0 then
        local overlapping_range = table.remove(list_ranges, index_to_remove)
        local min_x = overlapping_range[1]
        if range[1] < min_x then min_x = range[1] end
        local max_x = overlapping_range[2]
        if range[2] > max_x then max_x = range[2] end

        return merge(list_ranges, {min_x, max_x})
    else
        table.insert(list_ranges, range)
    end

    return list_ranges
end

local function readSensors(input_string, line_to_look_at)
    local ranges = {}
    for s_x, s_y, b_x, b_y in input_string:gmatch("Sensor at x=(-?%d+), y=(-?%d+): closest beacon is at x=(-?%d+), y=(-?%d+)") do
        s_x, s_y, b_x, b_y = tonumber(s_x), tonumber(s_y), tonumber(b_x), tonumber(b_y)
        local manhatten_dist = math.abs(s_x - b_x) + math.abs(s_y - b_y)
        local straight_strength = manhatten_dist - math.abs(s_y - line_to_look_at) + 1
        if straight_strength > 0 then
            local high_range = s_x + straight_strength - 1
            local low_range = s_x - straight_strength + 1
            if low_range < 0 then low_range = 0 end
            if high_range < 0 then high_range = 0 end
            if low_range > highest_x then low_range = highest_x end
            if high_range > highest_x then high_range = highest_x end
            ranges = merge(ranges, {low_range, high_range})
        end
    end
    local amount_ranges = table_count(ranges)
    if amount_ranges > 1 then
        for _, range in pairs(ranges) do
            print(line_to_look_at, range[1], range[2])
        end
    end

    return amount_ranges > 1
end

local input_file = fs.open("/input.txt", "r")
local input_string = input_file.readAll()
for i=1, highest_x do
    if i % 50000 == 0 then 
        print(i) 
        -- hack to let the turtle run longer
        os.queueEvent("fakeEvent");
        os.pullEvent();
    end
    if readSensors(input_string, i) then break end
end