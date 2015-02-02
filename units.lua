Unit = {
	--Default stats for different sized units.
	--Max health, shields, attack, etc.
	bigPrototype    = {
		size = "big",
		maxHealth = 400,
		view = {key = "val"} --Where custom drawing data goes.
	},
	mediumPrototype = {
		size = "medium",
		maxHealth = 150,
		view = {}
	},
	smallPrototype  = {
		size = "small",
		maxHealth = 50,
		view = {}
	},
	view = {}
}

Unit.bigPrototype.update    = Unit.update
Unit.mediumPrototype.update = Unit.update
Unit.smallPrototype.update  = Unit.update

function Unit.new(prototype, node, teamNumber)
	--Create the unit
	--Inherit some attributes from the prototype.
	local newUnit = shallowCopy(prototype)
	newUnit.node = node
	newUnit.x = node.x
	newUnit.y = node.y
	newUnit.restX = node.x
	newUnit.restY = node.y
	newUnit.teamNumber = teamNumber
	newUnit.view = shallowCopy(prototype.view)

	--Add it to our general units list.
	table.insert(gameModel.units, newUnit)

	--Add it to the node to which it has been assigned.
	if not node.visitingTeams[teamNumber] then
		node.visitingTeams[teamNumber] = {bigUnits = {}, mediumUnits = {}, smallUnits = {}}
	end
	local team = node.visitingTeams[teamNumber]
	if newUnit.size == "big" then
		table.insert(node.visitingTeams[teamNumber].bigUnits, newUnit)
	elseif newUnit.size == "medium" then
		table.insert(team.mediumUnits, newUnit)
	elseif newUnit.size == "small" then
		table.insert(team.smallUnits, newUnit)
	end


	--Return the new unit in case additional config needs to be done.
	return newUnit
end

function Unit.update(unit, dt)
	if Unit.view.update then Unit.view.update(unit, dt) end
end