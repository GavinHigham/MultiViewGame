function distance(p1, p2)
	return math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end

function nearestWithin(sourcePoint, table, range)
	local closestDistance
	local closestPoint
	for i, point in ipairs(table) do
		local currentDistance = distance(sourcePoint, point)
		if currentDistance < range and ((not closestPoint) or currentDistance < closestDistance) then
			closestPoint = point
			closestDistance = currentDistance
		end
	end
	return closestPoint
end