local process = Process("slice_stone")
process:onStart(function(_)
    local gd = Game():GD()
    local diff = math.round(gd.diff)
    local hps = { 1500, 4000, 10000, 99999, 99999 }
    local atks = { 300, 800, 1500, 2500, 9999 }
    local asps = { 0, 20, 50, 100, 100 }
    local movs = { 100, 125, 175, 220, 220 }
    local e = Game():enemies(TPL_UNIT.E_PowerStone, -450, -512, 270)
    e:mp(1000)
     :hp(hps[diff])
     :attack(atks[diff])
     :attackSpeed(asps[diff])
     :move(movs[diff])
    AI("hate"):link(e)
    local cps = { 600, 1300, 2400, 3500, 3500 }
    local co = cps[diff]
    e:onEvent(EVENT.Unit.Dead, function()
        local s = Game():sacred(1)
        if (s == false) then
            Game():sacred(1, true)
        end
        local p = gd.me:owner()
        p:award({ copper = co })
        async.call(p, function()
            UI_NinegridsInfo:info("info", 5, "石人认输了|n奖励 " .. colour.hex(colour.orange, co) .. " 铜币")
        end)
        Game():npc("NPC_PowerStone", TPL_UNIT.NPC_PowerStone, -450, -512, 270)
    end)
end)