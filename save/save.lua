local binser = require 'save.binser';
local SaveInterface = {};
local user_file_str = 'user_data';
local progress_file_str = 'progress_data';
local achievement_file_str = 'achievement_data';
local user_data;
local progress_data;
local achievement_data;

local function appendTXTFileType(str)
    return str .. '.txt';
end

local function save(name,...)
    love.filesystem.write(appendTXTFileType(name), binser.serialize(...));
end

local function getInfo(name)
    return love.filesystem.getInfo(appendTXTFileType(name),'file');
end

local function exists(name)
    return getInfo(name) ~= nil;
end

local function load(name)
    if exists(name) then
        local data = love.filesystem.read(appendTXTFileType(name));
        return binser.deserialize(data);
    end
    return false;
end

local function delete(name)
    love.filesystem.remove(appendTXTFileType(name));
end

local function loadUser()
    if exists(user_file_str) then
        local data = load(user_file_str);
        if data == nil then return false end
        user_data = data[1];
    else
        user_data = {
            points = 0
        }
    end
    return true;
end

local function loadProgress()
    if exists(progress_file_str) then
        local data = load(progress_file_str);
        if data == nil then return false end
        progress_data = data[1];
    else
        progress_data = {
            level = 1
        }
    end
    return true;
end

local function loadAchievements()
    if exists(achievement_file_str) then
        local data = load(achievement_file_str);
        if data == nil then return false end
        achievement_data = data[1];
    else
        achievement_data = {}
    end
    return true;
end

function SaveInterface.loadAll()
    loadUser();
    loadProgress();
    loadAchievements();
end

function SaveInterface.saveUser()
    save(user_file_str,user_data);
end

function SaveInterface.saveProgress()
    save(progress_file_str,progress_data);
end

function SaveInterface.saveAchievements()
    save(achievement_file_str,achievement_data);
end

function SaveInterface.saveAll()
    SaveInterface.saveUser();
    SaveInterface.saveProgress();
    SaveInterface.saveAchievements();
end

function SaveInterface.deleteUser()
    delete(user_file_str);
end

function SaveInterface.deleteProgress()
    delete(progress_file_str);
end

function SaveInterface.deleteAchievements()
    delete(achievement_file_str);
end

function SaveInterface.deleteAll()
    SaveInterface.deleteUser();
    SaveInterface.deleteProgress();
    SaveInterface.deleteAchievements();
end

function SaveInterface.getUserData()
    return user_data;
end

function SaveInterface.getProgressData()
    return progress_data;
end

function SaveInterface.getAchievementData()
    return achievement_data;
end

function SaveInterface.setProgressField(field,value)
    progress_data[field] = value;
end

function SaveInterface.setUserField(field,value)
    user_data[field] = value;
end

function SaveInterface.setAchievementsField(field,value)
    achievement_data[field] = value;
end

return SaveInterface;