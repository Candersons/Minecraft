--pastebin hVVXQChU

--[[
This program runs a quarry built with the mod
Create. Uses gantry shafts. And lots of other
blocks. Is cool. And was a pain to develop.

Requires a second computer sending messages.
This is how I learned the peripheral API of
ComputerCraft.

My comments occasionally say something along
the lines of "will likely replace with" and
then a better idea to how it is currently
programmed. Such replacements will be
unlikely unless I decide to work on this
again.
--]]

rednet.open("front")
redstone.setOutput("bottom", true)
--These lines are to make sure we have wireless
--stuff enabled. Hard to have a smart quarry
--without any sensor data

print("Make sure you have enough chest space! \nThis doesn't stop until it's done.\n\nIf you're ready, start the other computer.")
rednet.receive("start")
--Inform user of current short-comings of this
--quarry software. Also waits to start mining
--until you start the sensor computer.

function main()
--Put our main code in a main function that runs
--at the end. Allows to put our main body of code
--before our functions are declared. Which is what
--I was always taught to do.

--print("What is the length of the drill? (E-W)")
--length = read() + 1
--print("What is the width of the drill? (N-S)")
--width = read() + 1

west = false
south = true
--Hard coded quarry directions. Will likely
--replace with a player inputted version. Or maybe
--a smart version where the quarry doesn't require
--input to figure out directions.

length = 4
width = 4
--Hard coded drill size. Already have the
--replacement code written. Still testing quarry,
--though, so not asking size is faster right now.
    
--Future me here, I don't think i ever did write
--that code. I was lying to look cool. Probably.

state = {0,0,0}
print("\nStarted quarry\n")
--Initializes a variable, and informs user of
--the quarry having received the start signal.

while(true)
--This is where the magic happens. The actual
--mining is controlled in this loop, which breaks
--when the quarry reaches the farthest corner.
do
    mine()
    if(state[3] == 1) then
    --mine() mines. state[3] tells us if we are
    --finished/have reached the furthest corner.
        toOrigin()
        print("Going back from whence we came...")
        break
        --If we have, go back to the closest
        --corner and exit the main loop.
    end
    if(state[2] == 1) then
    --state[2] tells us if we have hit the end of
    --the East-West movement.
        allBack()
        moveSide(width+1)
        mine()
        --If so, we go back to the beginning of
        --the line, move to the side, and mine.
    end
    moveForward(length+1) 
    --Fyi, I move the length of the drill + 1
    --because create seems to not move it's gantry
    --shafts on the first attempt to move. This
    --allows us to stay in place first, and then
    --move exactly how much we want to to maximize
    --drill usage.   

end
print("\nFinished mining.\n\nRemember to turn off the other computer!\n")
--This runs after state[3] has been detected,
--breaking out of the loop. Informs the user we
--are done. And reminds them there's second
--computer to turn off. May attempt to make it
--turn off automatically after the program
--finishes.

end
--end of main() function

function stop(state)
--Turns a 1 or 0 into a true or false. This
--function mostly exists to aid readability of
--the program rather than to be useful.
    if(state[1]) then
        return true
    else
        return false
    end
end

function mine()
--This function lowers the drill, then waits
--for the sensor on the drill to start sending
--a signal again, which will only happen when
--it is no longer an entity. Which means it hit
--bedrock and turned back into blocks. It then
--raises the drill until it hits the top and turns
--into blocks again.
    print("Drilling...")
    redstone.setOutput("bottom", true)
    redstone.setOutput("left", true)
    redstone.setOutput("right", true)
    redstone.setOutput("top", true)
    redstone.setOutput("bottom", false)
    --Changes to gantry mode, powers the
    --north-south gantry, powers the
    --east-west gantry, powers the gearshift,
    --changes to drill mode
    
    sleep(5)
    --Makes sure we have enough time for our drill
    --to start drilling before we check if it is
    --done drilling.
    
    getState()
    --Checks if the drill is solid. Shouldn't be
    --if it's drilling (so it'll return a 0)
    
    while(true) do
        sleep(.5)
        getState()
        if(state[1] == 1) then
            break
        end
        --This loop waits until the drill is done,
        --then breaks to start raising the drill.
    end
    redstone.setOutput("top", false)
    print("Raising drill...")
    --Raising drill... stays in drill mode, just
    --stops powering the gearshift, changing the
    --direction of rotation.
    
    while(true) do
        sleep(.3)
        getState()
        if(state[1] == 1) then
            break
        end
        --Waits until the drill has been fully
        --raised.
    end
    redstone.setOutput("bottom", true)
    sleep(2)
    --Changes into gantry mode, and waits to allow
    --the piston to push the sequenced gearshift
    --where the shaft was previously. Sleeping
    --more than long enough to change from drill
    --to gantry mode. (Sequenced gearshift instead
    --of shaft)
    
