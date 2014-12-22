input = {}

function inputUpdate(dt)
	if love.mouse.isDown('l') then
		local x, y = love.mouse.getPosition()
		model.input.dragEnd = {x = x, y = y}
		if model.cartography.drawEdgeMode then
			model.cartography.dragEnd = nearestWithin(model.input.dragEnd, model.mapGraph.nodes, model.cartography.snapRange)
		elseif model.cartography.dragBegin then
			model.cartography.dragBegin.x, model.cartography.dragBegin.y = x, y
		end
	else
		model.input.dragBegin = nil
	end
end

input.update = inputUpdate


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
		model.input.dragBegin = {x = x, y = y}
		model.input.dragEnd = model.input.dragBegin --To avoid dereferencing nil if we want to draw a line and dragEnd is not yet updated.
		if model.cartography.drawEdgeMode then --There could be a lot of map nodes, don't want to do this unless we have to.
			model.cartography.dragBegin = nearestWithin(model.input.dragBegin, model.mapGraph.nodes, model.cartography.snapRange)
		else
			model.cartography.dragBegin = nearestWithin(model.input.dragBegin, model.mapGraph.nodes, model.cartography.selectRange)
		end
	end
end

--Stand-in for love.mousereleased, so we can support non-mouse cursors.
function cursorreleased(x, y, button)
	if button == 'l' then
		model.input.dragEnd = {x = x, y = y}
		if model.cartography.drawEdgeMode then
			local beginNode, endNode
			--Create new nodes if the beginning or end of the drag needs one.
			if not model.cartography.dragBegin then
				beginNode = newNode(model.input.dragBegin.x, model.input.dragBegin.y)
				table.insert(model.mapGraph.nodes, beginNode)
			else
				beginNode = model.cartography.dragBegin
			end
			if not model.cartography.dragEnd then
				endNode = newNode(model.input.dragEnd.x, model.input.dragEnd.y)
				table.insert(model.mapGraph.nodes, endNode)
			else
				endNode = model.cartography.dragEnd
			end
			--Create an edge between the two nodes, if there is not one there already.
			if not edgeExists(beginNode, endNode) then
				table.insert(beginNode.outgoing, endNode)
			end
		elseif model.cartography.dragBegin then
			model.cartography.dragBegin.x, model.cartography.dragBegin.y = x, y
		end
		model.input.dragBegin = nil
		model.input.dragEnd = nil
		model.cartography.dragBegin = nil
		model.cartography.dragEnd = nil
	end
end

function love.keyreleased(key)
	if key == 'p' then
		model.cartography.drawEdgeMode = not model.cartography.drawEdgeMode
	end
end