--Returns the distance between two points.
--p1 and p2 must be tables that each have attributes .x and .y.
function distance(p1, p2)
	return math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end

--Returns new x', y' such that x'^2 + y'^2 = 1, and the vector <x', y'> has the same orientation as <x, y>
function normalize(x, y)
	local mag = math.sqrt(x*x+y*y)
	if mag == 0 then mag = 1 end --Totally not okay. Will silently fail to normalize in weird edge cases. Ah well, C'est la vie.
	return x/mag, y/mag
end

function vectorScale(x, y, magnitude)
	return x*magnitude, y*magnitude
end

function vectorRotate(x, y, angle)
	return x*math.cos(angle) - y*math.sin(angle), x*math.sin(angle) + y*math.cos(angle)
end

--Find the nearest point in a table to some source point.
--Each point in the table, and the source point, must have a .x and .y attribute for distance calculations.
--Range is a distance, it controls how close a table point must be to the source point to be acceptable.
--If there is no point in the table within "range" distance of the source point, nil is returned.
function nearestWithin(sourcePoint, table, range)
	local closestDistance
	local closestPoint
	for _, point in ipairs(table) do
		local currentDistance = distance(sourcePoint, point)
		if currentDistance < range and ((not closestPoint) or currentDistance < closestDistance) then
			closestPoint = point
			closestDistance = currentDistance
		end
	end
	return closestPoint
end