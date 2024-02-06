local kit = "ninegrids_animate"
UI_NinegridsAnimate = UIKit(kit)
UI_NinegridsAnimate:onSetup(function(this)
    local stage = this:stage()
    local types = {
        blackHole = { len = 30, dur = 0.5 },
        challenge = { len = 12, dur = 1.2 },
        crystal = { len = 8, dur = 0.5 },
        flame = { len = 14, dur = 1 },
        doing = { len = 11, dur = 0.5 },
        forge = { len = 14, dur = 0.4 },
        levelup = { len = 12, dur = 0.5 },
        saving = { len = 7, dur = 0.2 },
        treasure = { len = 6, dur = 0.5 },
    }
    for k, v in pairx(types) do
        local motion = {}
        for i = 1, v.len do
            motion[i] = k .. "\\" .. string.fill(i, 2, "0", true)
        end
        stage[k] = FrameAnimate(kit .. "->" .. k, FrameGameUI)
            :adaptive(true)
            :show(false)
            :motion(motion)
            :duration(v.dur)
            :onStop(function(evt) evt:gradient({ duration = 0.1, alpha = -1 }, function(callFrame) callFrame:show(false) end) end)
    end
    stage.item = FrameBackdrop(kit .. "->item", FrameGameUI):texture("i_item"):adaptive(true):show(false)
    stage.see = FrameBackdrop(kit .. "->see", FrameGameUI):texture("i_see"):adaptive(true):show(false)
end)
function UI_NinegridsAnimate:item(relation, x, y)
    async.must()
    local stage = self:stage()
    stage.item
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, x or 0, y or 0)
         :size(0.03, 0.03)
         :show(false)
    local t = stage.item:prop("aniTimer")
    destroy(t)
    local i = 0
    t = async.setInterval(0.21, function(curTimer)
        i = i + 1
        if (i >= 9) then
            destroy(curTimer)
            return
        end
        local show = (not stage.item:show())
        local alpha = datum.ternary(show, 1, -1)
        stage.item:gradient({ duration = 0.2, alpha = alpha }, function(callFrame)
            callFrame:show(show)
        end)
    end)
    stage.item:prop("aniTimer", t)
end
function UI_NinegridsAnimate:see(relation, x, y)
    async.must()
    local stage = self:stage()
    stage.see
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, x or 0, y or 0)
         :size(0.03, 0.03)
         :show(false)
    local t = stage.see:prop("aniTimer")
    destroy(t)
    local i = 0
    t = async.setInterval(0.21, function(curTimer)
        i = i + 1
        if (i >= 9) then
            destroy(curTimer)
            return
        end
        local show = (not stage.see:show())
        local alpha = datum.ternary(show, 1, -1)
        stage.see:gradient({ duration = 0.2, alpha = alpha }, function(callFrame)
            callFrame:show(show)
        end)
    end)
    stage.see:prop("aniTimer", t)
end
function UI_NinegridsAnimate:save()
    async.must()
    local stage = self:stage()
    stage.saving
         :relation(FRAME_ALIGN_RIGHT_TOP, FrameGameUI, FRAME_ALIGN_RIGHT_TOP, -0.02, -0.05)
         :size(0.04, 0.04)
         :gradient({ duration = 0.1, alpha = 1 }, function(callFrame) callFrame:show(true) end)
         :play(18, true)
end
function UI_NinegridsAnimate:challenge()
    async.must()
    local stage = self:stage()
    stage.challenge
         :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.05)
         :size(0.4, 0.4 * 85 / 256)
         :gradient({ duration = 0.1, alpha = 1, size = -60 }, function(callFrame) callFrame:show(true) end)
         :play(1, true)
end
function UI_NinegridsAnimate:doing(relation, x, y)
    async.must()
    local stage = self:stage()
    stage.doing
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, x, y)
         :size(0.08, 0.08)
         :gradient({ duration = 0.1, alpha = 1 }, function(callFrame) callFrame:show(true) end)
         :play(1, true)
end
function UI_NinegridsAnimate:levelup(relation, x, y)
    async.must()
    audio(Vcm("war3_Tomes"))
    local stage = self:stage()
    stage.levelup
         :relation(FRAME_ALIGN_BOTTOM, relation or FrameGameUI, FRAME_ALIGN_CENTER, x, y)
         :size(0.16, 0.16 * 16 / 12)
         :gradient({ duration = 0.1, alpha = 1 }, function(callFrame) callFrame:show(true) end)
         :play(1, true)
end
function UI_NinegridsAnimate:forge(relation, x, y)
    async.must()
    audio(Vcm("war3_Tomes"))
    local stage = self:stage()
    stage.forge
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, x, y)
         :size(0.18, 0.18)
         :gradient({ duration = 0.1, alpha = 1, size = 60 }, function(callFrame) callFrame:show(true) end)
         :play(1, true)
end
function UI_NinegridsAnimate:blackHole(times)
    async.must()
    times = times or 1
    local stage = self:stage()
    stage.blackHole
         :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.05)
         :size(0.4, 0.4)
         :gradient({ duration = 0.1, alpha = 1, size = -90 }, function(callFrame) callFrame:show(true) end)
         :play(times, true)
end
function UI_NinegridsAnimate:treasure(relation, x, y)
    async.must()
    local stage = self:stage()
    stage.treasure
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
         :size(0.036, 0.036)
         :gradient({ duration = 0.6, alpha = 1, x = x or 0, y = y or 0 }, function(callFrame) callFrame:show(true) end)
         :play(2, true)
end
function UI_NinegridsAnimate:crystal(relation, x, y)
    async.must()
    local stage = self:stage()
    stage.crystal
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
         :size(0.03, 0.03)
         :gradient({ duration = 0.6, alpha = 1, x = x or 0, y = y or 0 }, function(callFrame) callFrame:show(true) end)
         :play(3, true)
end
function UI_NinegridsAnimate:flameStop()
    async.must()
    local stage = self:stage()
    stage.flame:stop()
end
function UI_NinegridsAnimate:flame(relation, x, y)
    self:flameStop()
    local stage = self:stage()
    stage.flame
         :relation(FRAME_ALIGN_CENTER, relation or FrameGameUI, FRAME_ALIGN_CENTER, x, y)
         :size(0.048, 0.048)
         :gradient({ duration = 1, alpha = 1 }, function(callFrame) callFrame:show(true) end)
         :play(-1, true)
end