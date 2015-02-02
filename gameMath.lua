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

--This is probably broken.
function axisAngleVectorRotate(x, y, z, ux, uy, uz, angle)
	local s, c = math.sin(angle), math.cos(angle)
	local c1 = 1-c
	retX = ux*(c + ux*ux*c1)  + uy*(ux*uy*c1-uz*s) + uz*(ux*uz*c1 + uy*s)
	retY = ux*(uy*ux*c1+uz*s) + uy*(c+uy*uy*c1)    + uz*(uy*uz*c1-ux*s)
	retZ = ux*(uz*ux*c1-uy*s) + uy*(uz*uy*c +ux*s) + uz*(c + uz*uz*c1)
	return retX, retY, retZ
end

function axisAngleVectorRotateTest()
	local x, y, z = axisAngleVectorRotate(1, 0, 0, 0, 0, 1, math.pi/2)
	print("x: " .. x .. " y: " .. y .. " z: " .. z)
	assert(x == 0)
	assert(y == 1)
	assert(z == 0)
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