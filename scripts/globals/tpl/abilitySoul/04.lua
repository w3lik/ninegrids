TPL_ABILITY_SOUL[4] = AbilityTpl()
    :name("快速杀意")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :coolDownAdv(15, -0.5)
    :mpCostAdv(30, 3)
    :icon("ability/RogueRedirect")
    :description(
    function(obj)
        local lv = obj:level()
        local def = 7 + lv * 3
        local atkSpd = 18 + lv * 3
        local dur = 1.8 + lv * 0.2
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            if (string.subPos(bu:name(), "杀") ~= -1) then
                dur = dur + 1
            end
        end
        return {
            "攻击前令木飙陷入恐惧，降低防御",
            "同时精神紧绷增快自身的攻击速度",
            colour.hex(colour.skyblue, "效果持续时间：" .. dur .. "秒"),
            colour.hex(colour.indianred, "木飙防御降低：" .. def),
            colour.hex(colour.lawngreen, "攻击速度增加：" .. atkSpd .. '%'),
            colour.hex(colour.yellow, "木飙为远程时持续时间增加1.5秒"),
        }
    end)
    :onUnitEvent(EVENT.Unit.BeforeAttack, function(beforeAttackData) beforeAttackData.triggerAbility:effective({ targetUnit = beforeAttackData.targetUnit }) end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        local lv = effectiveData.triggerAbility:level()
        local def = 7 + lv * 3
        local atkSpd = 18 + lv * 3
        local dur = 1.8 + lv * 0.2
        if (tu:isRanged()) then
            dur = dur + 1.5
        end
        u:buff("快速杀意")
         :signal(BUFF_SIGNAL.up)
         :icon("ability/RogueRedirect")
         :description({ colour.hex(colour.lawngreen, "攻速：+" .. atkSpd) })
         :duration(dur)
         :purpose(function(buffObj) buffObj:attackSpeed("+=" .. atkSpd) end)
         :rollback(function(buffObj) buffObj:attackSpeed("-=" .. atkSpd) end)
         :run()
        tu:buff("快速杀意")
          :name("杀意破防")
          :signal(BUFF_SIGNAL.down)
          :icon("ability/RogueRedirect")
          :description({ colour.hex(colour.indianred, "防御：-" .. def) })
          :duration(dur)
          :purpose(function(buffObj)
            buffObj:attach("buff/ArmorPenetrationOrange", "overhead")
            buffObj:defend("-=" .. def)
        end)
          :rollback(function(buffObj)
            buffObj:detach("buff/ArmorPenetrationOrange", "overhead")
            buffObj:defend("+=" .. def)
        end)
          :run()
    end)