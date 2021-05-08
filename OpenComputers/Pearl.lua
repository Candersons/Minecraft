--[[
This program uses a robot to craft a user speciied amount of ender pearls through Compact 
Machines 3 3d crafting. This program was specifically written for my Compact Claustrophobia 
world with it's custom recipes.
]]

robot = require("robot")
component = require("component")

print("How many pearls should I make?")                   --Ask user for how many pearls it should
num = io.read()                                           --craft
print("Making" .. num .. " pearls")

function wait(seconds)                                    --I was not aware of os.sleep at this time
  local start = os.time()                                 --so I used this function instead, making
  repeat robot.turnRight() robot.turnLeft() until os.time() > start + seconds --the robot turn to
end                                                       --prevent it from timing out, slightly 
                                                          --affecting the timing
function line()                                           --[Places three blocks along the same
  robot.place()                                           --axis]
  robot.back()
  robot.place()
  robot.back()
  robot.place()
end

function plate()                                          --places three lines of three blocks
  line()                                                  --next to each other along an axis
  robot.turnLeft()
  robot.forward()
  robot.turnRight()
  robot.forward()
  robot.forward()
  line()
  robot.turnLeft()
  robot.forward()
  robot.turnRight()
  robot.forward()
  robot.forward()
  line()
end

for i = 1, num, 1 do                                      --Program "officially" begins
  robot.select(1)
  robot.turnRight()                                       --Selects an inventory slot, and fills it
  robot.suck(1)                                           --with a block from a storage block
  if(robot.count() ~= 1) then                             --to it's right, stopping if it doesn't
    break                                                 --get anything
  end
  robot.select(2)                                         --Changes inventory slot, fills slot with
  robot.turnLeft()                                        --item from storage block in front and
  robot.forward()                                         --to the right of it's initial position
  robot.turnRight()
  robot.suck(1)
  if(robot.count() ~= 1) then
    break
  end
  robot.select(3)                                         --Changes inv slot again, filling it with
  robot.turnAround()                                      --26 blocks from storage 1 block forward
  robot.forward()                                         --and 2 blocks to the left of robot's
  robot.forward()                                         --initial position
  robot.suck(26)
  if(robot.count() ~= 26) then
    break
  end
  robot.turnRight()                                       --Moves to the bottom front right most block
  robot.forward()                                         --of the 3d crafting grid, placing a 3x3 of
  robot.forward()                                         --blocks
  robot.forward()
  plate()
  robot.up()                                              --Moves up and forward twice to middle front
  robot.forward()                                         --leftmost corner, placing a 3x3 of blocks
  robot.forward()                                         --with a different block in the center
  line()
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  robot.forward()
  robot.forward()
  robot.place()
  robot.back()
  robot.select(1)
  robot.place()
  robot.back()
  robot.select(3)
  robot.place()
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  robot.forward()
  robot.forward()
  line()
  robot.up()                                              --Moves up, forward twice, top front right 
  robot.forward()                                         --most corner, placing a 3x3 of blocks
  robot.forward()
  plate()
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  robot.select(2)
  robot.back()                                            --Drops the "catalyst" to begin the crafting
  robot.drop()                                            --and goes back to initial position for next
  robot.forward()                                         --crafting loop
  robot.down()
  robot.down()
  robot.turnRight()
  robot.forward()
  robot.forward()
  robot.forward()
  robot.turnRight()
  robot.forward()
  robot.forward()
  robot.turnAround()
  wait(480)                                               --Waits until crafting is done
end
