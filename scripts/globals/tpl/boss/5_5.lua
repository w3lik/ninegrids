TPL_ABILITY_BOSS["最终BOSS"] = {
    AbilityTpl()
        :name("无我镜像")
        :targetType(ABILITY_TARGET_TYPE.pas)
        :icon("ability/PurpleCapeMonster")
        :coolDownAdv(30, 0)
        :castChantAdv(1, 0)
        :castKeepAdv(3, 0)
        :description(
        function()
            return {
                "复制伤害最终BOSS的形态，且变得更加巨大",
                "同时获得映射当前泠" .. colour.hex(colour.gold, "1个泠技和泠器"),
                "再从界英泠映射得到" .. colour.hex(colour.gold, "1个泠技和泠器"),
                "被复制的物体将达到" .. colour.hex(colour.gold, "最强最高的等级"),
                "并且会自动清理冷却时间",
                colour.hex(colour.violet, "复制中途被打断时，最终BOSS会被眩晕3秒"),
            }
        end)
        :onUnitEvent(EVENT.Unit.Hurt,
        function(hurtData)
            local me = Game():GD().me
            local su = hurtData.sourceUnit
            if (math.rand(1, 100) <= 15 and me == su) then
                local isAllow = true
                local buffBans = { "狂将形态", "侠客形态", "清醒梦游荡", "恶魔化身" }
                for _, b in ipairs(buffBans) do
                    if (su:buffHas(b)) then
                        isAllow = false
                        break
                    end
                end
                if (isAllow) then
                    hurtData.triggerAbility:effective({
                        targetUnit = hurtData.sourceUnit
                    })
                end
            end
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            local x, y = u:x(), u:y()
            local tu = effectiveData.targetUnit
            if (u:buffHas("无我镜像")) then
                effector("eff/CallOfDreadRed", x, y, nil, 1)
                u:buffClear({ key = "无我镜像" })
            end
            local ti = 0
            local frq = 0.3
            time.setInterval(frq, function(curTimer)
                ti = ti + 1
                if (ti < 10) then
                    if (u:isDead()) then
                        destroy(curTimer)
                    elseif (u:isAbilityKeepCasting() == false or u:isInterrupt()) then
                        destroy(curTimer)
                        async.call(tu:owner(), function()
                            UI_NinegridsInfo:info("info", 3, "复制中途被打断，最终BOSS被眩晕3秒")
                            ability.stun({
                                targetUnit = u,
                                duration = 3,
                            })
                        end)
                    end
                else
                    destroy(curTimer)
                    effector("eff/CallOfDreadGreen", x, y, nil, 1)
                    u:attach("eff/CallOfDreadGreen", "overhead", 1)
                    for f = 1, 5, 1 do
                        time.setTimeout(0.05 * f, function()
                            local ex, ey = vector2.polar(x, y, math.rand(50, 150), 72 * f)
                            Effect("PossessionTarget", ex, ey, 30 + japi.Z(ex, ey), 1):size(2)
                        end)
                    end
                    local mirror = "镜像 · " .. tu:name()
                    local attackMode = tu:attackMode()
                    local fromTpl = u:tpl()
                    local fromModelAlias = u:modelAlias()
                    local fromSpeechAlias = u:speechAlias()
                    local fromMaterial = u:material()
                    local fromMoveType = u:moveType()
                    local fromWeaponSound = u:weaponSound()
                    local fromWeaponSoundMode = u:weaponSoundMode()
                    local fromEnchantMaterial = u:enchantMaterial()
                    local fromCastAnimation = u:castAnimation()
                    local fromKeepAnimation = u:keepAnimation()
                    local toTpl = tu:tpl()
                    local toModelAlias = tu:modelAlias()
                    local toSpeechAlias = tu:speechAlias()
                    local toMaterial = tu:material()
                    local toMoveType = tu:moveType()
                    local toWeaponSound = tu:weaponSound()
                    local toWeaponSoundMode = tu:weaponSoundMode()
                    local toEnchantMaterial = tu:enchantMaterial()
                    local toCastAnimation = tu:castAnimation()
                    local toKeepAnimation = tu:keepAnimation()
                    local changeData = {}
                    local changeKeys = {
                        "modelScale", "scale", "stature", "attackPoint", "weaponLength", "weaponHeight",
                        "hp", "mp", "attack", "defend", "move", "attackSpaceBase", "attackRange", "attackRipple",
                        SYMBOL_MUT .. "hp",
                        SYMBOL_MUT .. "attack",
                        SYMBOL_MUT .. "attackSpeed",
                        SYMBOL_MUT .. "defend",
                        "crit", SYMBOL_ODD .. "crit",
                        "stun", SYMBOL_ODD .. "stun",
                        "hpRegen", "mpRegen", "shield",
                        "attackSpeed", "avoid", "aim", "sight",
                        "damageIncrease", "hurtReduction"
                    }
                    for _, k in ipairs(ENCHANT_TYPES) do
                        table.insert(changeKeys, SYMBOL_E .. k)
                        table.insert(changeKeys, SYMBOL_EI .. k)
                        table.insert(changeKeys, SYMBOL_RES .. SYMBOL_E .. k)
                    end
                    for _, k in ipairs(changeKeys) do
                        local val = (toTpl:prop(k) or 0)
                        if (k == "modelScale" or k == "scale" or k == "stature") then
                            val = val * 1.7
                        end
                        if (k == "weaponLength" or k == "weaponHeight") then
                            val = val * 1.3
                        end
                        changeData[k] = val - (fromTpl:prop(k) or 0)
                    end
                    u:buff("无我镜像")
                     :icon("ability/PurpleCapeMonster")
                     :description({ colour.hex(colour.gold, "变成" .. mirror .. "了") })
                     :duration(-1)
                     :purpose(function(buffObj)
                        buffObj:attackModePush(attackMode)
                        buffObj:modelAlias(toModelAlias)
                        buffObj:material(toMaterial)
                        buffObj:moveType(toMoveType)
                        buffObj:weaponSoundMode(toWeaponSoundMode)
                        if (toWeaponSound) then
                            buffObj:weaponSound(toWeaponSound)
                        else
                            buffObj:clear("weaponSound")
                        end
                        local eao = buffObj:enchantMaterial()
                        if (eao) then
                            enchant.subtract(buffObj, eao, enchant._material)
                            buffObj:clear("enchantMaterial")
                        end
                        if (toEnchantMaterial) then
                            buffObj:enchantMaterial(toEnchantMaterial)
                        end
                        if (toCastAnimation) then
                            buffObj:castAnimation(toCastAnimation)
                        else
                            buffObj:clear("castAnimation")
                        end
                        if (toKeepAnimation) then
                            buffObj:keepAnimation(toKeepAnimation)
                        else
                            buffObj:clear("keepAnimation")
                        end
                        for _, k in ipairs(changeKeys) do
                            if (changeData[k] > 0) then
                                buffObj:prop(k, "+=" .. changeData[k])
                            elseif (changeData[k] < 0) then
                                buffObj:prop(k, "-=" .. math.abs(changeData[k]))
                            end
                        end
                        buffObj:speechAlias(toSpeechAlias)
                    end)
                     :rollback(function(buffObj)
                        buffObj:attackModeRemove(attackMode)
                        buffObj:modelAlias(fromModelAlias)
                        buffObj:material(fromMaterial)
                        buffObj:moveType(fromMoveType)
                        buffObj:weaponSoundMode(fromWeaponSoundMode)
                        if (fromWeaponSound) then
                            buffObj:weaponSound(fromWeaponSound)
                        else
                            buffObj:clear("weaponSound")
                        end
                        local eao = buffObj:enchantMaterial()
                        if (eao) then
                            enchant.subtract(buffObj, fromEnchantMaterial, enchant._material)
                            buffObj:clear("enchantMaterial")
                        end
                        if (fromEnchantMaterial) then
                            buffObj:enchantMaterial(fromEnchantMaterial)
                        end
                        if (fromCastAnimation) then
                            buffObj:castAnimation(fromCastAnimation)
                        else
                            buffObj:clear("castAnimation")
                        end
                        if (fromKeepAnimation) then
                            buffObj:keepAnimation(fromKeepAnimation)
                        else
                            buffObj:clear("keepAnimation")
                        end
                        for _, k in ipairs(changeKeys) do
                            if (changeData[k] > 0) then
                                buffObj:prop(k, "-=" .. changeData[k])
                            elseif (changeData[k] < 0) then
                                buffObj:prop(k, "+=" .. math.abs(changeData[k]))
                            end
                        end
                        buffObj:speechAlias(fromSpeechAlias)
                    end)
                     :run()
                    local abTmp = {}
                    local itTmp = {}
                    local abSlot = tu:abilitySlot()
                    local storage = abSlot:storage()
                    for i = 1, abSlot:volume(), 1 do
                        if (isClass(storage[i], AbilityClass)) then
                            table.insert(abTmp, storage[i]:tpl())
                        end
                    end
                    local itSlot = tu:itemSlot()
                    storage = itSlot:storage()
                    for i = 1, itSlot:volume(), 1 do
                        if (isClass(storage[i], AbilityClass)) then
                            table.insert(itTmp, storage[i]:tpl())
                        end
                    end
                    local total = 2
                    local abTpl = {}
                    local itTpl = {}
                    if (#abTmp > 0) then
                        table.insert(abTpl, table.rand(abTmp, 1))
                    end
                    if (#itTmp > 0) then
                        table.insert(itTpl, table.rand(itTmp, 1))
                    end
                    local abFill = {
                        TPL_ABILITY_BOSS["亡泠(死骑)"][1],
                        TPL_ABILITY_BOSS["影泠(无踪刺客)"][2],
                        TPL_ABILITY_BOSS["匠泠(军技师)"][2],
                        TPL_ABILITY_BOSS["蛛泠(牙杀至咬)"][1],
                        TPL_ABILITY_BOSS["蛇妖泠(美杜莎)"][2],
                        TPL_ABILITY_BOSS["剑泠(疾风)"][2],
                        TPL_ABILITY_BOSS["狂泠(战)"][2],
                        TPL_ABILITY_BOSS["霜泠(巫妖)"][1],
                        TPL_ABILITY_BOSS["毒泠(怪萌)"][3],
                        TPL_ABILITY_BOSS["刍泠(噩法师)"][3],
                        TPL_ABILITY_BOSS["剑泠(阎殇)"][2], TPL_ABILITY_BOSS["剑泠(阎殇)"][3],
                        TPL_ABILITY_BOSS["汐泠(卫将)"][3],
                        TPL_ABILITY_BOSS["花泠(小鹿)"][3],
                        TPL_ABILITY_BOSS["熊猫泠(醉仙)"][2],
                        TPL_ABILITY_BOSS["酋泠(牛头人)"][1], TPL_ABILITY_BOSS["酋泠(牛头人)"][3],
                        TPL_ABILITY_BOSS["龙泠(青龙拳师)"][2],
                        TPL_ABILITY_BOSS["旅泠(方长)"][1], TPL_ABILITY_BOSS["旅泠(方长)"][2],
                        TPL_ABILITY_BOSS["剑泠(缠水)"][3],
                        TPL_ABILITY_BOSS["枪泠(电弧鼠)"][1], TPL_ABILITY_BOSS["枪泠(电弧鼠)"][2],
                        TPL_ABILITY_BOSS["夜泠(游侠)"][2],
                        TPL_ABILITY_BOSS["魔泠(恶魔猎手)"][3],
                        TPL_ABILITY_BOSS["剑泠(黑月)"][2],
                        TPL_ABILITY_BOSS["骷髅泠(骨王)"][3],
                        TPL_ABILITY_BOSS["焰泠(鬼火灵)"][3], TPL_ABILITY_BOSS["焰泠(鬼火灵)"][4],
                        TPL_ABILITY_BOSS["海皇泠(鲨煌)"][3], TPL_ABILITY_BOSS["海皇泠(鲨煌)"][4],
                        TPL_ABILITY_BOSS["灭泠(巨鹿魔)"][3], TPL_ABILITY_BOSS["灭泠(巨鹿魔)"][4],
                        TPL_ABILITY_BOSS["祭泠(弋洛伽)"][4],
                        TPL_ABILITY_BOSS["沙泠(法老尸)"][2], TPL_ABILITY_BOSS["沙泠(法老尸)"][4],
                        TPL_ABILITY_BOSS["初生至泠(雷霆战鬼)"][2],
                        TPL_ABILITY_BOSS["洞悉至泠(噬灵妖怪)"][1], TPL_ABILITY_BOSS["洞悉至泠(噬灵妖怪)"][2],
                        TPL_ABILITY_BOSS["破灭至泠(狱炎爆蜥)"][1], TPL_ABILITY_BOSS["破灭至泠(狱炎爆蜥)"][3],
                        TPL_ABILITY_BOSS["觉醒至泠(人屠杀神)"][1], TPL_ABILITY_BOSS["觉醒至泠(人屠杀神)"][4],
                    }
                    while (#abTpl < total) do
                        table.insert(abTpl, abFill[math.rand(1, #abFill)])
                    end
                    while (#itTpl < total) do
                        table.insert(itTpl, TPL_SACRED[math.rand(1, 48)])
                    end
                    local rAIdx = table.rand({ 2, 3, 4, 5 }, total)
                    local rIIdx = table.rand({ 1, 2, 3, 4, 5, 6 }, total)
                    abSlot = u:abilitySlot()
                    itSlot = u:itemSlot()
                    for i = 1, total do
                        abSlot:remove(rAIdx[i])
                        itSlot:remove(rIIdx[i])
                        local ab = Ability(abTpl[i])
                        local lvMax = ab:levelMax()
                        ab:level(lvMax)
                        abSlot:insert(ab, rAIdx[i])
                        ab:bossConv()
                        local it = Item(itTpl[i])
                        lvMax = it:levelMax()
                        it:level(lvMax)
                        it:attributes(it:prop("forgeList")[lvMax])
                        Game():bossSpell(it:ability())
                        itSlot:insert(it, rIIdx[i])
                    end
                end
            end)
        end),
}