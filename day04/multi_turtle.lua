function prepare_disk_drive()
    turtle.select(1)
    turtle.place()
    turtle.select(2)
    turtle.drop(1)
    fs.copy("day04/worker_turtle_startup.lua","/disk/startup.lua")
    fs.copy("day04/print_digit.lua","/disk/print_digit.lua")
end

function fuel_turtle(turtle_peripheral)
    turtle.select(4)
    turtle.drop(8)
    rednet.send(turtle_peripheral.getID(), "refuel all")
end

function supply_blocks()
    block_itemslot = 5
    turtle.select(block_itemslot)
    while turtle.getItemCount() == 0 do
        block_itemslot = block_itemslot + 1
        turtle.select(block_itemslot)
    end
    turtle.drop(64)
end

function prepare_turtle(forward, left, digit_to_print)
    peripheral.find("modem", rednet.open)
    turtle.select(3)
    turtle.place()
    os.sleep(1)
    turtle_peripheral = peripheral.wrap("front")
    turtle_peripheral.turnOn()
    os.sleep(1)
    fuel_turtle(turtle_peripheral)
    supply_blocks()
    rednet.send(turtle_peripheral.getID(), "cp /disk/print_digit.lua /print_digit.lua")
    rednet.send(turtle_peripheral.getID(), "print_digit "..forward.." "..left.." "..digit_to_print)
    peripheral.find("modem", rednet.close)
    return
end