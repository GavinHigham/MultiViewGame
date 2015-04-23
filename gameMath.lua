matrix = require("matrix")

--Handy angles
deg15  = math.pi/12
deg30  = math.pi/6
deg60  = math.pi/3
deg45  = math.pi/4
deg90  = math.pi/2
deg120 = math.pi*2/3

--Returns the distance between two points.
--p1 and p2 must be tables that each have attributes .x and .y.
function distance(p1, p2)
	return math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
end

--Returns new x', y' such that x'^2 + y'^2 = 1, and the vector <x', y'> has the same orientation as <x, y>
function normalize(x, y)
	local mag = math.sqrt(x*x+y*y)
	if mag == 0 then return 0, 0 end --mag will only be 0 if the original vector was 0-length.
	return x/mag, y/mag
end

function vec3norm(x, y, z)
	local mag = math.sqrt(x*x+y*y+z*z)
	if mag == 0 then return 0, 0, 0 end --mag will only be 0 if the original vector was 0-length.
	return x/mag, y/mag, z/mag
end

function vectorScale(x, y, magnitude)
	return x*magnitude, y*magnitude
end

function vectorRotate(x, y, angle)
	return x*math.cos(angle) - y*math.sin(angle), x*math.sin(angle) + y*math.cos(angle)
end

--This is probably broken.
function axisAngleVectorRotateMatrix(ux, uy, uz, angle)
	local s = math.sin(angle)
	local c = math.cos(angle)
	--print("s: " .. s .. " c: " .. c)
	local c1 = 1-c
	return matrix{
		{c + ux*ux*c1,    ux*uy*c1 - uz*s, ux*uz*c1 + uy*s},
		{uy*ux*c1 + uz*s, c + uy*uy*c1,    uy*uz*c1 - ux*s},
		{uz*ux*c1 - uy*s, uz*uy*c1 + ux*s, c + uz*uz*c1}
	}
end

--Dead code
function axisAngleVectorRotateTest()
	local x, y, z = axisAngleVectorRotate(1, 0, 0, 0, 0, 1, math.pi/2)
	print("x: " .. x .. " y: " .. y .. " z: " .. z)
	--assert(math.cos(math.pi/2.0) == 0)
	--assert(x == 0)
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