TPL_SACRED[19] = ItemTpl()
    :name("刍咒骨符")
    :icon("item/BoneChimes")
    :modelAlias("item/Chimes")
    :description("使用怨气极大的羊骨制成的符链")
    :prop("forgeList",
    {
        { { "hpSuckAbility", 4 } },
        { { "hpSuckAbility", 6 } },
        { { "hpSuckAbility", 8 } },
        { { "hpSuckAbility", 9 } },
        { { "hpSuckAbility", 10 } },
        { { "hpSuckAbility", 13 } },
        { { "hpSuckAbility", 16 } },
        { { "hpSuckAbility", 18 } },
        { { "hpSuckAbility", 20 } },
        { { "hpSuckAbility", 25 } },
    })
    :ability(
    AbilityTpl()
        :name("刍咒骨符")
        :icon("item/BoneChimes")
        :targetType(ABILITY_TARGET_TYPE.tag_unit)
        :coolDownAdv(50, -1)
        :mpCostAdv(100, 5)
        :castDistanceAdv(400, 0)
        :castRadiusAdv(50, 0)
        :description(
        {
            colour.hex(colour.gold, "使用后你受到伤害时相连木飙相同承受"),
            colour.hex(colour.gold, "效果持续9秒"),
        })
        :castTargetFilter(CAST_TARGET_FILTER.enemySacred)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local u = effectiveData.triggerUnit
            if (event.syncHas(u, EVENT.Unit.Hurt, "刍咒骨符连命")) then
                async.call(u:owner(), function()
                    UI_NinegridsInfo:info("alert", 2, "已处在连命状态")
                end)
                return
            end
            local tu = effectiveData.targetUnit
            local dur = 9
            local b = u:buff("刍咒骨符连命")
            b:signal(BUFF_SIGNAL.up)
             :icon("item/BoneChimes")
             :description({ colour.hex(colour.lawngreen, "与你相连的木飙也会受到你所受至伤") })
             :duration(dur)
             :purpose(
                function(buffObj)
                    buffObj:onEvent(EVENT.Unit.Hurt, "刍咒骨符连命", function(hurtData)
                        if (isClass(hurtData.sourceUnit, UnitClass)) then
                            ability.damage({
                                sourceUnit = hurtData.sourceUnit,
                                targetUnit = hurtData.sourceUnit,
                                damageSrc = DAMAGE_SRC.item,
                                damageType = hurtData.damageType,
                                damageTypeLevel = 0,
                                damage = hurtData.damage,
                                breakArmor = { BREAK_ARMOR.defend, BREAK_ARMOR.avoid, BREAK_ARMOR.invincible }
                            })
                        end
                    end)
                end)
             :rollback(function(buffObj) buffObj:onEvent(EVENT.Unit.Hurt, "刍咒骨符连命", nil) end)
             :run()
            tu:buff("刍咒骨符连命")
              :signal(BUFF_SIGNAL.down)
              :icon("item/BoneChimes")
              :description({ colour.hex(colour.lawngreen, "会受到与你相连的木飙所受至伤") })
              :duration(dur)
              :purpose(
                function(buffObj)
                    local l = LightningChain(LIGHTNING_TYPE.soul, u, buffObj)
                    buffObj:prop("刍咒骨符L", l)
                end)
              :rollback(
                function(buffObj)
                    buffObj:clear("刍咒骨符L", true)
                    if (isClass(b, BuffClass) and b:isRunning()) then
                        b:back()
                    end
                end)
              :run()
        end))