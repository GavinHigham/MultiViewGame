require("mapGraph")
--Model should store everything is needed for an abstract representation of the game.
--It also describes the namespace setup somewhat.
require("units")
model = {
		mapGraph = {
			nodes = {}
		},
		cartography = {
			createEdgeMode = true,
			moveNodeMode   = false,
			createUnitMode = false,
			dragBegin = nil, --Begin of drag could be overriden.
			dragEnd   = nil,   --End of drag could be overriden.
			snapRange   = 50,
			selectRange = 25
		},
		entities = {},
		input = {
			dragBegin = nil,
			dragEnd   = nil
		},
		selectedNode = nil
	}
--Ideas for improvement:
--**Move input variables into their own model, and make this one "GameModel".
--If I want this game to have multiple possible views, they might have different notions of game input.
--**Have context-specific models.
--The model I need for creating maps is also not really necessary for gameplay.

function model.update(dt)
	for i, entity in ipairs(model.entities) do
		entity:update(dt)
	end
end