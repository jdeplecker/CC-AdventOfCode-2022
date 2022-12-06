function spawnTurtlesOntable(table)

    for i=1,14 do
        for j=26,1,-1 do
            if i == 1 then
                commands.exec("fill ~-1 ~"..(j-1).." ~3 ~-1 ~"..(j-1).." ~16 minecraft:air")
            end
            if table[i][j] then
                commands.exec("setblock ~-1 ~"..(j-1).." ~"..(i+2).." computercraft:turtle_advanced[facing=south]")
            end
        end
    end
end

function is_done(table, show)

    if show then
        commands.exec("fill ~-2 ~ ~3 ~-2 ~25 ~16 minecraft:white_concrete_powder")
    end
    unique_row = 0
    for j=1,26 do
        unique_in_row = 0
        for i=1,14 do
            if table[i][j] then
                unique_in_row = unique_in_row + 1
            end
        end
        if unique_in_row == 1 then
            unique_row = unique_row + 1
        else 
            if unique_in_row > 1 and show then
                commands.exec("fill ~-2 ~"..(j-1).." ~3 ~-2 ~"..(j-1).." ~16 minecraft:red_concrete_powder")
            end
        end

    end
    return unique_row == 14        
end

function rotateAndInsert(table, row_to_insert)
    for i=14,2,-1 do
        table[i] = table[i-1]
    end
    table[1] = {
        [row_to_insert] = true
    }
end

function spawnTurtles(input_string)

    table = {}

    for i=1,14 do
        table[i] = {}
    end

    spawnTurtlesOntable(table)
    
    i = 1
    for row in input_string:gmatch("(%a)") do
        rotateAndInsert(table, string.byte(row) - 96)

        if i < 50 or i > 3670 then
            spawnTurtlesOntable(table)
            os.sleep(0.2)
        end
        if is_done(table, i < 50 or i > 3670 ) then
            break
        end
        i = i + 1
    end
    commands.exec("fill ~-2 ~ ~3 ~-2 ~25 ~16 minecraft:green_concrete_powder")
    print(i)
end

os.sleep(2)
input_file = fs.open("/input.txt", "r")
spawnTurtles(input_file.readAll())