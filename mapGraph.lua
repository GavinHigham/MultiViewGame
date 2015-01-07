function newNode(x, y)
	return {x = x, y = y, outgoing = {}, visitingTeams = {
			--team 1 might look like: {bigUnits = {}, mediumUnits = {}, smallUnits = {}}
			--index by 1, 2, 3, etc. using table.insert()
			}
		}
end

--Could receive a generic 
function edgeExists(u, v)
	if u.outgoing then
		for i, v2 in ipairs(u.outgoing) do
			if v == v2 then
				return true
			end
		end
	end
	return false
end