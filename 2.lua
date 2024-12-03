local utils = require("utils")
local inspect = require("inspect")

local function solve(input, part)
	local lines = utils.split(utils.normalize_ln(input), "\n", true)

	-- print(lines[1]) -- pirma eilute
	-- print(lines[2]) -- antra eilute

	local levels = {}

	for k, v in ipairs(lines) do
		table.insert(
			levels,
			utils.map(utils.split(v, " "), function(val)
				return tonumber(val)
			end)
		)
	end

	--[[
        {
            { 58, 59, 62, 63, 64, 63 },
            { 71, 72, 74, 76, 78, 80, 82, 82 },
            ...
        }
    ]]
	-- print(inspect(levels))

    local result = 0

    --[[
        
    The levels are either all increasing or all decreasing.
    Any two adjacent levels differ by at least one and at most three.

    ]]

    --Analyze the unusual data from the engineers. How many reports are safe?

	for i = 1, #levels do
        local level = levels[i]
        local function is_safe(level)
            local old_num = nil
            local safe = true
            for i = 1, #level - 1 do
                local res = math.abs(level[i] - level[i + 1])
                -- Any two adjacent levels differ by at least one and at most three.
                if res >= 1 and res <= 3 then
                    local gaidys = level[i] - level[i + 1]

                    if old_num ~= nil then 
                        if (gaidys < 0 and old_num < 0) or (gaidys > 0 and old_num > 0) then
                            
                        else
                            safe = false
                            break
                        end
                    end

                    old_num = gaidys
                else
                    safe = false
                    break
                end
            end

            return safe
        end

        if part == 1 then
            if is_safe(level) then
                result = result + 1
            end
        else
            local hmm = {}
            table.insert(hmm, utils.copy_table(level))
            for i = 1, #level do
                local new_level = utils.copy_table(level)
                table.remove(new_level, i)
                table.insert(hmm, new_level)
            end
            local results_tbl = {}
            for k, v in ipairs(hmm) do
                local level = v
                local safe = is_safe(level)
                table.insert(results_tbl, safe)
            end
            if utils.contains(results_tbl, true) then
                result = result + 1
            end
        end        
	end

	return result
end

print(solve(utils.read_file("inputs/2.txt"), 1))
print(solve(utils.read_file("inputs/2.txt"), 2))
