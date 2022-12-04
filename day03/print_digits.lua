digits = {
 [0]={true, true, false, true, true, true, true},
 [1]={false, false, false, true, false, false, true},
 [2]={true, true, true, true, true, false, false},
 [3]={true, false, true, true, true, false, true},
 [4]={false, false, true, true, false, true, true},
 [5]={true, false, true, false, true, true, true},
 [6]={true, true, true, false, true, true, true},
 [7]={false, false, false, true, true, false, true},
 [8]={true, true, true, true, true, true, true},
 [9]={true, false, true, true, true, true, true}
}

function create_horizontal_row(segment_num, digit_to_print)
	return {
		false, 
		digits[digit_to_print][segment_num], 
		digits[digit_to_print][segment_num], 
		digits[digit_to_print][segment_num], 
		false
	}
end

function create_vertical_row(segment_num_first, segment_num_second, digit_to_print)
	return {
		digits[digit_to_print][segment_num_first],
		false,
		false,
		false,
		digits[digit_to_print][segment_num_second]
	}
end

function create_grid_row(row_num, digit_to_print)
	if row_num == 1 then
		return create_horizontal_row(1, digit_to_print)
	end
	if row_num == 2 or row_num == 4 then
		return create_vertical_row(2, 7, digit_to_print)
	end
	if row_num == 3 then
		return create_vertical_row(7, 2, digit_to_print)
	end
	if row_num == 5 then
		return create_horizontal_row(3, digit_to_print)
	end
	if row_num == 6 or row_num == 8 then
		return create_vertical_row(6, 4, digit_to_print)
	end
	if row_num == 7 then
		return create_vertical_row(4, 6, digit_to_print)
	end
	if row_num == 9 then
		return create_horizontal_row(5, digit_to_print)
	end
end


function print_digit(digit_to_print)
	turtle.up()
	for i = 1, 9 do
		for _, has_to_print in ipairs(create_grid_row(i, digit_to_print)) do
			if turtle.getItemCount() == 0 then
				turtle.select(turtle.getSelectedSlot() + 1)
			end

			if has_to_print then
				turtle.placeDown()
			end

			turtle.forward()
		end
		if i ~= 9 then
			turtle.up()
			turtle.turnLeft()
			turtle.turnLeft()
			turtle.forward()
		end
	end
	
	turtle.forward()
	turtle.forward()
	for i = 1,9 do
		turtle.down()
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