end
--end of mine() function

function moveForward(steps)
--Moves in the East-West direction towards unmined
--blocks.
    print("Moving forward...")
    redstone.setOutput("right", false)
    redstone.setOutput("top", west)
    --Unpowers the second gantry, and either does
    --or doesn't power the gearshift depending on
    --the direction the quarry moves in.
    
    for i = 1, steps, 1 do
        redstone.setOutput("back", true)
        sleep(.5)
        redstone.setOutput("back", false)
        sleep(.5)
        --Powers sequenced gearshift as much as we
        --need to to mine most efficiently. Mimics
        --a button press. Could probably be made
        --faster.
    end
    redstone.setOutput("right", true)
    --Powers the second gantry (e-w).
end
--end of moveForward() function

function allBack()
--Called when hitting the end of your east-west
--quarry space. Goes back to the beginning of the
--line.
    print("Taking it back now yall!")
    redstone.setOutput("right", false)
    redstone.setOutput("top", not west)
    redstone.setOutput("bottom", false)
    --unpowers second gantry (e-w), either powers
    --or doesn't power the gearshift to move back
    --to the start of the line, changes to drill
    --mode.
    
    sleep(2)
    --waits to allow enough time for the sequenced
    --gearshift to be exchanged with the shaft.
    
    while(true) do
        sleep(.5)
        getState()
        if(state[1] == 1) then
            break
        end
        --Waits until our drill is solid again,
        --meaning we have hit the beginning of the
        --line.
    end
    redstone.setOutput("bottom", true)
    sleep(2)
    redstone.setOutput("right", true)
    --changes to gantry mode, powers e-w gantry
    
end
--end of allBack() function

function moveSide(steps)
    
    if(south) then
        print("Slide to the right!")
    else
        print("Slide to the left!")
    end
    
--Moves North or South, whichever it is built to
--go.
    redstone.setOutput("right", false)
    redstone.setOutput("left", false)
    redstone.setOutput("top", not south)
    --unpowers both first (n-s) and second (e-w)
    --gantrys, then either powers or doesn't power
    --the gearshift to allow for movement in the
    --correct direction.
    
    for i = 1, steps, 1 do
        redstone.setOutput("back", true)
        sleep(.5)
        redstone.setOutput("back", false)
        sleep(.5)
        --Moves either North or South as many steps
        --as is necessary to mine new blocks
        --without mining air or leaving unmined
        --blocks
    end
    redstone.setOutput("left", true)
    redstone.setOutput("right", true)
    --Powers both gantrys. Gantries? Gantrys?
end

function toOrigin()
--Called when finished mining. Moves the drill
--back to the beginning/closest corner.
    allBack()
    --See above
    redstone.setOutput("right", false)
    redstone.setOutput("left", false)
    redstone.setOutput("top", south)
    redstone.setOutput("bottom", false)
    --unpowers both gantrys, sets gearshift into
    --backwards mode, and turns into drill mode
    --(which simply allows for the drill to move
    --back to the origin without telling it to
    --move for every individual block.
    
    sleep(2)
    --Allows drill to change into drill mode
    
    while(true) do
        sleep(.5)
        getState()
        if(state[1] == 1) then
            break
        end
        --Waits until the drill is solid again
    end
    redstone.setOutput("bottom", true)
    --Turns into gantry mode. Means the gantrys
    --won't continue spinning after finishing.
    --Which I think looks nicer. It's just looks.
end

function getState()
    s, state, p = rednet.receive("quarry")
    return state
    --Receives the state variable from our sensor
    --computer. This array stores information on
    --whether or not our drill is currently solid,
    --whether or not we have hit the end of our
    --second gantry's length, and whether or not
    --we have hit the end of the mineable area.
    --I just ignore the s and p variables, which
    --should tell us the id of the computer who
    --sent the message, and the protocol used.
    --Which in this case is "quarry". The return
    --state part just shows which variable is
    --actually going to be used. Just readability. 
end

main()
--Actually runs the code. Prevents the issue of
--not having defined our functions by the time we
--call them.
