peripheral.find("modem", rednet.open)
while true do
    local id, message = rednet.receive()
    print(("Computer %d sent message %s"):format(id, message))
    shell.run(message)
end
peripheral.find("modem", rednet.close)