require("spaceView")
require("model") --Contains main model definition and associated references.
require("gameMath")
require("input")
local LightWorld = require("light_world/lib")
local view = spaceView --Default view is space theme.
local stateModel = model

function love.load()
	lightWorld = LightWorld({
		ambient = {view.ambientLight, view.ambientLight, view.ambientLight}
	})
	spaceViewLoad()
end

function love.draw()
	view.draw()
end

function love.update(dt)
	lightWorld:update(dt)
	--lightWorld:setTranslation(x, y, scale)
	model.update(dt)
	input.update(dt)
end