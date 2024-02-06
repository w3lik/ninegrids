local process = Process("slice_diff1_area4_P1")
process:onStart(function(this)
    this:next("interrupt")
    Game():effects("env/Web1", -4183, -118, 0, math.rand(0, 359)):size(0.1 * math.rand(20, 30))
    Game():effects("env/Web1", -5409, -1168, 0, math.rand(0, 359)):size(0.1 * math.rand(13, 19))
    Game():effects("env/Web1", -3603, -1696, 0, math.rand(0, 359)):size(0.1 * math.rand(11, 14))
    Game():effects("env/Web1", -3117, -829, 0, math.rand(0, 359)):size(0.1 * math.rand(11, 14))
    Game():effects("env/Web1", -4684, 1330, 0, math.rand(0, 359)):size(0.1 * math.rand(13, 16))
    Game():effects("env/Web2", -5094, 459, 0, math.rand(0, 359)):size(0.1 * math.rand(10, 13))
    Game():effects("env/Web2", -4960, 423, 0, math.rand(0, 359)):size(0.1 * math.rand(20, 40))
    Game():effects("env/Web2", -2813, 417, 0, math.rand(0, 359)):size(0.1 * math.rand(12, 20))
    Game():effects("env/Web2", -3992, 1041, 0, math.rand(0, 359)):size(0.1 * math.rand(15, 30))
    Game():effects("env/Web2", -2612, -1978, 0, math.rand(0, 359)):size(0.1 * math.rand(13, 18))
    Game():creeps({
        period = 15,
        coordinate = {
            { -5683, -1534 }, { -4392, -1560 },
            { -2768, -1880 }, { -2895, -77 },
            { -5458, 1311 }, { -4130, 1008 },
        },
        elite = {
            tpl = { TPL_UNIT.SpiderBlue, TPL_UNIT.SpiderGreen },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Spider, TPL_UNIT.SpiderBlack },
            qty = 1,
        }
    })
    local boss = Game():bossBorn()
    Game():scenes({
        name = "蜘蛛蛋",
        coordinate = {
            { -3534, 106 }, { -3565, 241 },
            { -2767, -107 }, { -2721, -431 },
            { -4608, 17 }, { -4994, -130 }, { -4677, -705 },
            { -5958, -573 }, { -5786, -982 },
            { -4950, -1224 }, { -1431, -1222 },
        },
        modelAlias = { "EggSack_portrait" },
        modelScale = { 0.9, 1.0, 1.1, 1.2, 1.3, 1.4 },
        period = { 10, 30 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            boss:orderAttack(x, y)
            boss:move("-=" .. 0.1 * boss:attack() .. ';5')
            boss:defend("-=10;5")
            async.call(killer:owner(), function()
                UI_NinegridsInfo:info("info", 3, "蜘蛛蛋碎裂令蜘蛛分神不暇！防御、移动都弱化了！")
            end)
        end,
        deadPeriod = { 75, 115 },
        dead = function(sceneData)
            local x, y = sceneData.x, sceneData.y
            effector("PoisonStingTarget", x, y, japi.Z(x, y), 1)
            local tpl = { TPL_UNIT.SpiderBlue, TPL_UNIT.SpiderGreen, TPL_UNIT.Spider, TPL_UNIT.SpiderBlack }
            local e = Game():enemies(table.rand(tpl), x, y, 270, true)
            e:rgba(255, 50, 50, 255)
             :modelScale(1.2)
             :scale(1.4)
             :hp(800)
             :attack(130)
             :defend(10)
        end
    })
end)