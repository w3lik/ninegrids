local kit = "ninegrids_info"
UI_NinegridsInfo = UIKit(kit)
UI_NinegridsInfo:onSetup(function(this)
    local stage = this:stage()
    stage.erode = FrameBackdrop(kit .. "->erode", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_RIGHT_BOTTOM, FrameGameUI, FRAME_ALIGN_RIGHT_BOTTOM, 0, 0)
        :size(0.08, 0.08 * 132 / 120)
        :texture("erode")
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false, 0) end)
        :onEvent(EVENT.Frame.Enter,
        function(evtData)
            FrameTooltips()
                :relation(FRAME_ALIGN_RIGHT_BOTTOM, evtData.triggerFrame, FRAME_ALIGN_LEFT_BOTTOM, 0, 0.015)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :content(tooltipsErode())
                :show(true)
        end)
    stage.erodeTxt = FrameText(kit .. "->erode->txt", stage.erode)
        :relation(FRAME_ALIGN_CENTER, stage.erode, FRAME_ALIGN_CENTER, 0.01, -0.015)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(10)
        :text(Game():GD().erode)
    stage.countdown = FrameBackdrop(kit .. "->countdown", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, 0, -0.06)
        :size(0.1, 0.1 * 42 / 256)
        :texture("timer")
        :show(false)
    stage.countdownTxt = FrameText(kit .. "->countdown->txt", stage.countdown)
        :relation(FRAME_ALIGN_CENTER, stage.countdown, FRAME_ALIGN_CENTER, 0, 0)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(10)
    stage.navi = FrameBackdrop(kit .. "->navi", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, -0.16, 0)
        :size(0.14, 0.14 * 68 / 640)
        :texture("mapNavi")
    stage.naviIdx = FrameBackdrop(kit .. "->naviIdx", stage.navi)
        :size(0.01, 0.01)
        :texture("mapNaviIdx")
    stage.naviPass = {}
    for i = 1, 9 do
        stage.naviPass[i] = FrameBackdrop(kit .. "->naviPass->" .. i, stage.navi)
            :relation(FRAME_ALIGN_LEFT, stage.navi, FRAME_ALIGN_LEFT, 0.003 + (i - 1) * 0.01558, 0)
            :size(0.01, 0.01)
            :texture("mapNaviPass")
            :show(false)
    end
    local selectMe = function()
        local gd = Game():GD()
        local me = gd.me
        if (isClass(me, UnitClass) and me:isAlive()) then
            local o = me:owner()
            if (o:selection() == me) then
                camera.to(me:x(), me:y(), 0)
            else
                me:owner():select(me)
            end
        end
    end
    stage.avatarName = FrameBackdrop(kit .. '->avatarName', FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_LEFT_TOP, FrameGameUI, FRAME_ALIGN_LEFT_TOP, 0.008, -0.1)
        :size(0.06, 0.06 / 196 * 96)
        :texture("avatar\\name")
    stage.avatarNameTxt = FrameText(kit .. '->avatarNameTxt', stage.avatarName)
        :relation(FRAME_ALIGN_CENTER, stage.avatarName, FRAME_ALIGN_CENTER, 0, 0.001)
        :fontSize(9)
    stage.avatar = FrameBackdrop(kit .. '->avatar', stage.avatarName)
        :size(0.04, 0.04)
        :relation(FRAME_ALIGN_BOTTOM, stage.avatarName, FRAME_ALIGN_TOP, 0, 0.01)
        :onEvent(EVENT.Frame.LeftClick, selectMe)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false, 0) end)
        :onEvent(EVENT.Frame.Enter,
        function(evtData)
            FrameTooltips()
                :relation(FRAME_ALIGN_LEFT, evtData.triggerFrame, FRAME_ALIGN_RIGHT, 0.012, 0)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :content(tooltipsMe())
                :show(true)
        end)
    local btnW = 0.015
    for i = 1, 4, 1 do
        stage["avatarBtnA" .. i] = FrameButton(kit .. '->avatarA' .. i, stage.avatar)
            :size(btnW, btnW)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.avatar, FRAME_ALIGN_RIGHT_TOP, 0.012 + (i - 1) * (btnW + 0.004), -0.002)
            :show(false)
    end
    for i = 1, 4, 1 do
        stage["avatarBtnB" .. i] = FrameButton(kit .. '->avatarB' .. i, stage.avatar)
            :size(btnW, btnW)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.avatar, FRAME_ALIGN_RIGHT_TOP, 0.012 + (i - 1) * (btnW + 0.004), -0.024)
            :show(false)
    end
    local aic = {
        "ability/InscriptionVantusRuneAzure",
        "ability/InscriptionVantusRuneTomb",
        "ability/InscriptionVantusRuneSuramar",
        "ability/InscriptionVantusRuneNightmare",
        "ability/InscriptionVantusRuneOdyn",
    }
    stage.avatar:texture(assets.icon(aic[Game():GD().diff]))
    stage.avatarBorder = FrameBackdrop(kit .. '->avatarBorder', stage.avatar)
        :relation(FRAME_ALIGN_CENTER, stage.avatar, FRAME_ALIGN_CENTER, 0, 0)
        :size(0.055, 0.055)
    keyboard.onRelease(KEYBOARD["F1"], kit, selectMe)
    local lw = 0.07
    stage.levels = FrameButton(kit .. "->levels", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, -0.28, -0.018)
        :size(lw, lw * 75 / 188)
        :texture("levels")
        :onEvent(EVENT.Frame.LeftClick, function() UI_NinegridsUpgrade:upgrade() end)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function()
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_RIGHT, stage.levels, FRAME_ALIGN_LEFT, -0.01, 0)
                :content({
                tips = { colour.hex(colour.gold, "点击") .. colour.hex(colour.silver, "以分配能力点") } })
                :show(true)
        end)
    stage.levelDef = FrameText(kit .. "->levels->def", stage.levels)
        :relation(FRAME_ALIGN_CENTER, stage.levels, FRAME_ALIGN_CENTER, -lw * 0.362, -0.001)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(7)
        :text(0)
    stage.levelAtk = FrameText(kit .. "->levels->atk", stage.levels)
        :relation(FRAME_ALIGN_CENTER, stage.levels, FRAME_ALIGN_CENTER, 0, -0.001)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(7)
        :text(0)
    stage.levelSpd = FrameText(kit .. "->levels->spd", stage.levels)
        :relation(FRAME_ALIGN_CENTER, stage.levels, FRAME_ALIGN_CENTER, lw * 0.362, -0.001)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(7)
        :text(0)
    stage.darkMarker = FrameBackdrop(kit .. "->darkMarker", FrameGameUI)
        :block(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
        :size(0.8, 0.6)
        :texture(TEAM_COLOR_BLP_BLACK)
        :alpha(200)
        :show(false)
    stage.dead = FrameBackdrop(kit .. "->dead", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.08)
        :size(0.6, 0.6 / 512 * 110)
        :texture("dead")
        :show(false)
    stage.deadTxt = FrameText(kit .. "->deadTxt", stage.dead)
        :relation(FRAME_ALIGN_TOP, stage.dead, FRAME_ALIGN_BOTTOM, 0, -0.02)
        :fontSize(9)
        :textAlign(TEXT_ALIGN_CENTER)
        :text("泠飞嚯散，进度已归于虚无，灵泠凝聚并重生中...")
    stage.boss = FrameBackdrop(kit .. "->boss", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.05)
        :size(0.4, 0.4 / 512 * 258)
        :texture("boss")
        :show(false)
    stage.me = FrameBackdrop(kit .. "->me", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.05)
        :size(0.4, 0.4 / 512 * 258)
        :texture("me")
        :show(false)
    stage.msg = FrameBackdrop(kit .. "->msg", FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, 0, -0.07)
        :size(0.2, 0.2 * 42 / 256)
        :show(false)
    stage.msgTxt = FrameText(kit .. "->msg->txt", stage.msg)
        :relation(FRAME_ALIGN_CENTER, stage.msg, FRAME_ALIGN_CENTER, 0, 0)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(12)
end)
function UI_NinegridsInfo:updated()
    async.must()
    local stage = self:stage()
    local gd = Game():GD()
    local me = gd.me
    local erode = gd.erode
    if (erode > 50) then
        UI_NinegridsAnimate:flame(stage.erodeTxt, 0, 0.002)
        stage.erodeTxt:text(colour.hex(colour.red, "侵蚀|n" .. erode))
    else
        UI_NinegridsAnimate:flameStop()
        stage.erodeTxt:text("侵蚀|n" .. erode)
    end
    stage.levelDef:text(gd.upgradeDef)
    stage.levelAtk:text(gd.upgradeAtk)
    stage.levelSpd:text(gd.upgradeSpd)
    if (isClass(me, UnitClass) and me:isAlive()) then
        stage.avatarBorder:texture("avatar\\gold")
        stage.avatar:texture(me:icon())
        local n = me:name()
        local ns = vistring.width(n .. "占位符", stage.avatarNameTxt:fontSize())
        stage.avatarNameTxt:text(n)
        stage.avatarName:alpha(255):size(ns, ns / 196 * 96)
    else
        stage.avatarBorder:texture("avatar\\dark")
        stage.avatarNameTxt:text("断 泠")
        stage.avatarName:alpha(150):size(0.06, 0.06 / 196 * 96)
    end
    for i = 2, 5, 1 do
        local tpl = TPL_SOUL[gd["meSoul" .. i]]
        local b = stage["avatarBtnA" .. (i - 1)]
        local key = "F" .. i
        local icon, desc
        if (isClass(tpl, UnitTplClass)) then
            icon = tpl:icon()
            desc = { key, tpl:name() }
            keyboard.onRelease(KEYBOARD[key], "meSoulC", function()
                if (keyboard.isPressing(KEYBOARD["Alt"])) then
                    return
                end
                if (self:prop("soulCTimer") ~= nil) then
                    self:info("alert", 1, "冷却中")
                    return
                end
                if (isClass(gd.me, UnitClass) == false) then
                    self:info("alert", 1, "泠元已断泠")
                    return
                end
                if (gd.me:isInterrupt()) then
                    return
                end
                sync.send("ninegrids_essence", { "soulC", tpl:prop("idx") })
                for j = 1, 4, 1 do
                    stage["avatarBtnA" .. j]:alpha(150)
                end
                self:prop("soulCTimer", async.setTimeout(100, function()
                    self:clear("soulCTimer")
                    for j = 1, 4, 1 do
                        stage["avatarBtnA" .. j]:alpha(255)
                    end
                end))
            end)
        else
            icon = "Framework\\ui\\default.tga"
            desc = { key, "未备用泠元", colour.hex(colour.gold, "按 O 设定") }
            keyboard.onRelease(KEYBOARD[key], "meSoulC", nil)
        end
        b:texture(icon)
         :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
         :onEvent(EVENT.Frame.Enter,
            function()
                FrameTooltips()
                    :textAlign(TEXT_ALIGN_CENTER)
                    :fontSize(10)
                    :relation(FRAME_ALIGN_BOTTOM, b, FRAME_ALIGN_TOP, 0, 0.002)
                    :content({ tips = desc })
                    :show(true)
            end)
         :show(true)
    end
    stage.avatarBtnB1:prop("texture", assets.icon("other/PlusYellow"))
         :onEvent(EVENT.Frame.LeftClick, function() UI_NinegridsUpgrade:upgrade() end)
         :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
         :onEvent(EVENT.Frame.Enter,
        function()
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT_TOP, stage.avatarBtnB1, FRAME_ALIGN_LEFT_BOTTOM, 0, -0.02)
                :content(tooltipsAvatarB1())
                :show(true)
        end)
         :show(true)
    stage.avatarBtnB2
         :texture(TPL_WEATHER[gd.weather]:icon())
         :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
         :onEvent(EVENT.Frame.Enter,
        function()
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT_TOP, stage.avatarBtnB2, FRAME_ALIGN_LEFT_BOTTOM, 0, -0.02)
                :content(tooltipsAvatarB2())
                :show(true)
        end)
         :show(true)
