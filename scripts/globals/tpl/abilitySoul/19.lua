TPL_ABILITY_SOUL[19] = AbilityTpl()
    :name("诡异秘术")
    :targetType(ABILITY_TARGET_TYPE.tag_nil)
    :icon("ability/ShadowEnslaveDemon")
    :coolDownAdv(60, -1)
    :mpCostAdv(125, -5)
    :description(
    function(obj)
        local lv = obj:level()
        local move = 60 + lv * 10
        local defend = 17 + lv * 7
        local damageIncrease = 10 + lv * 3
        return {
            "随机使一个技能[非物品]瞬间冷却",
            "只有已进入冷却的技能会被刷新",
            colour.hex(colour.gold, "如果不存在被刷新的技能，则自身能力提升10秒"),
            colour.hex(colour.lawngreen, "移动提升：" .. move),
            colour.hex(colour.lawngreen, "防御提升：" .. defend),
            colour.hex(colour.lawngreen, "伤害加成：" .. damageIncrease .. '%'),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local move = 60 + lv * 10
            local defend = 17 + lv * 7
            local damageIncrease = 10 + lv * 3
            return {
                "当被攻击命中时有50%几率",
                "随机使一个技能[非物品]瞬间冷却",
                "只有已进入冷却的技能会被刷新",
                colour.hex(colour.gold, "如果不存在被刷新的技能，则自身能力提升10秒"),
                colour.hex(colour.lawngreen, "移动提升：" .. move),
                colour.hex(colour.lawngreen, "防御提升：" .. defend),
                colour.hex(colour.lawngreen, "伤害加成：" .. damageIncrease .. '%'),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Be.Attack, this:id(), function()
            if (math.rand(1, 10) <= 5) then
                this:effective()
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local ss = u:abilitySlot():storage()
        local abs = {}
        for i = 1, (Game():GD().abilityTail + 1), 1 do
            local a = ss[i]
            if (isClass(a, AbilityClass) and a:name() ~= "诡异秘术" and a:isCooling()) then
                abs[#abs + 1] = a
            end
        end
        if (#abs <= 0) then
            local move = 25 + lv * 5
            local defend = 9 + lv * 3
            local damageIncrease = 7 + lv * 2
            u:buff("诡异秘术")
             :icon("ability/ShadowEnslaveDemon")
             :description({
                colour.hex(colour.lawngreen, "移动：+" .. move),
                colour.hex(colour.lawngreen, "防御：+" .. defend),
                colour.hex(colour.lawngreen, "伤害加成：+" .. damageIncrease .. '%'),
            })
             :duration(10)
             :purpose(function(buffObj)
                buffObj:attach("buff/SoulArmorIndigoOpt", "chest")
                buffObj:move("+=" .. move)
                buffObj:damageIncrease("+=" .. damageIncrease)
                buffObj:defend("+=" .. defend)
            end)
             :rollback(function(buffObj)
                buffObj:detach("buff/SoulArmorIndigoOpt", "chest")
                buffObj:move("-=" .. move)
                buffObj:damageIncrease("-=" .. damageIncrease)
                buffObj:defend("-=" .. defend)
            end)
             :run()
        else
            local abr = table.rand(abs, 1)
            abr:coolingInstant()
            audio(Vcm("war3_AutoCastButtonClick1"), u:owner())
        end
        abs = nil
    end)