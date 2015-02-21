function newNode(x, y)
	return {
		x = x,
		y = y,
		pos = {x = (x-(window.w/2))/window.w, y = (y-(window.h/2))/window.w, z = 1}, --coordinates with 0,0 in the middle of the screen.
		rot = matrix{{1,0,0},{0,1,0},{0,0,1}},
		edges = {},
		visitingTeams = {
			--team 1 might look like: {bigUnits = {}, mediumUnits = {}, smallUnits = {}}
			--index by 1, 2, 3, etc. using table.insert()
		},
	}
end

function newEdge(u, v)
	local newEdge = {
		u = u,
		v = v,
		view = {}
	}
	table.insert(u.edges, newEdge)
	table.insert(v.edges, newEdge)
	return newEdge
end

--Could receive a generic table
function edgeExists(u, v)
	if u.edges then
		for _, edge in ipairs(u.edges) do
			if edge.u == v or edge.v == v then
				return true
			end
		end
	end
	return false
end