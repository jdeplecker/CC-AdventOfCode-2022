function spawnTurtlesOntable(table)

    commands.exec("fill ~-1 ~1 ~3 ~-1 ~26 ~6 minecraft:air")
    for i=1,4 do
        for j=1,26 do
            if table[i][j] then
                commands.exec("setblock ~-1 ~"..j.." ~"..(i+2).." computercraft:turtle_advanced[facing=south]")
            end
        end
    end
end

function is_done(table, show)

    if show then
        commands.exec("fill ~-2 ~1 ~3 ~-2 ~26 ~6 minecraft:white_concrete_powder")
    end
    unique_row = 0
    for j=1,26 do
        unique_in_row = 0
        for i=1,4 do
            if table[i][j] then
                unique_in_row = unique_in_row + 1
            end
        end
        if unique_in_row == 1 then
            unique_row = unique_row + 1
        else 
            if unique_in_row > 1 and show then
                commands.exec("fill ~-2 ~"..j.." ~3 ~-2 ~"..j.." ~6 minecraft:red_concrete_powder")
            end
        end

    end
    return unique_row == 4        
end

function rotateAndInsert(table, row_to_insert)
    table[4] = table[3]
    table[3] = table[2]
    table[2] = table[1]
    table[1] = {
        [row_to_insert] = true
    }
end

function spawnTurtles(input_string)

    table = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {}
    }

    spawnTurtlesOntable(table)
    
    i = 1
    for row in input_string:gmatch("(%a)") do
        rotateAndInsert(table, string.byte(row) - 96)
        if is_done(table, i < 100) then
            break
        end

        if i < 100 then
            spawnTurtlesOntable(table)
            os.sleep(0.2)
        end
        i = i + 1
    end
    spawnTurtlesOntable(table)
    commands.exec("fill ~-2 ~1 ~3 ~-2 ~26 ~6 minecraft:green_concrete_powder")
    print(i)
end

input_file = fs.open("/input.txt", "r")
spawnTurtles(input_file.readAll())