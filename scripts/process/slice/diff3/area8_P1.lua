local process = Process("slice_diff3_area8_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():npc("DarkRangerDegenerate", TPL_UNIT.NPC_Token, 899, -4233, 270, function(evtUnit)
        evtUnit:name("游侠")
        evtUnit:icon("unit/DarkRangerDegenerate")
        evtUnit:modelAlias("hero/TheBansheeQueen")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.4)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 260,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "你找熊猫？它们已经回竹林了。",
                        "这里也重新回到了宁静。",
                        Game():balloonKeyboardTips("切磋")
                    },
                    call = function(callbackData)
                        effector("CycloneTarget", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1)
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