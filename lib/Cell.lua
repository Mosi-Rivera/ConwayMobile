local Class = require 'lib.Class';
local Cell = Class{};
local neighbor_directions = {
    {1,1},
    {-1,1},
    {-1,-1},
    {1,-1},
    {1,0},
    {0,1},
    {-1,0},
    {0,-1}
};

function Cell:init(x,y,b)
    self.count = 0;
    self.x = x;
    self.y = y;
    self.state = b or false;
    self.last_state = false;
    self.next_state = nil;
    self.neighbors = {};
end

function Cell:prepare(x,y,grid)
    for i = 1, #neighbor_directions do
        local dirs = neighbor_directions[i];
        local row = grid[y + dirs[2]];
        if row then
            table.insert(self.neighbors,row[x + dirs[1]]);
        end
    end
end

function Cell:preUpdate()
    self.count = 0;
    local neighbors = self.neighbors;
    for i = 1, #neighbors do
        if neighbors[i].state then
            self.count = self.count + 1;
        end
    end
    self.next_state = self.state and not (
        self.count < MIN_POPULATION or self.count > MAX_POPULATION
    ) or not (
        self.count < MIN_REPRODUCTION or self.count > MAX_REPRODUCTION
    );
end

function Cell:update()
    self.last_state = self.state;
    self.state = self.next_state;
    self.next_state = nil;
end

return Cell;