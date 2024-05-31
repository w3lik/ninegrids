local process = Process("slice_diff4_area1_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("UjimasaHojoV1", TPL_UNIT.NPC_Token, -5633, 5503, -45, function(evtUnit)
        evtUnit:name("黑月")
        evtUnit:icon("unit/Guldan2")
        evtUnit:modelAlias("hero/UjimasaHojoV1.07")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.35)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 270,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "月色正美。",
                        "你要挑战我吗？",
                        Game():balloonKeyboardTips("切磋")
                    },
                    call = function(callbackData)
                        effector("eff/GravityStorm", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1)
                        destroy(callbackData.balloonObj)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("alert", 3, "你有3秒的准备时间")
                        end)
                        Game():xTimer(false, 3, function()
                            Game():bossBorn()
                        end)
                    end
                },
            }
        })
    end)
end)