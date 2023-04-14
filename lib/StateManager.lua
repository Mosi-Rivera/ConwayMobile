local Class = require 'lib.Class';
local StateManager = Class{};

function StateManager:init(states,default,...)
	default = default or 1;
	self.states = states;
	self.active = nil;
	self:setState(default or 1,...);
end

function StateManager:setState(key,...)
	if self.active then
		self.active:exit();
	end
	self.active = self.states[key](...);
	self.active:enter(...);
end

function StateManager:update(...)
	self.active:update(...);
end

function StateManager:draw(...)
	self.active:draw(...);
end

return StateManager;
