--pastebin xkhBbNzu

modem = peripheral.wrap("back")
modem.open(0)

event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")

print("Message from "..senderDistance.." blocks away!")
print(message)