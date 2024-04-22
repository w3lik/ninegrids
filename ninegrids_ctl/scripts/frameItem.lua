function ninegridsCtl_frameItem(kit, stage)
    local kitIt = kit .. "->item"
    stage.item = FrameBackdrop(kitIt, stage.bgTail)
        :block(true)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, stage.bgTail, FRAME_ALIGN_RIGHT_BOTTOM, 0, 0)
        :size(0.094, 0.123)
        :show(false)
    stage.itemHun = FrameText(kitIt .. '->hun', stage.item)
        :relation(FRAME_ALIGN_BOTTOM, stage.item, FRAME_ALIGN_TOP, -0.01, -0.013)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(9)
        :size(0.08, 0.008)
        :text("泠器")
    stage.itemButton = {}
    stage.itemCharges = {}
    local raw = 2
    for i = 1, stage.itemMAX do
        local xo = 0.0046 + (i - 1) % raw * (stage.itemSize + stage.itemMargin)
        local yo = -0.0246 - (math.ceil(i / raw) - 1) * (stage.itemMargin + stage.itemSize)
        stage.itemButton[i] = FrameButton(kit .. '->btn->' .. i, stage.item)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.item, FRAME_ALIGN_LEFT_TOP, xo, yo)
            :size(stage.itemSize, stage.itemSize)
            :fontSize(7.5)
            :mask('Framework\\ui\\mask.tga')
            :show(false)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                if (cursor.isFollowing() or cursor.isDragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (false == isClass(selection, UnitClass)) then
                    return nil
                end
                local slot = selection:itemSlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                evtData.triggerFrame:childHighlight():show(true)
                local content = tooltipsItem(storage[i])
                if (content ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :fontSize(10)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :relation(FRAME_ALIGN_BOTTOM, stage.itemButton[i], FRAME_ALIGN_TOP, 0, 0.002)
                        :content(content)
                        :show(true)
                end
            end)
            :onEvent(EVENT.Frame.Leave,
            function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                FrameTooltips():show(false)
            end)
            :onEvent(EVENT.Frame.LeftClick,
            function(evtData)
                if (cursor.isFollowing() or cursor.isDragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (isClass(selection, UnitClass) == false) then
                    return
                end
                local slot = selection:itemSlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                if (storage[i]) then
                    local ab = storage[i]:ability()
                    if (isClass(ab, AbilityClass)) then
                        cursor.quote(ab:targetType(), { ability = ab })
                    end
                end
            end)
            :onEvent(EVENT.Frame.RightClick,
            function(evtData)
                if (cursor.isQuoting()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (false == isClass(selection, UnitClass)) then
                    return
                end
                local slot = selection:itemSlot()
                if (nil == slot) then
                    return
                end
                local storage = slot:storage()
                if (nil == storage) then
                    return
                end
                local ob = storage[i]
                local triggerFrame = evtData.triggerFrame
                japi.FrameSetAlpha(triggerFrame:handle(), 0)
                audio(Vcm("war3_MouseClick1"))
                cursor.quote("follow", {
                    object = ob,
                    frame = triggerFrame,
                    over = function()
                        japi.FrameSetAlpha(triggerFrame:handle(), triggerFrame:alpha())
                    end,
                    ---@param evt evtOnMouseRightClickData
                    rightClick = function(evt)
                        local p = evt.triggerPlayer
                        local sel = p:selection()
                        if (isClass(sel, UnitClass) and sel:owner() == p) then
                            local tarIdx = -1
                            local tarType, tarObj
                            local sto = sel:itemSlot():storage()
                            for j = 1, stage.itemMAX do
                                local it = sto[j]
                                local btn = stage.itemButton[j]
                                if (btn:isInner(evt.rx, evt.ry, false)) then
                                    tarObj, tarType, tarIdx = it, "item", j
                                    break
                                end
                            end
                            if (-1 ~= tarIdx and false == table.equal(ob, tarObj)) then
                                if (tarType == "item") then
                                    sync.send("slotSync", { "item_push", ob:id(), tarIdx, triggerFrame:id() })
                                end
                                audio(Vcm("war3_MouseClick1"))
                            else
                                cursor.quoteOver()
                            end
                        end
                    end,
                })
            end)
        
        stage.itemCharges[i] = FrameButton(kit .. '->charges->' .. i, stage.itemButton[i])
            :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.itemButton[i], FRAME_ALIGN_RIGHT_BOTTOM, -0.0013, 0.0018)
            :texture(TEAM_COLOR_BLP_BLACK)
            :fontSize(7)
    end
end