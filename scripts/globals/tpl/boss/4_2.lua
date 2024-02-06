TPL_ABILITY_BOSS["离子泠(电子)"] = {
    AbilityTpl()
        :name("超导")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/LightningNeuralNetwork")
        :description({ "流体流速变速", "提升移动速度和攻击速度" })
        :attributes(
        {
            { "move", 100, 0 },
            { "attackSpeed", 10, 0 },
        }),
    AbilityTpl()
        :name("雷暴")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Stormthundercloud")
        :coolDownAdv(60, 0)
        :mpCostAdv(235, 0)
        :castRadiusAdv(180, 0)
        :description(
        function()
            local thunder = 25
            local dur = 30
            return {
                "呼唤雷暴，天气会后续变为暴雨，同时电子的雷伤害增加",
                colour.hex(colour.lawngreen, "雷伤害：+" .. thunder .. '%'),
                colour.hex(colour.skyblue, "提升持续时间：" .. dur .. "秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 30) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local thunder = 25
            local dur = 30
            u:effect("eff/LightningWrath", 1)
            u:effect("eff/PsiWave", 1)
            Game():weather(6)
            u:buff("雷暴增伤")
             :icon("ability/Stormthundercloud")
             :signal(BUFF_SIGNAL.up)
             :description({ "雷伤害提升：25%" })
             :duration(dur)
             :purpose(function(buffObj)
                buffObj:detach("buff/Surge", "overhead")
                buffObj:enchantResistance(DAMAGE_TYPE.thunder, "+=" .. thunder)
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/Surge", "overhead")
                buffObj:enchantResistance(DAMAGE_TYPE.thunder, "-=" .. thunder)
            end)
             :run()
        end),
    AbilityTpl()
        :name("雷球")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/AnimateDead")
        :coolDownAdv(50, 0)
        :castChantAdv(1, 0)
        :mpCostAdv(175, 0)
        :description(
        function()
            return {
                "在身边召唤3个雷球" .. colour.hex(colour.gold, "20秒"),
                "雷球无法触碰无法移动，会不断的打击附近的敌人",
                colour.hex(colour.yellow, "在雷雨天气下，雷球攻速+15%")
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 100) <= 35) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local dur = 20
            local num = 3
            local atkSpeed = 0
            if (Game():isWeather("rainStorm")) then
                atkSpeed = 15
            end
            local x, y, fac = u:x(), u:y(), u:facing()
            local angle = 360 / num
            for i = 1, num, 1 do
                local tx, ty = vector2.polar(x, y, 300, angle * i)
                local e = Game():enemies(TPL_UNIT.SUMMON_ThunderBall, tx, ty, fac, true)
                e:period(dur)
                e:attack(300)
                e:attackSpeed(atkSpeed)
            end
        end),
    AbilityTpl()
        :name("电路")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :icon("ability/LightningSperm")
        :coolDownAdv(16, 0)
        :mpCostAdv(175, 0)
        :castRadiusAdv(250, 0)
        :castDistanceAdv(1000, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(530 + erode * 3)
            return {
                "与电子同步前进，快速去往目的地",
                "到达时对附近范围造成" .. dmg .. "雷伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 100) <= 40) then
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
            local erode = Game():GD().erode
            local dmg = math.floor(530 + erode * 3)
            local j = 0
            u:rgba(255, 255, 255, 0, 0.8)
            ability.leap({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "FarseerMissile",
                speed = 1500,
                height = 0,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 8 == 0) then
                        effector("MonsoonBoltTarget", vec[1], vec[2], nil, 0.3)
                        effector("eff/WaterBlast", vec[1], vec[2], nil, 0.3)
                    end
                end,
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
                    effector("eff/EmptyThunder", x, y, nil, 0.5)
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.thunder,
                                damageTypeLevel = 1,
                            })
                        end
                    end
                end
            })
        end),
}