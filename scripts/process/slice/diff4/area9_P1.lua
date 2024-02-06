local process = Process("slice_diff4_area9_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 40,
        coordinate = { { 5689, -2884 }, { 2990, -3889 }, { 4825, -4991 }, { 4749, -4047 } },
        normal = {
            tpl = { TPL_UNIT.Arachnathid, TPL_UNIT.EarthElemental },
            qty = 3,
        }
    })
    Game():bossBorn()
end)