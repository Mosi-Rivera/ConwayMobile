local sign = require 'lib.math_methods'.sign;
local event_types = {
    left = 'left',
    right = 'right',
    up = 'up',
    down = 'down',
    touch = 'touch'
}
local TouchManager = {events = event_types};
local touch_start_list = {};
local events = {};
local min_touch_move = 30;

function TouchManager.touchstart(x,y,i)
    touch_start_list[i] = {x,y};
end

function TouchManager.touchend(x,y,i)
    x,y = SCALE_MANAGER.screenToWorld(x,y);
    local sx,sy = SCALE_MANAGER.screenToWorld(touch_start_list[i][1],touch_start_list[i][2]);
    local dx,dy = x - sx, y - sy;
    local mx = math.abs(dx) > min_touch_move and sign(dx) or 0;
    local my = math.abs(dy) > min_touch_move and sign(dy) or 0;
    if mx  ~= 0 then
        events[mx > 0 and event_types.right or event_types.left] = true;
    elseif my ~= 0 then
        events[my > 0 and event_types.down or event_types.up] = true;
    else
        events.touch = {x,y};
    end
end

function TouchManager.getTouchEventStatus(event)
    return events[event];
end

function TouchManager.update()
    TouchManager.dumpEvents();
end

function TouchManager.dumpEvents()
    events = {};
end

return TouchManager;