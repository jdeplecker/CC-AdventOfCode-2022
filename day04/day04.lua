os.loadAPI("/day04/multi_turtle.lua")

function calculate_overlaps(input_string)

    result = 0
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for min1,max1,min2,max2 in line:gmatch("(.-)-(.-),(.-)-(.*)") do
            if (tonumber(min2) <= tonumber(min1) and tonumber(max1) <= tonumber(max2)) or (tonumber(min1) <= tonumber(min2) and tonumber(max2) <= tonumber(max1)) then
                result = result + 1
            end
        end
    end
    return result
end

function in_range(min, max, to_test)
    return to_test - min >= 0 and max - to_test >= 0
end

function calculate_overlaps2(input_string)

    result = 0
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for min1,max1,min2,max2 in line:gmatch("(.-)-(.-),(.-)-(.*)") do
            if in_range(min1, max1, min2) or in_range(min1, max1, max2) or (min1 - min2 > 0 and max2 - max1 > 0) then
                result = result + 1
            end
        end
    end
    return result
end

os.sleep(2)
input_file = fs.open("/day04/input.txt", "r")
-- print(calculate_overlaps(input_file.readAll()))
total_as_string = tostring(calculate_overlaps2(input_file.readAll()))
multi_turtle.prepare_disk_drive()
turtle.up()
for i=1, #total_as_string do
    multi_turtle.prepare_turtle(3, (#total_as_string - i) * 6, tonumber(total_as_string:sub(i, i)))
    os.sleep(2)
end