local process = Process("slice_diff2_area2_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("VillagerMan1", TPL_UNIT.NPC_Token, -36, 2948, 270, function(evtUnit)
        evtUnit:name("孤单的男村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "这里原来有个小村子", "有几十个村民的样子", "可惜现在都不复存在了" } } }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)