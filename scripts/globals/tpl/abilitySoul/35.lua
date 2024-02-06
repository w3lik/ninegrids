TPL_ABILITY_SOUL[35] = AbilityTpl()
    :name("亡者至仪")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/Ghostarmy")
    :description(
    function(obj)
        local lv = obj:level()
        local hpRegen = 0.5 + lv * 0.2
        local move = 22 + lv * 3
        local atkSpd = 10 + lv * 3
        local steel = 10 + lv * 1
        return {
            "击杀木飙时，可恢复" .. colour.hex(colour.gold, hpRegen .. '%') .. "的HP",
            "且继而提升移动、攻速、钢强化 15 秒",
            colour.hex(colour.lawngreen, "移动提升：" .. move),
            colour.hex(colour.lawngreen, "攻速提升：" .. atkSpd .. '%'),
            colour.hex(colour.lawngreen, "钢强化：" .. steel .. '%'),
            colour.hex(colour.yellow, "最多可叠加至 4 层"),
        }
    end)
    :onUnitEvent(EVENT.Unit.Kill,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local hpRegen = 0.5 + lv * 0.2
        u:attach("AIheTarget", "origin", 1)
        u:hpBack(hpRegen * 0.01 * u:hp())
        local n = 1
        local b = u:buffOne("亡者至仪")
        if (b) then
            n = b:prop("layer") or 1
            if (n < 4) then
                n = n + 1
            end
            u:buffClear({ key = "亡者至仪" })
        end
        local move = n * (22 + lv * 3)
        local atkSpd = n * (10 + lv * 3)
        local steel = n * (10 + lv * 1)
        u:buff("亡者至仪")
         :icon("ability/Ghostarmy")
         :prop("layer", n)
         :text(colour.hex(colour.gold, n))
         :description({
            colour.hex(colour.gold, n .. "层") .. "仪式",
            colour.hex(colour.lawngreen, "移动：+" .. move),
            colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%'),
            colour.hex(colour.lawngreen, "钢强化：+" .. steel .. '%'),
        })
         :duration(15)
         :purpose(function(buffObj)
            buffObj:attach("buff/BurningRageGreen", "head")
            buffObj:move("+=" .. move)
            buffObj:attackSpeed("+=" .. atkSpd)
            buffObj:enchant(DAMAGE_TYPE.steel, "+=" .. steel)
        end)
         :rollback(function(buffObj)
            buffObj:detach("buff/BurningRageGreen", "head")
            buffObj:move("-=" .. move)
            buffObj:attackSpeed("-=" .. atkSpd)
            buffObj:enchant(DAMAGE_TYPE.steel, "-=" .. steel)
        end)
         :run()
    end)