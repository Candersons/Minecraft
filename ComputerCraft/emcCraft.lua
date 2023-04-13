--Setting our output(chest) and our 
--"crafter" the emc link.
emc = peripheral.wrap("extendedexchange:compressed_refined_link_2")
chest = peripheral.wrap("minecraft:chest_5")
 
--My first program utilizing
--the monitor in any way!
--This "array" will be used to store
--our history
terminalHistory = {}
--This value indicates how long we
--want our history to be. Restricted
--to size of the screen. Maxed at 11.
terminalHistoryMax = 11
--Effectively resets our monitor
term.clear()
term.setCursorPos(1,1)
 
--This table will tell us what items
--to pull from the emc link (which
--can't be themselves otherwise rs
--autocrafting won't be happy). Use
--the exact name of the items, and
--add to it as much as you want
--(so long as you teach the emc link
--the items you want)
replace = {
  ["minecraft:cobblestone"] = "minecraft:netherrack",
  ["minecraft:emerald"] = "minecraft:nether_star",
  ["minecraft:redstone"] = "minecraft:end_stone"
}
 
--Our main function. Where all the
--magic(pain) happens
function main()
  --Work forever
  while(true) do
    --This variable ensures we output
    --all the items we wanted. Useful
    --for items of different stack
    --sizes
    output = 0
    --This checks if we've received
    --any input, sleeping if we haven't
    if(turtle.getItemCount(1) ~= 0) then
      --This function waits for our
      --input to input.
      wait()
      --This tells us what our input
      --was
      item = turtle.getItemDetail(1)
      --And this tells us what slot in
      --the emc link our wanted item
      --rests in.
      slot = findSlot(replace[item.name])
      --If the link doesn't have that
      --item, tell the user, and 
      --"continue"
      if(slot == false) then
        --Adds this action to our
        --history variable which is
        --used for formatting our
        --screen.
        table.insert(terminalHistory, 1, replace[item.name] .. " not in emc link.") table.remove(terminalHistory, terminalHistoryMax + 1)
        --Prints everything we want to
        --see to the screen.
        printScreen()
        --Empties our input (so we
        --don't endlessly talk about
        --the emc link not having what
        --we want, preventing further
        --actions)
        chest.pullItems("turtle_5", 1, 64)
        break
      end
      
      --Here we save our terminal
      --output into an "array" instead
      --of just printing it. We also
      --delete anything extending past
      --our max "array" length
      table.insert(terminalHistory,1,"Grabbing " .. item.count .. " " .. replace[item.name] .. ".") table.remove(terminalHistory, terminalHistoryMax + 1)
      --Print our terminal's output
      printScreen()
      --This loop ensures we get all
      --the output items we want
      while(output < item.count) do
        output = output + chest.pullItems(peripheral.getName(emc), slot, item.count)
      end
      --This loop makes sure our turtle
      --gets rid of our previous input
      --before continuing on      
      while(turtle.getItemCount(1) > 0) do
        chest.pullItems("turtle_5", 1, 64)
      end
    else
    --Sleeps if we have no input.
      sleep(.5)
    end
  end
end
 
--This function makes the turtle wait
--to start collecting items until it
--has finished receiving input
function wait()
  --Initialize a bunch of variables.
  --Just kind of felt like putting the
  --local in front of them this time.
  --This first variable simply stores
  --the time since our last input was
  --received
  local timeSinceLastItemInserted = 0
  --This variable is for how long
  --since our last input we want to
  --wait to see if we receive more
  --input
  local timeCheck = .01
  --This is how quickly we want to
  --check for an input
  local sleepAmount = .005
  --Loop time. Loop for as long as we
  --are still receiving input. 
  while(timeSinceLastItemInserted < timeCheck) do
    --count will store our input
    count = turtle.getItemCount(1)
    --check will keep that first input
    --value
    check = count
    --Then we wait some time for the
    --crafter to push an item into the
    --turtle.
    sleep(sleepAmount)
    --Then store what our input is now
    count = turtle.getItemCount(1)
    --This line tells us time has
    --passed
    timeSinceLastItemInserted = timeSinceLastItemInserted + sleepAmount
    --Then we check if our input has
    --changed
    if(check < count) then
      --Resetting our timer if it has
      timeSinceLastItemInserted = 0
    end
  end
end
 
--This function takes a string input
--(the name of the item you want) and
--it finds which slot of the emc link
--the item exists in. If it exists.
function findSlot(itemName)
  slot = 1
  --Not entirely sure how this works,
  --but this effectively checks every
  --slot of the emc link to see what
  --it knows.
  for k, v in pairs(emc.list()) do
    --And this checks if one of those
    --slots has the item we want.
    if(itemName == v.name) then
      --Saving which slot that item
      --is in.
      slot = k
    end
  end
  --If our wanted item is in the link
  if(slot ~= 1) then
    --Return what slot it is in.
    return slot
  else
    --Otherwise it isn't in the link.
    return false
  end
end
 
--This function prints our screen
function printScreen()
  --Clears anything previously written
  term.clear()
  --Tells the computer to write from
  --the top of the terminal
  term.setCursorPos(1,1)
  --This actually prints everything,
  --walking through the
  --"terminalHistory" array for what
  --we want to print.
  for k, v in pairs(terminalHistory) do
    print(v)
  end
end
 
--Apparently lua has no continue
--statement. This is my workaround.
while(true) do
  main()
end

--Pastebin link: https://pastebin.com/8TChc6xq