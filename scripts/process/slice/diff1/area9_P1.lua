local process = Process("slice_diff1_area9_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():scenes({
        name = "火炬",
        coordinate = {
            { 4226, -3717 }, { 3715, -4223 }, { 4546, -4419 },
            { 4018, -3228 }, { 4410, -3200 },
            { 4052, -4049 }, { 5446, -4443 },
            { 3785, -5577 }, { 4676, -5577 },
        },
        modelAlias = { "LordaeronSummerBrazier" },
        modelScale = { 0.9, 1.0, 1.1 },
        period = { 20, 25 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo(colour.hex(colour.red, "火炬的火焰竟变成了炎魔"))
            end)
            local e = Game():enemies(TPL_UNIT.Fire_lava, x, y, math.rand(0, 359), true)
            e:hp(300)
            e:attack(70)
        end,
    })
    local boss = Game():bossBorn()
    local coordinate = { { 2600, -2662 }, { 3714, -2412 }, { 5779, -2851 }, { 5626, -5911 }, { 2716, -4095 } }
    local allys = { TPL_UNIT.Kobold, TPL_UNIT.KoboldGeomancer }
    local ally = function()
        for _, c in ipairs(coordinate) do
            for _ = 1, 2 do
                local a = Game():allys(table.rand(allys), c[1], c[2], 270, true)
                a:hp(math.floor(200 + gd.erode * 2))
                 :attack(math.floor(35 + gd.erode / 3))
                a:orderAttackTargetUnit(boss)
            end
        end
    end
    ally()
    Game():xTimer(true, 20, function()
        ally()
    end)
end)
