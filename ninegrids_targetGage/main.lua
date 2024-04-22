local kit = "ninegrids_targetGage"
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    stage.length = 0.18
    stage.height = stage.length * 34 / 386
    stage.bg = FrameBackdrop(kit .. "->bg", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, 0.146, -0.026)
        :size(stage.length, stage.height)
        :texture("bg")
        :show(false)
    stage.hp = FrameBackdrop(kit .. "->hp", stage.bg)
        :relation(FRAME_ALIGN_LEFT, stage.bg, FRAME_ALIGN_LEFT, 0, 0)
        :size(stage.length, stage.height)
        :texture("Framework\\ui\\tile_red.tga")
    stage.shield = FrameBackdrop(kit .. "->shield", stage.bg)
        :relation(FRAME_ALIGN_LEFT, stage.bg, FRAME_ALIGN_LEFT, 0, 0)
        :size(stage.length, stage.height)
        :texture("Framework\\ui\\tile_yellow.tga")
    stage.mask = FrameBackdrop(kit .. "->mask", stage.bg)
        :size(stage.length, stage.height)
        :texture("Framework\\ui\\tile_white.tga")
        :show(false)
    stage.mp = FrameBackdrop(kit .. "->mp", stage.bg)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, stage.bg, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
        :size(stage.length, 0.002)
        :texture("Framework\\ui\\tile_sky.tga")
    stage.name = FrameText(kit .. "->name", stage.bg)
        :relation(FRAME_ALIGN_LEFT, stage.bg, FRAME_ALIGN_LEFT, 0.004, 0.0007)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(9)
        :text('小小')
    stage.value = FrameText(kit .. "->value", stage.bg)
        :relation(FRAME_ALIGN_RIGHT, stage.bg, FRAME_ALIGN_RIGHT, -0.004, 0.0007)
        :textAlign(TEXT_ALIGN_RIGHT)
        :fontSize(9)
        :text('')
    local hlh = stage.height * 0.23
    local hll = hlh * 346 / 8
    stage.highlight = FrameBackdrop(kit .. "->highlight", stage.bg)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, 0, 0)
        :size(hll, hlh)
        :texture("highlight")
    local rBorder = 411 / 386
    local wBorder = stage.length * rBorder
    local hBorder = wBorder * 53 / 411
    local xBorder = wBorder * 0.008
    local yBorder = hBorder * 0.15
    stage.border = FrameBackdrop(kit .. "->border", stage.bg)
        :relation(FRAME_ALIGN_TOP, stage.bg, FRAME_ALIGN_TOP, xBorder, yBorder)
        :size(wBorder * 0.995, hBorder)
        :texture("border")
    stage.buff_max = 10
    stage.buff_iSize = stage.length / 13
    stage.buff_iMar = 0.0005
    stage.buff_buffs = {}
    stage.buff_buffSignal = {}
    stage.buff = FrameBackdrop(kit, stage.border)
        :relation(FRAME_ALIGN_LEFT_TOP, stage.border, FRAME_ALIGN_LEFT_BOTTOM, 0.01, -0.003)
        :size((stage.buff_iSize + stage.buff_iMar) * stage.buff_max, stage.buff_iSize)
    for i = 1, stage.buff_max do
        stage.buff_buffs[i] = FrameButton(kit .. '->btn->' .. i, stage.buff)
        if (i == 1) then
            stage.buff_buffs[i]:relation(FRAME_ALIGN_CENTER, stage.buff, FRAME_ALIGN_CENTER, -stage.buff_max / 2 * (stage.buff_iSize + stage.buff_iMar), 0)
        else
            stage.buff_buffs[i]:relation(FRAME_ALIGN_LEFT, stage.buff_buffs[i - 1], FRAME_ALIGN_RIGHT, stage.buff_iMar, 0)
        end
        stage.buff_buffs[i]:size(stage.buff_iSize, stage.buff_iSize)
             :fontSize(6)
             :maskValue(1)
             :show(false)
             :onEvent(EVENT.Frame.Leave, function(_) FrameTooltips():show(false, 0) end)
             :onEvent(EVENT.Frame.Enter,
            function()
                local tips = UIKit("ninegrids_buff"):tips(stage, i)
                if (tips ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :relation(FRAME_ALIGN_TOP, stage.buff_buffs[i], FRAME_ALIGN_BOTTOM, 0, -0.002)
                        :content({ tips = tips })
                        :show(true)
                end
            end)
        stage.buff_buffs[i]:childText():relation(FRAME_ALIGN_BOTTOM, stage.buff_buffs[i], FRAME_ALIGN_BOTTOM, 0, 0.003)
        stage.buff_buffSignal[i] = FrameBackdrop(kit .. '->signal->' .. i, stage.buff_buffs[i])
            :relation(FRAME_ALIGN_CENTER, stage.buff_buffs[i], FRAME_ALIGN_CENTER, 0, 0)
            :size(stage.buff_iSize, stage.buff_iSize)
    end
end)
function ui:maskClose()
    local stage = self:stage()
    local t = self:prop("maskTimer")
    if (isClass(t, TimerClass)) then
        destroy(t)
        self:clear("maskTimer")
    end
    stage.mask:show(false)
