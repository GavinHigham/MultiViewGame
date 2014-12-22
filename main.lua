require("spaceView")
require("model") --Contains main model definition and associated references.
require("gameMath")
require("input")
--local PostShader = require("light_world/lib/postshader")
--post_shader = PostShader()
local view = spaceView --Default view is space theme.
local stateModel = model

function love.load()
	local windowMode = {
		resizable = true,
		fsaa = 8
	}
	love.window.setMode(1280, 800, windowMode)

	--post_shader:addEffect("bloom", 3, 4)
	--render_buffer = love.graphics.newCanvas(love.window.getWidth(), love.window.getHeight())
end

function love.draw()
	--[[render_buffer:clear()
	love.graphics.push()
		love.graphics.setCanvas(render_buffer)]]
		view.draw(stateModel)
	--[[love.graphics.pop()
	love.graphics.setCanvas()
	post_shader:drawWith(render_buffer)]]
end

function love.update(dt)
	model.update(dt)
	input.update(dt)
end