end
function UI_NinegridsInfo:countdown(t, tit)
    async.must()
    must(isClass(t, TimerClass))
    if (t:remain() <= 0) then
        return
    end
    local stage = self:stage()
    if (isClass(stage.countdownTimer, TimerAsyncClass)) then
        destroy(stage.countdownTimer)
        stage.countdown:show(true)
    else
        stage.countdown:gradient({ duration = 0.1, alpha = 1 }, function(callFrame)
            callFrame:show(true)
        end)
    end
    stage.countdownTxt:text(tit .. t:remain() .. " 秒")
    stage.countdownTimer = async.setInterval(18, function(curTimer)
        local re = t:remain()
        if (isDestroy(t) or re <= 0) then
            destroy(curTimer)
            stage.countdown:gradient({ duration = 0.1, alpha = -1 }, function(callFrame)
                callFrame:show(false)
            end)
            stage.countdownTimer = nil
            return
        end
        stage.countdownTxt:text(tit .. math.format(re, 1) .. " 秒")
    end)
end
function UI_NinegridsInfo:navi(idx)
    async.must()
    local stage = self:stage()
    local sliceResult = Game():GD().sliceResult
    for i = 1, 9 do
        stage.naviPass[i]:show(i ~= idx and sliceResult[i] == 1)
    end
    local naviIdx = stage.naviIdx
    local prev = self:prop("naviIdxPrev")
    if (prev == idx) then
        return
    end
    if (prev == nil) then
        prev = 5
    end
    self:prop("naviIdxPrev", idx)
    local x = (prev - idx) * 0.006
    naviIdx:relation(FRAME_ALIGN_LEFT, stage.navi, FRAME_ALIGN_LEFT, 0.003 + (idx - 1) * 0.01558, 0)
           :gradient({ duration = 0.3, x = x, y = 0 })
