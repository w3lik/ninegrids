local kit = "ninegrids_upgrade"
UI_NinegridsUpgrade = UIKit(kit)
UI_NinegridsUpgrade:onSetup(function(this)
    local stage = this:stage()
    stage.main = FrameBackdrop(kit .. "->main", FrameGameUI)
        :adaptive(true)
        :prop("texture", assets.uikit("ninegrids_essence", "bg\\display", "tga"))
        :block(true)
        :esc(true)
        :close(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.055)
        :size(0.6, 0.32)
        :show(false)
        :onEvent(EVENT.Frame.Hide, function() FrameTooltips():show(false) end)
    stage.mainTxt = FrameText(kit .. "->mainTxt", stage.main)
        :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, 0, -0.03)
        :fontSize(13)
    stage.levelIcon = {}
    stage.levelTxt = {}
    stage.attrTxt = {}
    stage.confirmBtn = {}
    stage.confirmBtn10 = {}
    local bw = 0.054
    local ic = { "ability/HolyGreaterBlessingofSanctuary", "ability/ShockCut", "ability/Greenphantom" }
    local rel = { -0.18, 0, 0.18 }
    local typ = { "def", "atk", "spd" }
    for i, t in ipairs(typ) do
        stage.levelTxt[i] = FrameText(kit .. "->levelTxt->" .. t, stage.main)
            :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, rel[i], -0.08)
            :fontSize(12)
            :text(t)
        stage.levelIcon[i] = FrameBackdrop(kit .. "->levelIcon->" .. t, stage.main)
            :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, rel[i], -0.103)
            :texture(assets.icon(ic[i]))
            :size(0.06, 0.06)
        stage.attrTxt[i] = FrameText(kit .. "->attrTxt->" .. t, stage.main)
            :relation(FRAME_ALIGN_TOP, stage.levelIcon[i], FRAME_ALIGN_TOP, 0, -0.08)
            :fontSize(10)
            :textAlign(TEXT_ALIGN_LEFT)
            :text(t)
        stage.confirmBtn[i] = FrameButton(kit .. "->confirmBtn->" .. t, stage.main)
            :relation(FRAME_ALIGN_TOP, stage.levelIcon[i], FRAME_ALIGN_BOTTOM, -0.027, -0.1)
            :texture(assets.uikit("ninegrids_essence", "btn\\e_dark", "tga"))
            :size(bw, bw * 60 / 128)
            :text("加 1")
        stage.confirmBtn[i]:childText():relation(FRAME_ALIGN_CENTER, stage.confirmBtn[i], FRAME_ALIGN_CENTER, 0, 0.002)
        stage.confirmBtn10[i] = FrameButton(kit .. "->confirmBtn10->" .. t, stage.main)
            :relation(FRAME_ALIGN_TOP, stage.levelIcon[i], FRAME_ALIGN_BOTTOM, 0.027, -0.1)
            :texture(assets.uikit("ninegrids_essence", "btn\\e_dark", "tga"))
            :size(bw, bw * 60 / 128)
            :text("加 10")
        stage.confirmBtn10[i]:childText():relation(FRAME_ALIGN_CENTER, stage.confirmBtn10[i], FRAME_ALIGN_CENTER, 0, 0.002)
    end
    sync.receive(kit, function(syncData)
        local p = syncData.syncPlayer
        local command = syncData.transferData[1]
        local diff = math.round(syncData.transferData[2])
        Game():upgrade(command, diff)
        time.setTimeout(0.1, function()
            async.call(p, function()
                this:updated()
                UI_NinegridsInfo:updated()
            end)
        end)
    end)
