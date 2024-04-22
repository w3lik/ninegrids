function ninegridsCtl_frameWarehouse(kit, stage)
    local kitWh = kit .. "->warehouse"
    stage.warehouseDrag = FrameDrag(kitWh .. "->drag", FrameGameUI)
        :adaptive(true)
        :esc(true)
        :close(true)
        :relation(FRAME_ALIGN_RIGHT_BOTTOM, FrameGameUI, FRAME_ALIGN_RIGHT_BOTTOM, -0.06, 0.21)
        :size(0.16, 0.03)
        :padding(0, 0, 0.13, 0)
        :show(false)
        :onEvent(EVENT.Frame.Show,
        function()
            audio(Vcm("war3_MouseClick1"))
            UIKit("ninegrids_essence"):stage().switch.warehouse:childHighlight():show(true)
        end)
        :onEvent(EVENT.Frame.Hide,
        function()
            audio(Vcm("war3_MouseClick2"))
            UIKit("ninegrids_essence"):stage().switch.warehouse:childHighlight():show(false)
        end)
    stage.warehouse = FrameBackdrop(kitWh, stage.warehouseDrag)
        :block(true)
        :relation(FRAME_ALIGN_TOP, stage.warehouseDrag, FRAME_ALIGN_TOP, 0, 0)
        :size(0.16, 0.16)
    stage.warehouseCell = FrameText(kitWh .. "->stgTxt", stage.warehouse)
        :relation(FRAME_ALIGN_CENTER, stage.warehouse, FRAME_ALIGN_TOP, 0, -0.012)
        :textAlign(TEXT_ALIGN_RIGHT)
        :fontSize(10)
    stage.warehouseRes = {}
    for i, k in ipairs(stage.warehouseResAllow) do
        local n = stage.warehouseResOpt[k].name
        local opt = stage.warehouseResOpt[k]
        stage.warehouseRes[i] = FrameLabel(kitWh .. "->res->" .. k, stage.warehouse)
            :autoSize(true)
            :size(0.01, 0.01)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.warehouse, FRAME_ALIGN_LEFT_TOP, opt.x, opt.y)
            :icon(opt.texture)
            :textAlign(TEXT_ALIGN_LEFT)
            :fontSize(9)
            :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                local r = evtData.triggerPlayer:worth()
                local tips = {
                    "资源名称: " .. n,
                    "资源总量: " .. math.format(r[k] or 0, 0),
                    "资源获得率: " .. math.format(evtData.triggerPlayer:worthRatio(), 2) .. "%",
                }
                local cov = Game():worthConvert(k)
                if (cov ~= nil) then
                    table.insert(tips, "经济体系: " .. "1" .. stage.warehouseResOpt[cov[1]].name .. "=" .. cov[2] .. n)
                end
                FrameTooltips()
                    :kit(kit)
                    :textAlign(TEXT_ALIGN_LEFT)
                    :fontSize(10)
                    :relation(FRAME_ALIGN_BOTTOM, stage.warehouseRes[i], FRAME_ALIGN_TOP, 0, 0.002)
                    :content({ tips = tips })
                    :show(true)
            end)
    end
    stage.warehouseButton = {}
    stage.warehouseCharges = {}
    for i = 1, stage.warehouseMAX do
        local xo = 0.016 + (i - 1) % stage.warehouseRaw * (stage.warehouseSize + stage.warehouseMarginW)
        local yo = -0.06 - (math.ceil(i / stage.warehouseRaw) - 1) * (stage.warehouseMarginH + stage.warehouseSize)
        stage.warehouseButton[i] = FrameButton(kitWh .. "->btn->" .. i, stage.warehouse)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.warehouse, FRAME_ALIGN_LEFT_TOP, xo, yo)
            :size(stage.warehouseSize, stage.warehouseSize)
            :fontSize(7)
            :mask("Framework\\ui\\mask.tga")
            :show(false)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                if (cursor.isFollowing() or cursor.isDragging()) then
                    return
                end
                evtData.triggerFrame:childHighlight():show(true)
                local content = tooltipsWarehouse(evtData.triggerPlayer:warehouseSlot():storage()[i], evtData.triggerPlayer)
                if (content ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :fontSize(10)
                        :relation(FRAME_ALIGN_BOTTOM, stage.warehouseButton[i], FRAME_ALIGN_TOP, 0, 0.002)
                        :content(content)
                        :show(true)
                        :onEvent(EVENT.Frame.LeftClick,
                        function(ed)
                            FrameTooltips():show(false)
                            local it = ed.triggerPlayer:warehouseSlot():storage()[i]
                            if (isClass(it, ItemClass)) then
                                if (ed.key == "drop") then
                                    local selection = ed.triggerPlayer:selection()
                                    if (isClass(selection, UnitClass)) then
                                        sync.send("G_GAME_SYNC", { "item_drop", it:id(), selection:x(), selection:y() })
                                    end
                                end
                            end
                        end)
                end
            end)
            :onEvent(EVENT.Frame.Leave,
            function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                FrameTooltips():show(false)
            end)
        stage.warehouseCharges[i] = FrameButton(kitWh .. "->charges->" .. i, stage.warehouseButton[i]:childBorder())
            :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.warehouseButton[i], FRAME_ALIGN_RIGHT_BOTTOM, -0.0011, 0.00146)
            :texture(TEAM_COLOR_BLP_BLACK)
            :fontSize(7)
    end
end