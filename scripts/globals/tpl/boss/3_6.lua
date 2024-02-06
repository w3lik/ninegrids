TPL_ABILITY_BOSS["剑泠(缠水)"] = {
    AbilityTpl()
        :name("波谲")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/Heavenandearth")
        :coolDownAdv(10, 0)
        :mpCostAdv(0, 0)
        :description(
        function(obj)
            local tag = obj:prop("波谲") or 1
            if (tag == 1) then
                return {
                    "水无形，意无身，切换到攻击形态",
                }
            elseif (tag == 2) then
                return {
                    "水无形，意无身，切换到防御形态",
                }
            else
                return {
                    "水无形，意无身，切换到均衡形态",
                }
            end
        end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(atkData)
            if (math.rand(1, 100) <= 20) then
                atkData.triggerAbility:effective()
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local ab = effectiveData.triggerAbility
            u:buffClear({ key = "波谲" })
            local tag = ab:prop("波谲") or 1
            if (tag == 1) then
                ab:prop("波谲", 2)
                u:buff("波谲")
                 :icon("ability/Heavenandearth")
                 :duration(-1)
                 :description({
                    "攻击形态",
                    colour.hex(colour.lawngreen, "攻击：+" .. 200),
                    colour.hex(colour.indianred, "防御：-" .. 200),
                })
                 :purpose(function(buffObj)
                    buffObj:attach("buff/DisarmBlue", "overhead")
                    buffObj:attack("+=200")
                    buffObj:defend("-=200")
                end)
                 :rollback(function(buffObj)
                    buffObj:detach("buff/DisarmBlue", "overhead")
                    buffObj:attack("-=200")
                    buffObj:defend("+=200")
                end)
                 :run()
            elseif (tag == 2) then
                ab:prop("波谲", 3)
                u:buff("波谲")
                 :icon("ability/Heavenandearth")
                 :duration(-1)
                 :description({
                    "防御形态",
                    colour.hex(colour.lawngreen, "防御：+" .. 200),
                    colour.hex(colour.indianred, "攻击：-" .. 200),
                })
                 :purpose(function(buffObj)
                    buffObj:attach("buff/ArmorStimulusBlue", "overhead")
                    buffObj:defend("+=200")
                    buffObj:attack("-=200")
                end)
                 :rollback(function(buffObj)
                    buffObj:detach("buff/ArmorStimulusBlue", "overhead")
                    buffObj:defend("-=200")
                    buffObj:attack("+=200")
                end)
                 :run()
            else
                ab:prop("波谲", 1)
            end
        end),
    AbilityTpl()
        :name("祈雨")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/RaindropsBlue")
        :coolDownAdv(55, 0)
        :mpCostAdv(225, 0)
        :castRadiusAdv(180, 0)
        :description(
        function()
            local hpRegen = 50
            local mpRegen = 30
            local water = 25
            local dur = 15
            return {
                "祈求雨水，天气会后续变为雨天或暴雨",
                "还会在身边形成局部降雨，进入领域的敌人",
                "HP、MP恢复及水抗性都会降低",
                colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                colour.hex(colour.indianred, "MP恢复：-" .. mpRegen),
                colour.hex(colour.indianred, "水抗性：-" .. water .. '%'),
                colour.hex(colour.skyblue, "领域持续时间：" .. dur .. "秒"),
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
            local hpRegen = 50
            local mpRegen = 30
            local water = 25
            local dur = 15
            if (math.rand(1, 2) == 1) then
                Game():weather(5)
            else
                Game():weather(6)
            end
            AuraAttach()
                :radius(radius)
                :duration(dur)
                :centerUnit(u)
                :centerEffect("env/Rain", "overhead", 1.2)
                :filter(function(enumUnit) return enumUnit:isAlive() and (isClass(u, UnitClass) and enumUnit:isEnemy(u:owner())) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    local de = {
                        colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                        colour.hex(colour.indianred, "MP恢复：-" .. mpRegen),
                        colour.hex(colour.indianred, "水抗性：-" .. water .. '%'),
                    }
                    eu:buff("祈雨")
                      :icon("ability/RaindropsBlue")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/waterHands", "origin")
                        buffObj:hpRegen("-=" .. hpRegen)
                        buffObj:mpRegen("-=" .. mpRegen)
                        buffObj:enchantResistance(DAMAGE_TYPE.water, "-=" .. water)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/waterHands", "origin")
                        buffObj:hpRegen("+=" .. hpRegen)
                        buffObj:mpRegen("+=" .. mpRegen)
                        buffObj:enchantResistance(DAMAGE_TYPE.water, "+=" .. water)
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "祈雨" })
                end)
        end),
    AbilityTpl()
        :name("惊涛骇浪")
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/BlueKnifeLight")
        :coolDownAdv(50, 0)
        :mpCostAdv(175, 0)
        :castRadiusAdv(900, 0)
        :castKeepAdv(2, 0)
        :keepAnimation("attack slam")
        :castChantEffect("eff/VortexArea")
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function()
            local dmg = math.floor(170 + Game():GD().erode * 1.2)
            return {
                "在" .. colour.hex(colour.gold, "3秒") .. "内进行多次浪涛缠击",
                "每次缠击都会激发9道水波剑气",
                "浪涛缠击伤害：" .. colour.hex(colour.indianred, dmg),
                colour.hex(colour.yellow, "在雨天使用时造成伤害提升50%"),
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
            local dmg = math.floor(170 + Game():GD().erode * 1.2)
            local frq = 0.1
            local facing = 0
            if (Game():isWeather("rain")) then
                dmg = dmg * 1.5
            end
            time.setInterval(frq, function(curTimer)
                if (u:isDead() or false == u:isAbilityKeepCasting()) then
                    destroy(curTimer)
                    return
                end
                curTimer:period(0.95)
                facing = facing + 20
                for i = 1, 9 do
                    local tx, ty = vector2.polar(x, y, radius, facing + i * 40)
                    local j = 0
                    ability.missile({
                        sourceUnit = u,
                        targetVec = { tx, ty },
                        modelAlias = "slash/BladeShockwave",
                        scale = 1.4,
                        speed = 700,
                        onMove = function(_, vec)
                            j = j + 1
                            if (j % 9 == 0) then
                                local g = Group():catch(UnitClass, {
                                    circle = { x = vec[1], y = vec[2], radius = 175 },
                                    limit = 5,
                                    filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                                })
                                if (#g > 0) then
                                    for _, eu in ipairs(g) do
                                        u:effect("CrushingWaveDamage", 0.5)
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
                end
            end)
        end),
}