end)
function UI_NinegridsUpgrade:updated()
    local stage = self:stage()
    local gd = Game():GD()
    local desc0 = UPGRADE_DESC(0)
    local desc1 = UPGRADE_DESC(1)
    local desc10 = UPGRADE_DESC(10)
    stage.mainTxt:text("分配 " .. colour.hex(colour.gold, gd.upgradePoint) .. " 能力点")
    stage.levelTxt[1]:text(colour.hex("a1e9e4", "<守> Lv." .. gd.upgradeDef))
    stage.levelTxt[2]:text(colour.hex("ea4c3f", "<攻> Lv." .. gd.upgradeAtk))
    stage.levelTxt[3]:text(colour.hex("5cd58f", "<疾> Lv." .. gd.upgradeSpd))
    stage.attrTxt[1]:text(table.concat(desc0.upgrade["def"], '|n'))
    stage.attrTxt[2]:text(table.concat(desc0.upgrade["atk"], '|n'))
    stage.attrTxt[3]:text(table.concat(desc0.upgrade["spd"], '|n'))
    for i = 1, 3 do
        stage.confirmBtn[i]:texture(assets.uikit("ninegrids_essence", "btn\\e_dark", "tga"))
        stage.confirmBtn[i]:onEvent(EVENT.Frame.Enter, nil)
        stage.confirmBtn[i]:onEvent(EVENT.Frame.Leave, nil)
        stage.confirmBtn[i]:onEvent(EVENT.Frame.LeftClick, nil)
        stage.confirmBtn10[i]:texture(assets.uikit("ninegrids_essence", "btn\\e_dark", "tga"))
        stage.confirmBtn10[i]:onEvent(EVENT.Frame.Enter, nil)
        stage.confirmBtn10[i]:onEvent(EVENT.Frame.Leave, nil)
        stage.confirmBtn10[i]:onEvent(EVENT.Frame.LeftClick, nil)
    end
    if (gd.upgradePoint > 0) then
        local typ = { "def", "atk", "spd" }
        for i, t in ipairs(typ) do
            stage.confirmBtn[i]:texture(assets.uikit("ninegrids_essence", "btn\\e_green", "tga"))
            stage.confirmBtn[i]:onEvent(EVENT.Frame.Enter, function(evtData)
                evtData.triggerFrame:childHighlight():show(true)
                stage.attrTxt[i]:text(table.concat(desc1.upgrade[t], '|n'))
                FrameTooltips()
                    :fontSize(9)
                    :textAlign(TEXT_ALIGN_LEFT)
                    :relation(FRAME_ALIGN_TOP, stage.levelIcon[i], FRAME_ALIGN_TOP, 0, 0)
                    :content({ tips = desc1.step[t] })
                    :show(true)
            end)
            stage.confirmBtn[i]:onEvent(EVENT.Frame.Leave, function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                stage.attrTxt[i]:text(table.concat(desc0.upgrade[t], '|n'))
                FrameTooltips():show(false)
            end)
            stage.confirmBtn[i]:onEvent(EVENT.Frame.LeftClick, function(evtData)
                evtData.triggerFrame:onEvent(EVENT.Frame.Enter, nil)
                evtData.triggerFrame:onEvent(EVENT.Frame.Leave, nil)
                evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil)
                evtData.triggerFrame:childHighlight():show(false)
                stage.attrTxt[i]:text(table.concat(desc0.upgrade[t], '|n'))
                FrameTooltips():show(false)
                audio(Vcm("war3_MouseClick1"))
                sync.send(kit, { t, 1 })
            end)
            if (gd.upgradePoint >= 10) then
                stage.confirmBtn10[i]:texture(assets.uikit("ninegrids_essence", "btn\\e_green", "tga"))
                stage.confirmBtn10[i]:onEvent(EVENT.Frame.Enter, function(evtData)
                    evtData.triggerFrame:childHighlight():show(true)
                    stage.attrTxt[i]:text(table.concat(desc10.upgrade[t], '|n'))
                    FrameTooltips()
                        :fontSize(9)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :relation(FRAME_ALIGN_TOP, stage.levelIcon[i], FRAME_ALIGN_TOP, 0, 0)
                        :content({ tips = desc10.step[t] })
                        :show(true)
                end)
                stage.confirmBtn10[i]:onEvent(EVENT.Frame.Leave, function(evtData)
                    evtData.triggerFrame:childHighlight():show(false)
                    stage.attrTxt[i]:text(table.concat(desc0.upgrade[t], '|n'))
                    FrameTooltips():show(false)
                end)
                stage.confirmBtn10[i]:onEvent(EVENT.Frame.LeftClick, function(evtData)
                    evtData.triggerFrame:onEvent(EVENT.Frame.Enter, nil)
                    evtData.triggerFrame:onEvent(EVENT.Frame.Leave, nil)
                    evtData.triggerFrame:onEvent(EVENT.Frame.LeftClick, nil)
                    evtData.triggerFrame:childHighlight():show(false)
                    stage.attrTxt[i]:text(table.concat(desc0.upgrade[t], '|n'))
                    FrameTooltips():show(false)
                    audio(Vcm("war3_MouseClick1"))
                    sync.send(kit, { t, 10 })
                end)
            end
        end
    end
end
function UI_NinegridsUpgrade:upgrade()
    async.must()
    local stage = self:stage()
    local gd = Game():GD()
    if (false == isClass(gd.me, UnitClass)) then
        audio(Vcm("war3_MouseClick2"))
        return
    end
    local showing = stage.main:show()
    if (showing) then
        audio(Vcm("war3_MouseClick2"))
        stage.main:show(false)
        return
    end
    audio(Vcm("war3_MouseClick1"))
    stage.main:show(true)
    self:updated()
end
