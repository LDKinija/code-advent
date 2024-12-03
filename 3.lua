local utils = require("utils")
local inspect = require("inspect")

local function parse_numbers(str) 
    local local_table = { }
    local data = str

    while true do
        local startindex, endindex = string.find(data, "mul")
        if endindex then
            data = string.sub(data, endindex + 1, #data)
            if data:sub(1, 1) == "(" then 
                data = string.sub(data, 2, #data)
                local num1 = ""
                local num2 = ""
                local num2_start = false
                for lol=1, #data do
                    if tonumber(str:sub(lol, lol)) then 
                        if num2_start then
                            num2 = num2 .. data:sub(lol, lol)
                            print(num2)
                        else
                            num1 = num1 .. data:sub(lol, lol)
                            print(num1)
                        end
                    else
                        if data:sub(lol, lol)  == ',' then num2_start = true; goto gg; end
                        if data:sub(lol, lol)  == ')' then 
                            table.insert(local_table, {num1, num2})
                        end
        
                        break
                    end
                    ::gg::
                end
            end
        else break end
    end

    return local_table
end

local function solve(input, part)
    local result_table_1 = { }
    local result_table_2 = { }

    local result1 = 0
    local result2 = 0 

    local str = input
    local line

    local do_index_start, do_index_end = string.find(str, "do()")
    local dont_index_start, dont_index_end = string.find(str, "don't()")

    if do_index_end and do_index_start then
        line = string.sub(str, do_index_end, dont_index_start)
    end

    result_table_1 = parse_numbers(str)

    print(inspect(result_table_1))
    
    return result2
end

print(solve(utils.read_file("inputs/3p1.txt"), 1))
--print(solve(utils.read_file("inputs/3.txt"), 2))