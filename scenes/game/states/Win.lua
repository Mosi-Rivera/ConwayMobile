local Class = require 'lib.Class';
local ButtonGroup = require 'lib.ButtonGroup';
local Button = require 'lib.Button';
local approach = require 'lib.math_methods'.approach;
local Win = Class{};

function Win:init(game_scene)
    self.button_group = ButtonGroup({
        {
            Button(
                'NEXT LEVEL',
                0,
                0,
                BUTTON_WIDTH,
                BUTTON_HEIGHT,
                function()
                    SAVE_INTERFACE.setProgressField(
                        'level',
                        SAVE_INTERFACE.getProgressData().level + 1
                    );
                    SAVE_INTERFACE.saveProgress();
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
    },
    (VIRTUAL_WIDTH - BUTTON_WIDTH) / 2,
    VIRTUAL_HEIGHT / 2 + 15
);
end

function Win:update(dt)
    self.button_group:update(dt);
    self.button_group:touchUpdate();
end

function Win:printMessage()
    love.graphics.setColor(UI_TEXT_COLOR);
    FONT_MANAGER.setFont(1,FONT_SIZES.large);
    SCALE_MANAGER.printf(
        "LEVEL CLEARED!",
        (VIRTUAL_WIDTH - 400) / 2,
        VIRTUAL_HEIGHT / 2 - FONT_SIZES.large - FONT_SIZES.medium - 30,
        400,
        'center'
    );
end

function Win:draw(game_scene)
    SCALE_MANAGER.start();
    self.button_group:draw();
    SCALE_MANAGER.finish();
    self.button_group:print();
    self:printMessage();
end

function Win:enter()

end

function Win:exit()

end

return Win;