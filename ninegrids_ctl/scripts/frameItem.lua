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
                if (Cursor():isFollowing() or Cursor():dragging()) then
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
                if (Cursor():isFollowing() or Cursor():dragging()) then
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
                Cursor():itemQuote(storage[i])
            end)
        stage.itemCharges[i] = FrameButton(kit .. '->charges->' .. i, stage.itemButton[i])
            :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.itemButton[i], FRAME_ALIGN_RIGHT_BOTTOM, -0.0013, 0.0018)
            :texture(TEAM_COLOR_BLP_BLACK)
            :fontSize(7)
    end
    local onFollowChange = function(stopData, i)
        local fi = stopData.i
        local fo = stopData.followObj
        if (fi <= stage.itemMAX and i <= stage.itemMAX) then
            sync.send(kitIt .. "_SYNC", { "item_push", fo:id(), i, fi })
            audio(Vcm("war3_MouseClick1"))
        elseif (fi > stage.itemMAX and i > stage.itemMAX) then
            sync.send(kitIt .. "_SYNC", { "warehouse_push", fo:id(), i - stage.itemMAX, fi - stage.itemMAX })
            audio(Vcm("war3_MouseClick1"))
        else
            japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
            audio(Vcm("war3_MouseClick2"))
        end
    end
    sync.receive(kitIt .. "_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "item_push") then
            local itId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:selection():itemSlot():insert(it, i)
            end
            japi.FrameSetAlpha(stage.itemButton[fi]:handle(), stage.itemButton[fi]:alpha())
        elseif (command == "warehouse_push") then
            local itId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:warehouseSlot():insert(it, i)
            end
            japi.FrameSetAlpha(stage.warehouseButton[fi]:handle(), stage.warehouseButton[fi]:alpha())
        end
    end)
    mouse.onRightClick(kitIt .. "_mouse_right", function(evtData)
        local triggerPlayer = evtData.triggerPlayer
        local followObject = Cursor():followObj()
        local ing = Cursor():isFollowing() or Cursor():dragging()
        if (ing == true and isClass(followObject, ItemClass) == false) then
            return
        end
        local selection = triggerPlayer:selection()
        local iCheck = false
        local wCheck = false
        if (isClass(selection, 'Unit')) then
            if (selection:isAlive() and selection:owner() == triggerPlayer) then
                local itemSlot = selection:itemSlot()
                if (itemSlot ~= nil) then
                    for i = 1, stage.itemMAX do
                        local it = itemSlot:storage()[i]
                        local btn = stage.itemButton[i]
                        if (true == btn:parent():show() and btn:isInner(nil, nil, false)) then
                            if (ing == true) then
                                if (table.equal(followObject, it) == false) then
                                    Cursor():followStop(function(stopData)
                                        onFollowChange(stopData, i)
                                    end)
                                else
                                    Cursor():followStop()
                                end
                            elseif (isClass(it, ItemClass)) then
                                FrameTooltips():show(false, 0)
                                audio(Vcm("war3_MouseClick1"))
                                japi.FrameSetAlpha(btn:handle(), 0)
                                Cursor():followCall(it, { frame = btn, i = i }, function(stopData)
                                    japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                                end)
                            end
                            iCheck = true
                            break
                        end
                    end
                end
            end
        end
        for i = 1, stage.warehouseMAX do
            local it = triggerPlayer:warehouseSlot():storage()[i]
            local btn = stage.warehouseButton[i]
            if (true == btn:parent():show() and btn:isInner(nil, nil, false)) then
                if (ing == true) then
                    if (table.equal(followObject, it) == false) then
                        Cursor():followStop(function(stopData)
                            onFollowChange(stopData, stage.itemMAX + i)
                        end)
                    else
                        Cursor():followStop()
                    end
                elseif (isClass(it, ItemClass)) then
                    FrameTooltips():show(false, 0)
                    audio(Vcm("war3_MouseClick1"))
                    japi.FrameSetAlpha(btn:handle(), 0)
                    Cursor():followCall(it, { frame = btn, i = stage.itemMAX + i }, function(stopData)
                        japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                    end)
                end
                wCheck = true
                break
            end
        end
        if (iCheck == false and wCheck == false and ing == true) then
            Cursor():followStop()
        end
    end)
end