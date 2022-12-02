os.loadAPI("/day02/print_digits.lua")

function calculate_rps_score(input_string)

    result = 0
	delimiter = "\n"
    for match in (input_string..delimiter):gmatch("(.-)"..delimiter) do
        if match:find("X") then
            result = result + 1
            if match:find("A") then
                result = result + 3
            end
            if match:find("C") then
                result = result + 6
            end
        else
            if match:find("Y") then
                result = result + 2
                if match:find("B") then
                    result = result + 3
                end
                if match:find("A") then
                    result = result + 6
                end
            else
                result = result + 3
                if match:find("C") then
                    result = result + 3
                end
                if match:find("B") then
                    result = result + 6
                end
            end
        end
    end
    return result
end

function calculate_rps_score2(input_string)

    result = 0
	delimiter = "\n"
    for match in (input_string..delimiter):gmatch("(.-)"..delimiter) do
        if match:find("X") then
            if match:find("A") then
                result = result + 3
            else
                if match:find("B") then
                    result = result + 1
                else
                    result = result + 2
                end
            end
        else
            if match:find("Y") then
                result = result + 3
                if match:find("A") then
                    result = result + 1
                else
                    if match:find("B") then
                        result = result + 2
                    else
                        result = result + 3
                    end
                end
            else
                result = result + 6
                if match:find("A") then
                    result = result + 2
                else
                    if match:find("B") then
                        result = result + 3
                    else
                        result = result + 1
                    end
                end
            end
        end
    end
    return result
end

os.sleep(10)
input_file = fs.open("/day02/input.txt", "r")
--total_score = calculate_rps_score(input_file.readAll())
total_score = calculate_rps_score2(input_file.readAll())
print_digits.print_digits(total_score)