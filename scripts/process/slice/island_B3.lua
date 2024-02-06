local process = Process("slice_island_B3")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    local coordinate = { { 0, 0 }, { -249, 213 }, { 143, -83 }, { -743, -282 }, { 191, -616 } }
    local effs = { "LavaCracks0", "LavaCracks1", "LavaCracks2", "LavaCracks3" }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(11, 14))
    end
    coordinate = { { -100, 200 }, { 349, 0 }, { 0, -300 }, { 10, 500 }, { -800, 0 } }
    effs = { "LordaeronSummerBrazier", "TorchHuman", "TownBurningFireEmitter" }
    for _, c in ipairs(coordinate) do
        Game():effects(table.rand(effs), c[1], c[2], 0, math.rand(0, 359)):size(0.1 * math.rand(11, 13))
    end
    Game():scenes({
        name = "狱炎",
        coordinate = { { 118, 452 }, { -320, 6 }, { 392, 20 }, { 0, -550 } },
        modelAlias = { "TownBurningFireEmitter", "FireRockSmall" },
        modelScale = { 1.0, 1.1 },
        period = { 15, 20 },
        deadPeriod = { 5, 7 },
        dead = function(sceneData)
            local x, y = sceneData.x, sceneData.y
            effector("FireLordDeathExplode", x, y, nil, 1)
            local g = Group():catch(UnitClass, {
                filter = function(enumUnit)
                    return enumUnit:isAlive() and enumUnit:isEnemy(gd.me:owner()) == false
                end,
                circle = { x = x, y = y, radius = 200 },
                limit = 3,
            })
            if (#g > 0) then
                local dmg = 500
                for _, eu in ipairs(g) do
                    async.call(eu:owner(), function()
                        UI_LikEcho:echo("被狱炎爆炸烧伤，造成了 " .. colour.hex(colour.red, dmg) .. " 点火伤害")
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
        end
    })
    Game():creeps({
        coordinate = { { -848, -8 }, { -708, -6 } },
        elite = {
            tpl = { TPL_UNIT.SkeletalOrc },
            qty = 2,
            ai = AI("wander"),
        },
    })
    Game():bigBossBorn()
end)