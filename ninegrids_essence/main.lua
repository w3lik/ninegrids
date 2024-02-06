local kit = "ninegrids_essence"
local essenceMax = 48
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    local tipsEnter = function(key)
        return function(evtData)
            local tips = Store(key):description()
            evtData.triggerFrame:childHighlight():show(true)
            FrameTooltips()
                :relation(FRAME_ALIGN_RIGHT, evtData.triggerFrame, FRAME_ALIGN_LEFT, -0.006, 0)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :content({ tips = tips })
                :show(true)
        end
    end
    local tipsLeave = function(key)
        return function(evtData)
            if (key == "warehouse") then
                local frame = UIKit("ninegrids_ctl"):stage().warehouseDrag
                if (frame:show() ~= true) then
                    evtData.triggerFrame:childHighlight():show(false)
                end
            else
                local e = stage.essence:prop("essence")
                if (e ~= key) then
                    evtData.triggerFrame:childHighlight():show(false)
                end
            end
            FrameTooltips():show(false, 0)
        end
    end
    stage.essenceUndo = function(i)
        if (stage.essenceCurs[i] ~= nil) then
            stage.essenceCurs[i]:onEvent(EVENT.Frame.LeftClick, nil)
            stage.essenceCurs[i]:onEvent(EVENT.Frame.RightClick, nil)
            stage.essenceCurs[i]:onEvent(EVENT.Frame.Enter, nil)
            stage.essenceCurs[i]:onEvent(EVENT.Frame.Leave, nil)
            stage.essenceCurs[i]:show(false)
        end
    end
    stage.essence = FrameBackdrop(kit .. "->essenceBG", FrameGameUI)
        :adaptive(true)
        :texture("bg\\display")
        :block(true)
        :esc(true)
        :close(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.055)
        :show(false)
        :onEvent(EVENT.Frame.Hide,
        function()
            FrameTooltips():show(false)
            local key = stage.essence:prop("essence")
            if (key) then
                if (stage.switch[key]) then
                    stage.switch[key]:childHighlight():show(false)
                end
                for i = 1, essenceMax, 1 do
                    stage.essenceUndo(i)
                end
                stage.essence:clear("essence")
            end
        end)
    stage.essence:clear("essence")
    stage.essencePad = 0.024
    stage.essenceTitle = FrameText(kit .. "->essenceInfo->tit", stage.essence)
        :relation(FRAME_ALIGN_TOP, stage.essence, FRAME_ALIGN_TOP, 0, -stage.essencePad * 1.25)
        :fontSize(12)
        :text('')
    stage.essenceInfo = FrameBackdrop(kit .. "->essenceInfo", stage.essence)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.essence, FRAME_ALIGN_RIGHT_TOP, -stage.essencePad, -stage.essencePad * 2.5)
        :texture("Framework\\ui\\nil.tga")
    stage.essenceInfoIcon = FrameButton(kit .. "->essenceInfo->icon", stage.essenceInfo)
        :relation(FRAME_ALIGN_TOP, stage.essenceInfo, FRAME_ALIGN_TOP, 0, -stage.essencePad / 2)
        :texture("Framework\\ui\\nil.tga")
        :size(0.055, 0.055)
    stage.essenceBiographies = FrameBackdrop(kit .. "->essenceInfo->entertain", stage.essence)
        :relation(FRAME_ALIGN_LEFT, stage.essenceInfoIcon, FRAME_ALIGN_RIGHT, 0.003, 0.008)
        :size(0.022, 0.022)
        :texture("btn/i_what")
        :show(false)
    stage.essenceInfoName = FrameText(kit .. "->essenceInfo->name", stage.essenceInfo)
        :relation(FRAME_ALIGN_TOP, stage.essenceInfoIcon, FRAME_ALIGN_BOTTOM, 0, -0.005)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(11)
    stage.essenceInfoDesc = FrameText(kit .. "->essenceInfo->desc", stage.essenceInfo)
        :relation(FRAME_ALIGN_TOP, stage.essenceInfoName, FRAME_ALIGN_BOTTOM, 0, -0.007)
        :fontSize(9.5)
    local bw = 0.06
    stage.essenceConfirmB2 = FrameButton(kit .. "->essenceConfirm->b2", stage.essenceInfo)
        :relation(FRAME_ALIGN_BOTTOM, stage.essence, FRAME_ALIGN_RIGHT_BOTTOM, -0.176, 0.024)
        :texture("btn\\e_dark")
        :size(bw, bw * 60 / 128)
        :text("···")
    stage.essenceConfirmB1 = FrameButton(kit .. "->essenceConfirm->b1", stage.essenceInfo)
        :relation(FRAME_ALIGN_RIGHT, stage.essenceConfirmB2, FRAME_ALIGN_LEFT, -0.005, 0)
        :texture("btn\\e_dark")
        :size(bw, bw * 60 / 128)
        :text("···")
    stage.essenceConfirmB3 = FrameButton(kit .. "->essenceConfirm->b3", stage.essenceInfo)
        :relation(FRAME_ALIGN_LEFT, stage.essenceConfirmB2, FRAME_ALIGN_RIGHT, 0.005, 0)
        :texture("btn\\e_dark")
        :size(bw, bw * 60 / 128)
        :text("···")
    stage.essenceConfirmB1:childText():relation(FRAME_ALIGN_CENTER, stage.essenceConfirmB1, FRAME_ALIGN_CENTER, 0, 0.002)
    stage.essenceConfirmB2:childText():relation(FRAME_ALIGN_CENTER, stage.essenceConfirmB2, FRAME_ALIGN_CENTER, 0, 0.002)
    stage.essenceConfirmB3:childText():relation(FRAME_ALIGN_CENTER, stage.essenceConfirmB3, FRAME_ALIGN_CENTER, 0, 0.002)
    local bw2 = 0.05
    for i = 1, 5, 1 do
        local fb = FrameButton(kit .. "->essenceExtra->b" .. i, stage.essenceInfo)
            :texture("btn\\e_dark")
            :size(bw2, bw2 * 60 / 128)
            :text("···")
            :show(false)
        if (i == 1) then
            fb:relation(FRAME_ALIGN_RIGHT_TOP, stage.essence, FRAME_ALIGN_RIGHT_TOP, -0.04, -0.15)
        else
            fb:relation(FRAME_ALIGN_TOP, stage["essenceExtraB" .. (i - 1)], FRAME_ALIGN_BOTTOM, 0, -0.002)
        end
        fb:childText():relation(FRAME_ALIGN_CENTER, fb, FRAME_ALIGN_CENTER, 0, 0.002)
        stage["essenceExtraB" .. i] = fb
    end
    stage.essenceCurs = {}
    stage.essenceItems = {}
    for i = 1, essenceMax, 1 do
        stage.essenceItems[i] = FrameButton(kit .. "->essenceB->" .. i, stage.essence)
            :mask('Framework\\ui\\mask.tga')
            :fontSize(10)
            :show(false)
        stage.essenceItems[i]:childText()
             :relation(FRAME_ALIGN_LEFT_TOP, stage.essenceItems[i], FRAME_ALIGN_LEFT_TOP, 0.004, -0.004)
             :textAlign(TEXT_ALIGN_LEFT)
    end
    stage.shadowRound = FrameBackdrop(kit .. "->shadowRound", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_RIGHT_BOTTOM, FrameGameUI, FRAME_ALIGN_RIGHT_BOTTOM, 0, 0.04)
        :size(0.065, 0.42)
        :texture("Framework\\ui\\shadowRound.tga")
    local frameWarehouse = UIKit("ninegrids_ctl"):stage().warehouseDrag
    stage.switch = {}
    local _hk = function(frame)
        frame:hotkeyFontSize(9)
        frame:childHotkey():relation(FRAME_ALIGN_LEFT, frame, FRAME_ALIGN_RIGHT, 0, 0)
    end
    stage.switch.warehouse = FrameButton(kit .. "->warehouse", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.shadowRound, FRAME_ALIGN_BOTTOM, 0, 0.05)
        :size(0.04, 0.04)
        :texture("btn\\inventory")
        :hotkey('L')
        :onEvent(EVENT.Frame.LeftClick, function() frameWarehouse:show(not frameWarehouse:show()) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("warehouse"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("warehouse"))
    _hk(stage.switch.warehouse)
    local margin = 0.01
    stage.switch.sacred = FrameButton(kit .. "->sacred", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.warehouse, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :texture("btn\\deck")
        :hotkey('K')
        :onEvent(EVENT.Frame.LeftClick, function() this:essence("sacred", 8, true) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("sacred"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("sacred"))
    _hk(stage.switch.sacred)
    stage.switch.achievement = FrameButton(kit .. "->achievement", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.sacred, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :texture("btn\\achievement")
        :hotkey('J')
        :onEvent(EVENT.Frame.LeftClick, function() this:essence("achievement", 5, true) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("achievement"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("achievement"))
    _hk(stage.switch.achievement)
    stage.switch.soul = FrameButton(kit .. "->soul", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.achievement, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :texture("btn\\soul")
        :hotkey('O')
        :onEvent(EVENT.Frame.LeftClick, function() this:essence("soul", 8, true) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("soul"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("soul"))
    _hk(stage.switch.soul)
    stage.switch.ability = FrameButton(kit .. "->ability", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.soul, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :texture("btn\\book")
        :hotkey('I')
        :onEvent(EVENT.Frame.LeftClick, function() this:essence("ability", 8, true) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("ability"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("ability"))
    _hk(stage.switch.ability)
    stage.switch.fire = FrameButton(kit .. "->fire", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.ability, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :texture("btn\\fire")
        :hotkey('U')
        :onEvent(EVENT.Frame.LeftClick, function() this:essence("fire", 2, true) end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("fire"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("fire"))
    _hk(stage.switch.fire)
    stage.switch.weather = FrameButton(kit .. "->weather", stage.shadowRound)
        :relation(FRAME_ALIGN_BOTTOM, stage.switch.fire, FRAME_ALIGN_TOP, 0, margin)
        :size(0.04, 0.04)
        :alpha(100)
        :texture("btn\\weather")
        :hotkey('T')
        :onEvent(EVENT.Frame.LeftClick,
        function()
            if (Game():achievement(6)) then
                this:essence("weather", 2, true)
            end
        end)
        :onEvent(EVENT.Frame.Enter, tipsEnter("weather"))
        :onEvent(EVENT.Frame.Leave, tipsLeave("weather"))
    _hk(stage.switch.weather)
    keyboard.onRelease(KEYBOARD["T"], kit, function()
        if (Game():achievement(6)) then
            this:essence("weather", 2, true)
        end
    end)
    keyboard.onRelease(KEYBOARD["U"], kit, function() this:essence("fire", 2, true) end)
    keyboard.onRelease(KEYBOARD["I"], kit, function() this:essence("ability", 8, true) end)
    keyboard.onRelease(KEYBOARD["O"], kit, function() this:essence("soul", 8, true) end)
    keyboard.onRelease(KEYBOARD["J"], kit, function() this:essence("achievement", 5, true) end)
    keyboard.onRelease(KEYBOARD["K"], kit, function() this:essence("sacred", 8, true) end)
    keyboard.onRelease(KEYBOARD["L"], kit, function() frameWarehouse:show(not frameWarehouse:show()) end)
    sync.receive(kit, function(syncData)
        local p = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "firePush") then
            local idx = tonumber(syncData.transferData[2])
            Game():firePush(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("fire", 2)
                end)
            end)
        elseif (command == "fireRemove") then
            local idx = tonumber(syncData.transferData[2])
            Game():fireRemove(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("fire", 2)
                end)
            end)
        elseif (command == "abilityLvUp") then
            local idx = tonumber(syncData.transferData[2])
            time.setTimeout(0.3, function()
                Game():abilityLvUp(idx)
                async.call(p, function()
                    this:lvUp(idx, true)
                end)
            end)
        elseif (command == "abilityPush") then
            local idx = tonumber(syncData.transferData[2])
            Game():abilityPush(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("ability", 8)
                end)
            end)
        elseif (command == "abilityRemove") then
            local idx = tonumber(syncData.transferData[2])
            Game():abilityRemove(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("ability", 8)
                end)
            end)
        elseif (command == "abilityFreakPush") then
            local idx = tonumber(syncData.transferData[2])
            Game():abilityFreakPush(idx)
        elseif (command == "sacredPush") then
            local idx = tonumber(syncData.transferData[2])
            Game():sacredPush(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("sacred", 8)
                end)
            end)
        elseif (command == "sacredForge") then
            local idx = tonumber(syncData.transferData[2])
            time.setTimeout(0.3, function()
                Game():sacredForge(idx)
                async.call(p, function()
                    this:forger(idx, 1)
                end)
            end)
        elseif (command == "sacredForge10") then
            local idx = tonumber(syncData.transferData[2])
            time.setTimeout(0.3, function()
                Game():sacredForge10(idx)
                async.call(p, function()
                    this:forger(idx, 10)
                end)
            end)
        elseif (command == "sacredRemove") then
            local idx = tonumber(syncData.transferData[2])
            Game():sacredRemove(idx)
            time.setTimeout(0.1, function()
                async.call(p, function()
                    stage.essence:show(false)
                    this:essence("sacred", 8)
                end)
            end)
        elseif (command == "soulRune") then
            local idx = tonumber(syncData.transferData[2])
            Game():soulRune(idx)
        elseif (command == "soul") then
            local idx = tonumber(syncData.transferData[2])
            Game():meSoulC(idx)
        elseif (command == "soulC") then
            local idx = tonumber(syncData.transferData[2])
            Game():meSoulC(idx)
        elseif (command == "soulF") then
            local idx = tonumber(syncData.transferData[2])
            local fn = tonumber(syncData.transferData[3])
            Game():meSoulF(idx, fn)
            async.call(p, function()
                this:essence("soul", 8)
            end)
        elseif (command == "weather") then
            local idx = tonumber(syncData.transferData[2])
            Game():weather(idx)
        end
    end)
end)
function ui:isCurEssence(key, tpl)
    local is = false
    local gd = Game():GD()
    if (key == "fire" or key == "ability") then
        is = gd.me:abilitySlot():has(tpl)
    elseif (key == "sacred") then
        is = gd.me:itemSlot():has(tpl)
    elseif (key == "weather") then
        is = tpl:prop("idx") == gd.weather
    elseif (key == "soul") then
        is = tpl:prop("idx") == gd.meSoul1
    elseif (key == "soulRune") then
        is = tpl:prop("idx") == gd.diff
    end
    return is
end
function ui:isSoul(tpl, idx)
    local gd = Game():GD()
    return tpl:prop("idx") == gd["meSoul" .. idx]
end
function ui:isAllowUpdated(key, tpl)
    local lv = false
    local wor = false
    local wor10 = false
    local gd = Game():GD()
    if (key == "ability") then
        local idx = tpl:prop("idx")
        local abLv = gd.abilityLevel[idx]
        lv = abLv < gd.abilityMaxLv
        wor = Game():worthEqualOrGreater(gd.me:owner():worth(), Game():abilityLevelUpWorth(idx, abLv))
    elseif (key == "sacred") then
        local idx = tpl:prop("idx")
        local fgLv = gd.sacredForge[idx]
        lv = fgLv < gd.sacredMaxLv
        local pw = gd.me:owner():worth()
        local tw = Game():sacredForgeWorth(idx, fgLv)
        wor = Game():worthEqualOrGreater(pw, tw)
        wor10 = Game():worthEqualOrGreater(pw, Game():worthCale(tw, "*", 10))
    end
    return lv, wor, wor10
end
function ui:lvUp(idx, cover)
    async.must()
    local gd = Game():GD()
    local stage = self:stage()
    local tpl = TPL_ABILITY_SOUL[idx]
    local passLv, passWor = self:isAllowUpdated("ability", tpl)
    if (passLv) then
        if (passWor) then
            stage.essenceConfirmB1:text("升级"):texture("btn\\e_green"):onEvent(EVENT.Frame.LeftClick, function(evtData)
                evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                UI_NinegridsAnimate:doing(stage.essenceConfirmB2, -0.002, 0.212)
                sync.send(kit, { "abilityLvUp", idx })
                audio(Vcm("war3_MouseClick1"))
            end)
        else
            stage.essenceConfirmB1:text("升级"):texture("btn\\e_dark")
        end
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Leave, function()
            FrameTooltips():show(false)
            local lv = gd.abilityLevel[idx]
            local d = Game():combineDescription(tpl, { level = lv }, "abilityBook")
            if (type(d) == "table") then
                d = table.concat(d, "|n")
            end
            stage.essenceInfoDesc:text(d)
        end)
        local f = function()
            local lv = gd.abilityLevel[idx] + 1
            stage.essenceInfoDesc:text(table.concat(Game():combineDescription(tpl, { level = lv }, "abilityBook"), "|n"))
            FrameTooltips()
                :fontSize(10)
                :textAlign(TEXT_ALIGN_LEFT)
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.essenceInfoIcon, FRAME_ALIGN_LEFT_TOP, -0.005, 0.002)
                :content(tooltipsLvUp(idx))
                :show(true)
        end
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Enter, f)
        if (cover == true) then
            f()
        end
    else
        stage.essenceConfirmB1:text("圆满"):texture("btn\\e_dark")
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Leave, nil):onEvent(EVENT.Frame.Enter, nil)
        stage.essenceInfoDesc:text(table.concat(Game():combineDescription(tpl, { level = gd.abilityMaxLv }, "abilityBook"), "|n"))
        FrameTooltips():show(false)
    end
    local al = gd.abilityLevel[idx]
    if (al >= gd.abilityMaxLv) then
        stage.essenceItems[idx]:text(colour.hex(colour.gold, "Lv." .. al))
    else
        stage.essenceItems[idx]:text("Lv." .. al)
    end
    stage.essenceConfirmB1:alpha(255):onEvent(EVENT.Frame.Enter, "childHighlight", nil)
    stage.essenceConfirmB1:childHighlight():show(false)
