local process = Process("slice_diff2_area3_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("Zombie", TPL_UNIT.NPC_Token, 4323, 2760, 120, function(evtUnit)
        evtUnit:name("不动的僵尸")
        evtUnit:modelAlias("Zombie")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "一具失去活力的僵尸" } } }
        })
    end)
    Game():npc("Zombie", TPL_UNIT.NPC_Token, 3724, 5026, -45, function(evtUnit)
        evtUnit:name("不动的僵尸")
        evtUnit:modelAlias("Zombie")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = { { tips = { "......" } } }
        })
    end)
    Game():npc("YJMan1", TPL_UNIT.NPC_Token, 2653, 3800, 180, function(evtUnit)
        evtUnit:name("奇怪的研究员")
        evtUnit:modelAlias("HumanMage")
        evtUnit:modelScale(1)
        evtUnit:scale(1.1)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这个遗迹中有很多神奇的东西，",
                        "那些不会动的僵尸，",
                        "还有你看这个，",
                    },
                },
                {
                    tips = {
                        "这些神奇的符文发散着魅力，",
                        "还有这些奇怪的咒符石，",
                        "真是让人激动。",
                    },
                },
            }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)