TPL_SOUL_RUNE = {
    Tpl()
        :name("初生探秘区")
        :icon("ability/InscriptionVantusRuneAzure")
        :description(
        {
            colour.hex(colour.skyblue, "初生探秘区"),
            "界至起始",
            "渐入迷茫",
            "意义非凡",
        }),
    Tpl()
        :name("洞悉探秘区")
        :icon("ability/InscriptionVantusRuneTomb")
        :description(
        {
            colour.hex("f5ff22", "洞悉探秘区"),
            "界至醒悟",
            "索求真相",
            "历遍八方",
        }),
    Tpl()
        :name("破灭探秘区")
        :icon("ability/InscriptionVantusRuneSuramar")
        :description(
        {
            colour.hex("e3c6ee", "破灭探秘区"),
            "界至毁灭",
            "无拘无束",
            "踏破新生",
        }),
    Tpl()
        :name("觉醒探秘区")
        :icon("ability/InscriptionVantusRuneNightmare")
        :description(
        {
            colour.hex("e3c6ee", "觉醒探秘区"),
            "界至终焉",
            "神消泠散",
            "破我虚妄",
        }),
    Tpl()
        :name("本命探秘区")
        :icon("ability/InscriptionVantusRuneOdyn")
        :description(
        {
            colour.hex("efef5f", "本命探秘区"),
            "幻像至我",
            "同泠同技",
            "虚实何存",
        }),
}
local s = Store("soulRune")
s:name("探秘区至符")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "L") .. ")",
        "背包内的材料物品全都是临时的",
        "穿越则消失"
    }
end)
local c = s:salesGoods():count()
for i = 1, #TPL_SOUL_RUNE, 1 do
    local v = TPL_SOUL_RUNE[i]
    v:prop("idx", i)
    if (i > 1) then
        v:condition(function() return Game():GD().diffMax >= i end)
         :conditionTips("通过：" .. colour.hex(colour.red, TPL_SOUL_RUNE[i - 1]:name()))
    end
    if (i > c) then
        s:insert(v)
    end
end