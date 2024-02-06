event.confPropChange({
    [UnitClass] = "any",
    [GameClass] = {
        i18nLang = true,
        infoCenter = true,
        playingQuantity = true,
    },
    [PlayerClass] = {
        i18nLang = true,
        skin = true,
        name = true,
        alert = true,
        selection = true,
    },
})
local function _z(u, offset)
    return u:h() + 130 + offset
end
event.registerReaction(EVENT.Unit.Kill, function(evtData)
    local owner = evtData.targetUnit:owner()
    if (owner:selection() == evtData.targetUnit) then
        owner:prop("selection", evtData.triggerUnit)
    end
end)
event.registerReaction(EVENT.Unit.Crit, function(evtData)
    evtData.targetUnit:attach("lik_crit", "origin", 0.5)
end)
event.registerReaction(EVENT.Unit.CritAbility, function(evtData)
    local tu = evtData.targetUnit
    tu:attach("lik_crit_ability", "origin", 0.5)
    local model
    if (tu:owner():isComputer()) then
        model = "lik_ttg_crit_orange"
    else
        model = "lik_ttg_crit_red"
    end
    ttg.model({
        model = model,
        size = 1.4,
        x = tu:x(),
        y = tu:y(),
        z = _z(tu, -24),
        height = 50,
        speed = 0.5,
        duration = 0.8,
    })
end)
event.registerReaction(EVENT.Unit.Avoid, function(evtData)
    evtData.triggerUnit:attach("lik_ttg_avoid", "overhead", 0.3)
end)
event.registerReaction(EVENT.Unit.ImmuneInvincible, function(evtData)
    evtData.triggerUnit:attach("DivineShieldTarget", "origin", 1)
    ttg.model({
        model = "lik_ttg_immune_invincible",
        size = 1.2,
        x = evtData.triggerUnit:x(),
        y = evtData.triggerUnit:y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
event.registerReaction(EVENT.Unit.ImmuneDefend, function(evtData)
    ttg.model({
        model = "lik_ttg_immune_damage",
        size = 0.7,
        x = evtData.triggerUnit:x(),
        y = evtData.triggerUnit:y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
event.registerReaction(EVENT.Unit.ImmuneReduction, function(evtData)
    ttg.model({
        model = "lik_ttg_immune_damage",
        size = 0.7,
        x = evtData.triggerUnit:x(),
        y = evtData.triggerUnit:y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
event.registerReaction(EVENT.Unit.ImmuneEnchant, function(evtData)
    ttg.model({
        model = "lik_ttg_immune_enchant",
        size = 0.7,
        x = evtData.triggerUnit:x(),
        y = evtData.triggerUnit:y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
event.registerReaction(EVENT.Unit.HPSuckAttack, function(evtData)
    evtData.triggerUnit:attach("HealTarget2", "origin", 0.5)
end)
event.registerReaction(EVENT.Unit.HPSuckAbility, function(evtData)
    evtData.triggerUnit:attach("HealTarget2", "origin", 0.5)
end)
event.registerReaction(EVENT.Unit.MPSuckAttack, function(evtData)
    evtData.triggerUnit:attach("AImaTarget", "origin", 0.5)
end)
event.registerReaction(EVENT.Unit.MPSuckAbility, function(evtData)
    evtData.triggerUnit:attach("AImaTarget", "origin", 0.5)
end)
event.registerReaction(EVENT.Unit.Be.Stun, function(evtData)
    evtData.triggerUnit:attach("ThunderclapTarget", "overhead", evtData.duration)
end)
event.registerReaction(EVENT.Unit.Be.Split, function(evtData)
    evtData.triggerUnit:effect("SpellBreakerAttack")
end)
event.registerReaction(EVENT.Unit.Be.SplitSpread, function(evtData)
    evtData.triggerUnit:effect("CleaveDamageTarget")
end)
event.registerReaction(EVENT.Unit.Be.Shield, function(evtData)
    if (evtData.value >= 1) then
        local u = evtData.triggerUnit
        ttg.word({
            style = "shield",
            str = math.format(evtData.value, 0),
            width = 7.5,
            size = 0.45,
            x = u:x(),
            y = u:y(),
            z = _z(u, 0),
            height = 150,
            duration = 0.6,
        })
    end
end)
event.registerReaction(EVENT.Unit.Hurt, function(evtData)
    local str = math.format(evtData.damage, 0)
    local height = -50
    if (evtData.crit == true) then
        str = 'C' .. str
        height = 300
    end
    local u = evtData.triggerUnit
    local style
    if (u:owner():isComputer()) then
        style = "damage"
    else
        style = "hurt"
    end
    ttg.word({
        style = style,
        str = str,
        width = 12,
        size = 0.7,
        x = u:x(),
        y = u:y(),
        z = _z(u, 0),
        height = height,
        duration = 0.7,
    })
end)
event.registerReaction(EVENT.Unit.Enchant, function(evtData)
    local m = {
        [DAMAGE_TYPE.fire.value] = "lik_ttg_e_fire",
        [DAMAGE_TYPE.water.value] = "lik_ttg_e_water",
        [DAMAGE_TYPE.ice.value] = "lik_ttg_e_ice",
        [DAMAGE_TYPE.rock.value] = "lik_ttg_e_rock",
        [DAMAGE_TYPE.wind.value] = "lik_ttg_e_wind",
        [DAMAGE_TYPE.light.value] = "lik_ttg_e_light",
        [DAMAGE_TYPE.dark.value] = "lik_ttg_e_dark",
        [DAMAGE_TYPE.grass.value] = "lik_ttg_e_grass",
        [DAMAGE_TYPE.thunder.value] = "lik_ttg_e_thunder",
        [DAMAGE_TYPE.poison.value] = "lik_ttg_e_poison",
        [DAMAGE_TYPE.steel.value] = "lik_ttg_e_steel",
    }
    if (m[evtData.enchantType.value] ~= nil) then
        local tu = evtData.triggerUnit
        ttg.model({
            model = m[evtData.enchantType.value],
            size = 1.2,
            x = tu:x() - math.rand(30, -30),
            y = tu:y(),
            z = _z(tu, -tu:stature() * 2),
            height = 160,
            speed = 0.4,
            duration = 1,
        })
    end
end)
event.registerReaction(EVENT.Unit.Be.Stun, function(evtData)
    local p = evtData.triggerUnit:owner()
    if (p:isComputer() == false) then
        async.call(p, function()
            camera.quake(5, 0.1)
        end)
    end
end)