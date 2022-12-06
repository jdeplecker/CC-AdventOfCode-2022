os.loadAPI("/block_encoding.lua")

function move_to_column(current_column, column_to_move_to)
    if current_column > column_to_move_to then
        turtle.turnLeft()
        for col=column_to_move_to, current_column - 1 do
            turtle.forward()
        end
        turtle.turnRight()
    else 
        if current_column < column_to_move_to then
            turtle.turnRight()
            for col=current_column, column_to_move_to - 1 do
                turtle.forward()
            end
            turtle.turnLeft()
        end
    end
end

function move_to_top()
    while turtle.detect() do
        turtle.up()
    end
end

function move_to_bottom()
    while turtle.down() do
        turtle.down()
    end
end

function executeMoves(input_string)
    current_column = 1
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for amount_to_move, column_from, column_to in line:gmatch("move (%d+) from (%d+) to (%d+).*") do            
            for i=1,tonumber(amount_to_move) do
                move_to_column(current_column, tonumber(column_from))
                current_column = tonumber(column_from)
                move_to_top()
                turtle.down()
                turtle.dig()
                move_to_bottom()
                move_to_column(current_column, tonumber(column_to))
                current_column = tonumber(column_to)
                move_to_top()
                turtle.place()
                move_to_bottom()
            end
        end
    end
    move_to_column(current_column, 1)
end

function print_top_letters()
    for current_column=1,9 do
        move_to_top()
        turtle.down()
        turtle.dig()
        print(block_encoding.block_decode(turtle.getItemDetail().name))
        turtle.place()
        move_to_bottom()
        move_to_column(current_column, current_column + 1)
    end
end

input_file = fs.open("/input.txt", "r")
executeMoves(input_file.readAll())
print_top_letters()
