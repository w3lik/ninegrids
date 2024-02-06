TPL_UNIT.NPC_Fire = UnitTpl()
    :name("火魔")
    :modelAlias("unit/FireElemental2")
    :icon("unit/MagmaElemental")
    :modelScale(0.65)
    :scale(1.5)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(1)
    :move(0)
    :balloon(
    {
        z = 210,
        interval = 0.01,
        message = {
            {
                tips = {
                    "火焰山谷开始爆发了，前往挑战吗？",
                    "进入山谷后请坚持在时限内存活下来",
                    "成功挑战可获得" .. colour.hex(colour.yellow, "能力点和金币奖励"),
                    Game():balloonKeyboardTips("进入挑战")
                },
                call = function()
                    local gd = Game():GD()
                    Game():closeDoor()
                    if (isClass(gd.me, UnitClass) and gd.me:isAlive()) then
                        async.call(gd.me:owner(), function()
                            UI_NinegridsAnimate:blackHole()
                        end)
                        ProcessCurrent:next("slice_fire")
                    end
                end
            }
        },
    })