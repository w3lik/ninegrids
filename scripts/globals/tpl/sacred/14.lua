TPL_SACRED[14] = ItemTpl()
    :name("灵机芽种")
    :icon("item/StrangeSeeds")
    :modelAlias("item/StrangeSeeds")
    :description("蓬勃向上充满灵机的发芽种子")
    :prop("forgeList",
    {
        { { "mp", 50 }, { "mpRegen", 3 } },
        { { "mp", 70 }, { "mpRegen", 4 } },
        { { "mp", 90 }, { "mpRegen", 5 } },
        { { "mp", 110 }, { "mpRegen", 7 } },
        { { "mp", 130 }, { "mpRegen", 8 } },
        { { "mp", 160 }, { "mpRegen", 9 } },
        { { "mp", 200 }, { "mpRegen", 12 } },
        { { "mp", 230 }, { "mpRegen", 14 } },
        { { "mp", 250 }, { "mpRegen", 17 } },
        { { "mp", 300 }, { "mpRegen", 20 } },
    })
    :ability(
    AbilityTpl()
        :name("灵机芽种")
        :icon("item/StrangeSeeds")
        :targetType(ABILITY_TARGET_TYPE.tag_loc)
        :coolDownAdv(35, 0)
        :hpCostAdv(175, 15)
        :mpCostAdv(0, 0)
        :castDistanceAdv(500, 0)
        :description(
        function(this)
            local lv = this:level()
            local n = 1 + math.ceil(lv / 3)
            local hp = 300 + 125 * lv
            local atk = 50 + 10 * lv
            local def = 4 + 1 * lv
            local dur = 14 + 1 * lv
            local back = 42 + 3 * lv
            return {
                colour.hex(colour.gold, "召唤" .. atk .. "攻击力的" .. n .. "个树灵协助战斗"),
                colour.hex(colour.gold, "其为草体质、草免疫，" .. "HP" .. hp .. "，防御" .. def),
                colour.hex(colour.gold, "持续" .. dur .. "秒消失，若"),
                colour.hex(colour.gold, "当其枯萎时余下HP的" .. back .. "%将反补施法者"),
            }
        end)
        :onEvent(EVENT.Ability.Effective,
        function(effectiveData)
            local e = Effect("eff/NatureBlast", effectiveData.targetX, effectiveData.targetY, 30 + effectiveData.targetZ, 2)
            e:size(1.6)
            local u = effectiveData.triggerUnit
            local lv = effectiveData.triggerAbility:level()
            local n = 1 + math.ceil(lv / 3)
            local hp = 300 + 125 * lv
            local atk = 50 + 10 * lv
            local def = 4 + 1 * lv
            local dur = 14 + 1 * lv
            local back = 42 + 3 * lv
            for _ = 1, n do
                local x, y = vector2.polar(effectiveData.targetX, effectiveData.targetY, math.rand(50, 300), math.rand(0, 359))
                local facing = vector2.angle(effectiveData.triggerUnit:x(), effectiveData.triggerUnit:y(), x, y)
                local eu = Game():summons(effectiveData.triggerUnit:owner(), TPL_UNIT.Ent, x, y, facing)
                eu:effect("eff/WalkingChaos_ImpaleHit", 2)
                eu:period(dur):hp(hp):attack(atk):defend(def)
                eu:animate("birth")
                eu:onEvent(EVENT.Unit.Be.Kill, "Ent", function(beKillData)
                    if (isClass(u, UnitClass)) then
                        local tu = beKillData.triggerUnit
                        local hpCur = tu:hpCur()
                        if (hpCur > 0) then
                            tu:effect("eff/WalkingChaos_ImpaleHit", 2)
                            local x1, y1, z1, x2, y2, z2 = tu:x(), tu:y(), tu:z(), u:x(), u:y(), u:z()
                            lightning(LIGHTNING_TYPE.cureLite, x1, y1, z1, x2, y2, z2, 0.25)
                            u:hpBack(0.01 * back * hpCur)
                            u:attach("AIheTarget", "origin", 1)
                        end
                    end
                end)
            end
        end))