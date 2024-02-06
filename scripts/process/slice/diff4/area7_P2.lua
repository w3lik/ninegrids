local process = Process("slice_diff4_area7_P2")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 40,
        coordinate = { { -4440, -3475 }, { -3213, -5136 }, { -4475, -5515 } },
        elite = {
            tpl = { TPL_UNIT.NightmareSpiderBoss, TPL_UNIT.Nightmare_Spider },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Lasher_Nightmare, TPL_UNIT.Lasher_Nightmare2 },
            qty = 2,
        }
    })
    Game():bossBorn()
end)