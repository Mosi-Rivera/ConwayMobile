local Class = require 'lib.Class';
local Cell = require 'lib.Cell';
local Grid = Class{};

function Grid:init(width,height)
	height = height or width;
	self.width,self.height = width,height;
	local grid = {};
	for y = 1, height do
		local row = {};
		for x = 1, width do
			table.insert(row,Cell(x,y,false));
		end
		table.insert(grid,row);
	end
	for y = 1, height do
		for x = 1, width do
			grid[y][x]:prepare(x,y,grid);
		end
	end
	self.grid = grid;
end

function Grid:getDimensions()
		return self.width,self.height;
end

function Grid:getCellState(x,y)
	local cell = self.grid[y][x];
	return cell.state,cell.last_state,cell.next_state,cell.count;
end

function Grid:setCellState(x,y,state)
	self.grid[y][x].state = state;
end

function Grid:setLifeCell(x,y,b)
	self.grid[y][x]:setLifeCell(b);
end

function Grid:setDeathCell(x,y,b)
	self.grid[y][x]:setDeathCell(b);
end

function Grid:preupdate()
	local grid = self.grid;
	for y = 1, #grid do
		local row = grid[y];
		for x = 1, #row do
			local cell = row[x];
			cell:preUpdate();
		end
	end
end

function Grid:update()
	local grid = self.grid;
	for y = 1, #grid do
		local row = grid[y];
		for x = 1, #row do
			local cell = row[x];
			cell:update();
		end
	end
end

function Grid:forEachCellNeighbor(x,y,func)
	local neighbors = self.grid[y][x].neighbors;
	for i = 1, #neighbors do
		local cell = neighbors[i];
		func(cell.x,cell.y,cell.state,cell.last_state,cell.next_state,cell.count);
	end
end

function Grid:forEach(func)
	local grid = self.grid;
	for y = 1, #grid do
		local row = grid[y];
		for x = 1, #row do
			local cell = row[x];
			func(x,y,cell.state,cell.last_state,cell.next_state,cell.count);
		end
	end
end

return Grid;
