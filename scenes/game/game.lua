local Class = require 'lib.Class';
local Grid = require 'lib.Grid';
local math_methods = require 'lib.math_methods';
local GameOver     = require 'scenes.game.states.GameOver'
local Win          = require 'scenes.game.states.Win'
local approach = math_methods.approach;
local FadingTextManager = require 'lib.FadingTextManager'
local level_generator   = require 'lib.level_generator'
local Game = Class{};
local StateManager = require 'lib.StateManager';
local ActionSelectState = require 'scenes.game.states.ActionSelect';
local MoveState = require 'scenes.game.states.Move';
local UpdateState = require 'scenes.game.states.Update';
local NeighborDisplay = require 'scenes.game.states.NeighborDisplay';
local cell_size = 0;
local font_size = 0;

function Game:init()
	local level = level_generator(SAVE_INTERFACE.getProgressData().level);
	local data = level.data;
	self.seed = level.seed;
	self.actions = level.actions;
	self.max_actions = level.actions;
	self.fading_text_manager = FadingTextManager();
	self.grid = Grid(level.width,level.height);
	self.width,self.height = self.grid:getDimensions();
	self:setCellSize(self.width,self.height);
	self.active_cell = nil;
	self.skip_count = 3;
	self.input_buffer = nil;
	self.input_buffer_timer = 0;
	self:populateGrid(data);
	self.state_manager = StateManager({
		ActionSelectState,
		MoveState,
		NeighborDisplay,
		UpdateState,
		Win,
		GameOver
	},1,self);
end

function Game:resize()
	self:setCellSize(self.width,self.height);
end

function Game:getInputBuffer()
	return self.input_buffer_timer > 0 and self.input_buffer or false;
end

function Game:handleInputBuffer(dt)
	local flag = false;
	self.input_buffer_timer = math.max(0,self.input_buffer_timer - dt);
	if TOUCH_MANAGER.getTouchEventStatus(TOUCH_MANAGER.events.left) then
		self.input_buffer = TOUCH_MANAGER.events.left;
		flag = true;
    elseif TOUCH_MANAGER.getTouchEventStatus(TOUCH_MANAGER.events.right) then
        self.input_buffer = TOUCH_MANAGER.events.right;
		flag = true;
    elseif TOUCH_MANAGER.getTouchEventStatus(TOUCH_MANAGER.events.up) then
		self.input_buffer = TOUCH_MANAGER.events.up;
		flag = true;
    elseif TOUCH_MANAGER.getTouchEventStatus(TOUCH_MANAGER.events.down) then
        self.input_buffer = TOUCH_MANAGER.events.down;
		flag = true;
    end
	if flag then
		self.input_buffer_timer = 0.5;
	end
end

function Game:consumeInputBuffer()
	self.input_buffer = nil;
	self.input_buffer_timer = 0;
end

function Game:populateGrid(data)
	for y = 1, self.height do
		for x = 1, self.width do
			local state = data[(y - 1) * self.width + x];
			if state ~= 0 then
				if state == 1 or state == 2 then
					self.grid:setCellState(x,y,true);
					if state == 2 then
						self.active_cell = {x,y};
					end
				elseif state == 3 then
					self.destination_cell = {x,y};
				end
			end
		end
	end
end

function Game:consumeAction()
	self.actions = self.actions - 1;
end

function Game:getRemainingActions()
	return self.actions;
end

function Game:dumpActions()
	self.actions = 0;
end

function Game:refillActions()
	self.actions = self.max_actions;
end

function Game:addFadingText(...)
	self.fading_text_manager:addFadingText(...);
end

function Game:getGridStartCoords()
	return self.grid_start_x, self.grid_start_y;
end

function Game:canSkip()
	return self.skip_count > 0;
end

function Game:consumeSkip()
	self.skip_count = math.max(self.skip_count - 1,0);
end

function Game:setCellSize(w,h)
	if w / VIRTUAL_WIDTH > h / (VIRTUAL_HEIGHT - BAR_HEIGHT) then
		cell_size = (VIRTUAL_WIDTH - PADDING * 2 - MARGIN * w) / w;
	else
		cell_size = (VIRTUAL_HEIGHT - BAR_HEIGHT - PADDING * 2 - MARGIN * h) / h;
	end
	font_size = math.floor(cell_size / 2);
	FONT_MANAGER.addFontSize(1,font_size);
	self.grid_start_x = (VIRTUAL_WIDTH - self.width * MARGIN - (self.width - 1) * cell_size - PADDING * 2) / 2;
	self.grid_start_y = BAR_HEIGHT + (VIRTUAL_HEIGHT - BAR_HEIGHT - (self.height - 1) * MARGIN - self.height * cell_size - PADDING * 2) / 2;
end

function Game:enter()
	
end

function Game:exit()
	for _,v in pairs(FONT_SIZES) do
		if v == cell_size then
			return;
		end
	end
	FONT_MANAGER.removeFontSize(1,cell_size);
end

function Game:checkWin()
	local x,y = self:getActiveCell();
	if x == self.destination_cell[1] and y == self.destination_cell[2] then
		self:handleWin();
		return true;
	end
	return false;
end

