TPL_ABILITY_SOUL[32] = AbilityTpl()
    :name("恶魔化身")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/WarlockDemonicPower")
    :coolDownAdv(90, 0)
    :mpCostAdv(160, 10)
    :castChantAdv(0.75, 0)
    :castChantEffect("eff/CallOfDreadPurple")
    :description(
    function(obj)
        local lv = obj:level()
        local hp, mp = (425 + lv * 75), (225 + lv * 35)
        local atk = 53 + lv * 7
        local atkSpd = 17 + lv * 2
        local atkRng = 230 + lv * 15
        local move = 85 + lv * 5
        local hurtIncrease = 7 + lv * 1
        local light = 12 + lv * 3
        return {
            "化身成为邪堕恶魔20秒",
            "HP、MP上限得到提升",
            "速度、攻击、范围也急剧提升",
            "攻击模式化为黑暗毒性球",
            "但受伤加深并降低了对光伤害的抗性",
            colour.hex(colour.gold, "HP/MP提升：" .. hp .. '/' .. mp),
            colour.hex(colour.lawngreen, "攻击提升：" .. atk),
            colour.hex(colour.lawngreen, "攻击速度提升：" .. atkSpd .. '%'),
            colour.hex(colour.lawngreen, "攻击范围提升：" .. atkRng),
            colour.hex(colour.lawngreen, "移动速度提升：" .. move),
            colour.hex(colour.indianred, "受伤加深：" .. hurtIncrease .. '%'),
            colour.hex(colour.indianred, "光抗性降低：" .. light .. '%'),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local hp, mp = (425 + lv * 75), (225 + lv * 35)
            local atk = 53 + lv * 7
            local atkSpd = 17 + lv * 2
            local atkRng = 230 + lv * 15
            local move = 85 + lv * 5
            local hurtIncrease = 7 + lv * 1
            local light = 12 + lv * 3
            return {
                "当攻击击中时有30%的几率",
                "化身成为邪堕恶魔20秒",
                "HP、MP上限得到提升",
                "速度、攻击、范围也急剧提升",
                "攻击模式化为黑暗毒性球",
                "但受伤加深并降低了对光伤害的抗性",
                colour.hex(colour.gold, "HP/MP提升：" .. hp .. '/' .. mp),
                colour.hex(colour.lawngreen, "攻击提升：" .. atk),
                colour.hex(colour.lawngreen, "攻击速度提升：" .. atkSpd .. '%'),
                colour.hex(colour.lawngreen, "攻击范围提升：" .. atkRng),
                colour.hex(colour.lawngreen, "移动速度提升：" .. move),
                colour.hex(colour.indianred, "受伤加深：" .. hurtIncrease .. '%'),
                colour.hex(colour.indianred, "光抗性降低：" .. light .. '%'),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function()
            if (math.rand(1, 10) <= 3) then
                this:effective()
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local hp, mp = (425 + lv * 75), (225 + lv * 35)
        local atk = 53 + lv * 7
        local atkSpd = 17 + lv * 2
        local atkRng = 230 + lv * 15
        local move = 85 + lv * 5
        local hurtIncrease = 7 + lv * 1
        local light = 12 + lv * 3
        local icon = u:icon()
        local modelAlias = u:modelAlias()
        local weaponSound = u:weaponSound()
        local weaponLength = u:weaponLength()
        local weaponHeight = u:weaponHeight()
        local scale = u:scale()
        u:effect("eff/BlackExplosion", 2)
        u:buff("恶魔化身")
         :icon("ability/WarlockDemonicPower")
         :description({
            colour.hex(colour.lawngreen, "HP：+" .. hp),
            colour.hex(colour.lawngreen, "MP：+" .. mp),
            colour.hex(colour.lawngreen, "攻击：+" .. atk),
            colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%'),
            colour.hex(colour.lawngreen, "攻击范围：+" .. atkRng),
            colour.hex(colour.lawngreen, "移动：+" .. move),
            colour.hex(colour.lawngreen, "受伤：+" .. hurtIncrease .. '%'),
            colour.hex(colour.indianred, "光抗：-" .. light .. '%'),
        })
         :duration(20)
         :purpose(function(buffObj)
            buffObj:icon("unit/Demon")
            buffObj:modelAlias("EvilIllidan")
            buffObj:animateProperties("Alternate", true)
            buffObj:clear("weaponSound")
            buffObj:weaponLength(140)
            buffObj:weaponHeight(160)
            buffObj:scale(2.3)
            buffObj:stature("+=50")
            buffObj:attackModePush(AttackModeStatic("恶魔形态" .. buffObj:id())
                :mode("missile"):homing(true)
                :missileModel("DemonHunterMissile")
                :damageType(DAMAGE_TYPE.poison):damageTypeLevel(3))
            buffObj:hp("+=" .. hp)
            buffObj:mp("+=" .. mp)
            buffObj:attack("+=" .. atk)
            buffObj:attackSpeed("+=" .. atkSpd)
            buffObj:attackRange("+=" .. atkRng)
            buffObj:move("+=" .. move)
            buffObj:hurtIncrease("+=" .. hurtIncrease)
            buffObj:enchantResistance(DAMAGE_TYPE.light, "-=" .. light)
            async.call(buffObj:owner(), function() UI_NinegridsInfo:updated() end)
        end)
         :rollback(function(buffObj)
            buffObj:effect("eff/BlackExplosion", 1)
            buffObj:icon(icon)
            buffObj:modelAlias(modelAlias)
            buffObj:animateProperties("Alternate", false)
            buffObj:weaponSound(weaponSound)
            buffObj:weaponLength(weaponLength)
            buffObj:weaponHeight(weaponHeight)
            buffObj:scale(scale)
            buffObj:stature("-=50")
            buffObj:attackModeRemove(AttackModeStatic("恶魔形态" .. buffObj:id()):id())
            buffObj:hp("-=" .. hp)
            buffObj:mp("-=" .. mp)
            buffObj:attack("-=" .. atk)
            buffObj:attackSpeed("-=" .. atkSpd)
            buffObj:attackRange("-=" .. atkRng)
            buffObj:move("-=" .. move)
            buffObj:hurtIncrease("-=" .. hurtIncrease)
            buffObj:enchantResistance(DAMAGE_TYPE.light, "+=" .. light)
            async.call(buffObj:owner(), function() UI_NinegridsInfo:updated() end)
        end)
         :run()
    end)