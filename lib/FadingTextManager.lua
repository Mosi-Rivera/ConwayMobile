local Class = require 'lib.Class';
local FadingText = require 'lib.FadingText';
local FadingTextManager = Class{
    text_group = {}
};

function FadingTextManager:update(dt)
    local text_group = self.text_group;
    for i = #text_group, 1, -1 do
        if text_group[i]:update(dt) then
            table.remove(text_group,i);
        end
    end
end

function FadingTextManager:print()
    local text_group = self.text_group;
    for i = 1, #text_group do
        text_group[i]:print();
    end
    love.graphics.setColor(1,1,1,1);
end

function FadingTextManager:addFadingText(...)   
    table.insert(self.text_group,FadingText(...));
end

return FadingTextManager;