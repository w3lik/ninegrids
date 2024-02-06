local process = Process("slice_diff2_area1_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    Game():creeps({
        coordinate = { { -5455, 5255 }, { -5000, 3322 }, { -3509, 3936 }, { -4244, 5339 } },
        elite = {
            tpl = { TPL_UNIT.SkeletonMage },
            qty = 1,
        },
        normal = {
            tpl = { TPL_UNIT.Skeleton, TPL_UNIT.SkeletonArcher },
            qty = 2,
        }
    })
    Game():xTimer(false, 15, function()
        async.call(gd.me:owner(), function()
            UI_NinegridsInfo:info("alert", 3, "巫妖现身！")
        end)
        Game():xTimer(false, 2, function()
            Game():bossBorn()
        end)
    end)
    Game():scenes({
        name = "哀怨的冰块",
        coordinate = { { -5431, 4891 }, { -3871, 3773 }, { -2796, 4035 }, { -3620, 5192 } },
        modelAlias = { "IceBlock0", "IceBlock1", "IceBlock2", "IceBlock3" },
        modelScale = { 0.9, 1.0, 1.2 },
        period = { 15, 25 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo("粉碎了冰块" .. colour.hex(colour.red, "飞行冰块会眩晕最多3个木飙3秒"))
            end)
            local tx, ty = vector2.polar(x, y, 800, vector2.angle(killer:x(), killer:y(), x, y))
            local si = 0
            ability.missile({
                modelAlias = "LichMissile",
                sourceVec = { x, y },
                targetVec = { tx, ty },
                scale = 1.3,
                speed = 700,
                onMove = function(_, vec2)
                    local tu = Group():closest(UnitClass, {
                        filter = function(enumUnit)
                            return enumUnit:isAlive() and enumUnit:isEnemy(killer:owner()) and enumUnit:isStunning() == false
                        end,
                        circle = { x = vec2[1], y = vec2[2], radius = 150 },
                    })
                    if (isClass(tu, UnitClass)) then
                        ability.stun({ sourceUnit = killer, targetUnit = tu, duration = 3, odds = 100 })
                        si = si + 1
                        if (si >= 3) then
                            return false
                        end
                    end
                end,
            })
        end
    })
    Game():scenes({
        name = "封魔的冰爪",
        coordinate = { { -4996, 5468 }, { -4864, 3737 }, { -5299, 4707 }, { -3437, 4373 } },
        modelAlias = {
            "North_IceClaw0", "North_IceClaw1", "North_IceClaw2", "North_IceClaw3", "North_IceClaw4",
            "North_IceClaw5", "North_IceClaw6", "North_IceClaw7", "North_IceClaw8", "North_IceClaw9"
        },
        modelScale = { 0.7, 0.8, 0.9 },
        period = { 25, 35 },
        kill = function(sceneData)
            local killer, x, y = sceneData.sourceUnit, sceneData.x, sceneData.y
            async.call(killer:owner(), function()
                UI_LikEcho:echo("崩碎了冰爪" .. colour.hex(colour.red, "冰爪向3个方向发射降低木飙速度"))
            end)
            local angle = vector2.angle(killer:x(), killer:y(), x, y)
            for i = 1, 3 do
                local tx, ty = vector2.polar(x, y, 900, angle + (i - 1) * 120)
                ability.missile({
                    modelAlias = "FrostBoltMissile",
                    sourceVec = { x, y },
                    targetVec = { tx, ty },
                    scale = 1.3,
                    speed = 900,
                    onMove = function(_, vec2)
                        local tu = Group():closest(UnitClass, {
                            filter = function(enumUnit)
                                return enumUnit:isAlive() and enumUnit:isEnemy(killer:owner())
                            end,
                            circle = { x = vec2[1], y = vec2[2], radius = 150 },
                        })
                        if (isClass(tu, UnitClass)) then
                            tu:attackSpeed("-=35")
                            tu:move("-=75")
                            return false
                        end
                    end,
                })
            end
        end
    })
end)