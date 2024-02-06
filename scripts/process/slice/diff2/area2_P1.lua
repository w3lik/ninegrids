local process = Process("slice_diff2_area2_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        coordinate = { { -861, 5471 }, { -986, 3759 }, { 421, 5245 }, { 810, 2836 } },
        normal = {
            tpl = { TPL_UNIT.SUMMON_Poison },
            qty = 2,
        }
    })
    Game():bossBorn()
end)