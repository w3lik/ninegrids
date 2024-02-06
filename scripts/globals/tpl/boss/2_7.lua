TPL_ABILITY_BOSS["花泠(小鹿)"] = {
    AbilityTpl()
        :name("花至环")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/ButterflyField")
        :description({ "花花草草的自然至力", "增加自身的恢复力" })
        :attributes(
        {
            { "hp", 1000, 0 },
            { "hpRegen", 50, 0 },
        }),
    AbilityTpl()
        :name("荆棘反式")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Breakingthespeedofsound")
        :description(
        function()
            local erode = Game():GD().erode
            local atkSpd = math.floor(6 + erode * 0.02)
            local hpr = math.floor(8 + erode * 0.2)
            local lay = 10
            return {
                "每当造成伤害后都会增加一层荆棘至力",
                "每一层都将增加" .. colour.hex(colour.lawngreen, atkSpd) .. "%攻击速度",
                "每一层都将减少" .. colour.hex(colour.indianred, hpr) .. "点HP恢复",
                "每一层最多持续 5 秒，获得新层时刷新时间",
                "最多可叠加至 " .. lay .. " 层",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local u = hurtData.triggerUnit
            local erode = Game():GD().erode
            local atkSpd = math.floor(6 + erode * 0.02)
            local hpr = math.floor(8 + erode * 0.2)
            local lay = 10
            local n = 1
            local b = u:buffOne("荆棘反式")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "荆棘反式" })
            end
            n = math.min(n, lay)
            local attackSpeed = n * atkSpd
            local hpRegen = n * hpr
            u:buff("荆棘反式")
             :icon("ability/MuddyEye")
             :text(colour.hex(colour.gold, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.gold, n .. "层") .. "荆棘",
                colour.hex(colour.lawngreen, "攻速：+" .. attackSpeed .. '%'),
                colour.hex(colour.indianred, "HP恢复：-" .. hpRegen)
            })
             :duration(5)
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/AthelasPink", "origin")
                    buffObj:attackSpeed("+=" .. attackSpeed)
                    buffObj:hpRegen("-=" .. hpRegen)
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/AthelasPink", "origin")
                    buffObj:attackSpeed("-=" .. attackSpeed)
                    buffObj:hpRegen("+=" .. hpRegen)
                end)
             :run()
        end),
    AbilityTpl()
        :name("花海领域")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ElvesBaptism")
        :coolDownAdv(40, 0)
        :mpCostAdv(175, 0)
        :castRadiusAdv(350, 0)
        :castKeepAdv(8, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local atk = 100
            local grass = 30
            local dur = 12
            return {
                "在身边种下花海，影响附近场地",
                "敌人进入范围后会急剧降低攻击和草抗性",
                colour.hex(colour.indianred, "攻击：-" .. atk),
                colour.hex(colour.indianred, "草抗性：-" .. grass .. '%'),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
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
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = u:x(), u:y()
            local z = japi.Z(x, y)
            local atk = 100
            local grass = 30
            local dur = 12
            Effect("buff/AthelasPurple", x, y, z, 2):size(4)
            AuraAttach()
                :radius(radius)
                :duration(dur)
                :centerPosition({ x, y, z })
                :centerEffect("aura/ForestblessingForm1", nil, radius / 100)
                :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    local de = {
                        colour.hex(colour.indianred, "攻击：-" .. atk),
                        colour.hex(colour.indianred, "草抗性：-" .. grass .. '%'),
                    }
                    eu:buff("花海领域")
                      :icon("ability/ElvesBaptism")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/AthelasPurple", "origin")
                        buffObj:attack("-=" .. atk)
                        buffObj:enchantResistance(DAMAGE_TYPE.grass, "-=" .. grass)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/AthelasPurple", "origin")
                        buffObj:attack("+=" .. atk)
                        buffObj:enchantResistance(DAMAGE_TYPE.grass, "+=" .. grass)
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "花海领域" })
                end)
        end),
}