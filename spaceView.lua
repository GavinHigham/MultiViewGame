spaceView= {}
local modeTextPadding

function spaceViewDraw(model)

	--Configure lines for "stellar connection" drawing.
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(2)
	love.graphics.setColor(100, 100, 220, 255) --Light bluish
	for i, u in ipairs(model.mapGraph.nodes) do
		for j, v in ipairs(u.outgoing) do
			love.graphics.line(u.x, u.y, v.x, v.y)
		end
	end

	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	for i, node in ipairs(model.mapGraph.nodes) do
		love.graphics.circle("fill", node.x, node.y, 5, 16)
	end

	if model.input.dragBegin then
		if model.cartography.dragBegin or model.cartography.dragEnd then
			love.graphics.setColor(200, 40, 40, 255)
			local lineBegin = model.cartography.dragBegin or model.input.dragBegin
			local lineEnd = model.cartography.dragEnd or model.input.dragEnd
			love.graphics.line(lineBegin.x, lineBegin.y, lineEnd.x, lineEnd.y)
		end
		--Non-overriden line:
		love.graphics.setColor(100, 100, 100, 255)
		love.graphics.line(model.input.dragBegin.x, model.input.dragBegin.y, model.input.dragEnd.x, model.input.dragEnd.y)
	end

	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	if model.cartography.drawEdgeMode then
		love.graphics.print("Drag to create stars and jump lanes.", modeTextPadding, modeTextPadding)
	else
		love.graphics.print("Click and drag to move stars.")
	end
end

spaceView.draw = spaceViewDraw