input = {}
local cartography = gameModel.cartography
local modelInput = gameModel.input
local mapGraph = gameModel.mapGraph

function input.update(dt)
	if love.mouse.isDown('l') then
		local x, y = love.mouse.getPosition()
		modelInput.dragEnd = {x = x, y = y}
		if cartography.mode == "createEdge" then
			cartography.dragEnd = nearestWithin(modelInput.dragEnd, mapGraph.nodes, cartography.snapRange)
		elseif cartography.mode == "moveNode" and cartography.dragBegin then
			local dragBeginNode = cartography.dragBegin
			dragBeginNode.x, dragBeginNode.y = x, y
			dragBeginNode.pos.x = (dragBeginNode.x-(window.w/2))/window.w
			dragBeginNode.pos.y = (dragBeginNode.y-(window.h/2))/window.w
			dragBeginNode.rot = matrix{{1,0,0},{0,1,0},{0,0,1}}
		end
	else
		modelInput.dragBegin = nil
	end
	if love.mouse.isDown('r') then
		local x, y = love.mouse.getPosition()
		inputModel.panEnd = {x = x, y = y}
	else
		inputModel.panBegin = nil
	end
	if inputModel.panBegin and inputModel.panEnd then
		local rotX = inputModel.panEnd.x-inputModel.panBegin.x
		local rotY = inputModel.panEnd.y-inputModel.panBegin.y
		rotX, rotY = normalize(rotX, rotY)
		rotX, rotY = vectorRotate(-rotX, -rotY, math.pi/2)
		local angle = distance(inputModel.panBegin, inputModel.panEnd)/100
		local rot = axisAngleVectorRotateMatrix(rotX, rotY, 0, angle)
		--local rot = axisAngleVectorRotateMatrix(0, 1, 0, angle)
		cubeRot  =  rot * cubeRot
		for _, node in ipairs(gameModel.mapGraph.nodes) do
			node.rot =  rot * node.rot
			--print("X: " .. node.pos.x .. " Y: " .. node.pos.y .. " Z: " .. node.pos.z)
			print(node.rot[1][1] .. " " ..cubeRot[1][1] .. " " .. angle)
		end
		inputModel.panBegin = inputModel.panEnd
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

--Handles click events on the UI. Returns false if the click did not intersect with any UI elements.
function UIClick(x, y, button)
	return false
end

--Stand-in for love.mousepressed, so we can support non-mouse cursors.
function cursorpressed(x, y, button)
	if not UIClick(x, y, button) then
		if button == 'l' then
			modelInput.dragBegin = {x = x, y = y}
			modelInput.dragEnd = modelInput.dragBegin --To avoid dereferencing nil if we want to draw a line and dragEnd is not yet updated.
			if cartography.mode == "createEdge" then --There could be a lot of map nodes, don't want to do this unless we have to.
				cartography.dragBegin = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.snapRange)
			elseif cartography.mode == "moveNode" then
				cartography.dragBegin = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.selectRange)
			elseif cartography.mode == "createUnit" then
				--This may cause problems once I implement node/edge deletion.
				gameModel.selectedNode = nearestWithin(modelInput.dragBegin, mapGraph.nodes, cartography.selectRange)
			end
		elseif button == 'r' then
			inputModel.panBegin = {x = x, y = y}
		end
	end
end

--Stand-in for love.mousereleased, so we can support non-mouse cursors.
function cursorreleased(x, y, button)
	if button == 'l' then
		modelInput.dragEnd = {x = x, y = y}
		if cartography.mode == "createEdge" then
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
				table.insert(mapGraph.edges, newEdge(beginNode, endNode))
			end
		elseif cartography.mode == "moveNode" and cartography.dragBegin then
			cartography.dragBegin.x, cartography.dragBegin.y = x, y
		end
		modelInput.dragBegin  = nil
		modelInput.dragEnd    = nil
		cartography.dragBegin = nil
		cartography.dragEnd   = nil
	elseif button == 'r' then
		inputModel.panEnd = {x = x, y = y}
	end
end

function nextMode()
	if cartography.mode == "createEdge" then
		cartography.mode = "moveNode"
	elseif cartography.mode == "moveNode" then
		cartography.mode = "createUnit"
	elseif cartography.mode == "createUnit" then
		cartography.mode = "createEdge"
		gameModel.selectedNode = nil --This is really the wrong place for this.
	end
end

function love.keyreleased(key)
	if key == 'p' then
		nextMode()
	elseif key == "b" or key == "m" or key == "s" then
		if cartography.mode == "createUnit" then
			if gameModel.selectedNode then
				local teamNumber = 1
				if key == "b" then
					Unit.new(Unit.bigPrototype, gameModel.selectedNode, teamNumber)
					elseif key == "m" then
					Unit.new(Unit.mediumPrototype, gameModel.selectedNode, teamNumber)
				elseif key == "s" then
					Unit.new(Unit.smallPrototype, gameModel.selectedNode, teamNumber)
				end
			end
		end
	elseif key == "1" then
		for _, node in ipairs(gameModel.mapGraph.nodes) do
			node.pos.z = node.pos.z + 0.3
		end
	elseif key == "2" then
		for _, node in ipairs(gameModel.mapGraph.nodes) do
			node.pos.z = node.pos.z - 0.3
		end
	end
end