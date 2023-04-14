local Class = require 'lib.Class';
local Button = Class({});

function Button:init(text,x,y,w,h,execute)
    self.text = text;
    self.x = x;
    self.y = y;
    self.w = w;
    self.h = h;
    self.execute = execute;
end

function Button:execute(...)
    if self.execute then self.execute(...) end
end

function Button:update(dt,offset_x,offset_y)
    offset_x = offset_x or 0;
    offset_y = offset_y or 0;
    -- return INPUT_MANAGER.mouseRectCollision(offset_x + self.x,offset_y + self.y,self.w,self.h);
end

function Button:draw(hovering,offset_x,offset_y)
    offset_x = offset_x or 0;
    offset_y = offset_y or 0;
    if hovering then
        love.graphics.setColor(LIFE_CELL_COLOR);
    else
        love.graphics.setColor(BACKGROUND_REMAINING_MOVES_COLOR);
    end
    love.graphics.rectangle(
        'fill',
        offset_x + self.x,
        offset_y + self.y,
        self.w,
        self.h
    );
    love.graphics.setColor(1,1,1,1);
end

function Button:isHovering(x,y)
    return not (
        x < self.x or x > self.x + self.w or y < self.y or y > self.y + self.h
    );
end

function Button:print(hovering,offset_x,offset_y)
    offset_x = offset_x or 0;
    offset_y = offset_y or 0;
    if hovering then
        love.graphics.setColor(LIVE_CELL_COLOR);
    else
        love.graphics.setColor(UI_TEXT_COLOR);
    end
    FONT_MANAGER.setFont(1,FONT_SIZES.medium);
    SCALE_MANAGER.printf(
        self.text,
        offset_x + self.x,
        offset_y + self.y + (self.h - FONT_SIZES.medium) / 2,
        self.w,
        'center'
    );
end

return Button;