end
function UI_NinegridsInfo:darkMarker(enable)
    async.must()
    must(type(enable) == "boolean")
    async.call(PlayerLocal(), function()
        local stage = self:stage()
        local alpha = datum.ternary(enable, 1, -1)
        stage.darkMarker:gradient({ duration = 0.1, show = enable, alpha = alpha }, function(callFrame)
            callFrame:show(enable)
        end)
    end)
end
function UI_NinegridsInfo:dead(dur)
    async.must()
    dur = dur or 5
    self:darkMarker(true)
    --PlayerLocal():mark(TEXTURE_MARK.dream, dur, 255, 0, 0)
    local stage = self:stage()
    stage.dead:gradient({ duration = 0.5, alpha = 1 }, function(callFrame)
        callFrame:show(true)
    end)
    async.setTimeout(dur * 60, function()
        self:darkMarker(false)
        stage.dead:gradient({ duration = 0.3, alpha = -1 }, function(callFrame)
            callFrame:show(false)
        end)
    end)
end
function UI_NinegridsInfo:boss()
    async.must()
    self:darkMarker(true)
    local stage = self:stage()
    stage.boss:gradient({ duration = 0.3, alpha = 1 }, function(callFrame)
        callFrame:show(true)
    end)
    async.setTimeout(60, function()
        self:darkMarker(false)
        stage.boss:gradient({ duration = 0.3, alpha = -1 }, function(callFrame)
            callFrame:show(false)
        end)
    end)
