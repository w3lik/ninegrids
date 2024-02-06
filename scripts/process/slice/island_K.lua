local process = Process("slice_island_K")
process:onStart(function(this)
    this:next("interrupt")
    local gd = Game():GD()
    local icon, modelAlias, r, g, b
    if (gd.diff == 1) then
        icon = "ability/InscriptionVantusRuneAzure"
        modelAlias = "soulRune1"
        r, g, b = 109, 244, 225
    elseif (gd.diff == 2) then
        icon = "ability/InscriptionVantusRuneTomb"
        modelAlias = "soulRune2"
        r, g, b = 90, 227, 37
    elseif (gd.diff == 3) then
        icon = "ability/InscriptionVantusRuneSuramar"
        modelAlias = "soulRune3"
        r, g, b = 92, 67, 135
    elseif (gd.diff == 4) then
        icon = "ability/InscriptionVantusRuneNightmare"
        modelAlias = "soulRune4"
        r, g, b = 218, 39, 19
    elseif (gd.diff == 5) then
        icon = "ability/InscriptionVantusRuneOdyn"
        modelAlias = "soulRune5"
        r, g, b = 247, 251, 173
    end
    Game():npc("NPC_SoulRune", TPL_UNIT.NPC_SoulRune, 0, -550, 270, function(evtUnit)
        evtUnit:icon(icon)
        evtUnit:modelAlias(modelAlias)
        evtUnit:rgba(r, g, b)
    end)
    if (gd.diff <= 4) then
        Game():npc("NPC_Zeus", TPL_UNIT.NPC_Zeus, 0, 0, 270, function(evtUnit)
            evtUnit:modelScale(1.7):scale(2.0)
        end)
        Game():npc("NPC_Fire", TPL_UNIT.NPC_Fire, -638, 0, 270)
        Game():npc("NPC_Freak", TPL_UNIT.NPC_Freak, 320, 665, 270)
        Game():npc("NPC_Book", TPL_UNIT.NPC_Book, 512, -512, 270)
        Game():npc("NPC_PowerStone", TPL_UNIT.NPC_PowerStone, -450, -512, 270)
    end
    if (gd.diff == 1 and Game():achievement(6) == false) then
        balloonItemCreate("大空陨石", -1250, -550)
        balloonItemCreate("大空陨石", 470, -1180)
        balloonItemCreate("大空陨石", 650, 1040)
        balloonItemCreate("大空陨石", -460, 500)
        balloonItemCreate("大空陨石", 1350, -710)
    end
end)