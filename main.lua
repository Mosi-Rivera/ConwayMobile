require 'globals';
local StateManager = require 'lib.StateManager';
local GameScene = require 'scenes.game.game';
local HomeScene = require 'scenes.home.Home';
local key_released = {};
local key_pressed = {};

function love.load()
	-- SAVE_INTERFACE.deleteAll();
	SAVE_INTERFACE.loadAll();
	SCENE_MANAGER = StateManager({
		HomeScene,
		GameScene
	});
	SCALE_MANAGER.init();
	FONT_MANAGER.init();
end

function love.mousepressed(x, y, button, isTouch)
	TOUCH_MANAGER.touchstart(x,y,button);
end

function love.mousereleased(x, y, button, isTouch)
	TOUCH_MANAGER.touchend(x,y,button);
end

function love.resize(w,h)
	SCALE_MANAGER.resize(w,h);
	FONT_MANAGER.resize(w,h);
end

function love.wasKeyPressed(key)
	return key_pressed[key];
end

function love.wasKeyReleased(key)
	return key_released[key];
end

function love.keypressed(key)
	key_pressed[key] = true;
end

function love.keyreleased(key)
	key_released[key] = true;
end

function love.update(dt)
	SCENE_MANAGER:update(dt);
	key_released = {};
	key_pressed = {};
	TOUCH_MANAGER.update();
end

function love.draw()
	SCALE_MANAGER.drawStartPrep();
	SCENE_MANAGER:draw();
	SCALE_MANAGER.drawFinishPrep();
end
