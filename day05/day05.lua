function createBoard(input_string)
    board = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
        [7] = {},
        [8] = {},
        [9] = {},
    }
    row = 8
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        if row == 0 then
            break
        end
        col = 1
        for i=2,34,4 do
            letter = line:sub(i, i)
            if string.byte(letter) ~= 32 then
                board[col][row] = letter
            end
            col = col + 1
        end
        row = row - 1
    end
    return board
end

function makeMoves(input_string, board)
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for amount_to_move, column_from, column_to in line:gmatch("move (%d+) from (%d+) to (%d+).*") do            
            for i=1,tonumber(amount_to_move) do
                column_from = tonumber(column_from)
                column_to = tonumber(column_to)
                board[column_to][#board[column_to] + 1] = board[column_from][#board[column_from]]
                board[column_from][#board[column_from]] = nil
            end
        end
    end
end

function makeMoves2(input_string, board)
    for line in (input_string.."\n"):gmatch("(.-)\n") do
        for amount_to_move, column_from, column_to in line:gmatch("move (%d+) from (%d+) to (%d+).*") do            
            amount_to_move = tonumber(amount_to_move)
            column_to = tonumber(column_to)
            column_from = tonumber(column_from)
            orignal_column_to_size = #board[column_to]
            for i=1,amount_to_move do
                board[column_to][orignal_column_to_size + amount_to_move - i + 1] = board[column_from][#board[column_from]]
                board[column_from][#board[column_from]] = nil
            end
        end
    end
end

function printBoardTopElements(board)
    for col, row_table in pairs(board) do
        print(col, board[col][#board[col]])
    end
end

input_file = fs.open("/input.txt", "r")
board = createBoard(input_file.readAll())
input_file = fs.open("/input.txt", "r")
-- makeMoves(input_file.readAll(), board)
makeMoves2(input_file.readAll(), board)
printBoardTopElements(board)
