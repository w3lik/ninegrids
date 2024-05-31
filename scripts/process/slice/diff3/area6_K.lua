local process = Process("slice_diff3_area6_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("BladeMasterJungleTrollV1", TPL_UNIT.NPC_Token, 4514, 203, 180, function(evtUnit)
        evtUnit:name("缠水")
        evtUnit:modelAlias("hero/BladeMasterJungleTrollV1.01")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.35)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 280,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "窃取宝物时我就该早料到，",
                        "迟早有一天宝物也会离我而去，",
                        "被你击溃或许是命运的指引，",
                        "剑在你手上也许才是好的归宿。",
                    },
                },
            }
        })
    end)
    Game():npc("Murloc4", TPL_UNIT.MurlocGreen, 3234, 1709, -45, function(evtUnit)
        evtUnit:name("躺平的小鱼人")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "恶徒已被惩戒！",
                        "我们的大皇子归来至日，",
                        "海域一定能重获以往的辉煌！",
                    },
                },
            }
        })
    end)
    Game():npc("SeaSiren", TPL_UNIT.SeaSiren, 4347, -1657, 0, function(evtUnit)
        evtUnit:name("躲藏的海妖")
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "看来海蛇族不行了，",
                        "海妖至歌终将传遍",
                        "整个海域。桀桀桀~",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)