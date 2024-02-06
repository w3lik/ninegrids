local process = Process("slice_diff3_area9_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        period = 35,
        coordinate = { { 2905, -2741 }, { 4531, -3453 }, { 4825, -4991 }, { 3763, -5446 } },
        elite = {
            tpl = { TPL_UNIT.Ysera_MortalEN },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Ghoul, TPL_UNIT.Imp, TPL_UNIT.CryptFiend },
            qty = 2,
        }
    })
    Game():bossBorn()
end)