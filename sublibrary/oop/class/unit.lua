local class = Class(UnitClass)
function class:hpBack(value)
    if (value ~= 0) then
        self:hpCur("+=" .. value)
        if (math.abs(value) >= 1) then
            local str = math.format(value, 0)
            if (value > 0) then
                str = '+' .. str
            end
            local x, y = self:x(), self:y()
            local z = self:h() + 150
            ttg.word({
                style = "hp",
                str = str,
                width = 5.5,
                size = 0.35,
                x = x,
                y = y,
                z = z,
                height = 100,
                duration = 0.75,
            })
        end
    end
end
function class:mpBack(value)
    if (value ~= 0) then
        self:mpCur("+=" .. value)
        if (math.abs(value) >= 1) then
            local str = math.format(value, 0)
            if (value > 0) then
                str = '+' .. str
            end
            local x, y = self:x(), self:y()
            local z = self:h() + 150
            ttg.word({
                style = "mp",
                str = str,
                width = 5.5,
                size = 0.35,
                x = x,
                y = y,
                z = z,
                height = 75,
                duration = 0.75,
            })
        end
    end
end