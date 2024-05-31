local kit = "ninegrids_detail"
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    stage.whichUnit = nil
    stage.detailType = "data"
    stage.main = FrameBackdrop(kit .. "->main", FrameGameUI)
        :adaptive(true)
        :prop("texture", assets.uikit("ninegrids_essence", "bg\\display", "tga"))
        :block(true)
        :esc(true)
        :close(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.055)
        :size(0.7, 0.36)
        :show(false)
        :onEvent(EVENT.Frame.Hide, function() FrameTooltips():show(false) end)
    stage.mainTxt = FrameText(kit .. "->mainTxt", stage.main)
        :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, 0, -0.03)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(13)
    stage.avatar = FrameBackdrop(kit .. "->avatar", stage.main)
        :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, -0.255, -0.03)
        :size(0.06, 0.06)
    stage.attackMode = FrameText(kit .. "->attackMode", stage.avatar)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, stage.avatar, FRAME_ALIGN_RIGHT_BOTTOM, 0.003, 0.003)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(9)
        :text('···')
    stage.shiftBtn = FrameButton(kit .. "->shiftBtn", stage.main)
        :relation(FRAME_ALIGN_TOP, stage.main, FRAME_ALIGN_TOP, 0.24, -0.03)
        :texture(assets.uikit("ninegrids_essence", "btn\\e_green", "tga"))
        :size(0.06, 0.06 * 60 / 128)
        :text("查看说明")
        :onEvent(EVENT.Frame.Enter, function(evtData) evtData.triggerFrame:childHighlight():show(true) end)
        :onEvent(EVENT.Frame.Leave, function(evtData) evtData.triggerFrame:childHighlight():show(false) end)
        :onEvent(EVENT.Frame.LeftClick,
        function(evtData)
            evtData.triggerFrame:childHighlight():show(false)
            FrameTooltips():show(false)
            audio(Vcm("war3_MouseClick1"))
            if (stage.detailType == "data") then
                stage.detailType = "intro"
                evtData.triggerFrame:text("查看数值")
                evtData.triggerFrame:texture(assets.uikit("ninegrids_essence", "btn\\e_red", "tga"))
            else
                stage.detailType = "data"
                evtData.triggerFrame:text("查看说明")
                evtData.triggerFrame:texture(assets.uikit("ninegrids_essence", "btn\\e_green", "tga"))
            end
            this:updated()
        end)
    stage.shiftBtn:childText():relation(FRAME_ALIGN_CENTER, stage.shiftBtn, FRAME_ALIGN_CENTER, 0, 0.002)
    stage.attrTxt = {}
    local rel = { 0.004, 0.19, 0.342, 0.47 }
    for i = 1, 4 do
        stage.attrTxt[i] = FrameText(kit .. "->attrTxt->" .. i, stage.main)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.avatar, FRAME_ALIGN_LEFT_BOTTOM, rel[i], -0.008)
            :fontSize(9)
            :textAlign(TEXT_ALIGN_LEFT)
            :text('···')
    end
    local ctlStage = UIKit("ninegrids_ctl"):stage()
    stage.detailBtn = FrameButton(kit .. "->detailBtn", ctlStage.bg)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, ctlStage.bg, FRAME_ALIGN_LEFT_TOP, 0.064, -0.03)
        :prop("texture", assets.uikit("ninegrids_essence", "btn/i_what", "tga"))
        :alpha(160)
        :size(0.02, 0.02)
        :onEvent(EVENT.Frame.Leave, function(evtData) evtData.triggerFrame:alpha(160) end)
        :onEvent(EVENT.Frame.Enter, function(evtData) evtData.triggerFrame:alpha(255) end)
        :onEvent(EVENT.Frame.LeftClick, function() this:display() end)
    event.reactRegister(EVENT.Prop.Change, kit, function(evtData)
        if (evtData.triggerPlayer) then
            if (evtData.key == "selection") then
                if (isClass(evtData.new, UnitClass)) then
                    async.call(evtData.triggerPlayer, function()
                        stage.detailBtn:show(true)
                    end)
                else
                    async.call(evtData.triggerPlayer, function()
                        stage.detailBtn:show(false)
                    end)
                end
                async.call(evtData.triggerPlayer, function()
                    stage.main:show(false)
                end)
            end
        end
    end)
