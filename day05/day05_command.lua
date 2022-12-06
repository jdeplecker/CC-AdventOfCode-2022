os.loadAPI("/block_encoding.lua")

function setblock(left, up, block_type)
    commands.exec("setblock ~-3 ~"..up.." ~"..left.." "..block_type)
end

function createBoard(input_string)
    up = 7
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        if y == -1 then
            break
        end
        left = 9
        for i=2,34,4 do
            letter = line:sub(i, i)
            print(letter)
            if string.byte(letter) == 32 then
                setblock(left, up, "minecraft:air")
            else
                setblock(left, up, block_encoding.block_encode(letter))
            end
            left = left - 1
        end
        up = up - 1
    end
end

input_file = fs.open("/input.txt", "r")
createBoard(input_file.readAll())