require("mapGraph")
--Model should store everything is needed for an abstract representation of the game.
--It also describes the namespace setup somewhat.
require("units")
gameModel = {
		mapGraph = {
			nodes = {}
		},
		cartography = {
			mode = "createEdge",
			dragBegin = nil, --Begin of drag could be overriden.
			dragEnd   = nil,   --End of drag could be overriden.
			snapRange   = 50,
			selectRange = 25
		},
		units = {},
		input = {
			dragBegin = nil,
			dragEnd   = nil
		},
		selectedNode = nil
	}

inputModel = {
	panBegin = nil,
	panEnd   = nil
}
--Ideas for improvement:
--**Move input variables into their own model, and make this one "GameModel".
--If I want this game to have multiple possible views, they might have different notions of game input.
--**Have context-specific models.
--The model I need for creating maps is also not really necessary for gameplay.

function gameModel.update(dt)
	for _, unit in ipairs(gameModel.units) do
		Unit.update(unit, dt)
	end
	local w, h = love.window.getDimensions()
	for _, node in ipairs(gameModel.mapGraph.nodes) do
		node.x = (node.pos.x-w/2)/node.pos.z+w/2
		node.y = (node.pos.y-h/2)/node.pos.z+h/2
	end
end