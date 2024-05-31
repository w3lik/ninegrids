local process = Process("slice_diff3_area7_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Dryad1", TPL_UNIT.NPC_Token, -3809, -3042, 270, function(evtUnit)
        evtUnit:name("思考的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "科技与自然的共存", "这是一个大问题" } } }
        })
    end)
    Game():npc("Dryad2", TPL_UNIT.NPC_Token, -5853, -3832, 0, function(evtUnit)
        evtUnit:name("开心的树妖")
        evtUnit:modelAlias("Dryad")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "最近森林里多了很多奇怪的机器", "现在被清理掉了感觉舒服多了" } } }
        })
    end)
    Game():npc("Ent1", TPL_UNIT.NPC_Token, -3839, -4936, -45, function(evtUnit)
        evtUnit:name("笨笨的树精")
        evtUnit:modelAlias("Ent")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1.2)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "森林又回到了原来的样子", "鼠鼠是朋友，但是", "森林却变得奇怪了" } } }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)