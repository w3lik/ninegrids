local process = Process("slice_diff2_area4_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("HeroChaosBladeMaster", TPL_UNIT.NPC_Token, -4480, -387, 270, function(evtUnit)
        evtUnit:name("阎殇")
        evtUnit:modelAlias("HeroChaosBladeMaster")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "要战就战。",
                        "你要挑战我吗？",
                        Game():balloonKeyboardTips("切磋")
                    },
                    call = function(callbackData)
                        effector("eff/KingdomComeOpt", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1)
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