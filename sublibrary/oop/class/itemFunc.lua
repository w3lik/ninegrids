local class = Class(ItemFuncClass)
function class:entertain(modify)
    if (modify) then
        return self:prop("entertain", modify)
    end
    return self:prop("entertain") or "???"
end