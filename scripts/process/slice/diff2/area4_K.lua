local process = Process("slice_diff2_area4_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("HeroChaosBladeMaster", TPL_UNIT.NPC_Token, -4480, -387, 270, function(evtUnit)
        evtUnit:name("阎殇")
        evtUnit:modelAlias("HeroChaosBladeMaster")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.3)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "你的招式刚劲有力，",
                        "而我的速度却落于下风，",
                        "失败令我能变得更强。",
                    },
                },
            }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)