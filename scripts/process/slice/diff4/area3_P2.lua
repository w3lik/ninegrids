local process = Process("slice_diff4_area3_P2")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        coordinate = { { 5219, 5304 }, { 4197, 5360 }, { 3585, 3492 }, { 4447, 3049 } },
        normal = {
            tpl = { TPL_UNIT.Skeleton, TPL_UNIT.SkeletonArcher },
            qty = 2,
        }
    })
    Game():bossBorn()
end)