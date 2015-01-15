spaceView = {
	ambientLight = 55
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

function spaceViewLoad()
	tex.space_bg = love.graphics.newImage("tex/bg/bg_stars.jpg")
	--Configure lines for "stellar connection" drawing.
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(2)

	--Make these a little more concise.
	mi = model.input
	mc = model.cartography
end

function spaceViewDraw()
	spaceViewDrawBG()
	love.graphics.push()
    --love.graphics.translate(x, y)
    --love.graphics.scale(scale)
    lightWorld:draw(function()
		spaceViewDrawLit()
    end)
	love.graphics.pop()
	spaceViewDrawUnlit()
	spaceViewDrawUI()
end

function spaceViewDrawLit()

end

function spaceViewDrawBG()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(tex.space_bg)
end

function spaceViewDrawUnlit()
	love.graphics.setColor(75, 75, 255, 255) --Light bluish
	for i, u in ipairs(model.mapGraph.nodes) do
		for j, v in ipairs(u.outgoing) do
			love.graphics.line(u.x, u.y, v.x, v.y)
			drawArrow(v.x, v.y, u.x, u.y, finLength, finWidth, "fill")
		end
	end

	--Nodes (stars) are drawn here.
	for i, node in ipairs(model.mapGraph.nodes) do
		love.graphics.setColor(100, 220, 100, 255) --Light greenish
		love.graphics.circle("fill", node.x, node.y, 5, 16)
		drawVisitingUnits(node)
		--love.graphics.rectangle("line", node.x, node.y, 100, 100) --Hehe, this looks pretty cool.
	end
	if model.selectedNode then
		love.graphics.setColor(220, 100, 100, 200)
		love.graphics.circle("line", model.selectedNode.x, model.selectedNode.y, 10, 16)
	end
end

function drawVisitingUnits(node)
	--Draw all 'dem.
	--Figure out how many teams are visiting that star.
	--Display the orbitals, successively larger orbitals for teams that arrived later.
	--Display the units for each team.
	local radius = smallestOrbitalRadius
	updateUnitRestingPositions(node)
	love.graphics.setColor(70, 220, 70, 200)
	for i, team in ipairs(node.visitingTeams) do
		--Draw the orbital rings.
		love.graphics.circle("line", node.x, node.y, radius, 36)
		radius = radius + orbitalSpacing
		--Draw the units.
		for j, unit in ipairs(team.bigUnits) do
			spaceViewUnitDraw(unit)
		end
		for j, unit in ipairs(team.mediumUnits) do
			spaceViewUnitDraw(unit)
		end
		for j, unit in ipairs(team.smallUnits) do
			spaceViewUnitDraw(unit)
		end
	end
end


function updateUnitRestingPositions(node)
	--Big units go in the upper-right third, medium in the upper-left third, and small in the bottom third.
	--Distribute evenly by angle, between 330 and 90 degrees, 90 and 210, and 210 and 330, with a small
	--inner margin in each range to avoid overlap.
	--Successively larger orbitals are drawn at a greater radius.
	local radius = smallestOrbitalRadius
	local deg120 = 2*math.pi/3
	for i, visitingTeam in ipairs(node.visitingTeams) do
		local angleSpacing = (deg120)/#(visitingTeam.bigUnits)
		local angle = -math.pi/6 + angleSpacing/2
		for j, unit in ipairs(visitingTeam.bigUnits) do
			unit.restX = node.x+radius*math.cos(angle)
			unit.restY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		angleSpacing = (deg120)/#(visitingTeam.mediumUnits)
		angle = math.pi/2 + angleSpacing/2
		for j, unit in ipairs(visitingTeam.mediumUnits) do
			unit.restX = node.x+radius*math.cos(angle)
			unit.restY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		angleSpacing = (deg120)/#(visitingTeam.smallUnits)
		angle = 7*math.pi/6 + angleSpacing/2
		for j, unit in ipairs(visitingTeam.smallUnits) do
			unit.restX = node.x+radius*math.cos(angle)
			unit.restY = node.y+radius*math.sin(angle)
			angle = angle + angleSpacing
		end
		radius = radius + orbitalSpacing
	end
end

function spaceViewDrawUI()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), 16)
	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	if mc.createEdgeMode then
		love.graphics.print("Drag to create stars and jump lanes.", modeTextPadding, modeTextPadding)
	elseif mc.moveNodeMode then
		love.graphics.print("Click and drag to move stars.")
	elseif mc.createUnitMode then
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

spaceView.draw = spaceViewDraw

--Draws an arrow with two fins, "finAngle" away from the base line, oriented toward the right with an offset of "orientation". Units are in radians.
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

function spaceViewUnitDraw(unit)
	local unitSize = unit.classStats.size
	local ur = unitDiameter/2 --Unit radius

	if unitSize == "big" then
		--Draw a big unit.
		love.graphics.rectangle("line", unit.x-ur, unit.y-ur, unitDiameter, unitDiameter)
	elseif unitSize == "medium" then
		--Draw a medium unit.
		--This is a triangle.
		love.graphics.polygon("line", unit.x+ur, unit.y-ur, unit.x-ur, unit.y-ur, unit.x, unit.y+ur)
	elseif unitSize == "small" then
		--Draw a small unit
		love.graphics.circle("line", unit.x, unit.y, ur, 36)
	else
		--Extend from here
	end
end

spaceView.unitDraw = spaceViewUnitDraw
