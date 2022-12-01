os.loadAPI("/day01/print_digits.lua")

function find_all_elf_calories(input_string)

    result = {}
	delimiter = "\n"
    for match in (input_string..delimiter):gmatch("(.-)"..delimiter) do
		table_size = table.maxn(result)
		calories_number = tonumber(match) or 0
		if table_size > 0 then
			if calories_number > 0 then
				result[table_size] = result[table_size] + calories_number
			else
				table.insert(result, calories_number)
			end
		else
			table.insert(result, calories_number)
		end
    end
    return result
end

function find_biggest_three_calories(all_calories)	
	table.sort(all_calories, function(a,b) return a > b end)
	return all_calories[1] + all_calories[2] + all_calories[3]
end

function find_biggest_calories(all_calories)	
	table.sort(all_calories, function(a,b) return a > b end)
	return all_calories[1]
end

-- os.sleep(10)
input_file = fs.open("/day01/input.txt", "r")
all_calories = find_all_elf_calories(input_file.readAll())
biggest_calories = find_biggest_calories(all_calories)
-- biggest_calories = find_biggest_three_calories(all_calories)
print_digits.print_digits(biggest_calories)