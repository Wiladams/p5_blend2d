local NUMSINES = 20; -- how many of these things can we do at once?
local sines = new Array(NUMSINES); -- an array to hold all the current angles
local rad; -- an initial radius value for the central sine
local i; -- a counter variable
    
-- play with these to get a sense of what's going on:
local fund = 0.005; -- the speed of the central sine
local ratio = 1; -- what multiplier for speed is each additional sine?
local alpha = 50; -- how opaque is the tracing system
    
local trace = false; -- are we tracing?
    
function setup() 
      --createCanvas(710, 400);
    
      rad = height / 4; -- compute radius for central circle
      background(204); -- clear the screen
    
      for (local i = 0; i<sines.length; i++) {
        sines[i] = PI; -- start EVERYBODY facing NORTH
      }
end
    
function draw()
      if (not trace)  then
        background(204); -- clear screen if showing geometry
        stroke(0, 255); -- black pen
        noFill(); -- don't fill
      end
    
      -- MAIN ACTION
      push(); -- start a transformation matrix
      translate(width / 2, height / 2); -- move to middle of screen
    
      for (local i = 0; i < sines.length; i++) {
        local erad = 0; -- radius for small "point" within circle... this is the 'pen' when tracing
        -- setup for tracing
        if (trace) {
          stroke(0, 0, 255 * (float(i) / sines.length), alpha); -- blue
          fill(0, 0, 255, alpha / 2); -- also, um, blue
          erad = 5.0 * (1.0 - float(i) / sines.length); -- pen width will be related to which sine
        }
        local radius = rad / (i + 1); -- radius for circle itself
        rotate(sines[i]); -- rotate circle
        if (!trace) ellipse(0, 0, radius * 2, radius * 2); -- if we're simulating, draw the sine
        push(); -- go up one level
        translate(0, radius); -- move to sine edge
        if (!trace) ellipse(0, 0, 5, 5); -- draw a little circle
        if (trace) ellipse(0, 0, erad, erad); -- draw with erad if tracing
        pop(); -- go down one level
        translate(0, radius); -- move into position for next sine
        sines[i] = (sines[i] + (fund + (fund * i * ratio))) % TWO_PI; -- update angle based on fundamental
      }
    
      pop(); -- pop down final transformation
end
    
function keyReleased()
    if (key == ' ') then
        trace = not trace;
        background(255);
    end
end