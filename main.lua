require("gameMath")
require("spaceView")
require("model") --Contains main model definition and associated references.
require("input")
require("util")
--local LightWorld = require("light_world/lib")
view = spaceView --Default view is space theme.
local stateModel = model
window = {}

function love.load()
	--[[lightWorld = LightWorld({
		ambient = {view.ambientLight, view.ambientLight, view.ambientLight}
	})]]
	view.load()
	local w, h = love.window.getDimensions()
	window.w = w
	window.h = h

	if arg[2] then
		loadSaveGame(gameModel.mapGraph, arg[2])
	else
		loadSaveGame(gameModel.mapGraph, "savegame.lua")
	end
end

function love.draw()
	view.draw()
end

function love.update(dt)
	--lightWorld:update(dt)
	--lightWorld:setTranslation(x, y, scale)
	gameModel.update(dt)
	input.update(dt)
end