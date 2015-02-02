spaceView = {
	ambientLight = 55,
	units = {}
}
local modeTextPadding
local finLength = 20
local finWidth = 5
tex = {}
--Make these a little more concise.
local mi, mc
local smallestOrbitalRadius = 30
local orbitalSpacing = 20
local unitDiameter = 10
local rankSpacing = 5
local triadSpacing = 5
local selectedOffset = 0

--Handy angles
local deg15  = math.pi/12
local deg30  = math.pi/6
local deg60  = math.pi/3
local deg45  = math.pi/4
local deg90  = math.pi/2
local deg120 = math.pi*2/3

function spaceView.load()
	tex.space_bg = love.graphics.newImage("tex/bg/bg_stars.jpg")
	--Configure lines for "stellar connection" drawing.
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(2)

	--Make these a little more concise.
	mi = gameModel.input
	mc = gameModel.cartography

	Unit.view.update = spaceView.units.update
end

function spaceView.draw()
	spaceView.drawBG()
	--[[love.graphics.push()
    --love.graphics.translate(x, y)
    --love.graphics.scale(scale)
    lightWorld:draw(function()]]
		spaceView.drawLit()
    --[[end)
	love.graphics.pop()]]
	spaceView.drawUnlit()
	spaceView.drawUI()
end

function spaceView.drawLit()

end

function spaceView.drawBG()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(tex.space_bg)
end

function spaceView.drawUnlit()
	love.graphics.setColor(75, 75, 255, 255) --Light bluish
	for _, u in ipairs(gameModel.mapGraph.nodes) do
		for _, v in ipairs(u.outgoing) do
			love.graphics.line(u.x, u.y, v.x, v.y)
			drawArrow(v.x, v.y, u.x, u.y, finLength, finWidth, "fill")
		end
	end

	--Nodes (stars) are drawn here.
	for _, node in ipairs(gameModel.mapGraph.nodes) do
		love.graphics.setColor(100, 220, 100, 255) --Light greenish
		love.graphics.circle("fill", node.x, node.y, 5, 16)
		spaceView.units.drawVisiting(node)
		--love.graphics.rectangle("line", node.x, node.y, 100, 100) --Hehe, this looks pretty cool.
	end
	if gameModel.selectedNode then
		love.graphics.setColor(220, 100, 100, 200)
		love.graphics.circle("line", gameModel.selectedNode.x, gameModel.selectedNode.y, 10, 16)
	end
end

function spaceView.drawUI()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), 16)
	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	if mc.mode == "createEdge" then
		love.graphics.print("Drag to create stars and jump lanes.", modeTextPadding, modeTextPadding)
	elseif mc.mode == "moveNode" then
		love.graphics.print("Click and drag to move stars.")
	elseif mc.mode == "createUnit" then
		love.graphics.print("Click to select a star. Press b, m, and s to create big, medium, and small units.")
	end
	--Edges (jump connections) are drawn here.
	if mi.dragBegin then
		if mc.dragBegin or mc.dragEnd then
			love.graphics.setColor(200, 40, 40, 255)
			local lineBegin = mc.dragBegin or mi.dragBegin
			local lineEnd = mc.dragEnd or mi.dragEnd
			love.graphics.line(lineBegin.x, lineBegin.y, lineEnd.x, lineEnd.y)
			drawArrow(lineEnd.x, lineEnd.y, lineBegin.x, lineBegin.y, finLength+5, finWidth+4, "fin")
		end
		--Non-overriden line:
		love.graphics.setColor(100, 100, 100, 255)
		love.graphics.line(mi.dragBegin.x, mi.dragBegin.y, mi.dragEnd.x, mi.dragEnd.y)
		--drawArrow(mi.dragEnd.x, mi.dragEnd.y, mi.dragBegin.x, mi.dragBegin.y, finLength, finWidth)
	end
end

