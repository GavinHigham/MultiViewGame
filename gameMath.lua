function distance(p1, p2)
	return math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end

function normalize(x, y)
	local mag = math.sqrt(x*x+y*y)
	if mag == 0 then mag = 1 end --Totally not okay. Will silently fail to normalize in weird edge cases. Ah well, C'est la vie.
	return x/mag, y/mag
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