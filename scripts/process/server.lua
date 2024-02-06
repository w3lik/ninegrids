local process = Process("server")
process:onStart(function(this)
    local gd = Game():GD()
    local p = Player(1)
    local sev = Server(p)
    if (japi.ServerAlready(p)) then
        local vl = string.explode("|", sev:load("GG", RACE_HUMAN_NAME .. "|0|0|1|5|000000000|1|0|0|0|0"))
        gd.skin = vl[1]
        p:skin(gd.skin)
        vl[3] = math.round(vl[3] or 0)
        if (vl[3] > 0) then
            p:worth("=", { copper = vl[3] })
        end
        vl[4] = math.round(vl[4] or 1)
        vl[5] = math.round(vl[5] or 5)
        vl[6] = string.split(vl[6], 1)
        if (vl[4] > gd.diff) then
            gd.diff = math.min(5, vl[4])
            gd.diffMax = gd.diff
        end
        if (vl[5] ~= 5 and gd.sliceIndex == 5) then
            gd.sliceIndex = vl[5]
        end
        if (#vl[6] == 9) then
            for i, v in ipairs(vl[6]) do
                if (v == '1') then
                    gd.sliceResult[i] = 1
                else
                    gd.sliceResult[i] = 0
                end
            end
        end
        gd.weather = math.round(vl[7] or 1)
        gd.upgradePoint = math.round(vl[8] or 0)
        gd.upgradeDef = math.round(vl[9] or 0)
        gd.upgradeAtk = math.round(vl[10] or 0)
        gd.upgradeSpd = math.round(vl[11] or 0)
        vl = sev:load("DMX", 1)
        vl = math.round(vl)
        if (vl > gd.diffMax) then
            gd.diffMax = math.min(5, vl)
        end
        vl = sev:load("DFR", 0)
        vl = math.round(vl)
        if (vl > gd.fireLevel) then
            gd.fireLevel = math.min(9, vl)
        end
        vl = sev:load("KN", 0)
        vl = math.round(vl)
        if (vl > gd.lastDead) then
            gd.lastDead = vl
        end
        vl = string.explode("|", sev:load("OOO", "0|0|0|0|0|0|0|0"))
        vl[1] = math.round(vl[1] or 1)
        vl[2] = math.round(vl[2] or 1)
        vl[3] = math.round(vl[3] or 0)
        vl[4] = math.round(vl[4] or 0)
        vl[5] = math.round(vl[5] or 0)
        gd.meKill = vl[1]
        gd.meDead = vl[2]
        gd.meDied = vl[3]
        gd.meDamage = vl[4]
        gd.meHurt = vl[5]
        vl[6] = math.round(vl[6] or 0)
        vl[7] = math.round(vl[7] or 0)
        vl[8] = math.round(vl[8] or 0)
        gd.meE = { vl[6], vl[7], vl[8] }
        local def = "1|2|3|4|5|0|0"
        def = def .. '|' .. table.concat(table.repeater('0', gd.abilityTail), '|')
        def = def .. '|' .. table.concat(table.repeater('0', #Game():itemHotkey()), '|')
        vl = string.explode("|", sev:load("PPP", def))
        vl[1] = math.round(vl[1] or 1)
        vl[2] = math.round(vl[2] or 2)
        vl[3] = math.round(vl[3] or 3)
        vl[4] = math.round(vl[4] or 4)
        vl[5] = math.round(vl[5] or 5)
        vl[6] = math.round(vl[6] or 0)
        for i = 1, 5 do
            if (1 ~= gd.soul[vl[i]]) then
                if (i == 1) then
                    vl[i] = 1
                else
                    vl[i] = 0
                end
            end
        end
        gd.meSoul1 = vl[1]
        gd.meSoul2 = vl[2]
        gd.meSoul3 = vl[3]
        gd.meSoul4 = vl[4]
        gd.meSoul5 = vl[5]
        gd.meAbilityFreak = vl[6]
        gd.abilityLearn = {}
        for i = 7, (6 + gd.abilityTail) do
            local v = tonumber(vl[i] or 0)
            v = math.round(v)
            v = math.max(0, v)
            local j = i - 6
            gd.abilityLearn[j] = v
        end
        for i = (7 + gd.abilityTail), (6 + gd.abilityTail + #Game():itemHotkey()) do
            local v = tonumber(vl[i] or 0)
            v = math.round(v)
            v = math.min(#TPL_SACRED, v)
            v = math.max(0, v)
            local j = i - 6 - gd.abilityTail
            gd.sacredUse[j] = v
        end
        vl = string.split(sev:load("PPPP", string.repeater('0', #TPL_ACHIEVEMENT)), 1)
        gd.achievement = {}
        for i = 1, #TPL_ACHIEVEMENT do
            local v = vl[i]
            if (v == '1') then
                gd.achievement[i] = 1
            else
                gd.achievement[i] = 0
            end
        end
        if (gd.achievement[6] == 1) then
            UIKit("ninegrids_essence"):stage().switch.weather:alpha(255)
        end
        vl = string.split(sev:load("SSS", string.repeater('1', 8) .. string.repeater('0', #TPL_SOUL - 8)), 1)
        for i = 9, #TPL_SOUL do
            local v = vl[i]
            if (v == '1') then
                gd.soul[i] = 1
            else
                gd.soul[i] = 0
            end
        end
        vl = string.split(sev:load("LULU", string.repeater('1', #TPL_ABILITY_SOUL)), 1)
        gd.abilityLevel = {}
        for i = 1, #TPL_ABILITY_SOUL do
            local v = tonumber(vl[i] or 1)
            v = math.round(v)
            v = math.min(gd.abilityMaxLv, v)
            v = math.max(1, v)
            gd.abilityLevel[i] = v
        end
        vl = string.split(sev:load("SCGT", string.repeater('0', #TPL_SACRED)), 1)
        gd.sacredGet = {}
        for i = 1, #TPL_SACRED do
            local v = vl[i]
            if (v == '1') then
                gd.sacredGet[i] = 1
            else
                gd.sacredGet[i] = 0
            end
        end
        vl = string.split(sev:load("SCFG", string.repeater('1', #TPL_SACRED)), 1)
        gd.sacredForge = {}
        for i = 1, #TPL_SACRED do
            local v = tonumber(vl[i] or 1)
            v = math.round(v)
            v = math.min(gd.sacredMaxLv, v)
            v = math.max(1, v)
            gd.sacredForge[i] = v
        end
    end
    this:next("ihen")
end)
