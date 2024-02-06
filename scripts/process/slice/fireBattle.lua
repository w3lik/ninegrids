local process = Process("slice_fire_battle")
process:onStart(function(this)
    local gd = Game():GD()
    Bgm():volume(80):play("lik")
    local x, y = vector2.polar(-2555, 1800, 200, 90)
    if (gd.fireLevel <= 8) then
        local u = Game():enemies(TPL_UNIT.Fire_mid, x, y, 270)
        u:hp(500 + 300 * gd.fireLevel)
         :attack(100 + 50 * gd.fireLevel)
         :move(40 + 10 * gd.fireLevel)
         :defend(2 * gd.fireLevel)
    else
        local u = Game():enemies(TPL_UNIT.Fire_lavaKirami, x, y, 270)
        u:hp(7500)
         :attack(750)
         :move(300)
         :defend(35)
    end
    local n = math.floor(2 + 0.5 * gd.fireLevel)
    for _ = 1, n do
        Game():xTimer(true, 5, function(curTimer)
            curTimer:period(20)
            local distance = math.rand(128, 300)
            local angle = math.rand(0, 359)
            x, y = vector2.polar(-2555, 1800, distance, angle)
            local typ = math.rand(1, 2)
            if (typ == 1) then
                local u = Game():enemies(TPL_UNIT.Fire_lava, x, y, 360 - angle)
                u:hp(70 + 23 * gd.fireLevel)
                 :attack(30 + 7 * gd.fireLevel)
                 :defend(0.3 * gd.fireLevel)
            elseif (typ == 2) then
                local u = Game():enemies(TPL_UNIT.Fire_felboar, x, y, 360 - angle)
                u:hp(45 + 14 * gd.fireLevel)
                 :attack(40 + 11 * gd.fireLevel)
                 :defend(0.2 * gd.fireLevel)
            end
        end)
    end
    if (gd.fireLevel >= 3) then
        Game():xTimer(true, 15, function()
            local de = 7 + 5 * gd.fireLevel
            gd.me
              :buff("火焰山灼烧")
              :signal(BUFF_SIGNAL.down)
              :name("火焰山灼烧")
              :description(colour.hex(colour.indianred, "HP恢复：-" .. de))
              :icon("ability/IncendiaryBonds")
              :duration(10)
              :purpose(
                function(buffObj)
                    buffObj:attach("PhoenixMissile", "origin", -1)
                    buffObj:attach("PhoenixMissileMini", "hand,left", -1)
                    buffObj:attach("PhoenixMissileMini", "hand,right", -1)
                    buffObj:hpRegen("-=" .. de)
                end)
              :rollback(
                function(buffObj)
                    buffObj:detach("PhoenixMissile", "origin")
                    buffObj:detach("PhoenixMissileMini", "hand,left")
                    buffObj:detach("PhoenixMissileMini", "hand,right")
                    buffObj:hpRegen("+=" .. de)
                end)
              :run()
        end)
    end
    if (gd.fireLevel >= 5) then
        Game():xTimer(true, 8, function()
            for _ = 1, (gd.fireLevel + 2) do
                x, y = vector2.polar(-2555, 1800, math.rand(0, 500), math.rand(0, 359))
                alerter.circle(x, y, 150, 1.1)
                effector("eff/RainOfFire3", x, y, 0, 0.8)
                time.setTimeout(1.1, function()
                    local gus = Group():catch(UnitClass, {
                        circle = { x = x, y = y, radius = 150 },
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:owner() == gd.me:owner()
                        end
                    })
                    if (#gus > 0) then
                        local dmg = 150 + 50 * gd.fireLevel
                        for _, gu in ipairs(gus) do
                            effector("FireLordDeathExplode", gu:x(), gu:y(), nil, 1)
                            ability.damage({
                                targetUnit = gu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.common,
                                damageType = DAMAGE_TYPE.fire,
                                damageTypeLevel = 1
                            })
                        end
                    end
                end)
            end
        end)
    end
    local dur = 25 + 5 * gd.fireLevel
    local t = Game():xTimer(false, dur, function()
        Game():xTimerClear()
        gd.me:buffClear({ key = "火焰山灼烧" })
        async.call(gd.me:owner(), function()
            Bgm():stop()
            audio(Vcm("victory"))
            UI_NinegridsAnimate:challenge()
        end)
        Game():fireLevel()
        Game():npc("NPC_FireDo", TPL_UNIT.NPC_FireDo, -2555, 2200, 270)
        Game():openDoor("fire")
        this:next("interrupt")
    end)
    async.call(gd.me:owner(), function()
        UI_NinegridsInfo:countdown(t, "坚持 ")
    end)
end)