TPL_ABILITY_BOSS["剑泠(疾风)"] = {
    AbilityTpl()
        :name("风灵剑秀")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/MonkDragonkick")
        :description(
        function()
            local erode = Game():GD().erode
            local lay = 5
            local dmg = math.floor(300 + erode * 1)
            return {
                "每一次攻击后都会增加自身的攻击速度10%",
                "以此方式增加的攻速最多可叠加至" .. colour.hex(colour.gold, lay) .. "层",
                "当大于5层后再次攻击，加成重归于无并挥出风龙缠",
                "并对附近400范围的木飙造成" .. colour.hex(colour.indianred, dmg) .. "风伤害",
            }
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            local u = attackData.triggerUnit
            local erode = Game():GD().erode
            local lay = 5
            local dmg = math.floor(300 + erode * 1)
            local n = 1
            local b = u:buffOne("风灵剑秀")
            if (b) then
                n = b:prop("layer") or 1
                n = n + 1
                u:buffClear({ key = "风灵剑秀" })
            end
            if (n >= lay) then
                local radius = 400
                u:effect("slash/Dragon_Cut", 1):size(radius / 600)
                local g = Group():catch(UnitClass, {
                    filter = function(enumUnit)
                        return enumUnit:isAlive() and enumUnit:isEnemy(u:owner())
                    end,
                    circle = { x = u:x(), y = u:y(), radius = radius },
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        ability.damage({
                            sourceUnit = u,
                            targetUnit = eu,
                            damage = dmg,
                            damageSrc = DAMAGE_SRC.ability,
                            damageType = DAMAGE_TYPE.wind,
                            damageTypeLevel = 1,
                        })
                    end
                end
            else
                local atkSpd = n * 10
                u:buff("风灵剑秀")
                 :signal(BUFF_SIGNAL.up)
                 :icon("ability/MonkDragonkick")
                 :text(colour.hex(colour.gold, n))
                 :prop("layer", n)
                 :description({
                    colour.hex(colour.gold, n .. "层") .. "风灵剑秀",
                    colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%')
                })
                 :duration(-1)
                 :purpose(
                    function(buffObj)
                        buffObj:attackSpeed("+=" .. atkSpd)
                        buffObj:attach("buff/Echo", "origin")
                    end)
                 :rollback(
                    function(buffObj)
                        buffObj:detach("buff/Echo", "origin")
                        buffObj:attackSpeed("-=" .. atkSpd)
                    end)
                 :run()
            end
        end),
    AbilityTpl()
        :name("风卷残云")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/GreenFencing")
        :coolDownAdv(40, 0)
        :mpCostAdv(200, 10)
        :castChantAdv(3, 0)
        :castChantEffect("slash/Culling_Slash")
        :castRadiusAdv(300)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local erode = Game():GD().erode
            local dmg = math.floor(75 + erode * 0.3)
            return {
                "在周边卷起旋风，风如刀刃般盘旋升空",
                "范围半径内敌人会被卷飞2秒",
                "会在圆形边际处残留5个旋风一段时间",
                "对木飙进行风刃打击切割" .. colour.hex(colour.indianred, dmg) .. "风伤害",
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
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local erode = Game():GD().erode
            local dmg = math.floor(75 + erode * 0.3)
            local x, y = u:x(), u:y()
            u:effect("slash/Light_speed_cutting_green", 1)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                limit = 4,
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.crackFly({
                        name = "风卷残云",
                        icon = "ability/GreenFencing",
                        description = "被气流冲上天了",
                        sourceUnit = u,
                        targetUnit = eu,
                        effect = "Tornado_Target",
                        attach = "origin",
                        distance = 100,
                        height = math.rand(100, 200),
                        duration = 2,
                    })
                end
            end
            local angle = 360 / 5
            for i = 1, 5 do
                local nx, ny = vector2.polar(x, y, 250, angle * i)
                local e = Effect("TornadoElementalSmall", nx, ny, japi.Z(nx, ny), 5)
                time.setInterval(1 + (i - 1) * 0.4, function(curTime)
                    local me = Game():GD().me
                    if (isDestroy(e) or isDestroy(u) or u:isDead() or isDestroy(me)) then
                        destroy(curTime)
                        return
                    end
                    local ta = vector2.angle(nx, ny, me:x(), me:y())
                    local tx, ty = vector2.polar(nx, ny, 500, ta)
                    local j = 0
                    ability.missile({
                        modelAlias = "slash/DiskOfScythes",
                        sourceUnit = u,
                        sourceVec = { nx, ny },
                        targetVec = { tx, ty },
                        scale = 0.8,
                        speed = 300,
                        onMove = function(opt, vec)
                            j = j + 1
                            if (j % 7 == 0) then
                                local g2 = Group():catch(UnitClass, {
                                    circle = { x = vec[1], y = vec[2], radius = 100 },
                                    filter = function(enumUnit)
                                        return ab:isCastTarget(enumUnit)
                                    end,
                                })
                                if (#g2 > 0) then
                                    for _, eu in ipairs(g2) do
                                        ability.damage({
                                            sourceUnit = opt.sourceUnit,
                                            targetUnit = eu,
                                            damage = dmg,
                                            damageSrc = DAMAGE_SRC.ability,
                                            damageType = DAMAGE_TYPE.wind,
                                            damageTypeLevel = 0,
                                        })
                                    end
                                end
                            end
                        end
                    })
                end)
            end
        end),
}