local process = Process("slice_diff3_area7_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():scenes({
        name = "奇怪的机器",
        coordinate = { { -2797, -3230 }, { -3099, -4511 }, { -4609, -2945 }, { -4605, -4069 }, { -2944, -5456 }, { -4236, -5442 } },
        modelAlias = { "env/Auto-Doc", "env/Lantern", "env/FuturisticSign", "env/Projector", "env/FuturisticVentilation" },
        modelScale = { 1.0, 1.1 },
        period = { 20, 30 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo("机器爆炸，" .. colour.hex(colour.red, "附近敌人被炸晕2秒"))
            end)
            effector("ScatterShotTarget", x, y, japi.Z(x, y), 1)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:isEnemy(killer:owner())
                end,
                circle = { x = x, y = y, radius = 200 },
                limit = 3,
            })
            if (#g > 0) then
                for _, eu in ipairs(g) do
                    ability.stun({ sourceUnit = killer, targetUnit = eu, duration = 2, odds = 100 })
                end
            end
        end
    })
    Game():creeps({
        period = 40,
        coordinate = { { -4911, -3153 }, { -4454, -5595 }, { -3249, -4396 } },
        normal = {
            tpl = { TPL_UNIT.TinkerRobot },
            qty = 2,
        }
    })
    Game():xTimer(false, 30, function()
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "闯我阵地！吃我一枪！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
end)