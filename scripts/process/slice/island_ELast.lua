local process = Process("slice_island_ELast")
process:onStart(function(this)
    this:next("interrupt")
    Bgm():volume(70):play("lik")
    terrain.setWaterColor(255, 255, 255, 255)
    Game():GD().me:sight("+=5000")
    local soul = {
        { -345, 263, -45 },
        { -579, 300, 180 },
        { 207, 300, 190 },
        { -1151, 0, 135 },
        { 570, -178, 10 },
        { -321, -318, 30 },
        { 318, -189, 180 },
        { -578, -319, 180 },
        { -324, 510, 0 },
        { 314, 219, 270 },
        { 500, -448, 270 },
        { -1411, 212, -45 },
        { 1144, 243, 215 },
        { -900, -629, 270 },
        { 622, -322, 0 },
        { -448, -486, 270 },
        { -839, 956, 215 },
        { -269, 1319, 0 },
        { 960, 400, 215 },
        { -1723, 72, 170 },
        { 1342, -192, 180 },
        { -1230, -683, 0 },
        { -127, -1330, 90 },
        { 1336, -971, 160 },
        { -1531, 1144, -50 },
        { 303, 1346, -50 },
        { 425, 438, 55 },
        { -1461, -279, 30 },
        { 1035, -738, 70 },
        { -1110, -1120, 45 },
        { -596, -1062, 90 },
        { 585, -1087, 110 },
        { -1328, 692, 0 },
        { 547, 940, 250 },
        { 1312, 1368, 250 },
        { -1472, -431, -10 },
        { 1040, -350, 40 },
        { 0, -920, 90 },
        { 336, -1231, 115 },
        { 970, -1336, 270 },
    }
    for i, v in ipairs(soul) do
        time.setTimeout(0.05 * i, function()
            local tpl = TPL_SOUL[i]
            local e = Game():effects(tpl:modelAlias(), v[1], v[2], 0, v[3])
            e:size(tpl:modelScale())
            e:balloon({
                z = 200,
                interval = 0.01,
                message = { { tips = TRUTH[tpl:name()] } }
            })
            if (i ~= 26) then
                e:speed(0)
            end
            e:onEvent(EVENT.Object.Destruct, function(destructData)
                japi.YD_SetEffectZ(destructData.triggerEffect:handle(), -9999)
            end)
        end)
    end
    local e1 = Game():effects("env/RiftRed", 0, 0, 0, 270):size(4):speed(2.2)
    local e2 = Game():effects("env/RiftGreen", 0, 0, 0, 270):size(4):speed(1)
    local e3 = Game():effects("env/RiftPurple", 0, 0, 0, 270):size(4):speed(0.3)
    Game():npc("NPC_LastDoor", TPL_UNIT.NPC_Token, 0, 0, 270, function(evtUnit)
        evtUnit:modelAlias(".mdl")
        evtUnit:superposition("locust", "+=1")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/whirlpool", "tga"), 0.025, 0.025)
        evtUnit:balloon({
            z = 200,
            interval = 0.01,
            message = {
                {
                    tips = function()
                        return { "终点" }
                    end
                },
                {
                    tips = {
                        "此地一块破碎的裂缝",
                    },
                },
                {
                    tips = {
                        "终点残留破妄的影像",
                    },
                },
                {
                    tips = {
                        "也只能是归去",
                        colour.hex(colour.red, "你的一切都将重置"),
                        Game():balloonKeyboardTips("归去")
                    },
                    call = function(callbackData)
                        destroy(callbackData.balloonObj)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("info", 3, "即将回到初始的探秘区")
                        end)
                        local i = 0
                        local d = camera.distance()
                        japi.CameraLock(0, 200)
                        time.setInterval(0.02, function(curTimer)
                            i = i + 1
                            d = d - 25
                            camera.distance(d)
                            if (i > 50) then
                                destroy(curTimer)
                                Game():effectsClear()
                                Game():npcClear()
                                local gd = Game():GD()
                                gd.me:sight("-=5000")
                                gd.diff = 1
                                gd.abilityUpgrade = 0
                                Game():save("diff", gd.diff)
                                gd.weather = 1
                                gd.erode = 0
                                gd.sliceIndex = 5
                                gd.sliceResult = table.repeater(0, 9)
                                gd.upgradeStart = 0
                                gd.upgradePoint = 0
                                gd.upgradeDef = 0
                                gd.upgradeAtk = 0
                                gd.upgradeSpd = 0
                                Game():save("sliceResult", gd.sliceResult)
                                gd.meKill = 0
                                gd.meDied = 0
                                gd.meHurt = 0
                                gd.meDamage = 0
                                Game():save("meDead", gd.meDead)
                                this:next("enter")
                                return
                            end
                            e1:size("+=0.1")
                            e2:size("+=0.1")
                            e3:size("+=0.1")
                        end)
                    end
                }
            }
        })
    end)
end)