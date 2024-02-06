TPL_ABILITY_SOUL[12] = AbilityTpl()
    :name("撕裂伤口")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/Bleedingcutting")
    :description(
    function(obj)
        local lv = obj:level()
        local hpRegen = 4 + lv * 0.7
        local dur = 2
        return {
            "攻击会使得木飙产生伤口" .. colour.hex(colour.skyblue, "持续" .. dur .. "秒"),
            colour.hex(colour.indianred, "伤口会降低木飙的HP恢复" .. hpRegen .. "点"),
            colour.hex(colour.indianred, "而木飙已有伤口时，会使得伤势加重最多3次"),
            colour.hex(colour.violet, "当伤口达到3个时，会额外降低木飙的毒抗性10%"),
            "并且木飙的攻击者将吸取木飙伤害量10%的HP",
        }
    end)
    :onUnitEvent(EVENT.Unit.Attack,
    function(attackData)
        local u = attackData.triggerUnit
        local tu = attackData.targetUnit
        local lv = attackData.triggerAbility:level()
        local hpRegen = 4 + lv * 0.7
        local dur = 2
        local n = tu:buffCount("撕裂伤口")
        if (n < 3) then
            hpRegen = hpRegen + n * 3
            tu:buff("撕裂伤口")
              :name("撕裂伤口" .. (n + 1) .. "重")
              :signal(BUFF_SIGNAL.down)
              :icon("ability/Bleedingcutting")
              :description({ colour.hex(colour.indianred, "HP恢复：-" .. hpRegen) })
              :duration(dur)
              :purpose(function(buffObj)
                if (n >= 2) then buffObj:attach("buff/FatalWoundV2", "chest", -1) end
                if (n >= 1) then buffObj:attach("buff/Hemorrhage", "overhead", -1) end
                buffObj:attach("buff/Hemorrhage", "head", -1)
                buffObj:hpRegen("-=" .. hpRegen)
            end)
              :rollback(function(buffObj)
                if (n >= 2) then buffObj:detach("buff/FatalWoundV2", "chest") end
                if (n >= 1) then buffObj:detach("buff/Hemorrhage", "overhead") end
                buffObj:detach("buff/Hemorrhage", "head")
                buffObj:hpRegen("+=" .. hpRegen)
            end)
              :run()
        else
            tu:buff("撕裂伤口中毒")
              :signal(BUFF_SIGNAL.down)
              :icon("ability/Bleedingcutting")
              :description({ colour.hex(colour.indianred, "毒抗性：-10%") })
              :duration(dur / 2)
              :purpose(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.poison, "-=10") end)
              :rollback(function(buffObj) buffObj:enchantResistance(DAMAGE_TYPE.poison, "+=10") end)
              :run()
            u:hpBack(0.1 * attackData.damage)
            u:attach("AIheTarget", "origin", 1)
        end
    end)