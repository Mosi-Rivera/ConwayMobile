local Class = require 'lib.Class';
local ActionSelect = Class{};

function ActionSelect:init()

end

function ActionSelect:update(dt,game_scene)
    if game_scene:getInputBuffer() == TOUCH_MANAGER.events.left then
        game_scene:consumeInputBuffer();
        game_scene.state_manager:setState(2,game_scene,-1,0);
    elseif game_scene:getInputBuffer() == TOUCH_MANAGER.events.right then
        game_scene:consumeInputBuffer();
        game_scene.state_manager:setState(2,game_scene,1,0);
    elseif game_scene:getInputBuffer() == TOUCH_MANAGER.events.up then
        game_scene:consumeInputBuffer();
        game_scene.state_manager:setState(2,game_scene,0,-1);
    elseif game_scene:getInputBuffer() == TOUCH_MANAGER.events.down then
        game_scene:consumeInputBuffer();
        game_scene.state_manager:setState(2,game_scene,0,1);
    end
end

function ActionSelect:draw(game_scene)
    SCALE_MANAGER.start();
    game_scene:drawGrid();
    SCALE_MANAGER.finish();
    game_scene:printInfoBar();
    game_scene:printGrid();
end

function ActionSelect:enter(game_scene)
    game_scene.grid:preupdate();
end

function ActionSelect:exit()

end

return ActionSelect;