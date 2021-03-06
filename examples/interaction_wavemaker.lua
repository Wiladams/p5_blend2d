

local stats = require("P5status")()

local t = 0; -- time variable

function setup()
  noStroke();
  fill(40, 200, 40);
end

function draw() 
  background(10, 10); -- translucent background (creates trails)

  --background(10);
  
  --print(mouseX, mouseY)

  -- make a x and y grid of ellipses
  fill(40, 200, 40);
  for x = 0, width, 30 do
    for y = 0, height, 30 do
      -- starting point of each circle depends on mouse position
      local xAngle = map(mouseX, 0, width, -4 * PI, 4 * PI, true);
      local yAngle = map(mouseY, 0, height, -4 * PI, 4 * PI, true);
      -- and also varies based on the particle's location
      local angle = xAngle * (x / width) + yAngle * (y / height);

      -- each particle moves in a circle
      local myX = x + 20 * cos(2 * PI * t + angle);
      local myY = y + 20 * sin(2 * PI * t + angle);

      ellipse(myX, myY, 10); -- draw particle
    end
  end

  t = t + 0.01; -- update time

  stats:draw();

end

go {width = 600, height == 600, frameRate=30}