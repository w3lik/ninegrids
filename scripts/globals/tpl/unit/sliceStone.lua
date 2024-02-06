TPL_UNIT.NPC_PowerStone = UnitTpl()
    :name("挑衅的小小石人")
    :icon("unit/RockGolem")
    :modelAlias("unit/Clifford")
    :modelScale(0.8)
    :material(UNIT_MATERIAL.rock)
    :scale(1.5)
    :stature(70)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(0)
    :move(0)
    :balloon(
    {
        z = 220,
        interval = 0.01,
        message = {
            {
                tips = {
                    "诶嘿~我就在这站着",
                    "我就欠揍等你来打",
                    "你就说你敢不敢！",
                    Game():balloonKeyboardTips("教它做石")
                },
                call = function(callbackData)
                    local gd = Game():GD()
                    if (isClass(gd.me, UnitClass) and gd.me:isAlive()) then
                        gd.me:effect("ImpaleTargetDust", 2)
                        destroy(callbackData.balloonObj)
                        async.call(gd.me:owner(), function()
                            UI_NinegridsInfo:info("info", 5, "石人忽然直接变大！")
                        end)
                        ProcessCurrent:next("slice_stone")
                    end
                end
            },
        },
    })
TPL_UNIT.E_PowerStone = UnitTpl()
    :name("欠揍的小小石人")
    :icon("unit/RockGolem")
    :modelAlias("unit/Clifford")
    :modelScale(1.3)
    :material(UNIT_MATERIAL.rock)
    :scale(2.5)
    :stature(130)
    :itemSlot(false)
    :move(100)
    :enchantMaterial(DAMAGE_TYPE.rock)
    :attackMode(AttackMode():mode("common"))
    :weaponSound("rock_bash_heavy")