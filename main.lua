require("spaceView")
require("model") --Contains main model definition and associated references.
require("gameMath")
require("input")
local view = spaceView --Default view is space theme.
local stateModel = model

function love.load()
	local windowMode = {
		fullscreen = false,
		fullscreentype = 'normal',
		vsync = true,
		fsaa = 4,
		resizable = true
	}
	love.window.setMode(1280, 800, windowMode)
end

function love.draw()
	view.draw(stateModel)
end

function love.update(dt)
	model.update(dt)
	input.update(dt)
end