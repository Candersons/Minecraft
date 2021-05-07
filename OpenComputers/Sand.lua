--[[
This program takes a block from an inventory below it (in this case sand, but it can be anything)
and sieves it through an Ex Nihilo sieve. Before processing anything, the program asks the user
how many blocks they would like to process, ending once that amount has been sieved. It drops
whatever it picks up in it's first slot (I used a vacuum hopper (Thermal Expansion) to pick
that up) in order to pick up the next block it wants to sieve.
]]
os = require("os")
robot = require("robot")
component = require("component")
inventory = component.inventory_controller

local error = 0

print("\nHow much sand should I process?") --Getting user input
num = io.read()
print(num .. " sand, coming right up!")    --Tells the user what we saw/are doing

for i = 1, num, 1                          --Start the processing
  do
  robot.suckDown(1)                        --Pick up the block we want to sieve
  if(robot.count() ~= 1)
    then
    print("\nNot enough sand, stopping.\n")--Print error if we didn't get anything
    error = 1
    break
    end
  inventory.equip()                        --Prepare our block to be sieved
  for a = 1, 11, 1
    do
    robot.use()                            --Sieving...
    os.sleep(.051)
    if(robot.count() > 0)
      then
      robot.drop()                         --Drop whatever is potentially blocking our first slot
      end
    end
  end

if(error == 0) then print("\nDone!\n") end --Tells the user we didn't have any issues
