local class = Class(UnitFuncClass)
function class:entertain(modify)
    if (modify) then
        return self:prop("entertain", modify)
    end
    return self:prop("entertain") or "生平不详"
end