function tooltipsMe()
    local gd = Game():GD()
    local content = {
        tips = {
            "本轮升泠点数：" .. colour.hex(colour.gold, math.format(gd.upgradePoint, 0)),
            "本轮灭杀敌人：" .. colour.hex(colour.gold, math.integerFormat(gd.meKill)),
            "本轮受到伤害：" .. colour.hex(colour.indianred, math.integerFormat(gd.meHurt)),
            "本轮总量输出：" .. colour.hex(colour.indianred, math.integerFormat(gd.meDamage)),
            "断泠累计次数：" .. colour.hex(colour.gold, math.format(gd.meDead, 0)),
            "破灭妄我次数：" .. colour.hex(colour.gold, math.format(gd.lastDead, 0)),
            colour.format("|n按 %s 或 %s 可以跟踪单位坐标", colour.lightgray, {
                { colour.gold, "空格键" },
                { colour.gold, "F1" },
            }),
        },
        bars = {},
    }
    return content
end