end)
function ui:attackMode(whichUnit)
    if (isClass(whichUnit, UnitClass) == false) then
        return "未知"
    end
    local mode = ''
    local params = ''
    local dmgType = ''
    local am = whichUnit:attackMode()
    if (am == nil) then
        mode = colour.hex(colour.gold, "[武器]无")
        params = colour.hex(colour.silver, "[不可攻击]")
        dmgType = colour.hex(colour.silver, "[无武装特性]")
    else
        if (am:mode() == "common") then
            if (whichUnit:attackRange() < 200) then
                mode = mode .. colour.hex(colour.gold, "[武器]近战")
            else
                mode = mode .. colour.hex(colour.gold, "[武器]极速")
            end
            params = colour.hex(colour.silver, "[动作后立刻击中]")
        elseif (am:mode() == "lightning") then
            mode = mode .. colour.hex(colour.gold, "[武器]闪电霹雳")
            if (am:scatter() > 0 and am:radius() > 0) then
                params = params .. colour.hex(colour.plum, "[" .. am:radius() .. "范围随机" .. math.floor(am:scatter()) .. "个木飙进行散射]")
            end
            if (am:focus() > 0) then
                params = params .. colour.hex(colour.plum, "[对木飙聚焦打击" .. math.floor(am:focus()) .. "次]")
            end
            if (am:reflex() > 0) then
                params = params .. colour.hex(colour.plum, "[可随机反弹传递" .. math.floor(am:reflex()) .. "次]")
            end
        elseif (am:mode() == "missile") then
            if (am:homing()) then
                mode = mode .. colour.hex(colour.gold, "[武器]可跟踪型远程箭矢")
            else
                mode = mode .. colour.hex(colour.gold, "[武器]非跟踪型远程箭矢")
            end
            params = params .. colour.hex(colour.plum, "[发射速度" .. math.floor(am:speed()) .. "]")
            params = params .. colour.hex(colour.plum, "[发射加速度" .. math.floor(am:acceleration()) .. "]")
            params = params .. colour.hex(colour.plum, "[抛物拟合高度" .. math.floor(am:height()) .. "]")
            if (am:scatter() > 0 and am:radius() > 0) then
                params = params .. colour.hex(colour.plum, "[" .. am:radius() .. "范围随机" .. math.floor(am:scatter()) .. "个木飙进行散射]")
            end
            if (am:gatlin() > 0) then
                params = params .. colour.hex(colour.plum, "[对木飙额外打击" .. math.floor(am:gatlin()) .. "次]")
            end
            if (am:reflex() > 0) then
                params = params .. colour.hex(colour.plum, "[可随机反弹传递" .. math.floor(am:reflex()) .. "次]")
            end
        end
        if (am:damageType() ~= nil and am:damageType() ~= DAMAGE_TYPE.common) then
            dmgType = colour.hex(colour.mistyrose, "[武装附魔 " .. am:damageTypeLevel() .. " 级的" .. am:damageType().label .. "元素]")
        else
            dmgType = colour.hex(colour.silver, "[无武装附魔元素]")
        end
    end
    return table.concat({ mode, params, dmgType }, "|n")
end
function ui:intro(key)
    local data = {
        ["hp"] = "存活和某些技能需要生命值",
        ["hpRegen"] = "每秒恢复生命的量",
        ["mp"] = "释放技能需要魔法值",
        ["mpRegen"] = "每秒恢复魔法的量",
        ["move"] = "每秒移动的距离",
        ["avoid"] = "被攻击时躲避的几率",
        ["aim"] = "攻击时可降低木飙回避",
        ["defend"] = "受到伤害时的固定减免",
        ["shield"] = "先行抵御伤害不与多数机制反应",
        ["shieldBack"] = "护盾重新恢复需要的时间",
        ["attackRipple"] = "普通攻击的随机增量",
        ["attack"] = "普通攻击造成的伤害",
        [SYMBOL_MUT .. "attack"] = "普通攻击的百分比加成",
        ["attackRange"] = "从位置到木飙的极限攻击距离",
        ["attackRangeAcquire"] = "发现木飙后会发起攻击的距离",
        ["attackSpace"] = "计算后的频率",
        ["attackSpaceBase"] = "0%攻速加成时的频率",
        ["attackSpeed"] = "以基础频率计算加成",
        [SYMBOL_MUT .. "attackSpeed"] = "攻击速度的百分比加成",
        ["hpSuckAttack"] = "攻击时的吸取生命比例",
        ["hpSuckAbility"] = "施法时的吸取生命比例",
        ["mpSuckAttack"] = "攻击时的吸取魔法比例",
        ["mpSuckAbility"] = "施法时的吸取魔法比例",
        ["hurtIncrease"] = "受到伤害时的百分比加深",
        ["hurtReduction"] = "受到伤害时的百分比减免",
        ["damageIncrease"] = "造成伤害时的百分比加深",
        ["hurtRebound"] = "反伤的百分比比例",
        [SYMBOL_ODD .. "hurtRebound"] = "反伤的几率",
        ["reborn"] = "重生时间",
        ["cure"] = "影响生命魔法恢复",
        ["stun"] = "攻击时的眩晕时间",
        [SYMBOL_ODD .. "stun"] = "攻击时的眩晕几率",
        ["crit"] = "攻击时的暴击伤害加成",
        [SYMBOL_ODD .. "crit"] = "攻击时的暴击几率",
        ["enchantMystery"] = "增加所有元素伤害",
        ["sight"] = "白昼时的最大视野",
        ["nsight"] = "夜晚时的最大视野",
        ["visible"] = "在范围内可看穿隐形单位",
        ["coolDownPercent"] = "冷却时间增减比例",
        ["costPercent"] = "施法消耗增减比例",
        ["castChantPercent"] = "吟唱时间增减比例",
        ["castDistancePercent"] = "施法距离增减比例",
        ["castRangePercent"] = "施法范围增减比例",
        ["sp"] = "特殊的强化、弱化或设定",
    }
    for _, t in ipairs(ENCHANT_TYPES) do
        local e = Enchant(t)
        data[SYMBOL_E .. t] = "造成" .. e:name() .. "伤害时的提升"
        data[SYMBOL_RES .. SYMBOL_E .. t] = "受到" .. e:name() .. "伤害时的减免"
        data[SYMBOL_EI .. t] = "是否完全免疫" .. e:name() .. "伤害"
    end
    return data[key] or "未知"
