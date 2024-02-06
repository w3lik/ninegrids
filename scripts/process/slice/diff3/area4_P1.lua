local process = Process("slice_diff3_area4_P1")
process:onStart(function(this)
    this:next("interrupt")
    local e = Game():enemies(TPL_UNIT.SalvationSpire, -4416, -448, 270, true)
    e:onEvent(EVENT.Unit.Dead, function(deadData)
        Game():npcClear()
        async.call(deadData.sourceUnit:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "阿卡阿卡！阿卡阿卡！阿卡阿卡！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
    Game():npc("VillagerMan1", TPL_UNIT.NPC_Token, -3610, 389, 190, function(evtUnit)
        evtUnit:name("张望的男村民")
        evtUnit:modelAlias("VillagerMan2")
        evtUnit:iconMap(AUIKit("ninegrids_minimap", "dot/exclamation", "tga"), 0.01, 0.01)
        evtUnit:modelScale(1)
        evtUnit:scale(1)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "前面有一座临时堡垒，不知是哪方势力。",
                        "如果是好人就好了，我们经不起折腾了。",
                        "唉......",
                    },
                },
                {
                    tips = {
                        "我是从东北边来探路的，",
                        "我和我的村民们现在都在流浪，",
                        "如果堡垒里面的人没有恶意，我们就过来。",
                    },
                },
            }
        })
    end)
    Game():scenes({
        name = "阿卡蜡烛",
        coordinate = { { -4353, 1063 }, { -3034, -132 }, { -2768, -1835 }, { -4918, -1441 }, { -5669, -814 } },
        modelAlias = { "env/Candle1" },
        modelScale = { 0.9, 1.0 },
        period = 60,
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo(colour.hex(colour.red, "蜡烛化为阿卡士兵"))
            end)
            local e2 = Game():enemies(TPL_UNIT.SUMMON_GoldWarrior, x, y, math.rand(0, 359), true)
            e2:hp(750)
            e2:attack(275)
        end,
    })
end)