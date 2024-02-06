function ninegridsCtl_eventReaction(ui)
    event.registerReaction(EVENT.Prop.Change, ui:kit(), function(evtData)
        if (evtData.triggerPlayer) then
            if (evtData.key == "skin" and async.is()) then
                ui:updateSkin()
            elseif (evtData.key == "selection" and sync.is()) then
                async.call(evtData.triggerPlayer, function()
                    ui:updatePlate()
                    ui:updateEtc()
                    ui:updateAbility()
                    ui:updateItem()
                end)
                if (isClass(evtData.old, UnitClass)) then
                    event.register(evtData.old, EVENT.Unit.ItemSlotChange, ui:kit(), nil)
                    event.register(evtData.old, EVENT.Unit.AbilitySlotChange, ui:kit(), nil)
                end
                if (isClass(evtData.new, UnitClass)) then
                    event.register(evtData.new, EVENT.Unit.ItemSlotChange, ui:kit(), function(ed)
                        async.call(ed.triggerUnit:owner(), function()
                            ui:updateItem()
                        end)
                        local gd = Game():GD()
                        local me = gd.me
                        if (ed.triggerUnit == me) then
                            local slot = me:itemSlot()
                            if (slot) then
                                local s = slot:storage()
                                for i = 1, #Game():itemHotkey(), 1 do
                                    if (isClass(s[i], ItemClass)) then
                                        gd.sacredUse[i] = s[i]:tpl():prop("idx")
                                    else
                                        gd.sacredUse[i] = 0
                                    end
                                end
                            end
                            Game():save("sacredUse")
                        end
                    end)
                    event.register(evtData.new, EVENT.Unit.AbilitySlotChange, ui:kit(), function(ed)
                        async.call(ed.triggerUnit:owner(), function()
                            ui:updateAbility()
                        end)
                        local gd = Game():GD()
                        local me = gd.me
                        if (ed.triggerUnit == me) then
                            local slot = me:abilitySlot()
                            if (slot) then
                                local s = slot:storage()
                                for i = 1, gd.abilityTail, 1 do
                                    if (isClass(s[i], AbilityClass)) then
                                        gd.abilityLearn[i] = s[i]:tpl():prop("idx")
                                    else
                                        gd.abilityLearn[i] = 0
                                    end
                                end
                            end
                            Game():save("abilityLearn")
                        end
                    end)
                end
            end
        elseif (evtData.triggerUnit and sync.is()) then
            if (evtData.triggerUnit == PlayerLocal():selection()) then
                async.call(PlayerLocal(), function()
                    ui:updatePlate()
                    ui:updateEtc()
                end)
            end
        end
    end)
    PlayersForeach(function(enumPlayer, _)
        event.register(enumPlayer, EVENT.Player.WarehouseSlotChange, ui:kit(), function()
            ui:updateWarehouse()
        end)
    end)
end