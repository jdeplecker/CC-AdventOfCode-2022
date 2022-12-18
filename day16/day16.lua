local function table_count(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

local function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep(" ", indent) .. k .. ":"
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting, v)
        end
    end
end

local function readValves(input_string)
    local valves = {}
    for current_valve, flow_rate, connecting_valves in (input_string.."\n"):gmatch("Valve (%a%a) has flow rate=(%d+); tunnels? leads? to valves? (.-)\n") do
        -- print(current_valve, flow_rate, connecting_valves)
        if valves[current_valve] == nil then valves[current_valve] = {} end
        valves[current_valve]["flow"] = tonumber(flow_rate)
        valves[current_valve]["neighbours"] = {}
        for connecting_valve in connecting_valves:gmatch("(%a%a)") do
            table.insert(valves[current_valve]["neighbours"], connecting_valve)
        end
    end
    return valves
end

local function calculatePotential(valves, current_valve, depth)

    local potential = 0
    local seen = {}
    seen[current_valve] = true
    local stack_to_eval = {}
    table.insert(stack_to_eval, {["name"]=current_valve, ["depth"]=depth})

    while(#stack_to_eval > 0) do
        local valve_to_eval = table.remove(stack_to_eval, 1)
        if not seen[valve_to_eval["name"]] and valve_to_eval["depth"] > 0 then
            print(valve_to_eval["name"], valve_to_eval["depth"])
            potential = potential + valve_to_eval["depth"] * valves[valve_to_eval["name"]]["flow"]
            for _, neighbour in pairs(valves[valve_to_eval["name"]]["neighbours"]) do
                if not seen[neighbour] then
                    seen[neighbour] = true
                    table.insert(stack_to_eval, {["name"] = neighbour, ["depth"] = valve_to_eval["depth"] - 1})
                end
            end
        end
    end

    return potential
end

local function calculatePressure(valves)
    local current_node = "AA"
    local result_order = ""
    local total_pressure = 0

    for i = 1, 30 do
        local highest_neighbour = nil
        local highest_value = 0
        for _, neighbour in pairs(valves[current_node]["neighbours"]) do
            local choice_potential = calculatePotential(valves, neighbour, 30 - i)
            if choice_potential > highest_value then
                highest_value = choice_potential
                highest_neighbour = neighbour
            end
        end
        print("best choice", highest_neighbour)
        current_node = highest_neighbour
        if valves[current_node]["flow"] > 0 then
            total_pressure = total_pressure + valves[current_node]["flow"] * (30 - i)
            valves[current_node]["flow"] = 0
            i = i - 1
        end
        result_order = result_order .. " - " .. current_node
    end

    print(result_order)
    print(total_pressure)
end

local input_file = fs.open("/test_input.txt", "r")
calculatePressure(readValves(input_file.readAll()))