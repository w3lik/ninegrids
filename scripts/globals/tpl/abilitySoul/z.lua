local s = Store("ability")
s:name("典藏泠技")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "I") .. ")",
        "纪录在这里",
        "可随时使用"
    }
end)
local c = s:salesGoods():count()
for i = 1, #TPL_ABILITY_SOUL, 1 do
    local v = TPL_ABILITY_SOUL[i]
    v:prop("idx", i)
    v:levelMax(15)
    if (v:castTargetFilter() == nil) then
        v:castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
    end
    if (i >= 9 and i <= 40) then
        v:condition(function() return Game():soul(i) == true
        end)
         :conditionTips("打败：" .. TPL_SOUL[i]:name())
    end
    if (i > c) then
        s:insert(v)
    end
end