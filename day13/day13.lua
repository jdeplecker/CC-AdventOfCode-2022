local function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting, v)
        end
    end
end

local function makeTable(input_string)
    local signal_table = {}
    local inner_table_string = input_string:sub(2, #input_string-1)
    local open_brackets = 0
    local element_string = ""
    for i=1, #inner_table_string do
        local current_char = inner_table_string:sub(i, i)
        if current_char == "[" then
            open_brackets = open_brackets + 1
        elseif current_char == "]" then 
            open_brackets = open_brackets - 1
        elseif current_char == "," and open_brackets == 0 then
            if element_string:match("^%d+$") then
                -- print("inserting", element_string)
                table.insert(signal_table, tonumber(element_string))
            else
                -- print("making table", element_string)
                table.insert(signal_table, makeTable(element_string))
            end
            element_string = ""
            current_char = "" -- bit of a hack to avoid commas in element string
        end
        element_string = element_string..current_char
    end
    if #element_string > 0 then
        if element_string:match("^%d+$") then
            -- print("inserting", element_string)
            table.insert(signal_table, tonumber(element_string))
        else
            -- print("making table", element_string)
            table.insert(signal_table, makeTable(element_string))
        end
    end
    return signal_table
end

local function isRightOrder(table_left, table_right)

    for i=1, #table_left do
        local left = table_left[i]
        local right = table_right[i]
        if right == nil then return -1 end
        local left_number = tonumber(left)
        local right_number = tonumber(right)
        if left_number ~= nil and right_number ~= nil then
            if left_number < right_number then
                return 1
            elseif left_number > right_number then
                return -1
            end
        else
            if left_number ~= nil then
                left = {left_number}
            end
            if right_number ~= nil then
                right = {right_number}
            end
            local current_decision = isRightOrder(left, right)
            if current_decision ~= 0 then
                return current_decision
            end
        end
    end

    if #table_left < #table_right then
        return 1
    else
        return 0
    end
end

local function readSignals(input_string)
    
    local count = 0
    local index = 1
    for left, right in (input_string.."\n"):gmatch("(%[.-%])\n(%[.-%])\n") do
        if isRightOrder(makeTable(left), makeTable(right)) == 1 then
            count = count + index
        end
        index = index + 1
    end
    print(count)
end


local input_file = fs.open("/input.txt", "r")
readSignals(input_file.readAll())