function Game:handleWin()
	self.state_manager:setState(5,self);
end

function Game:checkGameOver()
	local x,y = self.active_cell[1],self.active_cell[2];
	if not self.grid:getCellState(x,y) then
		print('Game Over: you lose.')
		self:setActiveCellState(false);
		self:handleGameOver();
		return true;
	end
end

function Game:handleGameOver()
	self.state_manager:setState(6,self);
end

function Game:update(dt)
	self:handleInputBuffer(dt);
	self.fading_text_manager:update(dt);
	self.state_manager:update(dt,self);
end

function Game:getActiveCell()
	local x,y = self.active_cell[1],self.active_cell[2];
	return x,y,self.grid:getCellState(x,y);
end

function Game:setActiveCell(x,y)
	self.active_cell = {x,y};
end

function Game:setActiveCellState(state)
	self.grid:setCellState(self.active_cell[1],self.active_cell[2],state);
end

function Game:getCellSize()
	return cell_size;
end

function Game:getFontSize()
	return font_size;
end

function Game:drawMethod()
	local offset_x,offset_y = self:getGridStartCoords();
	return function(x,y,state,_,_,_,color)
		if state then
			love.graphics.setColor(
				color and color or LIVE_CELL_COLOR
			);
			love.graphics.rectangle(
				'fill',
				offset_x + (x - 1) * MARGIN + (x - 1) * cell_size,
				offset_y + (y - 1) * MARGIN + (y - 1) * cell_size,
				cell_size,
				cell_size
			);
		end 
	end
end

function Game:printMethod()
	local offset_x,offset_y = self:getGridStartCoords();
	return function(x,y,state,_,next_state,count,color)
		if count == 0 or next_state == state then return end
		love.graphics.setColor(
			color and color or (
				state and (
					not next_state and DEATH_CELL_COLOR or BACKGROUND_REMAINING_MOVES_COLOR
				) or (
					(count >= MIN_REPRODUCTION and count <= MAX_REPRODUCTION) and LIFE_CELL_COLOR or LIVE_CELL_COLOR
				)
			)
		);
		SCALE_MANAGER.printf(
			count,
			offset_x + (x - 1) * MARGIN + (x - 1) * cell_size,
			offset_y + (y - 1) * MARGIN + (y - 1) * cell_size + (cell_size - font_size) / 2,
			cell_size,
			'center'
		);
	end
end

function Game:drawCells(dm)
	dm = dm or self:drawMethod();
	love.graphics.setColor(LIVE_CELL_COLOR);
	self.grid:forEach(dm);
	return dm;
end

function Game:printCells(pm)
	pm = pm or self:printMethod();
	FONT_MANAGER.setFont(1,font_size);
	self.grid:forEach(pm);
	return pm;
end

function Game:drawActiveCell(x,y)
	love.graphics.setLineWidth(LINE_WIDTH);
	love.graphics.setColor(ACTIVE_CELL_COLOR);
	x,y = x or self.active_cell[1],y or self.active_cell[2];
	love.graphics.rectangle(
		'line',
		LINE_WIDTH / 2 + self.grid_start_x + (x - 1) * MARGIN + (x - 1) * cell_size,
		LINE_WIDTH / 2 + self.grid_start_y + (y - 1) * MARGIN + (y - 1) * cell_size,
		cell_size - LINE_WIDTH,
		cell_size - LINE_WIDTH
	);
end

function Game:printInfoBar()
	FONT_MANAGER.setFont(FONT_NAMES.BAZAR,FONT_SIZES.medium);
	love.graphics.setColor(UI_TEXT_COLOR);
	SCALE_MANAGER.printf(
		'ACTIONS: '.. self.actions,
		PADDING,
		BAR_HEIGHT / 2 - FONT_SIZES.medium / 2,
		200,
		'left'
	);
	SCALE_MANAGER.printf(
		'LEVEL: ' .. self.seed,
		VIRTUAL_WIDTH - 200 - PADDING,
		BAR_HEIGHT / 2 - FONT_SIZES.medium / 2,
		200,
		'right'
	);
end

function Game:drawDestinationCell()
	local x,y = self.destination_cell[1], self.destination_cell[2];
	love.graphics.setLineWidth(LINE_WIDTH);
	love.graphics.setColor(DESTINATION_CELL_COLOR);
	love.graphics.rectangle(
		'line',
		self.grid_start_x + (x - 1) * MARGIN + (x - 1) * cell_size + LINE_WIDTH / 2,
		self.grid_start_y + (y - 1) * MARGIN + (y - 1) * cell_size + LINE_WIDTH / 2,
		cell_size - LINE_WIDTH,
		cell_size - LINE_WIDTH
	);
end

function Game:drawGrid()
	local dm = self:drawMethod();
	self:drawCells(dm);
	self:drawActiveCell();
	self:drawDestinationCell();
end

function Game:printGrid()
	self:printCells()(
		self.active_cell[1],
		self.active_cell[2],
		true,
		nil,
		nil,
		0,
		LIVE_CELL_COLOR
	);
	
end

function Game:draw()
	self.state_manager:draw(self);
	FONT_MANAGER.setFont(1,font_size);
	self.fading_text_manager:print();
end

return Game;
