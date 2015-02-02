require("spaceView")
require("model") --Contains main model definition and associated references.
require("gameMath")
require("input")
require("util")
--local LightWorld = require("light_world/lib")
view = spaceView --Default view is space theme.
local stateModel = model

function love.load()
	--[[lightWorld = LightWorld({
		ambient = {view.ambientLight, view.ambientLight, view.ambientLight}
	})]]
	view.load()
	axisAngleVectorRotateTest()
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