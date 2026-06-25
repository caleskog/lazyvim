local M = {}

--- Blend two hex colors.
--- @param a string  hex color e.g. "#1a1b26"
--- @param b string  hex color e.g. "#9ece6a"
--- @param ratio number  0.0 = full a, 1.0 = full b
--- @return string  blended hex color
function M.blend(a, b, ratio)
	local function parse(c)
		return tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16)
	end
	local ar, ag, ab = parse(a)
	local br, bg, bb = parse(b)
	local r = math.floor(ar + (br - ar) * ratio + 0.5)
	local g = math.floor(ag + (bg - ag) * ratio + 0.5)
	local b_ = math.floor(ab + (bb - ab) * ratio + 0.5)
	return string.format("#%02x%02x%02x", r, g, b_)
end

return M
