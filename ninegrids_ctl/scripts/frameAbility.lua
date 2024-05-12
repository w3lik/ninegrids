function ninegridsCtl_frameAbility(kit, stage)
    local kitAb = kit .. "->ability"
    stage.ability = FrameBackdrop(kitAb, stage.bg)
        :relation(FRAME_ALIGN_BOTTOM, stage.bg, FRAME_ALIGN_BOTTOM, 0, 0)
        :show(false)
    stage.abilityBedding = {}
    stage.abilityBtn = {}
    for i = 1, stage.abilityMAX do
        stage.abilityBedding[i] = FrameBackdrop(kitAb .. '->bedding->' .. i, stage.ability)
            :size(stage.abilitySize, stage.abilitySize)
            :show(i < 5)
        if (i == 1) then
            stage.abilityBedding[i]:relation(FRAME_ALIGN_LEFT_TOP, stage.bg, FRAME_ALIGN_RIGHT_BOTTOM, -0.201, 0.098)
        else
            stage.abilityBedding[i]:relation(FRAME_ALIGN_LEFT_TOP, stage.abilityBedding[i - 1], FRAME_ALIGN_RIGHT_TOP, stage.abilityMargin, 0)
        end
    end
    for i = 1, stage.abilityMAX do
        stage.abilityBtn[i] = FrameButton(kitAb .. '->btn->' .. i, stage.ability)
            :size(stage.abilitySize, stage.abilitySize)
            :relation(FRAME_ALIGN_CENTER, stage.abilityBedding[i], FRAME_ALIGN_CENTER, 0, 0)
            :hotkeyFontSize(9)
            :fontSize(10)
            :mask('Framework\\ui\\mask.tga')
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                if (cursor.isFollowing() or cursor.isDragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (selection == nil) then
                    return
                end
                local slot = selection:abilitySlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                evtData.triggerFrame:childHighlight():show(true)
                local content = tooltipsAbility(storage[i], 0)
                if (content ~= nil) then
                    if (PlayerLocal():prop("righted") ~= 1) then
                        table.insert(content.tips, '')
                        if (i == stage.abilityMAX) then
                            table.insert(content.tips, colour.hex(colour.lightgray, "<异界泠力>"))
                        else
                            table.insert(content.tips, colour.hex(colour.gold, "<右键点击切换技能位置>"))
                        end
                    end
                    FrameTooltips()
                        :kit(kit)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :fontSize(10)
                        :relation(FRAME_ALIGN_BOTTOM, stage.abilityBtn[i], FRAME_ALIGN_TOP, 0, 0.002)
                        :content(content)
                        :show(true)
                end
            end)
            :onEvent(EVENT.Frame.Leave,
            function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                FrameTooltips():show(false, 0)
            end)
            :onEvent(EVENT.Frame.LeftClick,
            function(evtData)
                local selection = evtData.triggerPlayer:selection()
                if (isClass(selection, UnitClass) == false) then
                    return
                end
                local slot = selection:abilitySlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                local ab = storage[i]
                if (isClass(ab, AbilityClass)) then
                    cursor.quote(ab:targetType(), { ability = ab })
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
                local slot = selection:abilitySlot()
                if (nil == slot) then
                    return
                end
                local storage = slot:storage()
                if (nil == storage) then
                    return
                end
                local ob = storage[i]
                local triggerFrame = evtData.triggerFrame
                japi.DZ_FrameSetAlpha(triggerFrame:handle(), 0)
                audio(Vcm("war3_MouseClick1"))
                cursor.quote("follow", {
                    object = ob,
                    frame = triggerFrame,
                    over = function()
                        japi.DZ_FrameSetAlpha(triggerFrame:handle(), triggerFrame:alpha())
                    end,
                    ---@param evt evtOnMouseRightClickData
                    rightClick = function(evt)
                        local sel = evt.triggerPlayer:selection()
                        if (isClass(sel, UnitClass) and sel:owner() == evt.triggerPlayer) then
                            local tarIdx = -1
                            local tarObj
                            local sto = sel:abilitySlot():storage()
                            for j = 1, 5 do
                                local ab = sto[j]
                                local btn = stage.abilityBtn[j]
                                if (btn:isInner(evt.rx, evt.ry, false)) then
                                    tarIdx = j
                                    tarObj = ab
                                    break
                                end
                            end
                            if (-1 ~= tarIdx and false == table.equal(ob, tarObj)) then
                                sync.send("slotSync", { "ability_push", ob:id(), tarIdx })
                                audio(Vcm("war3_MouseClick1"))
                            else
                                cursor.quoteOver()
                            end
                        end
                    end,
                })
            end)
            :show(false)
    end
end