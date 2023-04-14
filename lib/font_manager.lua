local font_manager = {};
local fonts = {};

function font_manager.init()
    for i = 1, #FONTS do
        local font_data = FONTS[i];
        font_manager.addFontGroup(i,font_data[1]);
        for j = 2, #FONTS[i] do
            font_manager.addFontSize(i,font_data[j]);
        end
    end
end

function font_manager.resize(w,h)
    local groups = fonts;
    for key,group in pairs(groups) do
        for size,_ in pairs(group.fonts) do
            font_manager.addFontSize(key,size);
        end
    end
end

function font_manager.addFontSize(key,size)
    if not fonts[key] then return end
    local group = fonts[key];
    local src = group.src;
    group.fonts[size] = love.graphics.newFont(
        src,
        SCALE_MANAGER.worldToScreenY(
            type(size) == "string" and tonumber(size) or size
        )
    ); 
end

function font_manager.addFontGroup(key,src)
    if fonts[key] == nil then
        fonts[key] = {
            src = src,
            fonts = {}
        };
    end
end

function font_manager.removeFontGroup(key)
    fonts[key] = nil;
end

function font_manager.removeFontSize(key,size)
    if not fonts[key] then return end;
    fonts[key][size] = nil;
end

function font_manager.setFont(key,size)
    love.graphics.setFont(fonts[key].fonts[size]);
end

return font_manager;