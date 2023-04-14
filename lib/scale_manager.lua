local scale_manager = {};
local world_width;
local world_height;
local scale_x;
local scale_y;
local offset_x;
local offset_y;
local fullscreen = false;
local resizable = false;
local width;
local height;

function scale_manager.init()
    width = SCREEN_WIDTH;
    height = SCREEN_HEIGHT;
    fullscreen = FULLSCREEN;
    resizable = RESIZABLE;
    scale_manager.updateMode(fullscreen,resizable);
    scale_manager.resize(width,height);
end

function scale_manager.updateMode(_fullscreen,_resizable)
    fullscreen = _fullscreen;
    resizable = _resizable;
    love.window.updateMode(
        width,
        height,
        {
            fullscreen = fullscreen,
            resizable = resizable
        }
    );
end

function scale_manager.resize(w,h)
    if MOBILE then
        VIRTUAL_HEIGHT = VIRTUAL_WIDTH * h / w;
    end
    world_width = VIRTUAL_WIDTH;
    world_height = VIRTUAL_HEIGHT;
    width = SCREEN_WIDTH;
    height = SCREEN_HEIGHT;
    scale_x, scale_y = w / world_width, h / world_height;
    local scale = math.min(scale_x,scale_y);
    offset_x = math.floor((scale_x - scale) * (world_width / 2));
    offset_y = math.floor((scale_y - scale) * (world_height / 2));
    scale_x, scale_y = scale, scale;
    if MOBILE then
        SCENE_MANAGER.active:resize(); 
    end
end

function scale_manager.worldToScreenX(x)
    return x * scale_x;
end

function scale_manager.worldToScreenY(y)
    return y * scale_x;
end

function scale_manager.worldToScreen(x,y)
    return scale_manager.worldToScreenX(x), scale_manager.worldToScreenY(y);
end

function scale_manager.screenToWorldX(x)
    return (x - offset_x) / scale_x;
end

function scale_manager.screenToWorldY(y)
    return (y - offset_y) / scale_y;
end

function scale_manager.screenToWorld(x,y)
    return scale_manager.screenToWorldX(x),scale_manager.screenToWorldY(y);
end

function scale_manager.printf(text,x,y,w,pos)
    x,y = scale_manager.worldToScreen(x,y);
    w = scale_manager.worldToScreenX(w);
    love.graphics.printf(text,x,y,w,pos);
end

function scale_manager.drawStartPrep()
    love.graphics.translate(offset_x, offset_y);
    love.graphics.setScissor(
        offset_x,
        offset_y,
        world_width * scale_x,
        world_height * scale_y
    );
    love.graphics.setColor(0.5, 0.5, 0.5, 1);
    -- love.graphics.rectangle('fill',0,0,world_width * scale_x,world_height * scale_y);
    love.graphics.setColor(1, 1, 1, 1);
end

function scale_manager.start()
    love.graphics.push();
    love.graphics.scale(scale_x,scale_y);
end

function scale_manager.finish()
    love.graphics.pop();
end

function scale_manager.drawFinishPrep()
    love.graphics.setBackgroundColor(0, 0, 0, 1);
    love.graphics.setScissor();
end

return scale_manager;