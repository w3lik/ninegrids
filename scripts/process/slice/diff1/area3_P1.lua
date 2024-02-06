local process = Process("slice_diff1_area3_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    local i = 0
    Game():scenes({
        name = "猛烈的炸药桶",
        coordinate = {
            { 2755, 5276 }, { 3042, 4451 }, { 3249, 3515 },
            { 3533, 4626 }, { 3500, 4590 }, { 3552, 4590 },
            { 2842, 5564 }, { 3708, 2682 }, { 3946, 2870 },
            { 4282, 3708 }, { 4060, 4790 }, { 4040, 4800 }, { 4080, 4740 }, { 4065, 4700 },
            { 4982, 4748 }, { 4486, 3953 }, { 4922, 4000 },
            { 5267, 5636 }, { 5904, 5610 },
            { 5766, 4900 }, { 5776, 4950 }, { 5766, 4706 }
        },
        modelAlias = { "TNTBarrel" },
        modelScale = { 1.0, 1.15, 1.3 },
        period = { 3, 10 },
        kill = function(sceneData)
            local killer = sceneData.sourceUnit
            async.call(killer:owner(), function()
                UI_LikEcho:echo("炸药桶熄灭了")
            end)
            if (i < 3) then
                i = i + 1
                if (i >= 3) then
                    async.call(killer:owner(), function()
                        UI_NinegridsInfo:info("alert", 3, "是谁在损坏我的陷阱！")
                    end)
                    Game():xTimer(false, 3, function()
                        Game():bossBorn()
                    end)
                end
            end
        end,
        deadPeriod = { 8, 13 },
        dead = function(sceneData)
            local x, y = sceneData.x, sceneData.y
            effector("eff/MagmaExplosion", x, y, japi.Z(x, y), 2)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:owner():isNeutral() == false and enumUnit:name() ~= "猛烈的炸药桶"
                end,
                circle = { x = x, y = y, radius = 300 },
                limit = 5,
            })
            if (#g > 0) then
                local dmg = 250 + 6 * math.floor(gd.erode)
                for _, eu in ipairs(g) do
                    async.call(eu:owner(), function()
                        UI_LikEcho:echo("炸药桶爆炸了，造成了 " .. colour.hex(colour.red, dmg) .. " 点火伤害")
                    end)
                    ability.damage({
                        targetUnit = eu,
                        damage = dmg,
                        damageSrc = DAMAGE_SRC.common,
                        damageType = DAMAGE_TYPE.fire,
                        damageTypeLevel = 1,
                    })
                end
            end
            Game():xTimer(false, 0.2, function()
                g = Group():catch(UnitClass, {
                    filter = function(enumUnit)
                        return enumUnit:isAlive() and enumUnit:name() == "猛烈的炸药桶"
                    end,
                    circle = { x = x, y = y, radius = 300 },
                })
                if (#g > 0) then
                    for _, eu in ipairs(g) do
                        eu:kill()
                    end
                end
            end)
        end
    })
end)