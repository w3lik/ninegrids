local process = Process("slice_diff4_area6_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 35,
        coordinate = { { 3695, 742 }, { 4044, -717 }, { 5282, -762 } },
        elite = {
            tpl = { TPL_UNIT.SeaRoyalGuard, TPL_UNIT.SeaMyrmidon },
            qty = 2,
        },
        normal = {
            tpl = { TPL_UNIT.SeaSnapDragon },
            qty = 2,
        }
    })
    Game():bossBorn()
end)