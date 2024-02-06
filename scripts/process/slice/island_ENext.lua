local process = Process("slice_island_ENext")
process:onStart(function(_)
    local gd = Game():GD()
    local diff = math.round(gd.diff)
    local icon, modelAlias, r, g, b
    if (diff == 1) then
        icon = "ability/InscriptionVantusRuneTomb"
        modelAlias = "soulRune2"
        r, g, b = 90, 227, 37
    elseif (diff == 2) then
        icon = "ability/InscriptionVantusRuneSuramar"
        modelAlias = "soulRune3"
        r, g, b = 92, 67, 135
    elseif (diff == 3) then
        icon = "ability/InscriptionVantusRuneNightmare"
        modelAlias = "soulRune4"
        r, g, b = 218, 39, 19
    elseif (diff == 4) then
        icon = "ability/InscriptionVantusRuneOdyn"
        modelAlias = "soulRune5"
        r, g, b = 247, 251, 173
    elseif (diff == 5) then
        modelAlias = "env/RiftPurple"
    end
    if (diff < 5) then
        Game():npc("NPC_SoulRune", TPL_UNIT.NPC_SoulRuneNext, 0, 0, 270, function(evtUnit)
            evtUnit:icon(icon)
            evtUnit:modelAlias(modelAlias)
            evtUnit:rgba(r, g, b)
        end)
    else
        Game():npc("NPC_SoulLast", TPL_UNIT.NPC_SoulLast, 0, 0, 270, function(evtUnit)
            evtUnit:superposition("locust", 1)
            evtUnit:modelAlias(modelAlias)
        end)
    end
end)