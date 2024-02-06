TPL_ABILITY_BOSS["祭泠(弋洛伽)"] = {
    AbilityTpl()
        :name("舍生")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/WarlockEmpoweredImp")
        :description({ "以自身生命作为代价", "获得强大的攻击和吸血能力" })
        :attributes(
        {
            { "hp", -1500, 0 },
            { "hpRegen", -30, 0 },
            { "attack", 100, 0 },
            { "hpSuckAttack", 10, 0 },
        }),
    AbilityTpl()
        :name("狂风")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Greenengulfingtornado")
        :coolDownAdv(45, 0)
        :mpCostAdv(175, 0)
        :description(
        function()
            local attackSpeed = 100
            local dur = 5
            return {
                "御风而行，天气会后续变为狂风，同时短时间内攻速暴增",
                colour.hex(colour.lawngreen, "攻速：+" .. attackSpeed .. '%'),
                colour.hex(colour.skyblue, "提升持续时间：" .. dur .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 40) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local attackSpeed = 100
            local dur = 5
            u:attach("CycloneTarget", "origin", 2)
            Game():weather(4)
            u:buff("狂风疾速")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/Greenengulfingtornado")
             :duration(dur)
             :description({ colour.hex(colour.lawngreen, "攻速：+" .. attackSpeed .. '%') })
             :purpose(function(buffObj)
                buffObj:attach("Tornado_Target", "origin")
                buffObj:attackSpeed("+=" .. attackSpeed)
            end)
             :rollback(function(buffObj)
                buffObj:detach("Tornado_Target", "origin")
                buffObj:attackSpeed("-=" .. attackSpeed)
            end)
             :run()
        end),
    AbilityTpl()
        :name("狂徒败境")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/DeathStoneCone")
        :description(
        function()
            local dmg = 100
            return {
                "每当攻击成功时，如果木飙身上有负面状态",
                "将增加" .. colour.hex(colour.indianred, dmg .. "x负面数量") .. "的暗伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            local tu = attackData.targetUnit
            local n = tu:buffCount({ signal = BUFF_SIGNAL.down })
            if (n > 0) then
                local dmg = 100 * n
                tu:attach("eff/PhosgeneBurst", "origin", 0.5)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = tu,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.dark,
                    damageTypeLevel = 1,
                })
            end
        end),
    AbilityTpl()
        :name("冲刺")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/WardAgainstHarm")
        :coolDownAdv(18, 0)
        :mpCostAdv(150, 0)
        :castRadiusAdv(200, 0)
        :castDistanceAdv(1100, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local crashFly = 2
            return {
                "向着木飙位置飞跃快速地冲击",
                "击飞木飙范围附近敌人" .. crashFly .. "秒",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 30) then
                attackData.triggerAbility:effective({
                    targetX = attackData.targetUnit:x(),
                    targetY = attackData.targetUnit:y(),
                })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local crashFly = 2
            ability.leap({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "buff/Windwalk",
                speed = 1800,
                height = 0,
                onEnd = function(options)
                    if (options.sourceUnit:isDead()) then
                        return
                    end
                    local g = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = radius },
                        limit = 5,
                        filter = function(enumUnit)
                            return ab:isCastTarget(enumUnit)
                        end
                    })
                    effector("eff/SEvilWaveEffect", x, y, nil, 0.5)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.crackFly({
                                name = "冲刺击飞",
                                icon = "ability/WardAgainstHarm",
                                description = "飞上天了",
                                sourceUnit = u,
                                targetUnit = eu,
                                duration = crashFly,
                                effect = "Tornado_Target",
                                attach = "origin",
                                distance = 100,
                                height = 300,
                            })
                        end
                    end
                end
            })
        end),
}