end
function UI_NinegridsInfo:bossMe()
    async.must()
    audio(Vcm("bossMe"))
    self:darkMarker(true)
    local stage = self:stage()
    stage.me:gradient({ duration = 0.3, alpha = 1 }, function(callFrame)
        callFrame:show(true)
    end)
    async.setTimeout(180, function()
        self:darkMarker(false)
        stage.me:gradient({ duration = 0.3, alpha = -1 }, function(callFrame)
            callFrame:show(false)
        end)
    end)
end
function UI_NinegridsInfo:info(typ, duration, msg)
    async.must()
    must(type(msg) == "string" and type(typ) == "string")
    local stage = self:stage()
    if (typ == "alert") then
        stage.msgTxt:relation(FRAME_ALIGN_CENTER, stage.msg, FRAME_ALIGN_CENTER, 0, -0.005)
    else
        stage.msgTxt:relation(FRAME_ALIGN_CENTER, stage.msg, FRAME_ALIGN_CENTER, 0, 0)
    end
    if (typ == "alert") then
        stage.msg:texture("msg\\alert")
    elseif (typ == "info") then
        stage.msg:texture("msg\\info")
    elseif (typ == "error") then
        stage.msg:texture("msg\\error")
    elseif (typ == "great") then
        stage.msg:texture("msg\\great")
    else
        return
    end
    duration = duration or 5
    stage.msgTxt:text(msg)
    stage.msg:gradient({ duration = 0.3, alpha = 1, y = -0.06 }, function(callFrame)
        callFrame:show(true)
    end)
    local t = self:prop("msgTimer")
    if (isClass(t, TimerClass)) then
        self:clear("msgTimer", true)
        t = nil
    end
    t = async.setTimeout(duration * 60, function()
        stage.msg:gradient({ duration = 0.1, alpha = -1 }, function(callFrame)
            callFrame:show(false)
        end)
    end)
    self:prop("msgTimer", t)
end