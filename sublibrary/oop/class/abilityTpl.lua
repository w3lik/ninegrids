local class = Class(AbilityTplClass)
function class:pasConvTo(call)
    if (type(call) == "function") then
        self:prop("pasConvSetTo", call)
    end
    return self
end
function class:pasConvBack(call)
    if (type(call) == "function") then
        self:prop("pasConvSetBack", call)
    end
    return self
end