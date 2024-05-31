local process = Process("slice_diff1_area1_P1")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    local p = gd.me:owner()
    Game():npc("Pedlar", TPL_UNIT.NPC_Token, -4629, 4766, 0, function(evtUnit)
        evtUnit:name("古怪的行商")
        evtUnit:modelAlias("Acolyte")
        evtUnit:icon("unit/Acolyte")
        evtUnit:modelScale(1)
        evtUnit:scale(1.0)
        evtUnit:iconMap(assets.uikit("ninegrids_minimap", "dot/what", "tga"), 0.024, 0.024)
        evtUnit:balloon({
            z = 250,
            interval = 0.01,
            message = {
                {
                    tips = {
                        "现在妖怪肆掠都没法做生意了",
                    },
                },
                {
                    tips = {
                        "听说这里夜晚会出现恐怖的怪物",
                    },
                }
            }
        })
    end)
    Game():creeps({
        coordinate = { { -5960, 3710 }, { -5160, 5775 }, { -3750, 3500 }, { -3210, 5065 } },
        elite = {
            tpl = { TPL_UNIT.IcePolarBear2 },
            qty = 1,
            balloonItem = { "雪蓝核心" },
        },
        normal = {
            tpl = { TPL_UNIT.IcePolarBear, TPL_UNIT.IceBaiHu },
            qty = 3,
            balloonItem = { "雪蓝核心" },
            autoItem = { "熊肉", "虎肉" },
        }
    })
    Game():scenes({
        name = "哀怨的冰块",
        coordinate = { { -5360, 4126 }, { -5707, 4960 }, { -4705, 5500 }, { -3322, 4985 }, { -3408, 4168 }, { -3182, 3968 }, { -4218, 3706 }, { -4436, 4735 } },
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
    Game():xTimer(true, 5, function(curTimer)
        if (time.isNight()) then
            this:next("slice_diff1_area1_P2")
            destroy(curTimer)
        else
            async.call(p, function()
                UI_NinegridsInfo:info("info", 2, "入夜渐渐深...")
            end)
        end
    end)
end)