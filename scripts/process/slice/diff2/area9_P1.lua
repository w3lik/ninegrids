local process = Process("slice_diff2_area9_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 30,
        coordinate = { { 3508, -2906 }, { 4996, -4652 }, { 3389, -4656 }, { 4163, -5605 } },
        elite = {
            tpl = { TPL_UNIT.SpiritWalker },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Tauren },
            qty = 2,
        }
    })
    Game():bossBorn()
end)