TPL_ABILITY_BOSS["汐泠(卫将)"] = {
    AbilityTpl()
        :name("卫至心")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/RuneDefense")
        :description({ "坚决守护海族的心", "增加自身的防御" })
        :attributes(
        {
            { "defend", 50, 0 },
            { "hurtReduction", 15, 0 },
        }),
    AbilityTpl()
        :name("卫至核")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/MuddyEye")
        :description(
        function()
            local erode = Game():GD().erode
            local atk = math.floor(10 + erode * 0.05)
            local lay = 30
            return {
                "每当受到伤害后都会增加一层自身攻击力",
                "每一层都将增加" .. colour.hex(colour.lawngreen, atk) .. "攻击",
                "每一层最多持续 5 秒，获得新层时刷新时间",
                "最多可叠加至 " .. lay .. " 层",
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local u = hurtData.triggerUnit
            local erode = Game():GD().erode
            local atk = math.floor(10 + erode * 0.05)
            local lay = 30
            local n = 1
            local b = u:buffOne("卫至核")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "卫至核" })
            end
            n = math.min(n, lay)
            local attack = n * atk
            u:buff("卫至核")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/MuddyEye")
             :text(colour.hex(colour.gold, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.gold, n .. "层") .. "核力",
                colour.hex(colour.lawngreen, "攻击：+" .. attack)
            })
             :duration(5)
             :purpose(
                function(buffObj)
                    buffObj:attack("+=" .. attack)
                    buffObj:attach("buff/DisarmBlue", "weapon")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/DisarmBlue", "weapon")
                    buffObj:attack("-=" .. attack)
                end)
             :run()
        end),
    AbilityTpl()
        :name("潮袭")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/ShockWave2")
        :coolDownAdv(50, 0)
        :mpCostAdv(175, 0)
        :castRadiusAdv(1200, 0)
        :castKeepAdv(8, 0)
        :keepAnimation("attack slam")
        :castChantEffect("eff/VortexArea")
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(155 + Game():GD().erode * 1.7)
            return {
                "在" .. colour.hex(colour.gold, "8秒") .. "内击出潮汐袭击木飙",
                "潮汐伤害：" .. colour.hex(colour.indianred, dmg),
                colour.hex(colour.yellow, "在雨天使用时造成伤害提升100%"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 30) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local x, y = u:x(), u:y()
            local d = math.floor(155 + Game():GD().erode * 1.7)
            local frq = 0.5
            time.setInterval(frq, function(curTimer)
                if (u:isDead() or false == u:isAbilityKeepCasting()) then
                    destroy(curTimer)
                    return
                end
                curTimer:period(1)
                local dmg = d
                if (Game():isWeather("rain")) then
                    dmg = dmg * 2
                end
                local cu = Group():closest(UnitClass, {
                    circle = { x = x, y = y, radius = radius },
                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                })
                local angle
                if (isClass(cu, UnitClass)) then
                    angle = vector2.angle(x, y, cu:x(), cu:y())
                else
                    angle = math.rand(0, 359)
                end
                local tx, ty = vector2.polar(x, y, radius, angle)
                alerter.line(x, y, radius, angle, 0.5)
                local j = 0
                ability.missile({
                    sourceUnit = u,
                    targetVec = { tx, ty },
                    modelAlias = "CrushingWaveMissile",
                    scale = 1.2,
                    speed = 800,
                    onMove = function(_, vec)
                        j = j + 1
                        if (j % 8 == 0) then
                            local g = Group():catch(UnitClass, {
                                circle = { x = vec[1], y = vec[2], radius = 150 },
                                limit = 5,
                                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                            })
                            if (#g > 0) then
                                for _, eu in ipairs(g) do
                                    effector("CrushingWaveDamage", eu:x(), eu:y(), eu:h(), 0.5)
                                    ability.damage({
                                        sourceUnit = u,
                                        targetUnit = eu,
                                        damage = dmg,
                                        damageSrc = DAMAGE_SRC.ability,
                                        damageType = DAMAGE_TYPE.water,
                                        damageTypeLevel = 0,
                                    })
                                end
                            end
                        end
                    end,
                })
            end)
        end),
}