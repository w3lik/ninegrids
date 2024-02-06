local process = Process("slice_diff1_area7_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Dryad1", TPL_UNIT.NPC_Token, -3520, -3584, 120, function(evtUnit)
        evtUnit:name("无奈的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "我是来不及逃走了", "还好事态没有发展到不能", "挽回的地步..." } } }
        })
    end)
    Game():npc("Dryad2", TPL_UNIT.NPC_Token, -5182, -4753, 270, function(evtUnit)
        evtUnit:name("庆幸的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "还好我平时乱逛发现了", "西边的山洞，在里面藏着，", "不然也躲不过这场劫难。" } } }
        })
    end)
    Game():npc("Ent1", TPL_UNIT.NPC_Token, -3167, -4900, 190, function(evtUnit)
        evtUnit:name("神志不清的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "咕叽...咕叽...", "噜叵...噜叵...噜叵..." } } }
        })
    end)
    Game():npc("Ent2", TPL_UNIT.NPC_Token, -3058, -5207, 160, function(evtUnit)
        evtUnit:name("迷惑的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "我刚从外面东边回来！", "也不知道发生了什么？", "朋友它变得一直在胡言乱语了" } } }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)