
local values = {};
local i = 1;
local j = 1;

local width = 720
local height = 400

-- The statements in the setup() function
-- execute once when the program begins
-- The array is filled with random values in setup() function.
function setup()
  --createCanvas(720, 400);
  for idx = 1,(width/8) do
    table.insert(values,random(height));
  end
end



-- The bubbleSort() function sorts taking 8 elements of the array
-- per frame. The algorithm behind this function is bubble sort.
local function bubbleSort(chunkSize)
    chunkSize = chunkSize or 8
    -- sort 8 elements at a time
    for k = 1,chunkSize do
        --print("k: ", k)
        if(i < #values-1) then
            local temp = values[j];
            if (values[j] > values[j+1]) then
                values[j] = values[j+1];
                values[j+1] = temp;
            end
            j = j + 1;
      
            if (j >= #values) then
                j = 1;
                i = i + 1;
            end
        else
            noLoop();
        end
    end
end

-- The simulateSorting() function helps in animating
-- the whole bubble sort algorithm
-- by drawing the rectangles using values
-- in the array as the length of the rectangle.
function simulateSorting()
    stroke(100, 143, 143);
    fill(50);

    for idx = 1,#values do
        --rect(i*8 , height, 8, values[i],20);
        rect((idx-1)*8 , height, 8, -values[idx]);
    end
end

-- The statements in draw() function are executed until the
-- program is stopped. Each statement is executed in
-- sequence and after the last line is read, the first
-- line is executed again.
function draw()
    background(220);
    bubbleSort(16);
    simulateSorting();
end


go({width = 720, height = 400})