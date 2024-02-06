TPL_UNIT.NPC_Freak = UnitTpl()
    :name("谜语人")
    :modelAlias("unit/DemonHag")
    :icon("unit/LightningRevenant")
    :modelScale(1)
    :scale(1.2)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(1)
    :move(0)
    :balloon(
    {
        z = 250,
        interval = 0.01,
        message = {
            {
                tips = function()
                    local gd = Game():GD()
                    local learned = false
                    if (isClass(gd.me, UnitClass)) then
                        local ab = gd.me:abilitySlot():storage()[6]
                        if (isClass(ab, AbilityClass)) then
                            learned = true
                        end
                    end
                    local txt
                    if (learned) then
                        txt = {
                            "吾乃无比正义和英俊的大魔导士",
                            "我有另类特别的奇异...哦?",
                            "已经学过了，那你好，再见~",
                            Game():balloonKeyboardTips("更换技能")
                        }
                    else
                        txt = {
                            "吾乃无比正义和英俊的大魔导士",
                            "现在，可以免费赠你 1 个",
                            "另类特别的奇异魔技",
                            "一共有 " .. colour.hex(colour.gold, 6) .. " 种魔技，自由选择",
                            "但要注意的是",
                            colour.hex(colour.indianred, "学习后无法替换和放弃"),
                            colour.hex(colour.indianred, "学习后在断泠前都存在"),
                            colour.hex(colour.indianred, "魔技都有严重的负面效果"),
                            Game():balloonKeyboardTips("选择奇异魔技")
                        }
                    end
                    return txt
                end,
                call = function()
                    local gd = Game():GD()
                    local learned = false
                    if (isClass(gd.me, UnitClass)) then
                        local ab = gd.me:abilitySlot():storage()[6]
                        if (isClass(ab, AbilityClass)) then
                            learned = true
                        end
                    end
                    if (learned) then
                        async.call(gd.me:owner(), function()
                            UI_NinegridsInfo:info("error", 3, "这一世没有后悔药")
                        end)
                    else
                        async.call(gd.me:owner(), function()
                            UIKit("ninegrids_essence"):essence("abilityFreak", 1, false)
                        end)
                    end
                end
            }
        },
    })
TPL_UNIT.NPC_Freak_Sad = UnitTpl()
    :name("无能的堕魔导士")
    :modelAlias("unit/DemonHag")
    :icon("unit/LightningRevenant")
    :modelScale(1)
    :scale(1.2)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(1)
    :move(0)
    :balloon(
    {
        z = 220,
        interval = 0.01,
        message = {
            {
                tips = {
                    "吾乃无比正义的大魔导士",
                    "但现在我的奇异魔技",
                    "全都被这方探秘区封锁了",
                    "呜呜呜~",
                    Game():balloonKeyboardTips("安慰他 1 秒")
                },
                call = function()
                    async.call(Game():GD().me:owner(), function()
                        UI_NinegridsInfo:info("info", 3, "去去去，别烦我")
                    end)
                end
            }
        },
    })