local process = Process("slice_diff1_area2_P3")
process:onStart(function(this)
    this:next("interrupt")
    Game():creeps({
        coordinate = { { -986, 3759 }, { 421, 5245 }, { 810, 2836 } },
        elite = {
            tpl = { TPL_UNIT.Bandit, TPL_UNIT.BanditSpearThrower },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Bandit, TPL_UNIT.BanditSpearThrower },
            qty = 2,
        }
    })
    Game():scenes({
        name = "辛勤的小麦",
        coordinate = { { -1126, 5080 }, { -770, 5520 }, { -385, 5160 }, { 239, 5453 }, { 210, 4661 }, { 805, 4797 } },
        modelAlias = { "WheatBunch" },
        modelScale = { 0.8, 0.9, 1.0, 1.1 },
        period = { 20, 30 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo("扬起了小麦" .. colour.hex(colour.red, "附近敌人被眩晕4秒"))
            end)
            effector("eff/DustWindCirclefaster", x, y, japi.Z(x, y), 2)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:isEnemy(killer:owner())
                end,
                circle = { x = x, y = y, radius = 300 },
                limit = 5,
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.stun({ sourceUnit = killer, targetUnit = eu, duration = 4, odds = 100 })
                end
            end
        end
    })
    Game():bossBorn()
end)