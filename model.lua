require("mapGraph")
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

function modelUpdate(dt)
	for i, entity in ipairs(model.entities) do
		entity:update(dt)
	end
end

model.update = modelUpdate