end
function ui:forger(idx, coverIndex)
    async.must()
    local gd = Game():GD()
    local stage = self:stage()
    local tpl = TPL_SACRED[idx]
    local passLv, passWor, passWor10 = self:isAllowUpdated("sacred", tpl)
    if (passLv) then
        if (passWor) then
            stage.essenceConfirmB1:text("精炼"):texture("btn\\e_green")
            stage.essenceConfirmB1:onEvent(EVENT.Frame.LeftClick, function(evtData)
                stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, nil)
                evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil)
                evtData.triggerFrame:alpha(180):texture("btn\\e_dark")
                UI_NinegridsAnimate:doing(stage.essenceConfirmB2, -0.002, 0.212)
                audio(Vcm("forge"))
                sync.send(kit, { "sacredForge", idx })
            end)
        else
            stage.essenceConfirmB1:text("精炼"):texture("btn\\e_dark")
        end
        if (passWor10) then
            stage.essenceConfirmB2:text("精炼十连"):texture("btn\\e_green")
            stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function(evtData)
                stage.essenceConfirmB1:onEvent(EVENT.Frame.LeftClick, nil)
                evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil)
                evtData.triggerFrame:alpha(180):texture("btn\\e_dark")
                UI_NinegridsAnimate:doing(stage.essenceConfirmB2, -0.002, 0.212)
                audio(Vcm("forge"))
                sync.send(kit, { "sacredForge10", idx })
            end)
        else
            stage.essenceConfirmB2:text("精炼十连"):texture("btn\\e_dark")
        end
        stage.essenceConfirmB2:show(true)
        local l = function()
            FrameTooltips():show(false)
            local d = Game():combineDescription(tpl, nil, "sacred")
            if (type(d) == "table") then
                d = table.concat(d, "|n")
            end
            stage.essenceInfoDesc:text(d)
        end
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Leave, l)
        stage.essenceConfirmB2:onEvent(EVENT.Frame.Leave, l)
        local f = function(times)
            local lv = gd.sacredForge[idx] + 1
            stage.essenceInfoDesc:text(table.concat(Game():combineDescription(tpl, { level = lv }, "sacred"), "|n"))
            FrameTooltips()
                :fontSize(10)
                :textAlign(TEXT_ALIGN_LEFT)
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.essenceInfoIcon, FRAME_ALIGN_LEFT_TOP, -0.005, 0.002)
                :content(tooltipsForge(idx, times))
                :show(true)
        end
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Enter, function() f(1) end)
        stage.essenceConfirmB2:onEvent(EVENT.Frame.Enter, function() f(10) end)
        if (type(coverIndex) == "number") then
            f(coverIndex)
        end
    else
        stage.essenceConfirmB1:text("满精"):texture("btn\\e_dark")
        stage.essenceConfirmB1:onEvent(EVENT.Frame.Leave, nil):onEvent(EVENT.Frame.Enter, nil)
        stage.essenceConfirmB2:onEvent(EVENT.Frame.Leave, nil):onEvent(EVENT.Frame.Enter, nil):show(false)
        stage.essenceConfirmB1:relation(FRAME_ALIGN_RIGHT, stage.essenceConfirmB2, FRAME_ALIGN_LEFT, 0.024, 0)
        stage.essenceConfirmB3:relation(FRAME_ALIGN_LEFT, stage.essenceConfirmB2, FRAME_ALIGN_RIGHT, -0.024, 0)
        stage.essenceInfoDesc:text(table.concat(Game():combineDescription(tpl, { level = gd.sacredMaxLv }, "sacred"), "|n"))
        FrameTooltips():show(false)
    end
    local sf = gd.sacredForge[idx]
    if (sf >= gd.sacredMaxLv) then
        stage.essenceItems[idx]:text(colour.hex(colour.gold, "精" .. sf))
    else
        stage.essenceItems[idx]:text("精" .. sf)
    end
    stage.essenceConfirmB1:alpha(255):onEvent(EVENT.Frame.Enter, "childHighlight", nil)
    stage.essenceConfirmB2:alpha(255):onEvent(EVENT.Frame.Enter, "childHighlight", nil)
    stage.essenceConfirmB1:childHighlight():show(false)
    stage.essenceConfirmB2:childHighlight():show(false)
