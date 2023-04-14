local Class = require 'lib.Class';
local math_methods = require 'lib.math_methods';
local easeIn = math_methods.easeIn;
local easeOut = math_methods.easeOut;
local lerp = math_methods.lerp;
local FadingText = Class{};

function FadingText:init(text,x,y,w,lifetime,ox,oy,pos,color,f_onFinish)
    self.lifetime = lifetime;
    self.fx = x;
    self.fy = y;
    self.tx = self.fx + (ox or 0);
    self.ty = self.fy + (oy or 0);
    self.text = text;
    self.w = w;
    self.pos = pos or 'center';
    self.color = color or {1,1,1,1};
    self.timer = 0;
    self.f_onFinish = f_onFinish;
end

function FadingText:update(dt)
    self.timer = self.timer + dt;
    self.color[4] = 1 - easeIn(self.timer / self.lifetime,4);
    if self.timer >= self.lifetime then
        if self.f_onFinish then self.f_onFinish() end
        return true;
    end
end

function FadingText:print()
    love.graphics.setColor(self.color);
    local t = self.timer / self.lifetime;
    local x,y = lerp(self.fx,self.tx,easeOut(t,3)), lerp(self.fy,self.ty,easeOut(t,3));
    SCALE_MANAGER.printf(
        self.text,
        x,
        y,
        self.w,
        self.pos
    );
end

return FadingText;