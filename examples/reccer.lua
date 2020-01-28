local values = {};

local width = 720
local height = 400

function setup()
    -- get a random set of values
    for i = 1,(width/8) do
        table.insert(values,random(height));
    end

    noLoop();
end



function draw()
    background(220);
    stroke(100, 143, 143);
    fill(50);
    
    for i = 1,#values do
        --rect(10,10, 40, 60)
        rect(i*8 , height, 8, -values[i])
    end
end

go {width = 640, height=480}