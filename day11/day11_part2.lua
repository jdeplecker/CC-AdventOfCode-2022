
function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting, v)
        end
    end
end

function createOperationFunction(operation, operation_amount)
    return function (input) 
        operation_number = tonumber(operation_amount)
        if operation_amount == "old" then operation_number = input end
        if operation == "+" then 
            return input + operation_number
        else 
            return input * operation_number
        end 
    end
end

function readInMonkeys(input_string)
    monkeys = {}
    for monkey_nr, item_string, operation, operation_amount, test_amount, monkey_nr_true, monkey_nr_false in input_string:gmatch("Monkey (%d).-items: (.-)\n.-old ([+*]) (.-)\n.-by (%d+).-monkey (%d).-monkey (%d)") do
        items = {}
        for item in item_string:gmatch("(%d+)") do 
            table.insert(items, item) 
        end
        monkeys[tonumber(monkey_nr)] = {
            ["items"] = items,
            ["operation"] = createOperationFunction(operation, operation_amount),
            ["next_monkey"] = function (stress_level) if stress_level % tonumber(test_amount) == 0 then return tonumber(monkey_nr_true) else return tonumber(monkey_nr_false) end end,
            ["active_count"] = 0,
            ["test_amount"] = test_amount
        }
    end
    return monkeys
end

function solveMonkeyBusiness(monkeys)
    common_deviser = 1
    for monkey=0,#monkeys do
        common_deviser = common_deviser * monkeys[monkey]["test_amount"]
    end
    print(common_deviser)

    for round=1,10000 do
        for monkey=0,#monkeys do
            for _, item in pairs(monkeys[monkey]["items"]) do
                current_stress = monkeys[monkey]["operation"](item)
                current_stress = current_stress % common_deviser
                next_monkey = monkeys[monkey]["next_monkey"](current_stress)
                table.insert(monkeys[next_monkey]["items"], current_stress)
                monkeys[monkey]["active_count"] = monkeys[monkey]["active_count"] + 1
            end
            monkeys[monkey]["items"] = {}
        end
    end

    for monkey=0,#monkeys do
        print(monkey, monkeys[monkey]["active_count"])
    end
end


input_file = fs.open("/input.txt", "r")
monkeys = readInMonkeys(input_file.readAll())
solveMonkeyBusiness(monkeys)