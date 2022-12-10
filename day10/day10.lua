
instruction_counter = 1
register_x = 1
total_sum = 0

instructions_to_count = {
    [20]=true,
    [60]=true,
    [100]=true,
    [140]=true,
    [180]=true,
    [220]=true,
}
    
function doCycle()
    if instructions_to_count[instruction_counter] then
        total_sum = total_sum + (instruction_counter * register_x)
    end
    instruction_counter = instruction_counter + 1
end

function solveSignals(input_string)
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for op, amount in line:gmatch("(%a+) ([-]?%d+)") do
            doCycle()
            if op ~= "noop" then
                doCycle()
                register_x = register_x + tonumber(amount)
            end
        end
        for _ in line:gmatch("(noop)") do
            doCycle()
        end
    end

    print(total_sum)
end

input_file = fs.open("/input.txt", "r")
solveSignals(input_file.readAll())