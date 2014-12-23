spaceView = {
	ambientLight = 55
}
local modeTextPadding
local finLength = 20
local finWidth = 5
tex = {}
local mi, mc

function spaceViewLoad()
	tex.space_bg = love.graphics.newImage("tex/bg/bg_stars.jpg")
	--Make these a little more concise.
	mi = model.input
	mc = model.cartography
	--Configure lines for "stellar connection" drawing.
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(2)
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

	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	for i, node in ipairs(model.mapGraph.nodes) do
		love.graphics.circle("fill", node.x, node.y, 5, 16)
		--love.graphics.rectangle("line", node.x, node.y, 100, 100) --Hehe, this looks pretty cool.
	end
end

function spaceViewDrawUI()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), 16)
	love.graphics.setColor(100, 220, 100, 255) --Light greenish
	if mc.drawEdgeMode then
		love.graphics.print("Drag to create stars and jump lanes.", modeTextPadding, modeTextPadding)
	else
		love.graphics.print("Click and drag to move stars.")
	end

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