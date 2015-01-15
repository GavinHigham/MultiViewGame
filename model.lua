require("mapGraph")
model = {
		mapGraph = {
			nodes = {}
		},
		cartography = {
			drawEdgeMode = true,
			dragBegin = nil, --Begin of drag could be overriden.
			dragEnd = nil,   --End of drag could be overriden.
			snapRange = 50,
			selectRange = 25
		},
		entities = {},
		input = {
			dragBegin = nil,
			dragEnd = nil
		}
	}

function modelUpdate(dt)
	for i, entity in ipairs(model.entities) do
		entity.update(dt)
	end
end

model.update = modelUpdate