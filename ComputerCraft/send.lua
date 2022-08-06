--pastebin 7cNhb4dm

modem = peripheral.wrap("back")
print("Please enter your message to transmit:")
message = read()
modem.transmit(0,0,message)