end
function ui:essenceTick(key, tpl)
    async.must()
    local stage = self:stage()
    stage.essenceInfoIcon:texture(tpl:icon())
    local name = "???"
    local desc = "···"
    for i = 1, 3 do
        local b = stage["essenceConfirmB" .. i]
        b:text('...'):texture("btn\\e_dark"):alpha(255):show(false)
        b:childHighlight():show(false)
        b:onEvent(EVENT.Frame.LeftClick, nil)
        b:onEvent(EVENT.Frame.Enter, nil)
        b:onEvent(EVENT.Frame.Leave, nil)
    end
    stage.essenceConfirmB1:relation(FRAME_ALIGN_RIGHT, stage.essenceConfirmB2, FRAME_ALIGN_LEFT, -0.001, 0)
    stage.essenceConfirmB3:relation(FRAME_ALIGN_LEFT, stage.essenceConfirmB2, FRAME_ALIGN_RIGHT, 0.001, 0)
    stage.essenceInfoIcon:border("border\\white")
    stage.essenceInfoDesc:textAlign(TEXT_ALIGN_CENTER)
    stage.essenceBiographies:show(false)
    stage.essenceBiographies:onEvent(EVENT.Frame.Enter, nil)
    stage.essenceBiographies:onEvent(EVENT.Frame.Leave, nil)
    for i = 1, 5, 1 do
        local b = stage["essenceExtraB" .. i]
        b:texture("btn\\e_dark"):show(false)
        b:childHighlight():show(false)
        b:onEvent(EVENT.Frame.LeftClick, nil)
        b:onEvent(EVENT.Frame.Enter, nil)
        b:onEvent(EVENT.Frame.Leave, nil)
    end
    local isCurTpl = self:isCurEssence(key, tpl)
    if (isCurTpl) then
        stage.essenceInfoIcon:border("border\\checkBlue")
    else
        stage.essenceInfoIcon:border("border\\white")
    end
    local check = tpl:condition()
    if (check == false) then
        if (key == "soul" or key == "ability" or key == "sacred") then
            check = true
        end
    end
    if (instanceof(tpl, TplClass)) then
        if (key == "fire" and isClass(tpl, AbilityTplClass)) then
            name = tpl:name()
            desc = table.merge(desc, Game():combineDescription(tpl, nil, "abilityFire"))
            if (check) then
                if (isCurTpl) then
                    stage.essenceConfirmB2:text("遗忘"):texture("btn\\e_red")
                    stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "fireRemove", tpl:prop("idx") })
                    end)
                else
                    stage.essenceConfirmB2:text("学习"):texture("btn\\e_green")
                    stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "firePush", tpl:prop("idx") })
                    end)
                end
            else
                stage.essenceConfirmB2:text("封印")
                stage.essenceConfirmB2:texture("btn\\e_dark")
            end
            stage.essenceInfoDesc:textAlign(TEXT_ALIGN_LEFT)
            stage.essenceConfirmB2:show(true)
        elseif (key == "ability" and isClass(tpl, AbilityTplClass)) then
            name = tpl:name()
            local idx = tpl:prop("idx")
            desc = table.merge(desc, Game():combineDescription(tpl, { level = Game():GD().abilityLevel[idx] }, "abilityBook"))
            if (check) then
                self:lvUp(idx)
                if (isCurTpl) then
                    stage.essenceConfirmB3:text("遗忘"):texture("btn\\e_red")
                    stage.essenceConfirmB3:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "abilityRemove", tpl:prop("idx") })
                    end)
                else
                    stage.essenceConfirmB3:text("学习"):texture("btn\\e_green")
                    stage.essenceConfirmB3:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "abilityPush", idx })
                    end)
                end
            else
                stage.essenceConfirmB3:text("封印")
                stage.essenceConfirmB3:texture("btn\\e_dark")
            end
            stage.essenceInfoDesc:textAlign(TEXT_ALIGN_LEFT)
            stage.essenceConfirmB1:relation(FRAME_ALIGN_RIGHT, stage.essenceConfirmB2, FRAME_ALIGN_LEFT, 0.024, 0)
            stage.essenceConfirmB3:relation(FRAME_ALIGN_LEFT, stage.essenceConfirmB2, FRAME_ALIGN_RIGHT, -0.024, 0)
            stage.essenceConfirmB1:show(true)
            stage.essenceConfirmB3:show(true)
        elseif (key == "abilityFreak" and isClass(tpl, AbilityTplClass)) then
            name = tpl:name()
            desc = Game():combineDescription(tpl, nil, "abilityFreak")
            if (check) then
                stage.essenceConfirmB2:text("学习"):texture("btn\\e_green")
                stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function()
                    stage.essence:show(false)
                    sync.send(kit, { "abilityFreakPush", tpl:prop("idx") })
                end)
                stage.essenceConfirmB2:onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
                stage.essenceConfirmB2:onEvent(EVENT.Frame.Enter, function()
                    FrameTooltips()
                        :fontSize(10)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :relation(FRAME_ALIGN_RIGHT_TOP, stage.essenceInfoIcon, FRAME_ALIGN_LEFT_TOP, -0.005, 0.002)
                        :content({
                        tips = {
                            "请注意，学习后",
                            colour.hex(colour.red, "! 技能不可换 !"),
                            colour.hex(colour.red, "! 死亡才消失 !"),
                        } })
                        :show(true)
                end)
            else
                stage.essenceConfirmB2:text("封印")
                stage.essenceConfirmB2:texture("btn\\e_dark")
            end
            stage.essenceInfoDesc:textAlign(TEXT_ALIGN_LEFT)
            stage.essenceConfirmB2:show(true)
        elseif (key == "sacred" and isClass(tpl, ItemTplClass)) then
            name = tpl:name()
            desc = Game():combineDescription(tpl, nil, "sacred")
            if (check) then
                local idx = tpl:prop("idx")
                self:forger(idx)
                if (isCurTpl) then
                    stage.essenceConfirmB3:text("卸下"):texture("btn\\e_red")
                    stage.essenceConfirmB3:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "sacredRemove", idx })
                    end)
                else
                    stage.essenceConfirmB3:text("装备"):texture("btn\\e_green")
                    stage.essenceConfirmB3:onEvent(EVENT.Frame.LeftClick, function(evtData)
                        evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil):alpha(180):texture("btn\\e_dark")
                        sync.send(kit, { "sacredPush", idx })
                    end)
                end
            else
                stage.essenceConfirmB1:relation(FRAME_ALIGN_RIGHT, stage.essenceConfirmB2, FRAME_ALIGN_LEFT, 0.024, 0)
                stage.essenceConfirmB3:relation(FRAME_ALIGN_LEFT, stage.essenceConfirmB2, FRAME_ALIGN_RIGHT, -0.024, 0)
                stage.essenceConfirmB1:text("封印")
                stage.essenceConfirmB2:show(false)
                stage.essenceConfirmB3:text("封印")
                stage.essenceConfirmB3:texture("btn\\e_dark")
            end
            stage.essenceInfoDesc:textAlign(TEXT_ALIGN_LEFT)
            stage.essenceConfirmB1:show(true)
            stage.essenceConfirmB3:show(true)
            stage.essenceBiographies:onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
            stage.essenceBiographies:onEvent(EVENT.Frame.Enter, function()
                FrameTooltips()
                    :fontSize(9)
                    :textAlign(TEXT_ALIGN_LEFT)
                    :relation(FRAME_ALIGN_RIGHT_TOP, stage.essenceInfoIcon, FRAME_ALIGN_LEFT_TOP, -0.005, 0.002)
                    :content({ tips = tpl:entertain() })
                    :show(true)
            end)
            stage.essenceBiographies:show(true)
        elseif (key == "soul" and isClass(tpl, UnitTplClass)) then
            name = tpl:name()
            desc = Game():combineDescription(tpl, nil, "unitSoul")
            if (check) then
                if (isCurTpl) then
                    stage.essenceConfirmB2:text("当前")
                    stage.essenceConfirmB2:texture("btn\\e_dark")
                else
                    stage.essenceConfirmB2:text("共鸣")
                    stage.essenceConfirmB2:texture("btn\\e_green")
                    stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function()
                        stage.essence:show(false)
                        sync.send(kit, { "soul", tpl:prop("idx") })
                    end)
                end
            else
                stage.essenceConfirmB2:text("封印")
                stage.essenceConfirmB2:texture("btn\\e_dark")
            end
            stage.essenceInfoDesc:textAlign(TEXT_ALIGN_LEFT)
            stage.essenceConfirmB2:show(true)
            if (false == isCurTpl) then
                for i = 2, 5, 1 do
                    local b = stage["essenceExtraB" .. (i - 1)]
                    if (self:isSoul(tpl, i)) then
                        b:texture("btn\\e_dark"):text("当前F" .. i)
                    else
                        b:texture("btn\\e_green"):text("设为F" .. i)
                        b:onEvent(EVENT.Frame.Leave, function() b:childHighlight():show(false) end)
                        b:onEvent(EVENT.Frame.Enter, function() b:childHighlight():show(true) end)
                        b:onEvent(EVENT.Frame.LeftClick, function()
                            stage.essence:show(false)
                            sync.send(kit, { "soulF", tpl:prop("idx"), i })
                        end)
                    end
                    b:show(true)
                end
            end
            stage.essenceBiographies:onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
            stage.essenceBiographies:onEvent(EVENT.Frame.Enter, function()
                FrameTooltips()
                    :fontSize(9)
                    :textAlign(TEXT_ALIGN_LEFT)
                    :relation(FRAME_ALIGN_RIGHT_TOP, stage.essenceInfoIcon, FRAME_ALIGN_LEFT_TOP, -0.005, 0.002)
                    :content({ tips = tpl:entertain() })
                    :show(true)
            end)
            stage.essenceBiographies:show(true)
        elseif (key == "achievement") then
            name = '《' .. tpl:name() .. '》'
            desc = Game():combineDescription(tpl, nil, "achievement")
        elseif (key == "weather") then
            name = tpl:name()
            desc = Game():combineDescription(tpl, nil, SYMBOL_D)
            if (check) then
                if (isCurTpl) then
                    stage.essenceConfirmB2:text("当前")
                    stage.essenceConfirmB2:texture("btn\\e_dark")
                else
                    stage.essenceConfirmB2:text("召唤")
                    stage.essenceConfirmB2:texture("btn\\e_green")
                    stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function()
                        audio(Vcm("weather"))
                        stage.essence:show(false)
                        sync.send(kit, { "weather", tpl:prop("idx") })
                    end)
                end
            else
                stage.essenceConfirmB2:text("封印")
                stage.essenceConfirmB2:texture("btn\\e_dark")
            end
            stage.essenceConfirmB2:show(true)
        elseif (key == "soulRune") then
            desc = Game():combineDescription(tpl, nil, SYMBOL_D)
            name = desc[1]
            table.remove(desc, 1)
            if (check == false and tpl:prop("condition") ~= nil) then
                table.insert(desc, "")
                table.insert(desc, colour.format("跨跃条件：%s", colour.mintcream, {
                    { colour.mintcream, tpl:conditionTips() or "未知" }
                }))
            end
            if (check) then
                if (isCurTpl) then
                    stage.essenceConfirmB2:text("当前")
                    stage.essenceConfirmB2:texture("btn\\e_dark")
                else
                    stage.essenceConfirmB2:text("跨跃")
                    stage.essenceConfirmB2:texture("btn\\e_green")
                    stage.essenceConfirmB2:onEvent(EVENT.Frame.LeftClick, function()
                        stage.essence:show(false)
                        sync.send(kit, { "soulRune", tpl:prop("idx") })
                    end)
                end
            else
                stage.essenceConfirmB2:text("封印")
                stage.essenceConfirmB2:texture("btn\\e_dark")
            end
            stage.essenceConfirmB2:show(true)
        end
    end
    if (type(desc) == "table") then
        desc = table.concat(desc, "|n")
    end
    if (check) then
        stage.essenceInfo:alpha(255)
    else
        stage.essenceInfo:alpha(180)
    end
    stage.essenceInfoName:text(name)
    stage.essenceInfoDesc:text(desc)
    for i = 1, 3 do
        local b = stage["essenceConfirmB" .. i]
        if (b:show() and b:texture() ~= "war3mapUI\\ninegrids_essence\\assets\\btn\\e_dark.tga") then
            b:onEvent(EVENT.Frame.Enter, "childHighlight", function(evtData) evtData.triggerFrame:childHighlight():show(true) end)
            b:onEvent(EVENT.Frame.Leave, "childHighlight", function(evtData) evtData.triggerFrame:childHighlight():show(false) end)
        else
            b:onEvent(EVENT.Frame.Enter, "childHighlight", nil)
            b:onEvent(EVENT.Frame.Leave, "childHighlight", nil)
        end
    end
