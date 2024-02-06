local process = Process("slice_diff4_area6_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("SeaRoyalGuard", TPL_UNIT.SeaRoyalGuard, 5386, -1058, 110, function(evtUnit)
        evtUnit:name("不屈的皇海战士")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "海域在，海蛇族在。",
                        "皇家战士永不屈服。",
                    },
                },
            }
        })
    end)
    Game():npc("SeaMyrmidon1", TPL_UNIT.SeaMyrmidon, 4257, 1802, 270, function(evtUnit)
        evtUnit:name("逃走的巨海战士")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "它们怎么还不过来，再",
                        "等不到我就要自己先走了。",
                    },
                },
            }
        })
    end)
    Game():dig()
    Game():openDoor(gd.sliceIndex)
end)