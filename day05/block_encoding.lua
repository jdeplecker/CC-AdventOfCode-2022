block_encodings = {
    [65] = "minecraft:white_wool",
    [66] = "minecraft:orange_wool",
    [67] = "minecraft:magenta_wool",
    [68] = "minecraft:light_blue_wool",
    [69] = "minecraft:yellow_wool",
    [70] = "minecraft:lime_wool",
    [71] = "minecraft:pink_wool",
    [72] = "minecraft:gray_wool",
    [73] = "minecraft:light_gray_wool",
    [74] = "minecraft:cyan_wool",
    [75] = "minecraft:purple_wool",
    [76] = "minecraft:blue_wool",
    [77] = "minecraft:brown_wool",
    [78] = "minecraft:green_wool",
    [79] = "minecraft:red_wool",
    [80] = "minecraft:black_wool",
    [81] = "minecraft:white_concrete",
    [82] = "minecraft:orange_concrete",
    [83] = "minecraft:magenta_concrete",
    [84] = "minecraft:light_blue_concrete",
    [85] = "minecraft:yellow_concrete",
    [86] = "minecraft:lime_concrete",
    [87] = "minecraft:pink_concrete",
    [88] = "minecraft:gray_concrete",
    [89] = "minecraft:light_gray_concrete",
    [90] = "minecraft:cyan_concrete"
}


function block_encode(letter)
    return block_encodings[string.byte(letter)]    
end

function block_decode(block_type_input)
    for i, block_type in pairs(block_encodings) do
        if block_type == block_type_input then
            return string.char(i)
        end
    end
    return "not found"
end