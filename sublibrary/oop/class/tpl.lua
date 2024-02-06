local class = Class(TplClass)
function class:condition(modify)
    if (type(modify) == "function") then
        return self:prop("condition", modify)
    end
    local cond = self:prop("condition")
    if (type(cond) == "function") then
        local res = cond(self)
        if (type(res) == "boolean") then
            return res
        end
        return false
    end
    return true
end
function class:conditionTips(modify)
    return self:prop("conditionTips", modify)
end
function class:conditionPassTips(modify)
    return self:prop("conditionPassTips", modify)
end