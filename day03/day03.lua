os.loadAPI("/day03/print_digits.lua")

function calculate_rucksack_priority_sum(input_string)

    result = 0
	delimiter = "\n"
    for line in (input_string..delimiter):gmatch("(.-)"..delimiter) do
        rucksack_size = #line
        seen_bytes = {}
        for i = 1, rucksack_size do
            b = string.byte(line:sub(i, i))
            if i <= rucksack_size/2 then
                seen_bytes[b] = true
            else
                if seen_bytes[b] then
                    if b < string.byte("a") then
                        result = result + b - string.byte("A") + 27
                    else
                        result = result + b - string.byte("a") + 1
                    end
                    break
                end
            end
        end
    
    end
    return result
end

function calculate_rucksack_badges_sum(input_string)

    result = 0
	delimiter = "\n"
    elf_group = {}
    for line in (input_string..delimiter):gmatch("(.-)"..delimiter) do
        seen_bytes = {}
        check_third = #elf_group == 2
        for i = 1, #line do
            b = string.byte(line:sub(i, i))
            if check_third and elf_group[1][b] and elf_group[2][b] then
                if b < string.byte("a") then
                    result = result + b - string.byte("A") + 27
                else
                    result = result + b - string.byte("a") + 1
                end
                break
            else
                seen_bytes[b] = true
            end
        end

        if check_third then
            elf_group = {}
        else
            elf_group[#elf_group + 1] = seen_bytes
        end
    
    end
    return result
end

os.sleep(10)
input_file = fs.open("/day03/input.txt", "r")
-- total_sum = calculate_rucksack_priority_sum(input_file.readAll())
total_sum = calculate_rucksack_badges_sum(input_file.readAll())
print_digits.print_digits(total_sum)