local class = Class(AbilityClass)
function class:pasConvTo()
    local tpl = self:tpl()
    local to = tpl:prop("pasConvSetTo")
    if (type(to) == "function") then
        self:targetType(ABILITY_TARGET_TYPE.pas)
        to(self)
    end
end
function class:pasConvBack()
    local tpl = self:tpl()
    local back = tpl:prop("pasConvSetBack")
    if (type(back) == "function") then
        self:prop("targetType", tpl:prop("targetType"))
        self:prop("description", tpl:prop("description"))
        back(self)
    end
end
function class:bossConv()
    local tpl = self:tpl()
    local to = tpl:prop("pasConvSetTo")
    if (type(to) == "function") then
        to(self)
        self:prop("description", tpl:prop("description"))
    end
end