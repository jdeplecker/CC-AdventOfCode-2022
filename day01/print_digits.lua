digits = {
 [0]={true, true, false, true, true, true, false, true},
 [1]={false, false, false, true, false, false, false, true},
 [2]={true, true, true, true, true, false, false, false},
 [3]={true, false, true, true, true, false, false, true},
 [4]={false, false, true, true, false, true, false, true},
 [5]={true, false, true, false, true, true, false, true},
 [6]={true, true, true, false, true, true, false, true},
 [7]={false, false, false, true, true, false, false, true},
 [8]={true, true, true, true, true, true, false, true},
 [9]={true, false, true, true, true, true, false, true}
}

function has_to_turn_right(index)
	return index == 1 or index == 2 or index == 7 or index == 8
end

function print_digit(digit_to_print)
	print(digit_to_print)
	for i, has_to_print in ipairs(digits[digit_to_print]) do
		turtle.forward()
		if has_to_print then
			turtle.digDown()
		end
		turtle.forward()
		if has_to_print then
			turtle.digDown()
		end
		turtle.forward()
		if has_to_print then
			turtle.digDown()
		end
		turtle.forward()
		if has_to_turn_right(i) then
			turtle.turnRight()
		else
			turtle.turnLeft()
		end
	end
	
	for i = 1,6 do
		turtle.forward()
	end
end

function print_digits(digits_to_print)

	current_num = digits_to_print
	while current_num > 0 do
		remainder = current_num % 10
		print_digit(remainder)
		current_num = (current_num - remainder) / 10
	end
end