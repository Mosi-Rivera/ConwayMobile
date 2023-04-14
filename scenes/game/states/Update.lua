local Class = require 'lib.Class';
local math_methods = require 'lib.math_methods';
local easeOut = math_methods.easeOut;
local Update = Class{};
local C_UPDATE_TIME = 0.2;

function Update:init(game_scene)
    self.timer = 0;
    self.game_scene = game_scene;
    self.reproduction_text = {};
end

function Update:update(dt,game_scene)
    self.timer = self.timer + dt;
    local reproduction_text = self.reproduction_text;
    for i = 1, #reproduction_text do
        reproduction_text[i]:update(dt);
    end
    if self.timer >= C_UPDATE_TIME then
        if game_scene:checkWin() then return end
        if game_scene:checkGameOver() then return end;
        game_scene.state_manager:setState(1,game_scene);
    end
end
local function generateDrawMethod(t,cell_size,offset_x,offset_y)
    t = easeOut(t,2);
    return function(x,y,state,last_state,life_cell)
        if state == last_state then
            if state then
                love.graphics.rectangle(
                    'fill',
                    offset_x + (x - 1) * MARGIN + (x - 1) * cell_size,
                    offset_y + (y - 1) * MARGIN + (y - 1) * cell_size,
                    cell_size,
                    cell_size
                ); 
            end
        else
            love.graphics.setColor(
                life_cell and LIFE_CELL_COLOR or LIVE_CELL_COLOR
            )
            local tt = state and t or 1 - t;
            love.graphics.rectangle(
                'fill',
                offset_x + (x - 1) * MARGIN + (x - 1) * cell_size + (cell_size - cell_size * tt) / 2,
                offset_y + (y - 1) * MARGIN + (y - 1) * cell_size + (cell_size - cell_size * tt) / 2,
                cell_size * tt,
                cell_size * tt
            );
        end
    end
end

function Update:draw(game_scene)
    SCALE_MANAGER.start();
    local draw_func = generateDrawMethod(self.timer / C_UPDATE_TIME,game_scene:getCellSize(),game_scene:getGridStartCoords());
    game_scene.grid:forEach(draw_func);
    love.graphics.setColor(ACTIVE_CELL_COLOR);
    draw_func(game_scene:getActiveCell());
    game_scene:drawDestinationCell();
    SCALE_MANAGER.finish();
    game_scene:printInfoBar();
    game_scene:printGrid();
end

function Update:enter(game_scene)
    game_scene:checkWin();
    game_scene.grid:update();
    game_scene.grid:preupdate();
    game_scene:refillActions();
end

function Update:exit()
    
end

return Update;