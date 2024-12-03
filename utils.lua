local write_file
local read_file
do
    local status, err = pcall(function()
        local fs = require("@lune/fs")
        write_file = function(path, content)
            fs.writeFile(path, content)
        end

        read_file = function(path)
            return fs.readFile(path)
        end
    end)

    if plist then
        write_file = writefile
        read_file = readfile
        io = {
            write = function(...) end
        }
    elseif not status then
        write_file = function(path, content)
            local file = io.open(path, "wb")
            io.output(file)
            io.write(content)
            io.close(file)
            io.output(io.stdout)
        end

        read_file = function(path)
            local f = assert(io.open(path, "rb"))
            local content = f:read("*a")--f:read("*all")
            f:close()
            return content
        end

    end
end

do
    local status, err = pcall(function()
        local stdio = require("@lune/stdio")
        io = {
            write = stdio.write
        }
    end)
end

-- gsplit: iterate over substrings in a string separated by a pattern
-- 
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
-- 
-- Returns: iterator
--
-- Usage:
-- for substr in gsplit(text, pattern, plain) do
--   doSomething(substr)
-- end
local function gsplit(text, pattern, plain)
  local splitStart, length = 1, #text
  return function ()
    if splitStart then
      local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
      local ret
      if not sepStart then
        ret = string.sub(text, splitStart)
        splitStart = nil
      elseif sepEnd < sepStart then
        -- Empty separator!
        ret = string.sub(text, splitStart, sepStart)
        if sepStart < length then
          splitStart = sepStart + 1
        else
          splitStart = nil
        end
      else
        ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
        splitStart = sepEnd + 1
      end
      return ret
    end
  end
end

-- split: split a string into substrings separated by a pattern.
-- 
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
-- 
-- Returns: table (a sequence table containing the substrings)
local function split(text, pattern, plain)
  local ret = {}
  for match in gsplit(text, pattern, plain) do
    table.insert(ret, match)
  end
  return ret
end

local function normalize_ln(text)
    text = text:gsub("\r\n", "\n")
    -- if last char of text is newline then remove it
    if text:sub(-1) == "\n" then
        text = text:sub(1, -2)
    end
    return text
end

local function enum(tbl)
    for k, v in pairs(tbl) do
        tbl[v] = k
    end
    return tbl
end

local function except_value(set1, set2)
    local result = {}
    for _, value in ipairs(set1) do
        if not set2[value] then
            table.insert(result, value)
        end
    end
    return result
end

local function is_number(char)
    return tonumber(char) ~= nil
end

local function find(table, element)
    for key, value in pairs(table) do
        if value == element then
            return key
        end
    end
    return nil
end

printf = function(fmt, ...)
    print(fmt:format(...))
end

local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function except(set1, set2)
    local result = {}
    for _, value in ipairs(set1) do
        if not contains(set2, value) then
            table.insert(result, value)
        end
    end
    return result
end

local function copy_table(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        result[k] = v
    end
    return result
end

local function repeat_table(tbl, times)
    local result = {}
    local len = #tbl
    for i = 1, times do
        for k, v in ipairs(tbl) do
            result[len*(i-1) + k] = v
        end
    end
    return result
end

local function to_chars(str)
    local t = {}
    for i = 1, #str do
        t[i] = str:sub(i, i)
    end
    return t
end

local function sorted(tbl, ...)
    table.sort(tbl, ...)
    return tbl
end
local function move_one_down(tbl)
    for i = 0, #tbl - 1 do
        tbl[i] = tbl[i + 1]
    end
    return tbl
end

local function rem(a, m) 
    if a < 0 then 
        return rem(m - rem(-a, m), m);
    else 
        return a % m;
    end
end;

local function GCF(a, b) 
    if b == 0 then 
        return a; 
    else 
        return GCF(b, rem(a, b));
    end
end;

local function LCM(a, b) 
    return a * b / GCF(a, b);
end;

local function map(tbl, func)
    local result = {}
    for k, v in pairs(tbl) do
        result[k] = func(v)
    end
    return result
end

return {
    write_file = write_file,
    read_file = read_file,
    gsplit = gsplit,
    split = split,
    normalize_ln = normalize_ln,
    enum = enum,
    except_value = except_value,
    except = except,
    is_number = is_number,
    find = find,
    copy_table = copy_table,
    repeat_table = repeat_table,
    to_chars = to_chars,
    to_chars_python = to_chars_python,
    sorted = sorted,
    move_one_down = move_one_down,
    lcm = LCM,
    contains = contains,
    map = map
}