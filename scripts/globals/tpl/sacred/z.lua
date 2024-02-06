local s = Store("sacred")
s:name("泠器碑纪")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "K") .. ")",
        "纪录在这里",
        "可随时使用"
    }
end)
local c = s:salesGoods():count()
for i = 1, #TPL_SACRED, 1 do
    local v = TPL_SACRED[i]
    v:prop("idx", i)
    v:levelMax(10)
    v:entertain(BIOGRAPHIES_ITEM[v:name()])
    v:pawnable(false)
     :condition(function() return Game():sacred(i) == true end)
    if (i >= 9 and i <= 40) then
        v:conditionTips("打败：" .. TPL_SOUL[i]:name())
    end
    v:onEvent(EVENT.Item.Drop,
        function(dropData)
            local di = dropData.triggerItem
            local du = dropData.triggerUnit
            effector("eff/FantasyCircles", dropData.targetX, dropData.targetY, 1.5)
            di:superposition("locust", "+=1")
            Game():sacredRemove(i)
            time.setTimeout(1, function()
                di:instance(false)
                if (isClass(du, UnitClass)) then
                    async.call(du:owner(), function()
                        UI_NinegridsInfo:info("info", 5, "泠器已自动回归碑纪")
                    end)
                end
            end)
        end)
    if (i > c) then
        s:insert(v)
    end
end
BOSS_ITEMS = {
    { TPL_SACRED[43], TPL_SACRED[45], TPL_SACRED[48] },
    { TPL_SACRED[4], TPL_SACRED[48] },
    { TPL_SACRED[43], TPL_SACRED[47] },
    { TPL_SACRED[46], TPL_SACRED[48] },
    { TPL_SACRED[42], TPL_SACRED[44] },
    { TPL_SACRED[41], TPL_SACRED[47] },
    { TPL_SACRED[41], TPL_SACRED[46], TPL_SACRED[47] },
    { TPL_SACRED[41], TPL_SACRED[48] },
    { TPL_SACRED[6], TPL_SACRED[44] },
    { TPL_SACRED[47] },
    { TPL_SACRED[45], TPL_SACRED[48] },
    { TPL_SACRED[41], TPL_SACRED[48] },
    { TPL_SACRED[43], TPL_SACRED[44], TPL_SACRED[46] },
    { TPL_SACRED[2], TPL_SACRED[14], TPL_SACRED[47] },
    { TPL_SACRED[41], TPL_SACRED[42] },
    { TPL_SACRED[45], TPL_SACRED[47] },
    { TPL_SACRED[42], TPL_SACRED[43], TPL_SACRED[44] },
    { TPL_SACRED[19], TPL_SACRED[45], TPL_SACRED[48] },
    { TPL_SACRED[4], TPL_SACRED[41], TPL_SACRED[48] },
    { TPL_SACRED[42], TPL_SACRED[46], TPL_SACRED[47] },
    { TPL_SACRED[5], TPL_SACRED[13], TPL_SACRED[41] },
    { TPL_SACRED[10], TPL_SACRED[11], TPL_SACRED[43] },
    { TPL_SACRED[4], TPL_SACRED[16], TPL_SACRED[41] },
    { TPL_SACRED[9], TPL_SACRED[44], TPL_SACRED[47], TPL_SACRED[48] },
    { TPL_SACRED[3], TPL_SACRED[6], TPL_SACRED[45] },
    { TPL_SACRED[8], TPL_SACRED[17], TPL_SACRED[46] },
    { TPL_SACRED[19], TPL_SACRED[43], TPL_SACRED[45], TPL_SACRED[47], TPL_SACRED[48] },
    { TPL_SACRED[42], TPL_SACRED[44], TPL_SACRED[46] },
    { TPL_SACRED[25], TPL_SACRED[41], TPL_SACRED[43], TPL_SACRED[48] },
    { TPL_SACRED[6], TPL_SACRED[17], TPL_SACRED[19], TPL_SACRED[45], TPL_SACRED[47] },
    { TPL_SACRED[5], TPL_SACRED[16], TPL_SACRED[41] },
    { TPL_SACRED[7], TPL_SACRED[19], TPL_SACRED[42], TPL_SACRED[46] }
}
BOSS_BIG_ITEMS = {
    { TPL_SACRED[3], TPL_SACRED[9], TPL_SACRED[16], TPL_SACRED[34], TPL_SACRED[41], TPL_SACRED[43] },
    { TPL_SACRED[6], TPL_SACRED[8], TPL_SACRED[17], TPL_SACRED[19], TPL_SACRED[45], TPL_SACRED[46] },
    { TPL_SACRED[16], TPL_SACRED[18], TPL_SACRED[20], TPL_SACRED[24], TPL_SACRED[42], TPL_SACRED[48] },
    { TPL_SACRED[9], TPL_SACRED[26], TPL_SACRED[32], TPL_SACRED[33], TPL_SACRED[39], TPL_SACRED[48] },
}