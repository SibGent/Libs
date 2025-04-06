function table.shuffle(t)
    local rand = math.random

    for i = #t, 2, -1 do
        local j = rand(i)
        t[i], t[j] = t[j], t[i]
    end

    return t
end

function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == "table" then
        copy = {}

        for k, v in pairs(orig) do
            copy[k] = v
        end
    else
        copy = orig
    end

    return copy
end

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}

        for k, v in next, orig, nil do
            copy[table.deepcopy(k)] = table.deepcopy(v)
        end

        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

function table.length(t)
    local count = 0

    for k, v in pairs(t) do
        count = count + 1
    end

    return count
end

function table.getKeys(t)
    local keys = {}

    for k in pairs(t) do
        keys[1 + #keys] = k
    end

    return keys
end

function table.getValues(t)
    local values = {}

    for _, v in pairs(t) do
        values[1 + #values] = v
    end

    return values
end

function table.print(t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
