local kit = "ninegrids_minimap"
UI_NinegridsMinimap = UIKit(kit)
local mapNames = { "雪原", "怪村", "遗城", "红地", "小岛", "海湾", "密林", "山丘", "荒土" }
function UI_NinegridsMinimap:mapName(index)
    return mapNames[index]
end
UI_NinegridsMinimap:onSetup(function(this)
    local stage = this:stage()
    for i = 1, BJ_MAX_PLAYER_SLOTS do
        Player(i):prop("markMode", 1)
        Player(i):prop("allyMode", 1 + J.GetAllyColorFilterState())
    end
    stage.mapW = 0.1322
    stage.mapH = 0.1200
    local textures = {}
    for i = 1, 9 do
        textures[i] = { "map\\0" .. i, this:mapName(i) }
    end
    this.map = FrameMap(kit, FrameGameUI)
        :adaptive(true)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, 0.0058, 0.0068)
        :size(stage.mapW, stage.mapH)
        :cameraSize(0.01, 0.01)
        :texture(textures)
        :alertOption(
        { texture = "item\\alert", alpha = 190, size = 0.036 },
        { texture = "item\\questionWhite", alpha = 130, size = 0.016 })
    stage.bg = FrameBackdrop(kit .. '->bg', this.map)
        :block(true)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
        :size(0.207, 0.1541666667)
    local iconX = -0.0474
    local iconW = 0.013
    local iconH = 0.013
    local mmSize = 0.11
    stage.mapBig = FrameBackdrop(kit .. '->mm', FrameGameUI)
        :adaptive(true)
        :block(true)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0.04)
        :size(mmSize * 3 + 0.7, mmSize * 3 + 0.08)
        :texture(AUIKit("ninegrids_essence", "bg/display", "tga"))
        :alpha(255)
        :show(false)
    local mm = {
        { 5, FRAME_ALIGN_CENTER, "mapBig", FRAME_ALIGN_CENTER },
        { 2, FRAME_ALIGN_BOTTOM, "mapBig5", FRAME_ALIGN_TOP },
        { 4, FRAME_ALIGN_RIGHT, "mapBig5", FRAME_ALIGN_LEFT },
        { 6, FRAME_ALIGN_LEFT, "mapBig5", FRAME_ALIGN_RIGHT },
        { 8, FRAME_ALIGN_TOP, "mapBig5", FRAME_ALIGN_BOTTOM },
        { 1, FRAME_ALIGN_RIGHT_BOTTOM, "mapBig5", FRAME_ALIGN_LEFT_TOP },
        { 3, FRAME_ALIGN_LEFT_BOTTOM, "mapBig5", FRAME_ALIGN_RIGHT_TOP },
        { 7, FRAME_ALIGN_RIGHT_TOP, "mapBig5", FRAME_ALIGN_LEFT_BOTTOM },
        { 9, FRAME_ALIGN_LEFT_TOP, "mapBig5", FRAME_ALIGN_RIGHT_BOTTOM },
    }
    for _, m in ipairs(mm) do
        stage["mapBig" .. m[1]] = FrameBackdrop(kit .. '->mm->' .. m[1], stage.mapBig)
            :relation(m[2], stage[m[3]], m[4], 0, 0)
            :size(mmSize, mmSize)
            :texture("map\\0" .. m[1])
            :show(false)
    end
    keyboard.onRelease(KEYBOARD["N"], kit, function()
        if (stage.mapBig:show()) then
            stage.mapBig:show(false)
        else
            local gd = Game():GD()
            local maps = {
                { 5 },
                { 2, 4, 6, 8 },
                { 1, 3, 7, 9 },
            }
            for mi, ms in ipairs(maps) do
                for _, m in ipairs(ms) do
                    if (m == 5 or m == gd.sliceIndex or gd.sliceResult[m] == true) then
                        stage["mapBig" .. m]:alpha(255)
                    else
                        stage["mapBig" .. m]:alpha(75)
                    end
                    stage["mapBig" .. m]:gradient({ duration = 0.1 * mi, alpha = 1, size = 200 }, function(callFrame)
                        callFrame:show(true)
                    end)
                end
            end
            stage.mapBig:show(true)
        end
    end)
    stage.iconAlert = FrameBackdrop(kit .. '->iconAlert', this.map)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, iconX, -0.031)
        :size(iconW, iconH)
        :texture("icon\\alert")
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function()
            FrameTooltips()
                :kit(kit)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT, stage.iconAlert, FRAME_ALIGN_RIGHT, 0.02, 0)
                :content({
                tips = {
                    "使用 Alt + 左键",
                    "在地图上点击",
                    "可发送警告提示",
                    "按 N 键可查看大地图",
                } })
                :show(true)
        end)
    stage.markMax = 30
    stage.markMode = {
        { texture = "icon\\markMode_1", label = "同伴、BOSS、小怪" },
        { texture = "icon\\markMode_2", label = "同伴、BOSS" },
        { texture = "icon\\markMode_3", label = "同伴" },
    }
    stage.nextMarkMode = function(whichPlayer)
        audio(Vcm("war3_MouseClick1"))
        local i = whichPlayer:prop("markMode")
        i = i + 1
        if (i > #stage.markMode) then
            i = 1
        end
        whichPlayer:prop("markMode", i)
        stage.iconMarkMode:texture(stage.markMode[i].texture)
        if (FrameTooltips():show() and FrameTooltips():kit() == kit) then
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :content({ tips = {
                "点击可以(" .. colour.hex(colour.gold, "J") .. ")",
                "循环切换小地图标记观察状态",
                "当前观察：" .. colour.hex(colour.gold, stage.markMode[i].label)
            } })
        end
    end
    keyboard.onRelease(KEYBOARD['8'], kit, function(evtData)
        stage.nextMarkMode(evtData.triggerPlayer)
    end)
    stage.iconMarkMode = FrameBackdrop(kit .. '->markMode', this.map)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, iconX, -0.051)
        :size(iconW, iconH)
        :texture(stage.markMode[PlayerLocal():prop("markMode")].texture)
        :onEvent(EVENT.Frame.LeftClick, function(evtData) stage.nextMarkMode(evtData.triggerPlayer) end)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function(evtData)
            local i = evtData.triggerPlayer:prop("markMode")
            FrameTooltips()
                :kit(kit)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT, stage.iconMarkMode, FRAME_ALIGN_RIGHT, 0.02, 0)
                :content({ tips = {
                "点击可以(" .. colour.hex(colour.gold, "8") .. ")",
                "循环切换小地图标记观察状态",
                "当前观察：" .. colour.hex(colour.gold, stage.markMode[i].label)
            } }):show(true)
        end)
    stage.markList = {}
    for i = 1, stage.markMax do
        stage.markList[i] = FrameBackdrop(kit .. "->markModeList->" .. i, this.map)
            :relation(FRAME_ALIGN_CENTER, this.map, FRAME_ALIGN_CENTER, 0, 0)
            :show(false)
    end
    stage.allyMode = {
        { texture = "icon\\allyMode_1", label = "不开启" },
        { texture = "icon\\allyMode_2", label = "小地图" },
        { texture = "icon\\allyMode_3", label = "小地图和游戏" },
    }
    stage.nextAllyMode = function(whichPlayer)
        audio(Vcm("war3_MouseClick1"))
        local i = whichPlayer:prop("allyMode")
        i = i + 1
        if (i > #stage.allyMode) then
            i = 1
        end
        whichPlayer:prop("allyMode", i)
        J.SetAllyColorFilterState(math.floor(i - 1))
        stage.iconAllyMode:texture(stage.allyMode[i].texture)
        if (FrameTooltips():show() and FrameTooltips():kit() == kit) then
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :show(true)
                :content({ tips = {
                "点击可以(" .. colour.hex(colour.gold, "9") .. ")",
                "循环切换联盟颜色显示状态",
                "当前状态：" .. colour.hex(colour.gold, stage.allyMode[i].label)
            } })
        end
    end
    keyboard.onRelease(KEYBOARD['9'], kit, function(evtData)
        stage.nextAllyMode(evtData.triggerPlayer)
    end)
    stage.iconAllyMode = FrameBackdrop(kit .. '->allyMode', this.map)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, iconX, -0.07)
        :size(iconW, iconH)
        :texture(stage.allyMode[PlayerLocal():prop("allyMode")].texture)
        :onEvent(EVENT.Frame.LeftClick, function(evtData) stage.nextAllyMode(evtData.triggerPlayer) end)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function(evtData)
            local i = evtData.triggerPlayer:prop("allyMode")
            FrameTooltips()
                :kit(kit)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT, stage.iconAllyMode, FRAME_ALIGN_RIGHT, 0.02, 0)
                :content({ tips = {
                "点击可以(" .. colour.hex(colour.gold, "0") .. ")",
                "循环切换联盟颜色显示状态",
                "当前状态：" .. colour.hex(colour.gold, stage.allyMode[i].label)
            } }):show(true)
        end)
    sync.receive("skinChanged", function()
        Game():save("skin")
    end)
    stage.skins = { RACE_HUMAN_NAME, RACE_ORC_NAME, RACE_NIGHTELF_NAME, RACE_UNDEAD_NAME }
    stage.skinsLabel = {
        [RACE_HUMAN_NAME] = colour.hex(colour.lemonchiffon, "人类科技"),
        [RACE_ORC_NAME] = colour.hex(colour.sandybrown, "兽王图腾"),
        [RACE_NIGHTELF_NAME] = colour.hex(colour.mintcream, "暗夜森林"),
        [RACE_UNDEAD_NAME] = colour.hex(colour.violet, "不死泠祖"),
    }
    stage.nextSkin = function(whichPlayer)
        audio(Vcm("war3_MouseClick1"))
        local cur = whichPlayer:skin()
        local next = 1
        for i, s in ipairs(stage.skins) do
            if (cur == s) then
                next = i + 1
                if (next > #stage.skins) then
                    next = 1
                end
                break
            end
        end
        if (FrameTooltips():show() and FrameTooltips():kit() == kit) then
            FrameTooltips()
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :content({
                tips = {
                    "点击可以(" .. colour.hex(colour.gold, "L") .. ")",
                    "循环切换皮肤",
                    "当前皮肤：" .. stage.skinsLabel[stage.skins[next]]
                } })
        end
        whichPlayer:skin(stage.skins[next])
        sync.send("skinChanged")
    end
    keyboard.onRelease(KEYBOARD['0'], kit, function(evtData)
        stage.nextSkin(evtData.triggerPlayer)
    end)
    stage.iconSkin = FrameBackdrop(kit .. '->iconSkin', this.map)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, iconX, -0.088)
        :size(iconW, iconH)
        :texture("icon\\skin")
        :onEvent(EVENT.Frame.LeftClick, function(evtData) stage.nextSkin(evtData.triggerPlayer) end)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function()
            FrameTooltips()
                :kit(kit)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT, stage.iconSkin, FRAME_ALIGN_RIGHT, 0.02, 0)
                :content({ tips = {
                "点击可以(" .. colour.hex(colour.gold, "L") .. ")",
                "循环切换皮肤",
                "当前皮肤：" .. stage.skinsLabel[PlayerLocal():skin()]
            } }):show(true)
        end)
    stage.help = {}
    stage.pl = FrameText(kit .. '->pl', this.map)
        :relation(FRAME_ALIGN_RIGHT_TOP, stage.bg, FRAME_ALIGN_RIGHT_TOP, -0.049, -0.114)
        :size(0.01, 0.01)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(9)
        :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false) end)
        :onEvent(EVENT.Frame.Enter,
        function(evtData)
            local l = evtData.triggerPlayer:mapLv()
            local n = { "平凡的玩家" }
            if (l < 3) then
                n = { "萌新玩家" }
            elseif (l >= 6) then
                n = { "玩家中的高手" }
            elseif (l >= 10) then
                n = { "玩家中的大佬" }
            elseif (l >= 20) then
                n = { "大佬中的大佬" }
            end
            FrameTooltips()
                :kit(kit)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(10)
                :relation(FRAME_ALIGN_LEFT, stage.pl, FRAME_ALIGN_RIGHT, 0.02, 0)
                :content({ tips = n })
                :show(true)
        end)
    async.call(PlayerLocal(), function()
        if (PlayerLocal():isPlaying()) then
            stage.bg:texture("bg\\" .. PlayerLocal():skin())
        end
    end)
    event.registerReaction(EVENT.Prop.Change, "ninegrids_minimap", function(evtData)
        if (evtData.triggerPlayer) then
            if (evtData.key == "skin") then
                async.call(evtData.triggerPlayer, function()
                    stage.bg:texture("bg\\" .. evtData.new)
                end)
            end
        end
    end)
