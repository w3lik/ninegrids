local process = Process("slice_diff3_area6_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("BladeMasterJungleTrollV1", TPL_UNIT.NPC_Token, 4514, 203, 180, function(evtUnit)
        evtUnit:name("缠水")
        evtUnit:modelAlias("hero/BladeMasterJungleTrollV1.01")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.35)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我刚得到了渤泓宝剑。",
                        "你确定要挑战我吗？",
                        Game():balloonKeyboardTips("教训他")
                    },
                    call = function(callbackData)
                        Effect("CrushingWaveDamage", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1):size(1.5)
                        destroy(callbackData.balloonObj)
                        async.call(callbackData.triggerUnit:owner(), function()
                            UI_NinegridsInfo:info("alert", 3, "你有3秒的准备时间")
                        end)
                        Game():xTimer(false, 3, function()
                            this:next("slice_diff3_area6_P2")
                        end)
                    end
                },
            }
        })
    end)
end)