end
function ui:maskRemain(uniqueKey, ratio, relation)
    async.must()
    if (ratio <= 0) then
        self:maskClose()
        return
    end
    local curId = uniqueKey .. relation:id()
    local prevId = self:prop("prevId")
    if (prevId ~= nil and prevId ~= curId) then
        self:clear("prevRatio")
        self:clear("maskRemain")
    end
    self:prop("prevId", curId)
    local stage = self:stage()
    local prevRatio = self:prop("prevRatio") or 1
    local maskRemain = self:prop("maskRemain")
    if (maskRemain == nil) then
        maskRemain = math.min(1 - ratio, ratio + 0.002)
    else
        maskRemain = math.max(0, prevRatio - ratio + maskRemain)
    end
    if (maskRemain <= 0) then
        self:maskClose()
        return
    end
    self:prop("prevRatio", ratio)
    self:prop("maskRemain", maskRemain)
    stage.mask:show(true)
    stage.mask:relation(FRAME_ALIGN_LEFT, relation, FRAME_ALIGN_RIGHT, 0, 0):size(stage.length * maskRemain, stage.height)
    local t = async.setInterval(2, function(cutTimer)
        local pr = self:prop("maskRemain") or -1
        pr = pr - (stage.length / 30)
        self:prop("maskRemain", pr)
        if (pr <= 0) then
            destroy(cutTimer)
            self:maskClose()
            return
        end
        stage.mask:size(stage.length * pr, stage.height):show(true)
    end)
    self:prop("maskTimer", t)
end
function ui:updated(target)
    async.must()
    local stage = self:stage()
    local gd = Game():GD()
    local me = gd.me
    local p = me:owner()
    if (isClass(target, UnitClass) == false or target:isDead() or false == target:isEnemy(p)) then
        stage.bg:show(false)
        return
    end
    local hideTimer = self:prop("hideTimer")
    if (isClass(hideTimer, TimerAsyncClass)) then
        self:clear("hideTimer", true)
    end
    local call = function()
        stage.bg:show(true)
        stage.name:text(target:name())
        local shieldCur = target:shieldCur()
        if (shieldCur > 0) then
            local shield = target:shield()
            local ratio = shieldCur / shield
            stage.shield:size(math.max(0.001, stage.length * ratio), stage.height):show(true)
            stage.value:text(math.floor(shieldCur) .. '/' .. math.floor(shield) .. ' ' .. attribute.label("shield"))
            stage.hp:alpha(100)
            self:maskRemain(target:id(), ratio, stage.shield)
        else
            stage.shield:show(false)
            local hpCur = target:hpCur()
            if (hpCur > 0) then
                local hp = target:hp()
                local ratio = hpCur / hp
                stage.hp:alpha(255)
                stage.hp:size(math.max(0.001, stage.length * ratio), stage.height)
                stage.value:text(math.floor(hpCur) .. '/' .. math.floor(hp) .. ' ' .. attribute.label("hp"))
                self:maskRemain(target:id(), ratio, stage.hp)
            end
        end
        local mpCur = target:mpCur()
        if (mpCur > 0) then
            local mp = target:mp()
            local ratio = mpCur / mp
            stage.mp:size(math.max(0.001, stage.length * ratio), 0.002):show(true)
        else
            stage.mp:show(false)
        end
    end
    call()
    local ti = 0
    self:prop("hideTimer", async.setInterval(18, function(curTimer)
        ti = ti + 1
        if (ti > 16 or isClass(target, UnitClass) == false or target:isDead()) then
            destroy(curTimer)
            self:maskClose()
            stage.bg:gradient({ duration = 0.2, alpha = -1 }, function(callFrame)
                callFrame:show(false)
                stage.hp:size(stage.length, stage.height)
                stage.value:text('')
            end)
            return
        end
        call()
        UI_NinegridsBuff:updated(stage, target)
    end))
end