--Default stats for different sized units.
--Max health, shields, attack, etc.
local bigStats    = {
	size = "big",
	maxHealth = 400
}
local mediumStats = {
	size = "medium",
	maxHealth = 150
}
local smallStats  = {
	size = "small",
	maxHealth = 50
}

function makeUnit(unitType, node)
	local newUnit = {
		location = node,
		draw = view.unitDraw,
		update = unitUpdate,
		x = node.x,
		y = node.y,
		restX = node.x,
		restY = node.y
	}
	if unitType == "big" then
		--Make big unit
		newUnit.classStats = bigStats
	elseif unitType == "medium" then
		--Make medium unit
		newUnit.classStats = mediumStats
	elseif unitType == "small" then
		--Make small unit
		newUnit.classStats = smallStats
	else
		--Extend from here.
	end

	table.insert(model.entities, newUnit)
	return newUnit
end

function unitUpdate(unit, dt)
	unit.x = unit.restX - (unit.restX - unit.x)*0.9
	unit.y = unit.restY - (unit.restY - unit.y)*0.9
end