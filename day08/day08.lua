-- one turtle per tree
-- 4 blocks of coal fuel, 10 building blocks (green for visible & red for invisible)

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

function readTrees(input_string)
    all_trees = {}
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        currentTreeLine = {}
        for tree_height in line:gmatch("%d") do
            table.insert(currentTreeLine, {["height"]=tree_height, ["visible"]=false})
        end

        all_trees[#all_trees + 1] = currentTreeLine
    end
    return all_trees
end

function makeVisible(trees)
    -- right
    for rownr = 1, #trees do
        trees[rownr][#trees[rownr]]["visible"] = true
        height_to_check = trees[rownr][#trees[rownr]]["height"]
        for colnr = #trees[rownr]-1, 2, -1 do
            if trees[rownr][colnr]["height"] > height_to_check then
                trees[rownr][colnr]["visible"] = true
                height_to_check = trees[rownr][colnr]["height"]
            end
        end
    end

    -- left
    for rownr = 1, #trees do
        trees[rownr][1]["visible"] = true
        height_to_check = trees[rownr][1]["height"]
        for colnr = 2, #trees[rownr]-1 do
            if trees[rownr][colnr]["height"] > height_to_check then
                trees[rownr][colnr]["visible"] = true
                height_to_check = trees[rownr][colnr]["height"]
            end
        end
    end

    -- top
    for colnr = 1, #trees[1] do
        trees[1][colnr]["visible"] = true
        height_to_check = trees[1][colnr]["height"]
        for rownr = 2, #trees-1 do
            if trees[rownr][colnr]["height"] > height_to_check then
                trees[rownr][colnr]["visible"] = true
                height_to_check = trees[rownr][colnr]["height"]
            end
        end
    end

    -- bottom
    for colnr = 1, #trees[1] do
        trees[#trees[1]][colnr]["visible"] = true
        height_to_check = trees[#trees[1]][colnr]["height"]
        for rownr = #trees - 1, 2, -1 do
            if trees[rownr][colnr]["height"] > height_to_check then
                trees[rownr][colnr]["visible"] = true
                height_to_check = trees[rownr][colnr]["height"]
            end
        end
    end

    return trees
end

function countVisibles(trees)
    count = 0
    for rownr = 1, #trees do
        for colnr = 1, #trees[rownr] do
            if trees[rownr][colnr]["visible"] == true then
                count = count + 1
            end
        end
    end
    return count
end


input_file = fs.open("/input.txt", "r")
trees = readTrees(input_file.readAll())
trees = makeVisible(trees)
print(countVisibles(trees))
