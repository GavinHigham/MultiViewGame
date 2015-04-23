function newNode(x, y, inputModel)
	local posMat
	if (inputModel) then
		posMat = matrix.invert(inputModel.viewRotation) * matrix{{(x-(window.w/2))/window.w, (y-(window.h/2))/window.w, 1 - inputModel.viewRotationDistance}}^'T'
		posMat[3][1] = posMat[3][1] + inputModel.viewRotationDistance
	else
		posMat = matrix{{(x-(window.w/2))/window.w, (y-(window.h/2))/window.w, 1 - inputModel.viewRotationDistance}}^'T' --coordinates with 0,0 in the middle of the screen.
	end
	return {
		x = x,
		y = y,
		pos = {x = posMat[1][1], y = posMat[2][1], z = posMat[3][1]},
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

loadMapGraph = {nodes = {}, edges = {}}
function NodeEntry(n)
	n.x = (n.pos.x/n.pos.z)*window.w + window.w/2
	n.y = (n.pos.y/n.pos.z)*window.w + window.h/2
	n.edges = {}
	n.visitingTeams = {} --Update this and the serialize function to save games with unit positions.
	table.insert(loadMapGraph.nodes, n)
end
function EdgeEntry(e)
	table.insert(loadMapGraph.edges, newEdge(loadMapGraph.nodes[e.u], loadMapGraph.nodes[e.v]))
end

function loadSaveGame(m, filename)
    dofile(filename)
    m.nodes = loadMapGraph.nodes
    m.edges = loadMapGraph.edges
    loadMapGraph.nodes = {}
    loadMapGraph.edges = {}
end

--f is a file handle
function serializeMapGraph(nodes, edges, f)
	local serializedMapGraph = [[]]
	for i, node in ipairs(nodes) do
		node._serialIndex = i
		f:write([[
NodeEntry{
	pos = {x = ]] .. node.pos.x .. [[, y = ]] .. node.pos.y .. [[, z = ]] .. node.pos.z ..[[}
}
]])
	end
	for i, edge in ipairs(edges) do
		f:write([[
EdgeEntry{
	u = ]] .. edge.u._serialIndex .. [[,
	v = ]] .. edge.v._serialIndex .. [[

}
]])
	end
end
