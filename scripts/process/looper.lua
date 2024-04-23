local process = Process("looper")
process:onStart(function(this)
    Game():fog(false):mark(false)
    local gd = Game():GD()
    async.call(Player(1), function()
        UI_NinegridsInfo:navi(gd.sliceIndex)
        UI_NinegridsInfo:updated()
    end)
    local me = gd.me
    if (isClass(me, UnitClass)) then
        destroy(me)
        gd.me = nil
    end
    local to = Game():sliceDefTo(gd.sliceIndex)
    camera.spacePosition(to[1], to[2], true)
    camera.distance(2600)
    camera.to(to[1], to[2], 0)
    local dur = 4
    Player(1):mark(TEXTURE_MARK.dream, dur, 255, 200, 100)
    local rebornInc = 0
    local vec = { to[1], to[2], 120 }
    for i = 1, 8 do
        local x, y = vector2.polar(vec[1], vec[2], 1000, i * 45)
        ability.missile({
            sourceVec = { x, y, 50 },
            targetVec = vec,
            modelAlias = "FaerieFireTarget",
            animateScale = 1.00,
            scale = math.rand(14, 20) / 10,
            speed = 800 + i * 60,
            height = 500,
            shake = 35,
            onEnd = function()
                Game():fog(true):mark(true)
                rebornInc = rebornInc + 1
                if (rebornInc >= 8) then
                    local meSoul1 = TPL_SOUL[gd.meSoul1]
                    must(isClass(meSoul1, UnitTplClass))
                    local p = Player(1)
                    gd.me = Unit(meSoul1, p, to[1], to[2], 270)
                    gd.me:iconMap(AUIKit("ninegrids_minimap", "dot/me", "tga"), 0.03, 0.03)
                    gd.me:orderHold()
                    gd.me:abilitySlot():tail(1 + gd.abilityTail)
                    gd.me:effect("ResurrectCaster", 2)
                    local er = 0
                    for _, v in ipairs(gd.sliceResult) do
                        if (v == 1) then
                            er = er + Game():erodeCell()
                        end
                    end
                    Game():erode(er)
                    Game():weatherDo(gd.weather)
                    for j, v in ipairs(gd.achievement) do
                        if (1 == v) then
                            Game():achievementDo(j)
                        end
                    end
                    for j = 1, 4 do
                        if (gd.diffMax > j) then
                            Game():upgradePoint(math.round(8 * (2 + j)))
                        elseif (gd.diffMax == j) then
                            for _, res in ipairs(gd.sliceResult) do
                                if (res == 1) then
                                    Game():upgradePoint(math.round(2 + j))
                                end
                            end
                        elseif (gd.diffMax < j) then
                            break
                        end
                    end
                    Game():upgradePoint(gd.fireLevel * 3)
                    gd.upgradePoint = gd.upgradePoint + gd.upgradeStart
                    if (gd.upgradePoint > 0) then
                        async.call(p, function()
                            UI_NinegridsAnimate:see(FrameButton("ninegrids_info->levels"), -0.04, 0.003)
                        end)
                    end
                    local up = { "def", "atk", "spd" }
                    for _, u in ipairs(up) do
                        Game():upgradeDo(u)
                    end
                    gd.upgradeStart = -1
                    for sIdx = 1, gd.abilityTail, 1 do
                        local index = gd.abilityLearn[sIdx]
                        if (index > 0) then
                            if (index >= 100) then
                                Game():firePush(index, sIdx, true)
                            else
                                local tpl = TPL_ABILITY_SOUL[index]
                                if (isClass(tpl, AbilityTplClass)) then
                                    Game():abilityPush(index, sIdx, true)
                                end
                            end
                        end
                    end
                    if (gd.meAbilityFreak > 0) then
                        Game():abilityFreakPush(gd.meAbilityFreak, true)
                    end
                    for sIdx = 1, #Game():itemHotkey(), 1 do
                        local index = gd.sacredUse[sIdx]
                        if (index > 0) then
                            if (1 == gd.sacredGet[index]) then
                                Game():sacredPush(index, sIdx, true)
                            end
                        end
                    end
                    gd.me:balloonLighter(true)
                    gd.me:onEvent(EVENT.Unit.Reborn, function(rebornData)
                        local upr = { "def", "atk", "spd" }
                        for _, u in ipairs(upr) do
                            Game():upgradeDo(u)
                        end
                    end)
                    gd.me:onEvent(EVENT.Unit.Hurt, function(hurtData)
                        gd.meHurt = math.floor(gd.meHurt + hurtData.damage)
                    end)
                    gd.me:onEvent(EVENT.Unit.Damage, function(damageData)
                        gd.meDamage = math.floor(gd.meDamage + damageData.damage)
                        async.call(PlayerLocal(), function()
                            UIKit("ninegrids_targetGage"):updated(damageData.targetUnit)
                        end)
                    end)
                    gd.me:onEvent(EVENT.Unit.Shield, function(shieldData)
                        async.call(PlayerLocal(), function()
                            UIKit("ninegrids_targetGage"):updated(shieldData.targetUnit)
                        end)
                    end)
                    gd.me:onEvent(EVENT.Unit.Kill, function(killData)
                        if (killData.triggerUnit:isEnemy(killData.targetUnit:owner())) then
                            gd.meKill = math.floor(gd.meKill + 1)
                        end
                    end)
                    gd.me:onEvent(EVENT.Unit.Dead, function(deadData)
                        destroy(FogModifier(Player(1), "BOSS视野"))
                        Game():xTimerClear()
                        Game():closeDoor()
                        Game():npcClear()
                        Game():autoUseItemClear()
                        Game():summonsClear()
                        Game():effectsClear()
                        Game():digClear()
                        local u = deadData.triggerUnit
                        local dx, dy = u:x(), u:y()
                        Game():clear("learnArrow")
                        p:clear("me")
                        Bgm():play("fail")
                        gd.erode = 0
                        gd.sliceIndex = 5
                        gd.sliceResult = table.repeater(0, 9)
                        gd.sacredUpgrade = 0
                        gd.abilityUpgrade = 0
                        gd.upgradeStart = 0
                        gd.upgradePoint = 0
                        gd.upgradeDef = 0
                        gd.upgradeAtk = 0
                        gd.upgradeSpd = 0
                        if (gd.diff == 5) then
                            gd.diff = 4
                        end
                        Game():save("sliceResult", gd.sliceResult)
                        gd.meKill = 0
                        gd.meDead = gd.meDead + 1
                        if (gd.meDead >= 99) then
                            Game():achievement(8, true)
                        end
                        gd.meDied = 0
                        gd.meHurt = 0
                        gd.meDamage = 0
                        Game():save("meDead", gd.meDead)
                        gd.abilityLearn = table.repeater(0, gd.abilityTail)
                        gd.sacredUse = table.repeater(0, #Game():itemHotkey())
                        gd.meAbilityFreak = 0
                        Game():save("meAbilityFreak", gd.meAbilityFreak)
                        local fm = FogModifier(u:owner(), "死亡视野")
                        fm:position(dx, dy)
                        fm:radius(600)
                        fm:enable(true)
                        Effect("eff/NecroticBlast", dx, dy, japi.Z(dx, dy), 2):size(0.8)
                        for f = 1, 7, 1 do
                            time.setTimeout(0.07 * f, function()
                                local dx2, dy2 = vector2.polar(dx, dy, math.rand(0, 120), math.rand(0, 359))
                                Effect("eff/HandOfDeath", dx2, dy2, japi.Z(dx2, dy2), 2):size(0.8)
                            end)
                        end
                        time.setTimeout(3, function()
                            destroy(fm)
                            async.call(u:owner(), function()
                                UIKit("ninegrids_essence"):stage().essence:show(false)
                                UI_NinegridsInfo:dead(5.5)
                                UI_NinegridsInfo:updated()
                            end)
                            time.setTimeout(5, function()
                                Game():enemiesClear()
                                Game():allysClear()
                                UI_NinegridsMinimap.map:unlock()
                                Bgm():stop()
                                time.setTimeout(1, function()
                                    camera.reset(0)
                                    destroy(u)
                                    ProcessCurrent:next("looper")
                                end)
                            end)
                        end)
                    end)
                    gd.me:onEvent(EVENT.Unit.MoveStop, "spacePosition", function(moveData)
                        local u = moveData.triggerUnit
                        camera.spacePosition(u:x(), u:y(), true)
                    end)
                    async.call(p, function()
                        UI_NinegridsInfo:updated()
                    end)
                    p:onEvent(EVENT.Player.WorthChange, "money", function()
                        Game():save("copper")
                    end)
                    p:select(gd.me)
                    time.setTimeout(0.5, function()
                        camera.reset(0.2)
                        this:next("slice_diff" .. gd.diff .. "_area" .. gd.sliceIndex)
                    end)
                end
            end
        })
    end
end)
