local Class = require 'lib.Class';
local ButtonGroup = require 'lib.ButtonGroup';
local Button = require 'lib.Button';
local Home = Class{};

function Home:init()
    self.button_group = ButtonGroup({
        {
            Button(
                'PLAY!',
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
                'RESET',
                0,
                BUTTON_HEIGHT + 5,
                BUTTON_WIDTH,
                BUTTON_HEIGHT,
                function()
                    SAVE_INTERFACE.setProgressField('level',1);
                    SAVE_INTERFACE.saveProgress();
                end
            )
        }
    },
    (VIRTUAL_WIDTH - BUTTON_WIDTH) / 2,
    VIRTUAL_HEIGHT / 2 + FONT_SIZES.xlarge / 2 + 20
);
end

function Home:resize()
    self.button_group.x = (VIRTUAL_WIDTH - BUTTON_WIDTH) / 2;
    self.button_group_y = VIRTUAL_HEIGHT / 2 + FONT_SIZES.xlarge / 2;
end

function Home:update(dt)
    self.button_group:update(dt);
    self.button_group:touchUpdate();
end

function Home:printTitle()
    FONT_MANAGER.setFont(1,FONT_SIZES.large);
    love.graphics.setColor(UI_TEXT_COLOR);
    SCALE_MANAGER.printf(
        TITLE,
        0,
        math.floor((VIRTUAL_HEIGHT - FONT_SIZES.xlarge) / 2 - FONT_SIZES.large * 2 - 30),
        VIRTUAL_WIDTH,
        'center'
    );
end

function Home:printLevel()
    FONT_MANAGER.setFont(1,FONT_SIZES.xlarge);
    love.graphics.setColor(LIFE_CELL_COLOR);
    SCALE_MANAGER.printf(
        SAVE_INTERFACE.getProgressData().level,
        (VIRTUAL_WIDTH - 100) / 2,
        (VIRTUAL_HEIGHT - FONT_SIZES.xlarge) / 2,
        100,
        'center'
    );
end

function Home:draw()
    SCALE_MANAGER.start();
    self.button_group:draw();
    SCALE_MANAGER.finish();
    self:printTitle();
    self.button_group:print();
    self:printLevel();
end

function Home:enter()

end

function Home:exit()

end

return Home;