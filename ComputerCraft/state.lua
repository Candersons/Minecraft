--pastebin JPALWacQ

rednet.open("right")
--Makes sure we are ready to start sending data.
--Data's not useful when it's not being sent.
--Though I don't think we have to open our modem
--to send information. I might try to make this
--computer turn off after the quarry is finished,
--though. And we do need to be open to receive.

rednet.broadcast("1", "start")
--Tells the quarry controlling machine to start.
--Which allows for the computers to sync up. Kind
--of. I don't think it would be too big of an
--issue if they weren't. But it's cooler this way.

local state ={0,0,0}
--The important variable, being declard.

id = 1 --rednet.lookup("quarry", "controller")
--This saves which computer we should be sending
--our info to.

while(true)
--Send this information forever. No breaks. May
--try to add one in the future. Currently just
--have to hold ctrl+t or turn off the computer
--to stop this program.
do
    if(redstone.getAnalogInput("back") == 15)
    then
        state[3] = 1
    else
        state[3] = 0
        --This checks if we have hit the end of
        --our quarrying carreers. Currently the
        --end of line and end of quarrying
        --sensors share a redstone signal, so we
        --need to read the redstone strength
        --to decipher it. We could also add the
        --third, and last, sensor data to the same
        --line. Essentially this quarry could run
        --off of one computer, with five sides
        --for output and one side for input. But
        --I wanted to learn how to make computers
        --talk to each other in a useful way.
    end
    if(redstone.getInput("back"))
    then 
        state[2] = 1
    else
        state[2] = 0
        --This checks to see if we have hit the
        --end of our e-w movement.
    end
    if(redstone.getInput("front"))
    then
        state[1] = 1
    else
        state[1] = 0
    --This checks if the drill is solid.
    end
    rednet.send(id, state, "quarry")
    -- print(state[1],state[2],state[3])
    sleep(.3)
    --We then send the mining computer our data,
    --and wait to not cause an infinite loop that
    --runs as fast as possible. Which would be
    --bad. Also have some debugging code commented
    --out.
end