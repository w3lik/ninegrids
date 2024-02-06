TPL_UNIT.NPC_SoulRune = UnitTpl()
    :name("探秘区至符")
    :modelScale(1.2)
    :scale(1.1)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(0)
    :move(0)
    :balloon(
    {
        z = 160,
        interval = 0.01,
        message = {
            {
                tips = {
                    "<探秘区至符>",
                    "可跨跃到允许的平行探秘区",
                    colour.hex(colour.red, "而你的一切都将会重置"),
                    Game():balloonKeyboardTips("穿梭界域")
                },
                call = function()
                    async.call(Game():GD().me:owner(), function()
                        UIKit("ninegrids_essence"):essence("soulRune", 1, false)
                    end)
                end
            },
        },
    })
TPL_UNIT.NPC_SoulRuneNext = UnitTpl()
    :name("探秘区至符")
    :modelScale(2)
    :scale(1.8)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(0)
    :move(0)
    :balloon(
    {
        z = 260,
        interval = 0.01,
        message = {
            {
                tips = function()
                    local diff = Game():GD().diff
                    local msg = {
                        "<探秘区至符>",
                        "跨跃到" .. colour.hex(colour.red, "第" .. (diff + 1) .. "个") .. "异度探秘区",
                    }
                    if (diff < 4) then
                        table.insert(msg, colour.hex(colour.red, "而你的一切都将会重置"))
                    end
                    table.insert(msg, Game():balloonKeyboardTips("穿梭界域"))
                    return msg
                end,
                call = function()
                    Game():soulRune(math.round(Game():GD().diff + 1))
                end
            },
        },
    })
TPL_UNIT.NPC_SoulLast = UnitTpl()
    :name("终界裂缝")
    :modelScale(5)
    :scale(1)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(0)
    :move(0)
    :balloon(
    {
        z = 260,
        interval = 0.01,
        message = {
            {
                tips = {
                    "前往那处神秘的地方",
                    Game():balloonKeyboardTips("进入裂缝")
                },
                call = function(callbackData)
                    destroy(callbackData.balloonObj)
                    async.call(PlayerLocal(), function()
                        UI_NinegridsAnimate:blackHole()
                    end)
                    time.setTimeout(0.5, function()
                        ProcessCurrent:next("slice_island_ELast")
                    end)
                end
            },
        },
    })