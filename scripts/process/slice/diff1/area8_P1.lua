local process = Process("slice_diff1_area8_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():effects("env/TaijiSword", -239, -2609, 0, 270)
    Game():effects("env/TaijiSword", -893, -2928, 0, 270)
    Game():effects("env/TaijiSword", -403, -4277, 0, 270)
    Game():effects("env/TaijiSword", -1288, -4093, 0, 270)
    Game():effects("env/TaijiSword", -1093, -5155, 0, 270)
    Game():effects("env/TaijiSword", 740, -5150, 0, 270)
    Game():effects("env/TaijiSword", 1245, -5573, 0, 270)
    Game():npc("DarkRanger", TPL_UNIT.NPC_Token, 316, -3116, 180, function(evtUnit)
        evtUnit:name("疾风")
        evtUnit:modelAlias("HeroBladeMaster")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "风向变了。",
                        "你要挑战我吗？",
                        Game():balloonKeyboardTips("切磋")
                    },
                    call = function(callbackData)
                        effector("slash/Light_speed_cutting_green", callbackData.balloonObj:x(), callbackData.balloonObj:y(), nil, 1)
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