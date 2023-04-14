local Class = require 'lib.Class';
local ButtonGroup = Class({
    row_index = 1,
    column_index = 1
});

local function scrollDraw(self)
    local row;
    for i = self.scroll_start_index, math.min(#self.buttons,self.scroll_start_index + self.rows - 1) do
        row = self.buttons[i];
        for j = 1, #row do
            row[j]:draw(i == self.row_index and j == self.column_index,self.x,self.scroll_y);
        end
    end
    self.hovering = false;
end

local function normalDraw(self)
    local row;
    for i = 1, #self.buttons do
        row = self.buttons[i];
        for j = 1, #row do
            row[j]:draw(i == self.row_index and j == self.column_index,self.x,self.y);
        end
    end
    self.hovering = false;
end

local function scrollPrint(self)
    local row;
    for i = self.scroll_start_index, math.min(#self.buttons,self.scroll_start_index + self.rows - 1) do
        row = self.buttons[i];
        for j = 1, #row do
            row[j]:print(i == self.row_index and j == self.column_index,self.x,self.scroll_y);
        end
    end
    self.hovering = false;
end

local function normalPrint(self)
    local row;
    for i = 1, #self.buttons do
        row = self.buttons[i];
        for j = 1, #row do
            row[j]:print(i == self.row_index and j == self.column_index,self.x,self.y);
        end
    end
    self.hovering = false;
end

function ButtonGroup:init(buttons,x,y,config)
    config = config or {};
    self.buttons = buttons;
    self.x = x;
    self.y = y;
    self.scroll_start_index = 1;
    self.gap = config.gap;
    self.rows = config.rows;
    self.scroll = config.scroll;
    self.scroll_y = self.y;
    self.hovering = false;
    self.draw = self.scroll and scrollDraw or normalDraw;
    self.print = self.scroll and scrollPrint or normalPrint;
end

function ButtonGroup:moveX(n)
    self.column_index = math.max(
        1,
        math.min(
            #self.buttons[self.row_index],
            self.column_index + n
        )
    );
end

function ButtonGroup:moveY(n)
    self.row_index = math.max(
        1,
        math.min(
            #self.buttons,
            self.row_index + n
        )
    );
    self.column_index = math.min(
        self.column_index,
        #self.buttons[self.row_index]
    );
    if self.scroll then
        self.scroll_start_index = math.max(1,math.min(self.row_index,#self.buttons - (self.rows - 1)));
        self.scroll_y = self.y - self.gap * (self.scroll_start_index - 1);
    end
end

function ButtonGroup:update(dt)
    local buttons = self.buttons;
    local row;
    local _y = self.scroll and self.scroll_y or self.y;
    for y = 1, #buttons do
        row = buttons[y];
        for x = 1, #row do
            if row[x]:update(dt,self.x,_y,x,y) then
                self.row_index = y;
                self.column_index = x;
                self.hovering = true;
            end
        end
    end
end

function ButtonGroup:keyboardUpdate()
    if love.keyboard.isDown('right') then
        self:moveX(1);
    elseif love.keyboard.isDown('left') then
        self:moveX(-1);
    elseif love.keyboard.isDown('up') then
        self:moveY(-1);
    elseif love.keyboard.isDown('down') then
        self:moveY(1);
    elseif love.keyboard.isDown('space') then
        self:executeSelectedButton();
    end
end

function ButtonGroup:touchUpdate()
    local touch = TOUCH_MANAGER.getTouchEventStatus(TOUCH_MANAGER.events.touch);
    if touch then
        local _x,_y = touch[1] - self.x,touch[2] - self.y;
        local buttons = self.buttons;
        local row;
        for y = 1, #buttons do
            row = buttons[y];
            for x = 1, #row do
                if row[x]:isHovering(_x,_y) then
                    row[x]:execute();
                    return;
                end
            end
        end
    end
end

function ButtonGroup:getSelectedButton()
    return self.buttons[self.row_index][self.column_index];
end

function ButtonGroup:executeSelectedButton()
    return self:getSelectedButton():execute();
end

function ButtonGroup:executeHoveringButton()
    if self.hovering then
        self:executeSelectedButton();
    end
end

function ButtonGroup:reset()
    self.row_index = 1;
    self.column_index = 1;
    self.scroll_start_index = 1;
end

return ButtonGroup;