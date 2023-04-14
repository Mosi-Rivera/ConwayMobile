local Class = require 'lib.Class';
local ButtonGroup = require 'lib.ButtonGroup';
local Button = require 'lib.Button';
local approach = require 'lib.math_methods'.approach;
local GameOver = Class{};

function GameOver:init(game_scene)
    self.button_group = ButtonGroup({
        {
            Button(
                'TRY AGAIN',
                0,
                0,
                BUTTON_WIDTH,
                BUTTON_HEIGHT,
                function()
                    SCENE_MANAGER:setState(2);
                end
            )
        },
        {
            Button(
                'HOME',
                0,
                BUTTON_HEIGHT + 5,
                BUTTON_WIDTH,
                BUTTON_HEIGHT,
                function()
                    TOUCH_MANAGER.dumpEvents();
                    SCENE_MANAGER:setState(1);
                end
            )
        }
    },(VIRTUAL_WIDTH - BUTTON_WIDTH) / 2,VIRTUAL_HEIGHT / 2 + 15);
end

function GameOver:update(dt)
    self.button_group:update(dt);
    self.button_group:touchUpdate();
end

function GameOver:printMessage()
    love.graphics.setColor(UI_TEXT_COLOR);
    FONT_MANAGER.setFont(1,FONT_SIZES.large);
    SCALE_MANAGER.printf(
        "GAME OVER",
        (VIRTUAL_WIDTH - 400) / 2,
        VIRTUAL_HEIGHT / 2 - FONT_SIZES.large - FONT_SIZES.medium - 30,
        400,
        'center'
    );
end

function GameOver:draw(game_scene)
    SCALE_MANAGER.start();
    self.button_group:draw();
    SCALE_MANAGER.finish();
    self.button_group:print();
    self:printMessage();
end

function GameOver:enter()

end

function GameOver:exit()

end

return GameOver;