function table.shuffle(t)
    if type(t) ~= "table" then return t end
    local rand = math.random

    for i = #t, 2, -1 do
        local j = rand(i)
        t[i], t[j] = t[j], t[i]
    end

    return t
end

function table.shallowcopy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}

    for k, v in pairs(orig) do
        copy[k] = v
    end

    return copy
end

function table.deepcopy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}

    for k, v in next, orig, nil do
        copy[table.deepcopy(k)] = table.deepcopy(v)
    end

    setmetatable(copy, table.deepcopy(getmetatable(orig)))
    return copy
end

function table.length(t)
    if type(t) ~= "table" then return 0 end
    local count = 0

    for _, _ in pairs(t) do
        count = count + 1
    end

    return count
end

function table.getKeys(t)
    local keys = {}
    if type(t) ~= "table" then return keys end

    for k in pairs(t) do
        keys[1 + #keys] = k
    end

    return keys
end

function table.getValues(t)
    local values = {}
    if type(t) ~= "table" then return values end

    for _, v in pairs(t) do
        values[1 + #values] = v
    end

    return values
end

function table.print(t)
    local print_r_cache = {}

    local function sub_print_r(tbl, indent)
        if print_r_cache[tostring(tbl)] then
            print(indent .. "*" .. tostring(tbl))
            return
        end

        print_r_cache[tostring(tbl)] = true

        if type(tbl) == "table" then
            for pos, val in pairs(tbl) do
                if type(val) == "table" then
                    print(indent .. "[" .. tostring(pos) .. "] => " .. tostring(tbl) .. " {")
                    sub_print_r(val, indent .. "    ")
                    print(indent .. "}")
                elseif type(val) == "string" then
                    print(indent .. "[" .. tostring(pos) .. '] => "' .. val .. '"')
                else
                    print(indent .. "[" .. tostring(pos) .. "] => " .. tostring(val))
                end
            end
        else
            print(indent .. tostring(tbl))
        end
    end

    if type(t) == "table" then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        print(tostring(t))
    end
    print()
end
