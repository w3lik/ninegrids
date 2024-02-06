local process = Process("slice_diff1_area7_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 35,
        coordinate = { { -4873, -3193 }, { -3320, -4513 }, { -4626, -5336 } },
        elite = {
            tpl = { TPL_UNIT.CorruptedTreeOfLife },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.CorruptedEnt },
            qty = 3,
        }
    })
    Game():scenes({
        name = "树桩",
        coordinate = {
            { -5948, -4222 }, { -5826, -4222 },
            { -3137, -3029 }, { -3038, -2968 },
            { -4344, -4487 }, { -4236, -4473 },
            { -2531, -4227 }, { -2461, -4263 },
            { -3816, -5357 }, { -3761, -5270 },
        },
        modelAlias = { "AshenHollowStump" },
        modelScale = { 0.9, 1.0, 1.1 },
        period = { 5, 15 },
        deadPeriod = 7,
        kill = function(sceneData)
            local killer = sceneData.sourceUnit
            async.call(killer:owner(), function()
                UI_LikEcho:echo("路开了")
            end)
        end,
    })
    Game():bossBorn()
end)