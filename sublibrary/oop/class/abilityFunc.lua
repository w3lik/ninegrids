local class = Class(AbilityFuncClass)
function class:params(modify)
    if (type(modify) == "function") then
        return self:prop("monUpgrade", modify)
    end
    return self:prop("monUpgrade")(self)
end