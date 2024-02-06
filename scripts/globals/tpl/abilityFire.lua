TPL_ABILITY_FIRE = {
    AbilityTpl()
        :name("火焰守礼")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/FireSealOfFire")
        :description(
        {
            "火焰提供的防御礼物",
            "可略微提升获得者的体质",
        })
        :attributes({ { "hp", 200, 0 }, { "hpRegen", 4, 0 }, { "defend", 6, 0 } }),
    AbilityTpl()
        :name("火焰同化")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/InnerFireHolySpirit")
        :description(
        {
            "接受火焰的洗涤同化",
            "增加对火的强化及抗性",
            "降低对水的强化及抗性",
        })
        :attributes(
        {
            { SYMBOL_E .. DAMAGE_TYPE.fire.value, 30, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.fire.value, 25, 0 },
            { SYMBOL_E .. DAMAGE_TYPE.water.value, -30, 0 },
            { SYMBOL_RES .. SYMBOL_E .. DAMAGE_TYPE.water.value, -25, 0 },
        }),
    AbilityTpl()
        :name("烈分领域")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/StrangeSpiritFire")
        :coolDownAdv(16, 0)
        :mpCostAdv(135, 0)
        :castRadiusAdv(300, 0)
        :castTargetFilter(CAST_TARGET_FILTER.notNeutral)
        :description(
        function(obj)
            local radius = obj:castRadius()
            local fire = 30
            local fire2 = 30
            local dur = 10
            return {
                "在木飙位置生成" .. colour.hex(colour.gold, radius) .. "半径范围烈分领域",
                "进入范围后敌我都会提升火伤加成和降低火抗性",
                colour.hex(colour.lawngreen, "火加成：+" .. fire .. '%'),
                colour.hex(colour.indianred, "火抗性：-" .. fire2 .. '%'),
                colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
            }
        end)
        :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), nil) end)
        :pasConvTo(
        function(this)
            this:prop("description", function(obj)
                local radius = obj:castRadius()
                local fire = 30
                local fire2 = 30
                local dur = 10
                return {
                    "当移动时会在自身" .. colour.hex(colour.gold, radius) .. "半径范围生成烈分领域",
                    "进入范围后敌我都会提升火伤加成和降低火抗性",
                    colour.hex(colour.lawngreen, "火加成：+" .. fire .. '%'),
                    colour.hex(colour.indianred, "火抗性：-" .. fire2 .. '%'),
                    colour.hex(colour.skyblue, "持续时间：" .. dur .. "秒"),
                }
            end)
            this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), function(movingData)
                this:effective({
                    targetX = movingData.triggerUnit:x(),
                    targetY = movingData.triggerUnit:y(),
                    targetZ = nil,
                })
            end)
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local fire = 30
            local fire2 = 30
            local dur = 10
            local x, y = effectiveData.targetX, effectiveData.targetY
            AuraAttach()
                :radius(radius)
                :duration(dur)
                :centerPosition({ x, y, 30 + effectiveData.targetZ })
                :centerEffect("buff/FlameBurning", nil, radius / 130)
                :filter(function(enumUnit) return ab:isCastTarget(enumUnit) end)
                :onEvent(EVENT.Aura.Enter,
                function(auraData)
                    local eu = auraData.triggerUnit
                    local de = {
                        colour.hex(colour.lawngreen, "火加成：+" .. fire .. '%'),
                        colour.hex(colour.indianred, "草抗性：-" .. fire2 .. '%'),
                    }
                    eu:buff("烈分领域分烧")
                      :icon("ability/StrangeSpiritFire")
                      :description(de)
                      :duration(-1)
                      :purpose(function(buffObj)
                        buffObj:attach("buff/CursedSTR096", "origin")
                        buffObj:enchant(DAMAGE_TYPE.fire, "+=" .. fire)
                        buffObj:enchantResistance(DAMAGE_TYPE.fire, "-=" .. fire2)
                    end)
                      :rollback(function(buffObj)
                        buffObj:detach("buff/CursedSTR096", "origin")
                        buffObj:enchant(DAMAGE_TYPE.fire, "-=" .. fire)
                        buffObj:enchantResistance(DAMAGE_TYPE.fire, "+=" .. fire2)
                    end)
                      :run()
                end)
                :onEvent(EVENT.Aura.Leave,
                function(auraData)
                    auraData.triggerUnit:buffClear({ key = "烈分领域分烧" })
                end)
        end),
    AbilityTpl()
        :name("天星冲击")
        :targetType(ABILITY_TARGET_TYPE.tag_circle)
        :icon("ability/FireBoom")
        :coolDownAdv(15, 0)
        :mpCostAdv(150, 0)
        :castChantAdv(1, 0)
        :castRadiusAdv(200, 0)
        :castDistanceAdv(300, 0)
        :castTargetFilter(CAST_TARGET_FILTER.enemyAbility)
        :description(
        function(obj)
            local radius = obj:castRadius()
            local stun = 4
            return {
                "从天而降火焰对半径" .. radius .. "爆破一击",
                "范围内的敌人都会被附着3层的火元素",
                "并会在 " .. stun .. " 秒陷入眩晕状态",
                colour.hex(colour.yellow, "在雨天天气下，眩晕时长减半")
            }
        end)
        :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
        :pasConvTo(
        function(this)
            this:prop("description", function(obj)
                local radius = obj:castRadius()
                local stun = 4
                return {
                    "从天而降火焰对半径" .. radius .. "爆破一击",
                    "范围内的敌人都会被附着3层的火元素",
                    "并会在 " .. stun .. " 秒陷入眩晕状态",
                    colour.hex(colour.yellow, "在雨天天气下，眩晕时长减半")
                }
            end)
            this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
                this:effective({
                    targetX = attackData.targetUnit:x(),
                    targetY = attackData.targetUnit:y(),
                    targetZ = nil,
                })
            end)
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = effectiveData.targetX, effectiveData.targetY
            local ab = effectiveData.triggerAbility
            local radius = ab:castRadius()
            local stun = 4
            if (Game():isWeather("rain")) then
                stun = stun * 0.5
            end
            Effect("eff/CharmSeal", x, y, japi.Z(x, y) + 50, 1.5):size(radius / 130)
            local g = Group():catch(UnitClass, {
                circle = { x = x, y = y, radius = radius },
                filter = function(enumUnit)
                    return ab:isCastTarget(enumUnit)
                end
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    eu:effect("FireLordDeathExplode", 1)
                    ability.stun({ sourceUnit = u, targetUnit = eu, duration = stun, odds = 100, effect = "StasisTotemTarget" })
                    enchant.append(eu, DAMAGE_TYPE.fire, 3, u)
                end
            end
        end),
    AbilityTpl()
        :name("魔躯火身")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Firepaw2")
        :description(
        {
            "感受火魔的炎躯",
            "将至同化，附于己身",
            colour.hex(colour.gold, "永久") .. "为自己" .. colour.hex(colour.indianred, "火附着"),
            "在这种状态下",
            colour.hex(colour.gold, "被击中的敌人火抗性会") .. colour.hex(colour.indianred, "在3秒内下降5%"),
        })
        :onEvent(EVENT.Ability.Get, function(getData) enchant.append(getData.triggerUnit, DAMAGE_TYPE.fire, -1) end)
        :onEvent(EVENT.Ability.Lose, function(loseData) enchant.subtract(loseData.triggerUnit, DAMAGE_TYPE.fire, -1) end)
        :onUnitEvent(EVENT.Unit.Attack,
        function(attackData)
            attackData.targetUnit
                      :buff("魔躯火身")
                      :signal(BUFF_SIGNAL.down)
                      :name("魔火减抗")
                      :icon("ability/Firepaw2")
                      :description({ "白气弥漫", colour.hex(colour.red, "火抗性：-5%") })
                      :duration(3)
                      :purpose(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.fire, "-=5") end)
                      :rollback(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.fire, "+=5") end)
                      :run()
        end),
    AbilityTpl()
        :name("焱魔火球术")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/Firepaw")
        :description(
        {
            "融合焱魔的烈焰，将普攻",
            "转变为3附着的" .. colour.hex(colour.gold, "[焱魔火球]"),
            "附魔：" .. colour.hex(colour.littlepink, "火焰"),
            "优先级：" .. colour.hex(colour.skyblue, 5),
        })
        :attributes({ { "attackRange", 300, 0 } })
        :onEvent(EVENT.Ability.Get,
        function(glData)
            local mode = AttackMode()
                :mode("missile")
                :damageType(DAMAGE_TYPE.fire)
                :damageTypeLevel(3)
                :missileModel("DemonHunterMissile")
                :height(200)
                :speed(600)
                :priority(5)
            glData.triggerUnit:prop("火魔的火球", mode)
            glData.triggerUnit:attackModePush(mode)
            glData.triggerUnit:attackModeRemove()
        end)
        :onEvent(EVENT.Ability.Lose,
        function(glData)
            local mode = glData.triggerUnit:prop("火魔的火球")
            glData.triggerUnit:attackModeRemove(mode:id())
            glData.triggerUnit:clear("火魔的火球")
        end),
    AbilityTpl()
        :name("闪狐遁")
        :coolDownAdv(23, 0)
        :mpCostAdv(75, 0)
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/RacialFireresist")
        :description(
        function(obj)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:move()) * 0.6
            else
                dmg = "移动x0.6"
            end
            return {
                "在当前位置召唤一团六狐星阵",
                "狐火在" .. colour.hex(colour.gold, "3秒") .. "后引爆",
                "召唤后会进入隐形状态，直到狐火引爆消失",
                "引爆火伤害：" .. colour.hex(colour.indianred, dmg),
                "引爆半径：" .. colour.hex(colour.violet, 128),
            }
        end)
        :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), nil) end)
        :pasConvTo(
        function(this)
            this:prop("description", function(obj)
                local dmg
                local bu = obj:prop("bindUnit")
                if (isClass(bu, UnitClass)) then
                    dmg = math.floor(bu:move()) * 0.6
                else
                    dmg = "移动x0.6"
                end
                return {
                    "当移动时会在当前位置召唤一团六狐星阵",
                    "狐火在" .. colour.hex(colour.gold, "3秒") .. "后引爆",
                    "召唤后会进入隐形状态，直到狐火引爆消失",
                    "引爆火伤害：" .. colour.hex(colour.indianred, dmg),
                    "引爆半径：" .. colour.hex(colour.violet, 128),
                }
            end)
            this:bindUnit():onEvent(EVENT.Unit.Moving, this:id(), function()
                this:effective()
            end)
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local p = u:owner()
            local dmg = math.floor(u:move() * 0.6)
            local x, y = u:x(), u:y()
            local e = Effect("aura/SixPointedStarDemonArray", x, y, 0, -1):size(0.9)
            u:buff("闪狐遁")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/RacialFireresist")
             :description("处于闪狐遁中")
             :duration(3)
             :purpose(function(buffObj)
                buffObj:superposition("invisible", "+=1")
            end)
             :rollback(function(buffObj)
                buffObj:superposition("invisible", "-=1")
                destroy(e)
                effector("eff/BloodExplosion2", x, y, nil, 1)
                Group():forEach(UnitClass, {
                    filter = function(enumObj) return enumObj:isAlive() and enumObj:isEnemy(p) end,
                    circle = { x = x, y = y, radius = 128 },
                }, function(enumObj)
                    ability.damage({
                        sourceUnit = u,
                        targetUnit = enumObj,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.ability,
                        damageType = DAMAGE_TYPE.fire,
                        damageTypeLevel = 1,
                    })
                end)
            end)
             :run()
        end),
    AbilityTpl()
        :name("封火步")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/FireBurningSpeed")
        :description(
        {
            "移动步伐时的每一步",
            "都会提升火伤害加成",
            colour.format("转身或停下后效果继续持续%s秒", nil, { { colour.mintcream, 2 } }),
            colour.format("每步火伤加成：%s%", nil, { { colour.red, 1 } }),
            colour.hex(colour.yellow, "以上效果最高可叠加 100 层")
        })
        :onUnitEvent(EVENT.Unit.Moving,
        function(moveData)
            moveData.triggerUnit:attach("BreathOfFireDamage", "origin", 1)
            moveData.triggerAbility:effective()
        end)
        :onUnitEvent(EVENT.Unit.MoveTurn,
        function(moveData)
            moveData.triggerUnit:attach("BreathOfFireDamage", "origin", 1)
            moveData.triggerAbility:effective()
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local n = 1
            local b = u:buffOne("封火步")
            if (b) then
                n = b:prop("layer") or 1
                if (n < 100) then
                    n = n + 1
                end
                u:buffClear({ key = "封火步" })
            end
            local fire = n * 1
            b = u:buff("封火步")
            b:signal(BUFF_SIGNAL.up)
             :icon("ability/FireBurningSpeed")
             :text(colour.hex(colour.gold, n))
             :prop("layer", n)
             :description({
                colour.hex(colour.gold, n .. "步") .. "封火步",
                colour.hex(colour.lawngreen, "伤害加成：" .. fire .. '%')
            })
             :duration(2)
             :purpose(function(buffObj)
                buffObj:enchant(DAMAGE_TYPE.fire, "+=" .. fire)
            end)
             :rollback(function(buffObj)
                buffObj:enchant(DAMAGE_TYPE.fire, "-=" .. fire)
            end)
             :run()
        end),
    AbilityTpl()
        :name("火焰免疫")
        :coolDownAdv(20, 0)
        :mpCostAdv(50, 0)
        :targetType(ABILITY_TARGET_TYPE.tag_nil)
        :icon("ability/FireMan")
        :description(
        function()
            return {
                "短时间内对火焰伤害完全免疫",
                "持续时间：" .. colour.hex(colour.skyblue, "5秒"),
            }
        end)
        :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.BeforeHurt, this:id(), nil) end)
        :pasConvTo(
        function(this)
            this:prop("description", function()
                return {
                    "受伤前可进入对火焰伤害完全免疫状态",
                    "持续时间：" .. colour.hex(colour.skyblue, "5秒"),
                }
            end)
            this:bindUnit():onEvent(EVENT.Unit.BeforeHurt, this:id(), function()
                this:effective()
            end)
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            u:buff("火焰免疫")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/FireMan")
             :description("处于火焰免疫中")
             :duration(5)
             :purpose(function(buffObj)
                buffObj:attach("buff/Bullerouge", "origin")
                buffObj:enchantImmune(DAMAGE_TYPE.fire, "+=1")
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/Bullerouge", "origin")
                buffObj:enchantImmune(DAMAGE_TYPE.fire, "-=1")
            end)
             :run()
        end),
    AbilityTpl()
        :name("烬灭转化")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/DazzleBlastingCenter")
        :description(
        {
            "所有技能(包括物品技能)冷却减少 " .. colour.hex(colour.gold, "1秒"),
            "使已学到的 " .. colour.hex(colour.gold, "泠技·主动技能"),
            "全部转变为 " .. colour.hex(colour.skyblue, "泠技·被动技能"),
            colour.hex(colour.silver, "不同技能转化后触发被动条件并不相同")
        })
        :onEvent(EVENT.Ability.Get,
        function(abData)
            abData.triggerUnit:coolDown("-=1")
            local gd = Game():GD()
            local slot = abData.triggerUnit:abilitySlot()
            if (isClass(slot, AbilitySlotClass)) then
                local ss = slot:storage()
                for i = 1, gd.abilityTail do
                    local ab = ss[i]
                    if (isClass(ab, AbilityClass)) then
                        ab:pasConvTo()
                    end
                end
            end
            abData.triggerUnit:onEvent(EVENT.Ability.Get, "烬灭转化", function(abData2)
                abData2.triggerAbility:pasConvTo()
            end)
            abData.triggerUnit:onEvent(EVENT.Ability.Lose, "烬灭转化", function(abData2)
                abData2.triggerAbility:pasConvBack()
            end)
        end)
        :onEvent(EVENT.Ability.Lose,
        function(abData)
            abData.triggerUnit:coolDown("+=1")
            abData.triggerUnit:onEvent(EVENT.Ability.Get, "烬灭转化", nil)
            abData.triggerUnit:onEvent(EVENT.Ability.Lose, "烬灭转化", nil)
            local gd = Game():GD()
            local slot = abData.triggerUnit:abilitySlot()
            if (isClass(slot, AbilitySlotClass)) then
                local ss = slot:storage()
                for i = 1, gd.abilityTail do
                    local ab = ss[i]
                    if (isClass(ab, AbilityClass)) then
                        ab:pasConvBack()
                    end
                end
            end
        end)
}
local s = Store("fire")
s:name("火焰山泠技")
s:description(function(this)
    return {
        this:name() .. "(" .. colour.hex(colour.gold, "U") .. ")",
        "纪录在这里",
        "可随时使用"
    }
end)
local c = s:salesGoods():count()
for i = 1, #TPL_ABILITY_FIRE, 1 do
    local v = TPL_ABILITY_FIRE[i]
    v:prop("idx", 100 * i)
    if (i > 1) then
        local j = i - 1
        v:condition(function() return Game():GD().fireLevel >= j end)
         :conditionTips("火焰山挑战通过" .. colour.hex(colour.red, "Lv" .. j))
         :conditionPassTips("已获得")
    end
    if (i > c) then
        s:insert(v)
    end
end