end
function ui:essence(key, wn, withVoice)
    must(type(key) == "string")
    async.must()
    if (false == isStaticClass(key, StoreClass)) then
        return
    end
    local p = PlayerLocal()
    async.call(p, function()
        local stage = self:stage()
        local prevKey = stage.essence:prop("essence")
        local essenceTickTpl = stage.essence:prop("essenceTickTpl")
        if (essenceTickTpl == nil) then
            essenceTickTpl = {}
            stage.essence:prop("essenceTickTpl", essenceTickTpl)
        end
        local enable = (prevKey == nil)
        if (prevKey ~= nil and prevKey ~= key) then
            stage.essence:show(false)
            enable = true
        end
        if (enable == true) then
            stage.essence:prop("wn", wn)
            if (true == withVoice) then
                audio(Vcm("war3_MouseClick1"))
            end
            local st = Store(key)
            stage.essenceTitle:text(st:name())
            local size = 0.045
            local margin = 0.01
            local data = st:salesGoods()
            local gd = Game():GD()
            if (isClass(gd.me, UnitClass) and gd.me:isAlive()) then
                if (isClass(data, ArrayClass)) then
                    local num = data:count()
                    local hn = math.ceil(num / wn)
                    local w = wn * size + (wn - 1) * margin
                    local h = hn * size + (hn - 1) * margin
                    local wif = 0.3
                    local hif = 0.26
                    h = math.max(hif, h)
                    stage.essenceInfo:size(wif, h)
                    stage.essence:prop("essence", key)
                    stage.essence:size(stage.essencePad * 4 + margin + w + wif, stage.essencePad * 3 + h + 0.02)
                    stage.essence:show(true)
                    if (stage.switch[key]) then
                        stage.switch[key]:childHighlight():show(true)
                    end
                    for i = 1, essenceMax, 1 do
                        if (i <= num) then
                            local d = data:get(i)
                            local tpl = d.goods
                            stage.essenceCurs[i] = stage.essenceItems[i]
                            if (i == 1) then
                                stage.essenceCurs[i]:relation(FRAME_ALIGN_LEFT_TOP, stage.essenceInfo, FRAME_ALIGN_LEFT_TOP, -(margin + size) * wn, 0)
                            elseif (wn == 1) then
                                stage.essenceCurs[i]:relation(FRAME_ALIGN_TOP, stage.essenceCurs[i - 1], FRAME_ALIGN_BOTTOM, 0, -margin)
                            elseif ((i - 1) % wn == 0) then
                                local j = (math.floor(i / wn) - 1) * wn + 1
                                stage.essenceCurs[i]:relation(FRAME_ALIGN_TOP, stage.essenceCurs[j], FRAME_ALIGN_BOTTOM, 0, -margin)
                            else
                                stage.essenceCurs[i]:relation(FRAME_ALIGN_LEFT, stage.essenceCurs[i - 1], FRAME_ALIGN_RIGHT, margin, 0)
                            end
                            local allow = false
                            if (tpl:condition()) then
                                allow = true
                            elseif ((key == "soul" or key == "ability" or key == "sacred")) then
                                allow = true
                            end
                            if (allow) then
                                stage.essenceCurs[i]:alpha(255)
                                if (key == "sacred") then
                                    stage.essenceCurs[i]:onEvent(EVENT.Frame.RightClick, function()
                                        if (self:isCurEssence(key, tpl)) then
                                            sync.send(kit, { "sacredRemove", tpl:prop("idx") })
                                        else
                                            sync.send(kit, { "sacredPush", tpl:prop("idx") })
                                        end
                                    end)
                                elseif (key == "fire") then
                                    stage.essenceCurs[i]:onEvent(EVENT.Frame.RightClick, function()
                                        if (self:isCurEssence(key, tpl)) then
                                            sync.send(kit, { "fireRemove", tpl:prop("idx") })
                                        else
                                            sync.send(kit, { "firePush", tpl:prop("idx") })
                                        end
                                    end)
                                elseif (key == "ability") then
                                    stage.essenceCurs[i]:onEvent(EVENT.Frame.RightClick, function()
                                        if (self:isCurEssence(key, tpl)) then
                                            sync.send(kit, { "abilityRemove", tpl:prop("idx") })
                                        else
                                            sync.send(kit, { "abilityPush", tpl:prop("idx") })
                                        end
                                    end)
                                end
                            else
                                stage.essenceCurs[i]:alpha(50)
                            end
                            stage.essenceCurs[i]:text('')
                            if (allow) then
                                if (key == "sacred") then
                                    local sf = gd.sacredForge[i]
                                    if (sf >= gd.sacredMaxLv) then
                                        stage.essenceCurs[i]:text(colour.hex(colour.gold, "精" .. sf))
                                    else
                                        stage.essenceCurs[i]:text("精" .. sf)
                                    end
                                elseif (key == "ability") then
                                    local al = gd.abilityLevel[i]
                                    if (al >= gd.abilityMaxLv) then
                                        stage.essenceCurs[i]:text(colour.hex(colour.gold, "Lv." .. al))
                                    else
                                        stage.essenceCurs[i]:text("Lv." .. al)
                                    end
                                elseif (key == "soul") then
                                    for j = 2, 5, 1 do
                                        if (self:isSoul(tpl, j)) then
                                            stage.essenceCurs[i]:text("F" .. j)
                                            break
                                        end
                                    end
                                end
                            end
                            stage.essenceCurs[i]:onEvent(EVENT.Frame.LeftClick, function(evtData)
                                local essenceTickFr = stage.essence:prop("essenceTickFr")
                                if (essenceTickFr ~= nil) then
                                    essenceTickFr:childHighlight():show(false)
                                end
                                essenceTickFr = evtData.triggerFrame
                                stage.essence:prop("essenceTickFr", essenceTickFr)
                                if (essenceTickFr:alpha() == 255) then
                                    audio(Vcm("war3_MouseClick1"))
                                else
                                    audio(Vcm("war3_MouseClick2"))
                                end
                                self:essenceTick(key, tpl)
                                essenceTickTpl[key] = tpl
                            end)
                            if (self:isCurEssence(key, tpl)) then
                                stage.essenceCurs[i]:border("border\\checkGold")
                            else
                                stage.essenceCurs[i]:border("border\\white")
                            end
                            stage.essenceCurs[i]:onEvent(EVENT.Frame.Enter, function(evtData) evtData.triggerFrame:childHighlight():show(true) end)
                            stage.essenceCurs[i]:onEvent(EVENT.Frame.Leave,
                                function(evtData)
                                    local essenceTickFr = stage.essence:prop("essenceTickFr")
                                    if (essenceTickFr ~= evtData.triggerFrame) then
                                        evtData.triggerFrame:childHighlight():show(false)
                                    end
                                end)
                            stage.essenceCurs[i]:size(size, size):texture(tpl:icon()):show(true)
                            if (i == 1) then
                                self:essenceTick(key, essenceTickTpl[key] or tpl)
                            end
                        else
                            stage.essenceUndo(i)
                        end
                    end
                end
            end
        else
            if (true == withVoice) then
                audio(Vcm("war3_MouseClick2"))
            end
            stage.essence:show(false)
        end
    end)
end