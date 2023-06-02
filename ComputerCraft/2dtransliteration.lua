--[[
This is one of the coolest things I've made. This
one program can be used to simultaneously set up
anchors for a two dimensional transliteration
(aka how gps works, but without up and down/
without y values) and to ask for location.

Three computers must be given ender modems and
told their x and z values. This can be done
in two different ways. Either create a file
called "location.txt" in the home directory,
or pass the computer its location through
the command line, e.g.
"2dtransliteration host 50 26"
with the first value being the x coordinate,
and the second being its z coordinate
(referred to later in this program as y
because y is not the value of depth in math).
This will result in the computer waiting for
a message asking it to send its location and
distance. Upon receiving said message, it will
send a table with an x and y value, as well as
print to its screen that it has received a
message asking for location.

If you do not pass that you want the computer
to act as a host in the command line, it will
instead send a message asking for its location.
It will then wait to receive three different
messages, which states the location of the
computer that sent the message, and saves the
distance associated with that message (which
computercraft itself gives with every wireless
message). It then does some math, and prints
the x and z coords. It calls the z coord y,
because z is typically up/down in math. Not
sure why Minecraft does that differently.
--]]

--Allows us to read our inputs
input = {...}
 
--Computer talking stuff. Important for positioning
modem = peripheral.find("modem")
modem.open(9001)
modem.open(5)
 
--This will store the location of a hosting comp
location = {x = 0, y = 0}
 
--This tells us how many input were passed in
inputs = 0
 
--This is to make things print correctly
cursor = {term.getCursorPos()}
 
--This is to store how many gps requests we've had
requests = 0
 
--This is where the positioning/hosting happens
function main()
--Here we figure out how many things were in input
for k, v in pairs(input) do
  inputs = inputs + 1
end
 
--If we received an input
if inputs ~= 0 then
  --Read through all the inputs we got
  for k, v in pairs(input) do
    --If one of those inputs was "host"
    if input[k] == "host" then
      --check to see if a file stores our location
      if fileExists("/location.txt") then
        local file = io.open("/location.txt", "r")
        --Read files return strings. Here we pass
        --that string into a function that will
        --seperate every word separated by spaces
        --into different elements of a table
        location = {stringToPos(file._handle.readAll())}
        --Here we take those elements of that table
        --and turn it into numbers, stored in
        --the correct way.
        location = {x = tonumber(location[1][1]),y = tonumber(location[1][2])}
        file._handle.close()
      --if not, we need our location inputted
      else
        --To get our input from the command line,
        --read the next two inputs from the line
        --and store them as x and y coordinates.
        --Or complain if we didn't have input.
        if input[k+1] == nil then
          print("X coordinate expected.")
          return
        else if input[k+2] == nil then
          print("Y coordinate expected.")
          return
        end
        end
        --Formatting our input
        location = {x = tonumber(input[k+1]), y = tonumber(input[k+2])}
      end
      while true do
        --I'm not sure if ComputerCraft will time
        --out functions if they don't do stuff, so
        --I made it so hosting computers always do
        --stuff. Iterate through the same loop.
        --Forever.
        --We accomplish that by starting a timer
        os.startTimer(5)
        --And then looking for an event
        local event = {os.pullEvent()}
        --If we got a "wifi" message
        if event[1] == "modem_message" then
          --Check to see if it's asking to locate
          if event[5] == "Locate" then
            --Store that we've served another
            --customer, do some aesthetic stuff
            --for how we print our served customers
            --then transmit our location.
            requests = requests + 1
            term.setCursorPos(1, cursor[2])
            print(requests .. " GPS requests served")
            modem.transmit(event[4], 9001, location)
          end
        end
      end
    end 
  end
end
 
--I am locating via geometric transliteration.
--AKA I make a bunch of circles with a radius
--equal to the distance from the device to locate
--to this computer (and two other computers), do
--some math to find where those circles intersect,
--and that intersection point is where we are.
circle = {}
 
--Here we ask to be found
modem.transmit(9001,5,"Locate")
 
--This assures us we've contacted enough hosts
i = 1
 
--This loop times out if there isn't enough hosts
--providing their location, otherwise storing the
--locations of each host that gets back to us,
--breaking out of the loop once we've had three
--responses
while true do
  os.startTimer(1)
  local event = {os.pullEvent()}
  if event[1] == "modem_message" then
    circle[i] = event
    i = i + 1
  end
  if i == 4 then
    break
  end
  if event[1] == "timer" then
    print("Not enough hosts")
    return
  end
end
 
--Here's all the math. I understand most of it,
--but not enough to explain. Just know it took
--a lot of fiddling in Desmos to get working.
a = circle[1][6]
b = circle[2][6]
c = circle[3][6]
 
A = (-2 * circle[1][1][5].x) + (2 * circle[2][1][5].x)
B = (-2 * circle[1][1][5].y) + (2 * circle[2][1][5].y)
C = (a * a) - (b * b) - (circle[1][1][5].x * circle[1][1][5].x) + (circle[2][1][5].x * circle[2][1][5].x) - (circle[1][1][5].y * circle[1][1][5].y) + (circle[2][1][5].y * circle[2][1][5].y)
D = (-2 * circle[2][1][5].x) + (2 * circle[3][1][5].x)
E = (-2 * circle[2][1][5].y) + (2 * circle[3][1][5].y)
F = (b * b) - (c * c) - (circle[2][1][5].x * circle[2][1][5].x) + (circle[3][1][5].x * circle[3][1][5].x) - (circle[2][1][5].y * circle[2][1][5].y) + (circle[3][1][5].y * circle[3][1][5].y)
 
x = ((C*E) - (F*B)) / ((E*A) - (B*D))
y = ((C*D) - (A*F)) / ((B*D) - (A*E))
 
--And we finally print our location!
print("x = " .. x .. "\ny = " .. y)
 
end
 
--This function tells us if a file exists.
--Somewhat self explanatory.
function fileExists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end
 
--This function takes a file, which will be read as
--one big string, and separates everything split up
--with spaces into elements of a table instead.
function stringToPos(string)
  local splitString = {""}
  local splits = 1
  for i = 1, string.len(string) do
    if string.char(string.byte(string, i)) == " " then
      splits = splits + 1
      splitString[splits] = ""
    else
      splitString[splits] = splitString[splits] .. string.char(string.byte(string, i))
    end
  end
  return splitString
end
 
--Magic can't happen if we don't tell it to
main()
