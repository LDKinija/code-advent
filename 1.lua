local utils = require("utils")
local inspect = require("inspect")

local function solve(input, part)
	local lines = utils.split(utils.normalize_ln(input), "\n", true)
	local tbl1 = {}
	local tbl2 = {}
	for _, line in ipairs(lines) do
		local tbl = utils.except(utils.split(line, " "), {""})
		table.insert(tbl1, tonumber(tbl[1]))
		table.insert(tbl2, tonumber(tbl[2]))
	end
	table.sort(tbl1)
	table.sort(tbl2)



	if part == 1 then
		local distance = 0
		for i = 1, #tbl1 do
			local v1 = tbl1[i]
			local v2 = tbl2[i]
			distance = distance + math.abs(v1 - v2)
		end

		return distance
	end

	--[[
		Calculate a total similarity score by adding up each number in the left list 
		after multiplying it by the number of times that number appears in the right list.
	]]

	local tmap = {}
	for k, v in ipairs(tbl2) do
		tmap[v] = (tmap[v] or 0) + 1
	end

	local total = 0
	for k, v in ipairs(tbl1) do
		tbl1[k] = v * (tmap[v] or 0)
		total = total + tbl1[k]
	end

	return total
end
	
print(solve(utils.read_file("inputs/1.txt"), 1))
print(solve(utils.read_file("inputs/1.txt"), 2))