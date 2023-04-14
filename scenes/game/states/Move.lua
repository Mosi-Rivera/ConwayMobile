local math_methods = require 'lib.math_methods';
local easeOut = math_methods.easeOut;
local lerp = math_methods.lerp;
local Class = require 'lib.Class';
local Move = Class{};
local C_TRANSITION_TIME = 0.2;

local function updateStage2(self,dt,game_scene)
    self.timer = self.timer + dt;
    if self.timer >= C_TRANSITION_TIME then
        if game_scene:checkWin() then return end
        game_scene.grid:preupdate();
        if game_scene:getRemainingActions() > 0 then
            game_scene.state_manager:setState(1,game_scene);
        else
            game_scene.state_manager:setState(3,game_scene);
        end
    end
end


local function drawStage2(self,game_scene)
    SCALE_MANAGER.start();
    game_scene:drawGrid();
    SCALE_MANAGER.finish();
    game_scene:printInfoBar();
    game_scene:printGrid();
end

local function updateStage1(self,dt,game_scene)
    self.timer = self.timer + dt;
    if self.timer >= C_TRANSITION_TIME then
        game_scene:setActiveCellState(true);
        self.update = updateStage2;
        self.draw = drawStage2;
        self.timer = 0;
    end
end

local function drawStage1(self,game_scene)
    SCALE_MANAGER.start();
	game_scene:drawCells();
	local t = self.timer / C_TRANSITION_TIME;
    local x = lerp(self.from[1],self.to[1],easeOut(t,2));
    local y = lerp(self.from[2],self.to[2],easeOut(t,2));
    game_scene:drawMethod()(
        x,
        y,
        true,
        nil,
        nil,
        0,
        LIVE_CELL_COLOR
    );
    game_scene:drawActiveCell(x,y);
	love.graphics.setColor(1,1,1,1);
    SCALE_MANAGER.finish();
    game_scene:printInfoBar();
    game_scene:printGrid();
end

function Move:init(game_scene,x,y)
    self.timer = 0;
    self.update = updateStage1;
    self.draw = drawStage1;
end

function Move:enter(game_scene,x,y)
    local fx,fy = game_scene.active_cell[1],game_scene.active_cell[2];
    local tx,ty = fx + x,fy + y;
    local width,height = game_scene.grid:getDimensions();
    if tx < 1 or tx > width or ty < 1 or ty > height then 
        return game_scene.state_manager:setState(1,game_scene);
    end
    game_scene:consumeAction();
    self.from = {fx,fy};
    self.to = {tx,ty};
    game_scene:setActiveCellState(false);
    game_scene:setActiveCell(self.to[1],self.to[2]);
end

function Move:exit()

end

return Move;