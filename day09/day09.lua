
function moveTail(head, tail) 
    if math.abs(head["x"] - tail["x"]) < 2 and math.abs(head["y"] - tail["y"]) < 2 then
        -- print("touching")
        return tail
    end

    return {
        ["x"] = tail["x"] + round((head["x"] - tail["x"])/2),
        ["y"] = tail["y"] + round((head["y"] - tail["y"])/2)
    }
end

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
  end
  

function solveSnake(input_string)
    visited = {}
    head = {["x"]=0, ["y"]=0}
    tail = {["x"]=0, ["y"]=0}
    for dir, amount in input_string:gmatch("(%a) (%d+)") do
        -- print(dir, amount)
        for i=1,tonumber(amount) do
            -- print(tail["x"].."-"..tail["y"])
            visited[tail["x"].."B"..tail["y"]] = true
            moves = {
                ["R"] = {["x"]=1, ["y"]=0},
                ["L"] = {["x"]=-1, ["y"]=0},
                ["U"] = {["x"]=0, ["y"]=-1},
                ["D"] = {["x"]=0, ["y"]=1},
            }

            head["x"] = head["x"] + moves[dir]["x"]
            head["y"] = head["y"] + moves[dir]["y"]

            print("before", tail["x"].."-"..tail["y"], head["x"].."-"..head["y"])
            tail = moveTail(head, tail)
            visited[tail["x"].."B"..tail["y"]] = true
            print(tail["x"].."-"..tail["y"], head["x"].."-"..head["y"])
        end
        -- os.pullEvent("key")
    end
    visited[tail["x"].."B"..tail["y"]] = true

    count = 0
    for k, v in pairs(visited) do
        if v then
            count = count + 1
        end
    end
    print(count)
end


input_file = fs.open("/test_input.txt", "r")
solveSnake(input_file.readAll())