
instruction_counter = 1
register_x = 1

monitor = peripheral.wrap("left")
    

function getToken()
    if (instruction_counter - 1) % 40 + 1 > (register_x - 1) and (instruction_counter - 1) % 40 + 1 < (register_x + 3) then
        return "$"
    end

    return "."
end

function doCycle()
    x = (instruction_counter - 1) % 40 + 1
    y = math.ceil(instruction_counter / 40)
    monitor.setCursorPos(x, y)
    monitor.write(getToken())

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
end

input_file = fs.open("/input.txt", "r")
solveSignals(input_file.readAll())