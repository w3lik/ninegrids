local s = Store("warehouse")
s:name("任务材料")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "L") .. ")",
        "背包内的材料物品全都是临时的",
        "穿越则消失"
    }
end)