--Draws an arrow with two fins, "finAngle" away from the base line,
--oriented toward the right with an offset of "orientation". Units are in radians.
function drawArrow(x, y, x2, y2, finLength, finWidth, style, double)
	local double = double or false
	local nx, ny = normalize(x - x2, y - y2)
	mx, my = x - nx*finLength, y - ny*finLength
	local f1x, f1y = mx + ny*finWidth, my - nx*finWidth
	local f2x, f2y = mx - ny*finWidth, my + nx*finWidth
	if style ~= "fin" then
		love.graphics.polygon(style, x, y, f1x, f1y, f2x, f2y)
	else
		love.graphics.line(x, y, f1x, f1y)
		love.graphics.line(x, y, f2x, f2y)
	end
	if double then
		drawArrow(mx, my, x2, y2, finLength, finWidth, style, false)
	end
end

------------------------------------------------------------------------------------------------------------------------
--Units view Code
------------------------------------------------------------------------------------------------------------------------

function spaceView.units.drawVisiting(node)
	--Draw all 'dem.
	--Figure out how many teams are visiting that star.
	--Display the orbitals, successively larger orbitals for teams that arrived later.
	--Display the units for each team.
	local radius = smallestOrbitalRadius
	love.graphics.setColor(70, 220, 70, 200)
	spaceView.units.updateOrbitPositions(node)
	spaceView.units.updateTriadPositions(node)
	--spaceView.units.updateRankPositions(node)
	for _, team in ipairs(node.visitingTeams) do
		--Draw the orbital rings.
		love.graphics.circle("line", node.x, node.y, radius, 36)
		radius = radius + orbitalSpacing
		--Draw the units.
		local x, y = -4, -smallestOrbitalRadius-2*unitDiameter
		if node == gameModel.selectedNode then 
			selectedOffset = 14
		else
			selectedOffset = 0
		end
		love.graphics.print(#team.bigUnits, node.x+x-selectedOffset, node.y+y-selectedOffset-5)
		for _, unit in ipairs(team.bigUnits) do
			spaceView.units.draw(unit)
		end
		x, y = vectorRotate(x, y, deg120)
		love.graphics.print(#team.mediumUnits, node.x+x+selectedOffset, node.y+y+selectedOffset-5)
		for _, unit in ipairs(team.mediumUnits) do
			spaceView.units.draw(unit)
		end
		x, y = vectorRotate(x, y, deg120)
		love.graphics.print(#team.smallUnits, node.x+x-selectedOffset, node.y+y-selectedOffset)
		for _, unit in ipairs(team.smallUnits) do
			spaceView.units.draw(unit)
		end
	end
end

--Ease move to the resting position.
function spaceView.units.update(unit, dt)
	if unit.node == gameModel.selectedNode then
		spaceView.units.setRestToTriadPosition(unit)
	else
		spaceView.units.setRestToOrbitPosition(unit)
	end
	unit.x = unit.restX - (unit.restX - unit.x)*0.9
	unit.y = unit.restY - (unit.restY - unit.y)*0.9
end

--This function should be called when some number of units are moved or added.
function spaceView.units.moved(sourceNode, destinationNode)
	spaceView.units.updateOrbitPositions(sourceNode)
	spaceView.units.updateOrbitPositions(destinationNode)
end


function spaceView.units.setRestToOrbitPosition(unit)
	unit.restX = unit.view.orbitX or unit.restX
	unit.restY = unit.view.orbitY or unit.restY
end

function spaceView.units.setRestToRankPosition(unit)
	unit.restX = unit.view.rankX or unit.restX
	unit.restY = unit.view.rankY or unit.restY
end

function spaceView.units.setRestToTriadPosition(unit)
	unit.restX = unit.view.triadX or unit.restX
	unit.restY = unit.view.triadY or unit.restY
end

function spaceView.units.updateRankPositions(node)
	for _, visitingTeam in ipairs(node.visitingTeams) do --Maybe change this only to the active team.
		local x = node.x - (rankSpacing + unitDiameter) * #visitingTeam.bigUnits/2 + unitDiameter/2 + rankSpacing/2
		local y = node.y + rankSpacing + unitDiameter
		for _, unit in ipairs(visitingTeam.bigUnits) do
			unit.view.rankX = x
			unit.view.rankY = y
			x = x + rankSpacing + unitDiameter
		end
		y = y + rankSpacing + unitDiameter
		local x = node.x - (rankSpacing + unitDiameter) * #visitingTeam.mediumUnits/2 + unitDiameter/2 + rankSpacing/2
		for _, unit in ipairs(visitingTeam.mediumUnits) do
			unit.view.rankX = x
			unit.view.rankY = y
			x = x + rankSpacing + unitDiameter
		end
		y = y + rankSpacing + unitDiameter
		local x = node.x - (rankSpacing + unitDiameter) * #visitingTeam.smallUnits/2 + unitDiameter/2 + rankSpacing/2
		for _, unit in ipairs(visitingTeam.smallUnits) do
			unit.view.rankX = x
			unit.view.rankY = y
			x = x + rankSpacing + unitDiameter
		end
	end
end

function spaceView.units.updateTriadPositions(node)
	for _, visitingTeam in ipairs(node.visitingTeams) do --Maybe change this only to the active team.
		local angle = -deg90-deg45
		for i, unit in ipairs(visitingTeam.bigUnits) do
			local cx = i*unitDiameter+triadSpacing  --(#visitingTeam.bigUnits+1)/2
			local cy = cx
			local x, y = vectorRotate(cx, cy, angle)
			unit.view.triadX, unit.view.triadY = node.x+x, node.y+y
		end
		angle = angle + deg120
		for i, unit in ipairs(visitingTeam.mediumUnits) do
			local cx = i*unitDiameter+triadSpacing--(#visitingTeam.bigUnits+1)/2
			local cy = cx
			local x, y = vectorRotate(cx, cy, angle)
			unit.view.triadX, unit.view.triadY = node.x+x, node.y+y
		end
		angle = angle + deg120
		for i, unit in ipairs(visitingTeam.smallUnits) do
			local cx = i*unitDiameter+triadSpacing--(#visitingTeam.bigUnits+1)/2
			local cy = cx
			local x, y = vectorRotate(cx, cy, angle)
			unit.view.triadX, unit.view.triadY = node.x+x, node.y+y
		end
	end
end

function spaceView.units.updateOrbitPositions(node)
	--Big units go in the upper-right third, medium in the upper-left third, and small in the bottom third.
	--Distribute evenly by angle, between 330 and 90 degrees, 90 and 210, and 210 and 330, with a small
	--inner margin in each range to avoid overlap.
	--Successively larger orbitals are drawn at a greater radius.
	local radius = smallestOrbitalRadius
	for _, visitingTeam in ipairs(node.visitingTeams) do
		local angleSpacing = (deg120)/#(visitingTeam.bigUnits)
		local angle = deg120+deg90 + angleSpacing/2
		for _, unit in ipairs(visitingTeam.bigUnits) do
			unit.view.orbitX = node.x+radius*math.cos(angle)
			unit.view.orbitY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		angleSpacing = (deg120)/#(visitingTeam.mediumUnits)
		angle = -deg30 + angleSpacing/2
		for _, unit in ipairs(visitingTeam.mediumUnits) do
			unit.view.orbitX = node.x+radius*math.cos(angle)
			unit.view.orbitY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		angleSpacing = (deg120)/#(visitingTeam.smallUnits)
		angle = deg90 + angleSpacing/2
		for _, unit in ipairs(visitingTeam.smallUnits) do
			unit.view.orbitX = node.x+radius*math.cos(angle)
			unit.view.orbitY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		radius = radius + orbitalSpacing
	end
end

function spaceView.units.draw(unit)
	if     unit.size == "big"    then spaceView.units.drawBig(unit)
	elseif unit.size == "medium" then spaceView.units.drawMedium(unit)
	elseif unit.size == "small"  then spaceView.units.drawSmall(unit)
	end
end

function spaceView.units.drawBig(unit)
	local ur = unitDiameter/2 --Unit radius
	love.graphics.rectangle("line", unit.x-ur, unit.y-ur, unitDiameter, unitDiameter)
end

function spaceView.units.drawMedium(unit)
	local ur = unitDiameter/2 --Unit radius
	love.graphics.polygon("line", unit.x+ur, unit.y-ur, unit.x-ur, unit.y-ur, unit.x, unit.y+ur)
end

function spaceView.units.drawSmall(unit)
	local ur = unitDiameter/2 --Unit radius
	love.graphics.circle("line", unit.x, unit.y, ur, 36)
end
