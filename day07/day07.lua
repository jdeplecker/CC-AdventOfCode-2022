sum = 0
-- closest_dir_min_size = 8381165
closest_dir_min_size = 2586708
closest_dir_size = 70000000 --initial biggest value

function addDir(fs, path, dir_name)
    dir_to_add_dir = fs
    for _, dir in pairs(path) do
        dir_to_add_dir = dir_to_add_dir[dir]
    end
    if not dir_to_add_dir[dir_name] then
        dir_to_add_dir[dir_name] = {["size"]=0}
    end
end

function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        else
            print(formatting .. v)
            if k == "size" and v <= 100000 and v > 0 then
                sum = sum + v
            end
        end
    end
end

function part1(fs)
    for k, v in pairs(fs) do
        if type(v) == "table" then
            part1(v)
        else
            if k == "size" and v <= 100000 and v > 0 then
                sum = sum + v
            end
        end
    end
end

function part2(fs)
    for k, v in pairs(fs) do
        if type(v) == "table" then
            part2(v)
        else
            if k == "size" and v < closest_dir_size and v > closest_dir_min_size then
                print(v .. " is closer to "..closest_dir_min_size.." than "..closest_dir_size)
                closest_dir_size = v
            end
        end
    end
end

function solveDirectories(input_string)
    
    full_fs = {
        ["size"]=0
    }
    current_path = {}
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        if line:match("%$ cd %.%..-") then
            current_path[#current_path] = nil
        end
        if line:match("%$ cd %/") then
            current_path = {}
        end
        for dir_to_cd in line:gmatch("%$ cd (%a+.-%a-)") do
            current_path[#current_path + 1] = dir_to_cd
        end

        for size in line:gmatch("(%d+).-") do
            file_size = tonumber(size)
            dir_to_add_size = full_fs
            dir_to_add_size["size"] = dir_to_add_size["size"] + file_size
            for _, dir in pairs(current_path) do
                dir_to_add_size = dir_to_add_size[dir]
                dir_to_add_size["size"] = dir_to_add_size["size"] + file_size
            end            
        end

        for dir_to_create in line:gmatch("dir (%a+)") do
            addDir(full_fs, current_path, dir_to_create)
        end

    end

    tprint(full_fs)
    -- part1(full_fs)
    -- print("part1", sum)
    part2(full_fs)
    print("total file size", full_fs["size"])
    print("still needed", 30000000 - (70000000 - full_fs["size"]))
    print("closest dir size", closest_dir_size)

end

input_file = fs.open("/test_input.txt", "r")
solveDirectories(input_file.readAll())