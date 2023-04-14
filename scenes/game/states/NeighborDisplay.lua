local Class = require 'lib.Class';
local NeighborDisplay = Class{};
local time_to_next = 0.4;
local fade_time = 0.8;

local function getNeighborPositionsFunc(result)
    result = type(result) == "table" and result or {};
    return function(done)
        if done then
            return result 
        else
            return function(x,y,state,_,life_cell)
                if state then
                    table.insert(result,{
                        x,
                        y,
                        #result + 1,
                        life_cell
                    });
                end
            end
        end     
    end
end

function NeighborDisplay:update(dt,game_scene)
    self.timer = self.timer + dt;
    if self.timer > time_to_next then
        self.timer = 0;
        self.neighbor_index = self.neighbor_index + 1;
        if self.neighbor_index > #self.neighbors then
            return game_scene.state_manager:setState(4,game_scene);
        end
    end
end

function NeighborDisplay:draw(game_scene)
    SCALE_MANAGER.start();
    game_scene:drawGrid();
    SCALE_MANAGER.finish();
    game_scene:printInfoBar();
    game_scene:printGrid();
end

function NeighborDisplay:enter(game_scene)
    local func = getNeighborPositionsFunc();
    getNeighborPositionsFunc(
        game_scene.grid:forEachCellNeighbor(
            game_scene.active_cell[1],
            game_scene.active_cell[2],
            func()
        )
    );
    self.neighbors = func(true);
    if #self.neighbors <= 0 then
        self.neighbors = {{
            game_scene.active_cell[1],
            game_scene.active_cell[2],
            0
        }};
    end
    self.neighbor_index = 1;
    self.timer = 0;
end

function NeighborDisplay:exit()

end

return NeighborDisplay;