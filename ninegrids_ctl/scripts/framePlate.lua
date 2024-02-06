function ninegridsCtl_framePlate(kit, stage)
    stage.plateInfoLeave = function()
        FrameTooltips():show(false, 0)
    end
    stage.plateInfoEnter = function(evtData, field)
        local triggerPlayer = evtData.triggerPlayer
        local selection = triggerPlayer:selection()
        if (selection == nil) then
            return
        end
        local primary = selection:primary()
        local tips = {}
        local _attrLabel = function(sel, key)
            local label, form = attribute.conf(key)
            local val = sel:prop(key) or 0
            if (form == '%') then
                val = math.format(val, 2)
            elseif (form == "击每秒" or form == "每秒") then
                val = math.format(val, 3)
            else
                val = math.floor(val)
            end
            return label .. ": " .. val .. form
        end
        if (field == "portrait") then
            if (primary ~= nil) then
                table.insert(tips, colour.hex(colour.gold, "主属性: " .. primary.label))
                table.insert(tips, colour.hex(colour.littlepink, _attrLabel(selection, "str")))
                table.insert(tips, colour.hex(colour.mintcream, _attrLabel(selection, "agi")))
                table.insert(tips, colour.hex(colour.skyblue, _attrLabel(selection, "int")))
            end
            table.insert(tips, _attrLabel(selection, "sight"))
            table.insert(tips, _attrLabel(selection, "nsight"))
            if (selection:exp() > 0) then
                table.insert(tips, "经验: " .. selection:exp())
                table.insert(tips, "等级: " .. selection:level() .. "/" .. selection:levelMax())
            elseif (selection:level() > 0) then
                table.insert(tips, "等级: " .. selection:level())
            end
            local sp = selection:prop("sp")
            if (sp ~= nil) then
                table.insert(tips, colour.hex(colour.gold, "特性: " .. sp))
            end
        elseif (field == "attack") then
            if (false == selection:isAttackAble()) then
                table.insert(tips, colour.hex(colour.red, "无法攻击"))
            else
                table.insert(tips, _attrLabel(selection, "attack") .. colour.hex(colour.gold, "(快捷键A)"))
                table.insert(tips, _attrLabel(selection, "attackRipple"))
                table.insert(tips, _attrLabel(selection, "damageIncrease"))
                table.insert(tips, _attrLabel(selection, "enchantMystery"))
            end
        elseif (field == "attackSpeed") then
            if (false == selection:isAttackAble()) then
                table.insert(tips, colour.hex(colour.red, "无法攻击"))
            else
                local am = selection:attackMode()
                if (am == nil) then
                    table.insert(tips, "武器: 无")
                elseif (am:mode() == "common") then
                    if (selection:attackRange() < 200) then
                        table.insert(tips, "武器: 近战")
                    else
                        table.insert(tips, "武器: 极速")
                    end
                elseif (am:mode() == "lightning") then
                    table.insert(tips, "武器: 闪电")
                    if (am:scatter() > 0 and am:radius() > 0) then
                        table.insert(tips, "散射数量: " .. math.floor(am:scatter()))
                        table.insert(tips, "散射范围: " .. math.floor(am:radius()))
                    end
                    if (am:focus() > 0) then
                        table.insert(tips, "聚焦数量: " .. math.floor(am:focus()))
                    end
                    if (am:reflex() > 0) then
                        table.insert(tips, "反弹数量: " .. math.floor(am:reflex()))
                    end
                elseif (am:mode() == "missile") then
                    if (am:homing()) then
                        table.insert(tips, "武器: 远程[自动跟踪]")
                    else
                        table.insert(tips, "武器: 远程")
                    end
                    table.insert(tips, "发射速度: " .. math.floor(am:speed()))
                    table.insert(tips, "发射加速度: " .. math.floor(am:acceleration()))
                    table.insert(tips, "发射高度: " .. math.floor(am:height()))
                    if (am:scatter() > 0 and am:radius() > 0) then
                        table.insert(tips, "散射数量: " .. math.floor(am:scatter()))
                        table.insert(tips, "散射范围: " .. math.floor(am:radius()))
                    end
                    if (am:gatlin() > 0) then
                        table.insert(tips, "多段数量: " .. math.floor(am:gatlin()))
                    end
                    if (am:reflex() > 0) then
                        table.insert(tips, "反弹数量: " .. math.floor(am:reflex()))
                    end
                end
                if (am and am:damageType() ~= nil) then
                    table.insert(tips, "伤害类型: " .. am:damageType().label .. " Lv." .. am:damageTypeLevel())
                end
                table.insert(tips, _attrLabel(selection, "attackSpaceBase"))
                table.insert(tips, _attrLabel(selection, "attackSpeed"))
                table.insert(tips, _attrLabel(selection, "attackRange"))
                table.insert(tips, _attrLabel(selection, "aim"))
            end
        elseif (field == "defend") then
            table.insert(tips, _attrLabel(selection, "defend"))
            table.insert(tips, _attrLabel(selection, "avoid"))
            table.insert(tips, _attrLabel(selection, "cure"))
            table.insert(tips, _attrLabel(selection, "hurtReduction"))
            table.insert(tips, _attrLabel(selection, "hurtIncrease"))
        elseif (field == "move") then
            table.insert(tips, "地型移动: " .. math.min(522, selection:prop("move") or 0) .. colour.hex(colour.gold, "(快捷键M)"))
            table.insert(tips, _attrLabel(selection, "move"))
            table.insert(tips, "移动类型: " .. selection:moveType().label)
        end
        FrameTooltips()
            :kit(kit)
            :textAlign(TEXT_ALIGN_LEFT)
            :fontSize(10)
        if (field == "portrait") then
            FrameTooltips()
                :relation(FRAME_ALIGN_BOTTOM, stage.plateInfo[field], FRAME_ALIGN_TOP, 0, 0.004)
                :content({ tips = tips })
                :show(true)
        else
            if (#tips == 1) then
                FrameTooltips():relation(FRAME_ALIGN_RIGHT, stage.plateInfo[field], FRAME_ALIGN_LEFT, 0, 0)
            else
                FrameTooltips():relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.plateInfo.attack, FRAME_ALIGN_LEFT_BOTTOM, -0.015, -0.06)
            end
            FrameTooltips():content({ tips = tips }):show(true)
        end
    end
    local infoMargin = -0.006
    local infoWidth = 0.062
    local infoHeight = 0.014
    local infoAlpha = 220
    local infoFontSize = 8
    local plateTypes = { "Nil", "Unit", "Item" }
    stage.plate = {}
    stage.plateInfo = {}
    for _, t in ipairs(plateTypes) do
        local kp = kit .. "->plate->" .. t
        stage.plate[t] = FrameBackdrop(kp, stage.bg)
            :relation(FRAME_ALIGN_LEFT_BOTTOM, stage.bg, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
            :size(0.6, stage.bgH)
            :show(false)
        if (t == "Nil") then
            stage.plateNilMsg = FrameText(kp .. "->description", stage.plate[t])
                :relation(FRAME_ALIGN_CENTER, stage.plate[t], FRAME_ALIGN_CENTER, -0.09, -0.018)
                :textAlign(TEXT_ALIGN_CENTER)
                :fontSize(10)
        elseif (t == "Unit") then
            stage.plateMP = FrameBar(kp .. "->mp", stage.plate[t])
                :textLayout({ LAYOUT_ALIGN_CENTER, LAYOUT_ALIGN_RIGHT })
                :relation(FRAME_ALIGN_LEFT_BOTTOM, stage.plate[t], FRAME_ALIGN_LEFT_BOTTOM, 0.098, 0.007)
                :texture("value", "bar\\blue")
                :fontSize(LAYOUT_ALIGN_CENTER, 10)
                :fontSize(LAYOUT_ALIGN_RIGHT, 10)
                :value(0, stage.plateBarW, stage.plateBarH)
            stage.plateHP = FrameBar(kp .. "->hp", stage.plate[t])
                :textLayout({ LAYOUT_ALIGN_CENTER, LAYOUT_ALIGN_RIGHT })
                :relation(FRAME_ALIGN_BOTTOM, stage.plateMP, FRAME_ALIGN_TOP, 0, 0.005)
                :texture("value", "bar\\green")
                :fontSize(LAYOUT_ALIGN_CENTER, 10)
                :fontSize(LAYOUT_ALIGN_RIGHT, 10)
                :value(0, stage.plateBarW, stage.plateBarH)
            stage.plateShield = FrameBar(kp .. "->shield", stage.plate[t])
                :relation(FRAME_ALIGN_BOTTOM, stage.plateHP, FRAME_ALIGN_TOP, 0, 0)
                :texture("value", "bar\\gold")
                :value(0, stage.plateBarW, stage.plateBarH / 8)
            stage.plateInfo.portrait = FrameLabel(kp .. "->info->portrait", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.bgTail, FRAME_ALIGN_LEFT_TOP, 0.004, -0.027)
                :autoSize(true)
                :size(0.05, 0.012)
                :side(LAYOUT_ALIGN_RIGHT)
                :textAlign(TEXT_ALIGN_RIGHT)
                :fontSize(10)
                :onEvent(EVENT.Frame.Enter, function(evtData) stage.plateInfoEnter(evtData, "portrait") end)
                :onEvent(EVENT.Frame.Leave, stage.plateInfoLeave)
            stage.plateInfo.attack = FrameLabel(kp .. "->info->attack", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.plate[t], FRAME_ALIGN_LEFT_BOTTOM, 0.08, 0.084)
                :size(infoWidth, infoHeight)
                :side(LAYOUT_ALIGN_RIGHT)
                :alpha(infoAlpha)
                :textAlign(TEXT_ALIGN_RIGHT)
                :fontSize(infoFontSize)
                :onEvent(EVENT.Frame.Enter, function(evtData) stage.plateInfoEnter(evtData, "attack") end)
                :onEvent(EVENT.Frame.Leave, stage.plateInfoLeave)
            stage.plateInfo.attackSpeed = FrameLabel(kp .. "->info->attackSpeed", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.plateInfo.attack, FRAME_ALIGN_RIGHT_BOTTOM, 0, infoMargin)
                :size(infoWidth, infoHeight)
                :side(LAYOUT_ALIGN_RIGHT)
                :alpha(infoAlpha)
                :icon("icon\\attack_speed")
                :textAlign(TEXT_ALIGN_RIGHT)
                :fontSize(infoFontSize)
                :onEvent(EVENT.Frame.Enter, function(evtData) stage.plateInfoEnter(evtData, "attackSpeed") end)
                :onEvent(EVENT.Frame.Leave, stage.plateInfoLeave)
            stage.plateInfo.defend = FrameLabel(kp .. "->info->defend", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.plateInfo.attackSpeed, FRAME_ALIGN_RIGHT_BOTTOM, 0, infoMargin)
                :size(infoWidth, infoHeight)
                :side(LAYOUT_ALIGN_RIGHT)
                :alpha(infoAlpha)
                :icon("icon\\defend")
                :textAlign(TEXT_ALIGN_RIGHT)
                :fontSize(infoFontSize)
                :onEvent(EVENT.Frame.Enter, function(evtData) stage.plateInfoEnter(evtData, "defend") end)
                :onEvent(EVENT.Frame.Leave, stage.plateInfoLeave)
            stage.plateInfo.move = FrameLabel(kp .. "->info->move", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_TOP, stage.plateInfo.defend, FRAME_ALIGN_RIGHT_BOTTOM, 0, infoMargin)
                :size(infoWidth, infoHeight)
                :side(LAYOUT_ALIGN_RIGHT)
                :alpha(infoAlpha)
                :icon("icon\\move")
                :textAlign(TEXT_ALIGN_RIGHT)
                :fontSize(infoFontSize)
                :onEvent(EVENT.Frame.Enter, function(evtData) stage.plateInfoEnter(evtData, "move") end)
                :onEvent(EVENT.Frame.Leave, stage.plateInfoLeave)
        elseif (t == "Item") then
            stage.plateItemName = FrameText(kp .. "->itemName", stage.plate[t])
                :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.bgTail, FRAME_ALIGN_LEFT_TOP, 0.004, -0.027)
                :textAlign(TEXT_ALIGN_CENTER)
                :fontSize(10)
            stage.plateItemIcon = FrameBackdrop(kp .. "->itemIcon", stage.plate[t])
                :relation(FRAME_ALIGN_LEFT_TOP, stage.bg, FRAME_ALIGN_LEFT_TOP, 0.146, -0.056)
                :size(0.05, 0.05)
            stage.plateItemDesc = FrameText(kp .. "->itemDesc", stage.plate[t])
                :relation(FRAME_ALIGN_LEFT, stage.plateItemIcon, FRAME_ALIGN_RIGHT, 0.015, 0)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
        end
    end
end