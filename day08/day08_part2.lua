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

function calcTopScore(row, col, trees)
    for i = row - 1, 1, -1 do
        if trees[i][col]["height"] >= trees[row][col]["height"] then
            return row - i
        end
    end
    return row - 1
end

function calcBotScore(row, col, trees)
    for i = row + 1, #trees do
        if trees[i][col]["height"] >= trees[row][col]["height"] then
            return i - row
        end
    end
    return #trees - row
end

function calcLeftScore(row, col, trees)
    for i = col - 1, 1, -1 do
        if trees[row][i]["height"] >= trees[row][col]["height"] then
            return col - i
        end
    end
    return col - 1
end

function calcRightScore(row, col, trees)
    for i = col + 1, #trees[1] do
        if trees[row][i]["height"] >= trees[row][col]["height"] then
            return i - col
        end
    end
    return #trees[1] - col
end

function bestScenicTree(trees)
    best = 0
    for rownr = 1, #trees do
        for colnr = 1, #trees[rownr] do
            score = calcTopScore(rownr, colnr, trees) * calcBotScore(rownr, colnr, trees) * calcLeftScore(rownr, colnr, trees) * calcRightScore(rownr, colnr, trees)
            if score > best then
                best = score
                print("best at "..rownr.." "..colnr.." score "..score)
            end
            if rownr == 4 and colnr == 3 then
                print(calcTopScore(rownr, colnr, trees) .. " " .. calcBotScore(rownr, colnr, trees) .. " " .. calcLeftScore(rownr, colnr, trees) .. " " .. calcRightScore(rownr, colnr, trees))
            end

        end
    end

    return best
end

input_file = fs.open("/input.txt", "r")
trees = readTrees(input_file.readAll())
print(bestScenicTree(trees))