end)
UI_NinegridsMinimap:onStart(function(this)
    local stage = this:stage()
    async.call(PlayerLocal(), function()
        stage.pl:text(PlayerLocal():mapLv())
    end)
end)
UI_NinegridsMinimap:onRefresh(0.08, function(this)
    local p = PlayerLocal()
    async.call(p, function()
        local stage = this:stage()
        local _, _, xMin, yMin, xMax, yMax = this.map:l2r4()
        local allyMode = p:prop("allyMode")
        local markMode = p:prop("markMode")
        local us = Group():catch(UnitClass, {
            limit = stage.markMax,
            corner = { xMin, yMin, xMax, yMax },
            filter = function(enumObj)
                if (enumObj:isDead()) then
                    return false
                end
                if (type(enumObj:iconMap()) ~= "table") then
                    return false
                end
                if (enumObj:isEnemy(p)) then
                    if (markMode == 3) then
                        return false
                    end
                    if (p:isInvisibleUnit(enumObj)) then
                        return false
                    end
                    if (markMode == 2) then
                        if (true ~= enumObj:elite()) then
                            return false
                        end
                    end
                end
                return true
            end
        })
        for i = 1, stage.markMax do
            if (isClass(us[i], UnitClass) == false) then
                stage.markList[i]:show(false)
            else
                local u = us[i]
                local ic = u:iconMap()
                local texture = ic[1]
                local w = ic[2]
                local h = ic[3]
                if (texture == "px") then
                    if (allyMode == 3) then
                        if (u:isEnemy(p)) then
                            texture = TEAM_COLOR_BLP_RED
                        else
                            texture = TEAM_COLOR_BLP_BLUE
                        end
                    else
                        texture = TEAM_COLOR_BLP[u:owner():index()]
                    end
                end
                local size = this.map:prop("unAdaptiveSize")
                local rw, rh = this.map:t2r(u:x(), u:y())
                stage.markList[i]
                     :relation(FRAME_ALIGN_CENTER, this.map, FRAME_ALIGN_LEFT_BOTTOM, rw * size[1], rh * size[2])
                     :texture(texture)
                     :size(w, h)
                     :show(true)
            end
        end
    end)
end)