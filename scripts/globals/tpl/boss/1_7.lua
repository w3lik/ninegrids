TPL_ABILITY_BOSS["树泠(森林老鹿)"] = {
    AbilityTpl()
        :name("缠绕邪根")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :icon("ability/ForestFury")
        :coolDownAdv(15, 0)
        :mpCostAdv(100, 0)
        :castDistanceAdv(600, 0)
        :castRadiusAdv(50, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(150 + erode * 0.75)
            local atkSpd = math.floor(20 + erode * 0.04)
            return {
                "以树根缠绕木飙，树根会攻击木飙5次",
                "每秒持续造成" .. colour.hex(colour.indianred, dmg) .. "草伤害",
                "并在短时间减少其攻击速度" .. colour.hex(colour.indianred, atkSpd) .. "%",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            if (math.rand(1, 10) <= 5) then
                attackData.triggerAbility:effective({ targetUnit = attackData.targetUnit })
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local tu = effectiveData.targetUnit
            local erode = Game():GD().erode
            local dmg = math.floor(150 + erode * 0.75)
            local atkSpd = math.floor(20 + erode * 0.04)
            local twine = function(whichUnit)
                whichUnit:attach("EntanglingRootsTarget", "origin", 1)
                ability.damage({
                    sourceUnit = u,
                    targetUnit = whichUnit,
                    damage = dmg,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.grass,
                    damageTypeLevel = 1,
                })
                whichUnit
                    :buff("缠绕邪根")
                    :icon("ability/ForestFury")
                    :description("攻速降低" .. atkSpd .. '%')
                    :signal(BUFF_SIGNAL.down)
                    :duration(1)
                    :purpose(
                    function(buffObj)
                        buffObj:attackSpeed("-=" .. atkSpd)
                    end)
                    :rollback(
                    function(buffObj)
                        buffObj:attackSpeed("+=" .. atkSpd)
                    end)
                    :run()
            end
            twine(tu)
            local i = 0
            time.setInterval(1, function(curTimer)
                i = i + 1
                if (i > 4 or isDestroy(u) or u:isDead() or isDestroy(tu) or tu:isDead()) then
                    destroy(curTimer)
                    return
                end
                twine(tu)
            end)
        end),
    AbilityTpl()
        :name("邪灵黑暗")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/DemonhunterSpectank")
        :coolDownAdv(75, 0)
        :mpCostAdv(200, 10)
        :castChantAdv(1, 0)
        :castChantEffect("eff/CallOfDreadRed")
        :description(
        function(_)
            local erode = Game():GD().erode
            local atk = math.floor(100 + erode * 0.4)
            local def = math.floor(50 + erode * 0.2)
            local fire = 50
            return {
                "化身成为黑暗邪灵15秒",
                "攻击、防御得到提升",
                "攻击模式化为黑暗至球",
                "对火焰抗性也得到提升",
                colour.hex(colour.lawngreen, "攻击提升：" .. atk),
                colour.hex(colour.lawngreen, "防御提升：" .. def),
                colour.hex(colour.lawngreen, "火抗性提升：" .. fire .. '%'),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            if (math.rand(1, 10) <= 5) then
                hurtData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local erode = Game():GD().erode
            local atk = math.floor(100 + erode * 0.4)
            local def = math.floor(50 + erode * 0.2)
            local fire = 50
            local icon = u:icon()
            local modelAlias = u:modelAlias()
            u:buff("邪灵黑暗")
             :icon("ability/DemonhunterSpectank")
             :description({
                colour.hex(colour.lawngreen, "攻击：+" .. atk),
                colour.hex(colour.lawngreen, "防御：+" .. def),
                colour.hex(colour.lawngreen, "火抗：+" .. fire .. '%'),
            })
             :duration(15)
             :purpose(function(buffObj)
                buffObj:icon("unit/AchievementEmeraldnightmareCenarius")
                buffObj:modelAlias("hero/Cenarius_Nightmare")
                buffObj:attackModePush(AttackModeStatic("邪灵形态" .. buffObj:id())
                    :mode("missile"):homing(true)
                    :missileModel("missile/DarknessBomb")
                    :scatter(5):radius(600):speed(1200):height(400)
                    :damageType(DAMAGE_TYPE.dark):damageTypeLevel(1))
                buffObj:attack("+=" .. atk)
                buffObj:defend("+=" .. def)
                buffObj:enchantResistance(DAMAGE_TYPE.fire, "+=" .. fire)
            end)
             :rollback(function(buffObj)
                buffObj:icon(icon)
                buffObj:modelAlias(modelAlias)
                buffObj:attackModeRemove(AttackModeStatic("邪灵形态" .. buffObj:id()):id())
                buffObj:attack("-=" .. atk)
                buffObj:defend("-=" .. def)
                buffObj:enchantResistance(DAMAGE_TYPE.fire, "-=" .. fire)
            end)
             :run()
        end),
}