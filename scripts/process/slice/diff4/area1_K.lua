local process = Process("slice_diff4_area1_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("UjimasaHojoV1", TPL_UNIT.NPC_Token, -5633, 5503, -45, function(evtUnit)
        evtUnit:name("黑月")
        evtUnit:icon("unit/Guldan2")
        evtUnit:modelAlias("hero/UjimasaHojoV1.07")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.35)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 270,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "月色依稀",
                        "乌云遮天",
                        "吞天乏力",
                        "黑暗将逝",
                    },
                },
            }
        })
    end)
    Game():npc("VillagerMan1", TPL_UNIT.NPC_Token, -5004, 3459, 100, function(evtUnit)
        evtUnit:name("流浪的村民")
        evtUnit:modelAlias("VillagerMan1")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我是一个村民，几十年前",
                        "我的爷辈都居住在这雪山的东边，",
                        "那里过去有一个小村子。",
                    },
                },
                {
                    tips = {
                        "后来环境恶劣了，毒障丛生。",
                        "我们都搬到红林地带去了，",
                        "听说这里有为用剑的高手，我还想着来拜师呢。",
                    },
                },
            }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)