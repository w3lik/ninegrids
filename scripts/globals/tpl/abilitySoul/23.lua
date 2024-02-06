TPL_ABILITY_SOUL[23] = AbilityTpl()
    :name("熊猫家族")
    :targetType(ABILITY_TARGET_TYPE.tag_loc)
    :icon("ability/PandaFamily")
    :coolDownAdv(140, 0)
    :mpCostAdv(180, 10)
    :castDistanceAdv(200, 0)
    :castChantAdv(1, 0)
    :castAnimation("spell throw")
    :description(
    function(obj)
        local lv = obj:level()
        local dur = 19 + lv * 1
        local atk = 50 + lv * 10
        local atkSpd = 25 + lv * 2
        local def = 15 + lv * 2
        local move = 31 + lv * 4
        return {
            "呼唤熊猫一族全家协助战斗！持续战斗" .. colour.hex(colour.gold, dur) .. "秒",
            "期间自己化身为[狂将]或[侠客]其中一种形态",
            "狂将：攻击增加" .. colour.hex(colour.gold, atk) .. "，防御增加" .. colour.hex(colour.gold, def),
            "侠客：攻速增加" .. colour.hex(colour.gold, atkSpd) .. "%，移动增加" .. colour.hex(colour.gold, move),
            "精英族人包含有：大地[岩]、雷电[雷]、烈焰[火]，免疫元素",
            "英勇族人包含有：铩羽[钢]、药师[草]、剑光[光]，泉老[水]",
            "每位族人能力都不一样，可研究发掘其能力",
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dur = 19 + lv * 1
            local atk = 50 + lv * 10
            local atkSpd = 25 + lv * 2
            local def = 15 + lv * 2
            local move = 31 + lv * 4
            return {
                "当被攻击时HP低于最大HP的65%",
                "呼唤熊猫一族全家协助战斗！持续战斗" .. colour.hex(colour.gold, dur) .. "秒",
                "期间自己化身为[狂将]或[侠客]其中一种形态",
                "狂将：攻击增加" .. colour.hex(colour.gold, atk) .. "，防御增加" .. colour.hex(colour.gold, def),
                "侠客：攻速增加" .. colour.hex(colour.gold, atkSpd) .. "%，移动增加" .. colour.hex(colour.gold, move),
                "精英族人有：大地[岩]、雷电[雷]、烈焰[火]，可免疫元素",
                "英勇族人有：铩羽[钢]、药师[毒]、剑光[光]",
                "参战族人有：泉老[水]、芳竹[草]",
                "每位族人能力都不一样，可研究发掘其能力",
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), function(beAttackData)
            local u = beAttackData.triggerUnit
            if (u:hpCur() < (u:hp() * 0.65)) then
                this:effective({
                    targetX = u:x(),
                    targetY = u:y(),
                    targetZ = u:z(),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local lv = effectiveData.triggerAbility:level()
        local x, y, z = effectiveData.targetX, effectiveData.targetY, effectiveData.targetZ
        local dur = 19 + lv * 1
        local hp1, hp2, hp3 = (500 + lv * 90), (330 + lv * 75), (150 + lv * 50)
        local atk1, atk2, atk3 = (u:attack() * 0.08 + lv * 7), (u:attack() * 0.06 + lv * 5), (u:attack() * 0.05 + lv * 3)
        local atk = 50 + lv * 10
        local def = 15 + lv * 2
        local atkSpd = 25 + lv * 2
        local move = 31 + lv * 4
        local icon = u:icon()
        local modelAlias = u:modelAlias()
        local weaponSound = u:weaponSound()
        if (math.rand(1, 2) == 1) then
            u:buff("狂将形态")
             :icon("unit/Pandaren_IronFist")
             :description({ colour.hex(colour.lawngreen, "攻击：+" .. atk), colour.hex(colour.lawngreen, "防御：+" .. def) })
             :duration(dur)
             :purpose(function(buffObj)
                buffObj:icon("unit/Pandaren_IronFist")
                buffObj:modelAlias("pandaren/Pandaren_IronFist")
                buffObj:weaponSound("metal_bash_heavy")
                buffObj:attackModePush(AttackModeStatic("狂将形态" .. buffObj:id())
                    :mode("missile")
                    :missileModel("slash/Coup_de_Grace")
                    :damageType(DAMAGE_TYPE.steel):damageTypeLevel(2))
                buffObj:attack("+=" .. atk)
                buffObj:defend("+=" .. def)
            end)
             :rollback(function(buffObj)
                buffObj:icon(icon)
                buffObj:modelAlias(modelAlias)
                buffObj:weaponSound(weaponSound)
                buffObj:attackModeRemove(AttackModeStatic("狂将形态" .. buffObj:id()):id())
                buffObj:attack("-=" .. atk)
                buffObj:defend("-=" .. def)
            end)
             :run()
        else
            u:buff("侠客形态")
             :icon("unit/Pandaren_Shado")
             :description({ colour.hex(colour.lawngreen, "攻速：+" .. atkSpd), colour.hex(colour.lawngreen, "移动：+" .. move) })
             :duration(dur)
             :purpose(function(buffObj)
                buffObj:icon("unit/Pandaren_Shado")
                buffObj:modelAlias("pandaren/Pandaren_Shado")
                buffObj:weaponSound("metal_slice_light")
                buffObj:attackModePush(AttackModeStatic("侠客形态" .. buffObj:id())
                    :mode("missile")
                    :missileModel("slash/BladeBeamFinal")
                    :damageType(DAMAGE_TYPE.wind):damageTypeLevel(2))
                buffObj:attackSpeed("+=" .. atkSpd)
                buffObj:move("+=" .. move)
                async.call(buffObj:owner(), function() UI_NinegridsInfo:updated() end)
            end)
             :rollback(function(buffObj)
                buffObj:icon(icon)
                buffObj:modelAlias(modelAlias)
                buffObj:weaponSound(weaponSound)
                buffObj:attackModeRemove(AttackModeStatic("侠客形态" .. buffObj:id()):id())
                buffObj:attackSpeed("-=" .. atkSpd)
                buffObj:move("-=" .. move)
                async.call(buffObj:owner(), function() UI_NinegridsInfo:updated() end)
            end)
             :run()
        end
        local pandas = {
            { TPL_UNIT.ABILITY_SOUL_PandaEarth, "missile/PsionicShotYellow", 150 },
            { TPL_UNIT.ABILITY_SOUL_PandaStorm, "missile/PsionicShotBlue", 150 },
            { TPL_UNIT.ABILITY_SOUL_PandaFire, "missile/PsionicShotRed", 150 },
            { TPL_UNIT.ABILITY_SOUL_PandaArcher, "missile/PsionicShotOrange", 300 },
            { TPL_UNIT.ABILITY_SOUL_PandaHarvester, "missile/PsionicShotPurple", 200 },
            { TPL_UNIT.ABILITY_SOUL_PandaHonorguard, "missile/PsionicShotSilver", 200 },
            { TPL_UNIT.ABILITY_SOUL_PandaSage, "missile/PsionicShotTeal", 300 },
            { TPL_UNIT.ABILITY_SOUL_PandaVulture, "missile/PsionicShotGreen", 400 },
        }
        for i, v in ipairs(pandas) do
            local angle = i * 51.4
            local tx, ty = vector2.polar(x, y, v[3], angle)
            ability.missile({
                modelAlias = v[2],
                sourceVec = { x, y, z + 100 },
                targetVec = { tx, ty, z + 100 },
                speed = 300,
                onEnd = function(_, vec)
                    local fu = Game():summons(u:owner(), v[1], vec[1], vec[2], 360 - angle)
                    fu:effect("eff/DifferentLanding", 1)
                    fu:mp(100):duration(dur)
                    if (i <= 3) then
                        fu:hp(hp1):attack(atk1)
                    elseif (i <= 6) then
                        fu:hp(hp2):attack(atk2)
                    else
                        fu:hp(hp3):attack(atk3)
                    end
                    fu:onEvent(EVENT.Object.Destruct, function(destroyData)
                        destroyData.triggerUnit:effect("eff/DifferentLiftoff", 1)
                    end)
                end
            })
        end
    end)