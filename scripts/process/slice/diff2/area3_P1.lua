local process = Process("slice_diff2_area3_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        coordinate = { { 5219, 5304 }, { 4197, 5360 }, { 3585, 3492 }, { 4447, 3049 } },
        normal = {
            tpl = { TPL_UNIT.Zombie },
            qty = 2,
        }
    })
    time.setTimeout(15, function()
        Game():bossBorn()
    end)
end)