local process = Process("slice_diff2_area7_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("FlowerDryad", TPL_UNIT.NPC_Token, -3812, -2998, 270, function(evtUnit)
        evtUnit:name("小鹿")
        evtUnit:icon("unit/ForestDruid")
        evtUnit:modelAlias("hero/FlowerDryad")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.7)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这是一场误会，森林总是善良的，",
                        "让我使用森林至力为你治疗。",
                        Game():balloonKeyboardTips("感受森林至力")
                    },
                    call = function(callbackData)
                        local u = callbackData.triggerUnit
                        async.call(u:owner(), function()
                            UI_NinegridsInfo:info("great", 3, "你的生命力和魔法力得到了恢复")
                        end)
                        u:hpBack(u:hp() - u:hpCur())
                        u:mpBack(u:mp() - u:mpCur())
                        u:attach("HealTarget2", "origin", 0.5)
                        u:attach("AImaTarget", "origin", 0.5)
                    end
                },
            }
        })
    end)
    Game():npc("Dryad2", TPL_UNIT.NPC_Token, -4848, -5889, 80, function(evtUnit)
        evtUnit:name("寻物的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "那只奇怪的老鼠去哪了？" } } }
        })
    end)
    Game():npc("Dryad1", TPL_UNIT.NPC_Token, -2594, -3284, 235, function(evtUnit)
        evtUnit:name("阿Q型树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "大家都是好朋友", "误会解开了就好" } } }
        })
    end)
    Game():npc("Ent1", TPL_UNIT.NPC_Token, -4596, -4125, 30, function(evtUnit)
        evtUnit:name("笨笨的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "树人不懂这些", "只懂防御...", "冒犯...见谅..." } } }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)