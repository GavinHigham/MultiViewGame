UI = {}
Div = {}
Style = {}
--[[
Style tags: 
	positioning = "relative"|"constant"
	sizing      = "relative"|"constant"
	horizontally_position_from = "left"|"center"|"right"
	vertically_position_from   = "top"|"center"|"bottom"
	x = (Some number. Fractional values < 1 for use with relative positioning.)
	y = (Some number. Fractional values < 1 for use with relative positioning.)
	margin_left   = (Some amount of external padding. Useful for insetting percentage-sized divs by a constant value.)
	margin_right  = (Some amount of external padding. Useful for insetting percentage-sized divs by a constant value.)
	margin_top    = (Some amount of external padding. Useful for insetting percentage-sized divs by a constant value.)
	margin_bottom = (Some amount of external padding. Useful for insetting percentage-sized divs by a constant value.)
]]

function Style.new(
	positioning,
	sizing,
	horizontally_position_from,
	vertically_position_from,
	x,
	y,
	w,
	h,
	margin_left,
	margin_right,
	margin_top,
	margin_bottom)
	if positioning ~= "constant" and positioning ~= "relative" then
		positioning = "relative" --Default to relative positioning.
	end
	if sizing ~= "constant" and sizing ~= "relative" then
		sizing = "relative" --Default to relative sizing.
	end
	if horizontally_position_from ~= "left" and horizontally_position_from ~= "center" and horizontally_position_from ~= "right" then
		horizontally_position_from = "center"
	end
	if vertically_position_from ~= "left" and vertically_position_from ~= "center" and vertically_position_from ~= "right" then
		vertically_position_from = "center"
	end
	return {
		positioning = positioning,
		horizontally_position_from = horizontally_position_from,
		vertically_position_from   = vertically_position_from,
		x = x or 0.5,
		y = y or 0.5,
		w = w or 1.0,
		h = h or 1.0,
		margin_left = margin_left or 0,
		margin_right = margin_right or 0,
		margin_top = margin_top or 0,
		margin_bottom = margin_bottom or 0
	}
end

function Div.new(parent, style)
	if parent.children then
		local xOffset = 0
		local w, h
		
		local x1, y1, x2, y2 --Top-left and bottom-right.
		if style.positioning == "constant" then xOffset = style.x end
		if horizontally_position_from == "left" or horizontally_position_from == "center" then
			local offset = 0
			if style.positioning == "constant" then offset = style.x
			else (offset = parent.x2 - parent.x1) * style.x end
			x1 = parent.x1 + style.margin_right
		elseif style.positioning == "right" then
		    --do
		end
		newDiv = {
			style = style,
			x1 = 
		}
		table.insert(parent.children, newDiv)
		return newDiv
	end
	return nil
end