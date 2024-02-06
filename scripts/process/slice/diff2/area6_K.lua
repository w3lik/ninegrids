local process = Process("slice_diff2_area6_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("BladeMasterJungleTrollV1", TPL_UNIT.NPC_Token, 5124, 91, 100, function(evtUnit)
        evtUnit:name("古怪的剑士")
        evtUnit:modelAlias("hero/BladeMasterJungleTrollV1.01")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.35)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "这群海蛇族全域都骚乱了。",
                        "我找到这个巨大的珊瑚礁，",
                        "里面似乎有我想要的东西。",
                    },
                },
            }
        })
    end)
    Game():npc("Murloc4", TPL_UNIT.MurlocGreen, 3234, 1709, -45, function(evtUnit)
        evtUnit:name("逃难的小鱼人")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "海蛇族不会这么容易屈服的，",
                        "等我们的大皇子归来，",
                        "定能将恶徒驱逐出海域！",
                    },
                },
            }
        })
    end)
    Game():npc("Turtle1", TPL_UNIT.Turtle, 5810, 1651, 200)
    Game():npc("Turtle2", TPL_UNIT.Turtle, 3875, -525, -45)
    Game():openDoor(gd.sliceIndex)
end)