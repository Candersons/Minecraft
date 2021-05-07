os = require("os")
robot = require("robot")
component = require("component")
inventory = component.inventory_controller

local error = 0

print("\nHow much sand should I process?")
num = io.read()
print(num .. " sand, coming right up!")

for i = 1, num, 1
  do
  robot.suckDown(1)
  if(robot.count() ~= 1)
    then
    print("\nNot enough sand, stopping.\n")
    error = 1
    break
    end
  inventory.equip()
  for a = 1, 11, 1
    do
    robot.use()
    os.sleep(.051)
    if(robot.count() > 0)
      then
      robot.drop()
      end
    end
  end

if(error == 0) then print("\nDone!\n") end
