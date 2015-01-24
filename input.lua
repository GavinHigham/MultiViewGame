input = {}
local cartography = model.cartography
local modelInput = model.input
local mapGraph = model.mapGraph

function input.update(dt)
	if love.mouse.isDown('l') then
		local x, y = love.mouse.getPosition()
		modelInput.dragEnd = {x = x, y = y}
		if cartography.createEdgeMode then
			cartography.dragEnd = nearestWithin(modelInput.dragEnd, mapGraph.nodes, cartography.snapRange)
		elseif cartography.moveNodeMode and cartography.dragBegin then
			cartography.dragBegin.x, cartography.dragBegin.y = x, y
		end
	else
		modelInput.dragBegin = nil
	end
end

function love.mousepressed(x, y, button)
	cursorpressed(x, y, button)
end

function love.mousereleased(x, y, button)
	cursorreleased(x, y, button)
end

-- I should probably have another layer of indirection with these functions, to make input code as reusable as possible.
-- I'm chosing not to add it for now, because it's simple enough to reimplement later, and it simplifies this code.

--Stand-in for love.mousepressed, so we can support non-mouse cursors.
function cursorpressed(x, y, button)
	if button == 'l' then
		modelInput.dragBegin = {x = x, y = y}
		modelInput.dragEnd = modelInput.dragBegin --To avoid dereferencing nil if we want to draw a line and dragEnd is not yet updated.
		if cartography.createEdgeMode then --There could be a lot of map nodes, don't want to do this unless we have to.
			cartography.dragBegin = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.snapRange)
		elseif cartography.moveNodeMode then
			cartography.dragBegin = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.selectRange)
		elseif cartography.createUnitMode then
			--This may cause problems once I implement node/edge deletion.
			model.selectedNode = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.selectRange)
		end
	end
end

--Stand-in for love.mousereleased, so we can support non-mouse cursors.
function cursorreleased(x, y, button)
	if button == 'l' then
		modelInput.dragEnd = {x = x, y = y}
		if cartography.createEdgeMode then
			local beginNode, endNode
			--Create new nodes if the beginning or end of the drag needs one.
			if not cartography.dragBegin then
				beginNode = newNode(modelInput.dragBegin.x, modelInput.dragBegin.y)
				table.insert(mapGraph.nodes, beginNode)
			else
				beginNode = cartography.dragBegin
			end
			if not cartography.dragEnd then
				endNode = newNode(modelInput.dragEnd.x, modelInput.dragEnd.y)
				table.insert(mapGraph.nodes, endNode)
			else
				endNode = cartography.dragEnd
			end
			--Create an edge between the two nodes, if there is not one there already.
			if not edgeExists(beginNode, endNode) then
				table.insert(beginNode.outgoing, endNode)
			end
		elseif cartography.moveNodeMode and cartography.dragBegin then
			cartography.dragBegin.x, cartography.dragBegin.y = x, y
		end
		modelInput.dragBegin  = nil
		modelInput.dragEnd    = nil
		cartography.dragBegin = nil
		cartography.dragEnd = nil
	end
end

function love.keyreleased(key)
	if key == 'p' then
		if cartography.createEdgeMode then
			cartography.createEdgeMode = false
			cartography.moveNodeMode = true
		elseif cartography.moveNodeMode then
			cartography.moveNodeMode = false
			cartography.createUnitMode = true
		elseif cartography.createUnitMode then
			cartography.createUnitMode = false
			cartography.createEdgeMode = true
			model.selectedNode = nil --This is really the wrong place for this.
		end
	elseif key == "b" or key == "m" or key == "s" then
		if cartography.createUnitMode then
			if model.selectedNode then
				local teamNumber = 1
				if key == "b" then
					addUnitToNode(makeUnit("big", model.selectedNode), teamNumber, model.selectedNode)
				elseif key == "m" then
					addUnitToNode(makeUnit("medium", model.selectedNode), teamNumber, model.selectedNode)
				elseif key == "s" then
					addUnitToNode(makeUnit("small", model.selectedNode), teamNumber, model.selectedNode)
				end
			end
		end
	end
end