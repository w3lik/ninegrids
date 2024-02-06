local process = Process("slice_diff3_area8_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():npc("DarkRangerDegenerate", TPL_UNIT.NPC_Token, 899, -4233, 270, function(evtUnit)
        evtUnit:name("游侠")
        evtUnit:icon("unit/DarkRangerDegenerate")
        evtUnit:modelAlias("hero/TheBansheeQueen")
        evtUnit:modelScale(1.3)
        evtUnit:scale(1.4)
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:balloon({
            z = 260,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "我本来是来寻人的，可惜没找到。",
                        "顺便寻宝也没什么收获，后来遇到了灾厄。",
                        "所以在这灵泉里疗伤，不然你哪能击败我。",
                    },
                },
                {
                    tips = {
                        "那灾厄手持巨斧，速度很快，现在是不见了，",
                        "不知道去哪里祸害其他人去了，",
                        "你遇到的话要小心一点了，我伤好便会离开了。",
                    },
                },
            }
        })
    end)
    Game():openDoor(gd.sliceIndex)
end)