end
function ui:updated(whichUnit)
    local stage = self:stage()
    whichUnit = whichUnit or stage.whichUnit
    if (isClass(whichUnit, UnitClass)) then
        stage.whichUnit = whichUnit
        stage.mainTxt:text(stage.whichUnit:name())
        stage.avatar:texture(stage.whichUnit:icon())
        local as = {
            {
                "hp",
                "hpRegen",
                "mp",
                "mpRegen",
                '',
                "move",
                "avoid",
                "aim",
                '',
                "defend",
                "shield",
                "shieldBack",
                '',
                "attackRipple",
                "attack",
                SYMBOL_MUT .. "attack",
                '',
                "attackRange",
                "attackRangeAcquire",
                '',
                "attackSpace",
                "attackSpaceBase",
                "attackSpeed",
                SYMBOL_MUT .. "attackSpeed",
                '',
                "sp"
            },
            {
                "hpSuckAttack",
                "hpSuckAbility",
                "mpSuckAttack",
                "mpSuckAbility",
                '',
                "hurtIncrease",
                "hurtReduction",
                "damageIncrease",
                "hurtRebound",
                SYMBOL_ODD .. "hurtRebound",
                '',
                "reborn",
                "cure",
                "stun",
                SYMBOL_ODD .. "stun",
                "crit",
                SYMBOL_ODD .. "crit",
                '',
                "enchantMystery",
                "sight",
                "nsight",
                "visible",
            },
            {},
            {},
        }
        for _, t in ipairs(ENCHANT_TYPES) do
            as[3][#as[3] + 1] = SYMBOL_E .. t
        end
        as[3][#as[3] + 1] = ''
        for _, t in ipairs(ENCHANT_TYPES) do
            as[3][#as[3] + 1] = SYMBOL_RES .. SYMBOL_E .. t
        end
        for _, t in ipairs(ENCHANT_TYPES) do
            as[4][#as[4] + 1] = SYMBOL_EI .. t
        end
        as[4][#as[4] + 1] = ''
        as[4][#as[4] + 1] = "coolDownPercent"
        as[4][#as[4] + 1] = "costPercent"
        as[4][#as[4] + 1] = "castChantPercent"
        as[4][#as[4] + 1] = "castDistancePercent"
        as[4][#as[4] + 1] = "castRangePercent"
        if (stage.detailType == "data") then
            stage.attackMode:text(ui:attackMode(stage.whichUnit))
            for i = 1, 4 do
                local d = {}
                for _, a in ipairs(as[i]) do
                    if (a == '') then
                        d[#d + 1] = ''
                    else
                        local v = stage.whichUnit:prop(a) or 0
                        if (a == "sp") then
                            if (v == 0) then
                                d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": 无"
                            else
                                d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": " .. v
                            end
                        elseif (a == "reborn") then
                            if (v > 0) then
                                d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": " .. attribute.form(a)
                            else
                                d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": 无法复活"
                            end
                        elseif (string.subPos(a, SYMBOL_EI) == 1) then
                            local label = "否"
                            if (v > 0) then
                                label = "是"
                            end
                            d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": " .. label
                        else
                            d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": " .. v .. attribute.form(a)
                        end
                    end
                end
                stage.attrTxt[i]:text(table.concat(d, "|n"))
            end
        elseif (stage.detailType == "intro") then
            stage.attackMode:text("说明单位攻击模式|n包含战斗模式、箭矢属性、附魔等信息")
            for i = 1, 4 do
                local d = {}
                for _, a in ipairs(as[i]) do
                    if (a == '') then
                        d[#d + 1] = ''
                    else
                        local label = ui:intro(a)
                        d[#d + 1] = colour.hex(colour.gold, attribute.label(a)) .. ": " .. label
                    end
                end
                stage.attrTxt[i]:text(table.concat(d, "|n"))
            end
        end
    end
end
function ui:display()
    local stage = ui:stage()
    local showing = stage.main:show()
    if (showing) then
        audio(Vcm("war3_MouseClick2"))
        stage.main:show(false)
        stage.detailType = "data"
        stage.shiftBtn:text("查看说明")
        stage.shiftBtn:texture(assets.uikit("ninegrids_essence", "btn\\e_green", "tga"))
        return
    end
    audio(Vcm("war3_MouseClick1"))
    stage.main:show(true)
    self:updated(PlayerLocal():selection())
end
