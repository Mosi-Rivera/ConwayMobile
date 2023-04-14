local options = {
    {0,0,0,0,0},
    {1,1,0,0,0},
    {1,1,1,0,0},
    {0,1,1,0,0},
    {0,1,1,1,0},
    {0,0,1,1,0},
    {0,0,1,1,1},
    {0,0,0,1,1},
    {1,0,0,1,1},
    {1,0,0,0,1},
    {1,1,0,0,1}
}

return function(seed)
    math.randomseed(seed);
    local width = 7 + math.floor((seed / 100) * 15);
    local height = math.floor(width * (1 + math.random(5,15) / 10));
    local data = {};
    local grid_size = width * height;
    for i = 1, grid_size, #options[1] do
        local selected_option =  options[math.random(1,#options)];
        for j = 1, math.min(grid_size - i,#selected_option) do
            table.insert(data,selected_option[j]);
        end
    end
    local sx = math.floor(width / 4 + math.random(1,3) * width / 4);
    local sy = math.floor(height / 4 + math.random(1,3) * height / 4);
    local start = (sy - 1) * width + sx;
    local destination = (height - sy) * width + (height - sx + 1);
    data[start] = 2;
    data[destination] = 3;
    return {
        seed = seed,
        data = data,
        width = width,
        height = height,
        actions = 2 + math.floor(width / 15)
    }
end