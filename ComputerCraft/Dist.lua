--[[
Program that reads any message sent on channel 15 with a wireless modem, and prints
the distance between the sender and receiver. Requires a separate computer with a
different program sending any message repeatedly on channel 15. Set to time out
after 2 seconds without receiving anything.
--]]

--Requires a loaded computer constantly sending a message (in this case on channel 15)

modem = peripheral.wrap("back")
modem.open(15)

parallel.waitForAny(
    function()
        e, s, t, r, m, dist = os.pullEvent("modem_message")
        print("The sender was "..dist.." blocks away!")
        return
    end,
    function()
        sleep(2)
        print("Timed out. Sender out of range or unloaded.")
        return
    end
)

--Haven't used this in a while. Might not actually work.
