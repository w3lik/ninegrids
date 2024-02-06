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
                if (Cursor():isFollowing() or Cursor():dragging()) then
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
                Cursor():abilityQuote(storage[i])
            end)
            :show(false)
    end
    sync.receive(kitAb .. "_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "push") then
            syncPlayer:prop("righted", 1)
            local abId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            local ab = i2o(abId)
            if (isClass(ab, AbilityClass)) then
                syncPlayer:selection():abilitySlot():insert(ab, i)
            end
            japi.FrameSetAlpha(stage.abilityBtn[fi]:handle(), stage.abilityBtn[fi]:alpha())
        end
    end)
    mouse.onRightClick(kitAb .. "_mouse_right", function(evtData)
        local triggerPlayer = evtData.triggerPlayer
        local followObject = Cursor():followObj()
        local ing = Cursor():isFollowing() or Cursor():dragging()
        if (ing == true and isClass(followObject, AbilityClass) == false) then
            return
        end
        local selection = triggerPlayer:selection()
        if (isClass(selection, 'Unit')) then
            local abilitySlot = selection:abilitySlot()
            if (selection:isAlive() and selection:owner() == triggerPlayer and abilitySlot ~= nil) then
                local j = 0
                for i = 1, 5 do
                    local ab = abilitySlot:storage()[i]
                    local bed = stage.abilityBedding[i]
                    if (bed:isInner()) then
                        if (ing == true) then
                            if (table.equal(followObject, ab) == false) then
                                Cursor():followStop(function(stopData)
                                    local fab = stopData.followObj
                                    if (isClass(fab, AbilityClass)) then
                                        local fi = stopData.i
                                        local fo = stopData.followObj
                                        sync.send(kitAb .. "_SYNC", { "push", fo:id(), i, fi })
                                        audio(Vcm("war3_MouseClick1"))
                                    end
                                end)
                            else
                                Cursor():followStop()
                            end
                        elseif (isClass(ab, AbilityClass)) then
                            FrameTooltips():show(false, 0)
                            audio(Vcm("war3_MouseClick1"))
                            japi.FrameSetAlpha(stage.abilityBtn[i]:handle(), 0)
                            Cursor():followCall(ab, { frame = stage.abilityBtn[i], i = i }, function(stopData)
                                japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                            end)
                        end
                        break
                    end
                    j = i + 1
                end
                if (j > 5 and ing == true) then
                    Cursor():followStop()
                end
            end
        end
    end)
end