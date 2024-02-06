local process = Process("slice_island_B1")
process:onStart(function(this)
    this:next("interrupt")
    local coordinate = { { 0, 0 }, { 74, 605 }, { -743, -60 }, { 69, -774 }, { 677, 46 } }
    local effs = { "RuneArt0", "RuneArt1", "RuneArt2", "RuneArt3", "RuneArt4", "RuneArt5", "RuneArt6" }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(11, 14))
    end
    Game():creeps({
        coordinate = { { -108, 866 }, { -1196, 12 }, { -139, -1117 }, { 1096, -108 } },
        elite = {
            tpl = { TPL_UNIT.Rifleman, TPL_UNIT.Knight },
            qty = 3,
            ai = AI("wander"),
        },
    })
    Game():bigBossBorn()
end)