--Requires a loaded computer constantly sending a message (in this case on channel 15)

modem = peripheral.wrap("back")
modem.open(15)

parallel.waitForAny(
  function()
    e, s, t, r, m, dist = os.pullEvent("modem_message")
    print("The sender was "..dist.." blocks away!")
  end,
  function()
    sleep(2)
    print("Timed out. Sender out of range or unloaded.")
  end
)
