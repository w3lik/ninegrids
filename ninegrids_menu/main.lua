local kit = "ninegrids_menu"
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    stage.menu = FrameBackdrop(kit, FrameGameUI)
        :adaptive(true)
        :block(true)
        :absolut(FRAME_ALIGN_TOP, 0, 0)
        :size(0.65, 0.0375)
    stage.menu_mapName = FrameText(kit .. "->mn", stage.menu)
        :relation(FRAME_ALIGN_LEFT, stage.menu, FRAME_ALIGN_TOP, -0.298, -0.008)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(9)
    stage.menu_player = FrameText(kit .. "->msv", stage.menu)
        :relation(FRAME_ALIGN_LEFT_TOP, stage.menu, FRAME_ALIGN_RIGHT_TOP, -0.058, -0.0032)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(10)
    stage.menu_info = FrameText(kit .. "->info", stage.menu)
        :relation(FRAME_ALIGN_TOP, stage.menu, FRAME_ALIGN_TOP, 0, -0.007)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(9)
        :text("")
    stage.worth = {}
    stage.resAllow = {}
    stage.resOpt = {
        gold = { texture = 'worth/gold', color = 'FED112', x = 0.02, y = -0.03 },
        silver = { texture = 'worth/silver', color = 'BEC8EB', x = 0.02, y = -0.043 },
        copper = { texture = 'worth/copper', color = 'D7AE8E', x = 0.08, y = -0.043 },
    }
    local res = Game():worth()
    res:forEach(function(key, value)
        if (stage.resOpt[key]) then
            stage.resOpt[key].name = value.name
            if (false == table.includes(stage.resAllow, key)) then
                table.insert(stage.resAllow, key)
            end
        else
            stage.resOpt[key] = { name = value.name }
        end
    end)
    for i, k in ipairs(stage.resAllow) do
        local x = 0.052 + (i - 1) * 0.071
        local y = -0.004
        local n = stage.resOpt[k].name
        local opt = stage.resOpt[k]
        stage.worth[i] = FrameLabel(kit .. "->res->" .. k, stage.menu)
            :autoSize(false)
            :size(0.053, 0.01)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.menu, FRAME_ALIGN_TOP, x, y)
            :icon(opt.texture)
            :textAlign(TEXT_ALIGN_RIGHT)
            :fontSize(9)
            :onEvent(EVENT.Frame.Leave, function() FrameTooltips():show(false, 0) end)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                local r = evtData.triggerPlayer:worth()
                local tips = {
                    "资源名称: " .. n,
                    "资源总量: " .. math.format(r[k] or 0, 0),
                    "资源获得率: " .. math.format(evtData.triggerPlayer:worthRatio(), 2) .. "%",
                }
                local cov = Game():worthConvert(k)
                if (cov ~= nil) then
                    table.insert(tips, "经济体系: " .. "1" .. stage.resOpt[cov[1]].name .. "=" .. cov[2] .. n)
                end
                FrameTooltips()
                    :kit(kit)
                    :textAlign(TEXT_ALIGN_LEFT)
                    :fontSize(10)
                    :relation(FRAME_ALIGN_TOP, stage.worth[i], FRAME_ALIGN_BOTTOM, 0, -0.002)
                    :content({ tips = tips })
                    :show(true)
            end)
    end
    if (i18n.isEnable()) then
        Game():onEvent(EVENT.Game.Start, "I18N_DIALOG", function()
            stage.menu_i18nDialog = Dialog("LIK_TEC", i18n._langList, function(evtData)
                async.call(evtData.triggerPlayer, function()
                    i18n.lang(evtData.value)
                end)
            end)
            stage.menu_i18n = FrameButton(stage.menu:kit() .. "->i18n", stage.menu)
                :relation(FRAME_ALIGN_TOP, stage.menu, FRAME_ALIGN_TOP, 0.256, -0.004)
                :size(0.012, 0.014)
                :texture("icon/i18n")
                :onEvent(EVENT.Frame.LeftClick, function(evtData) stage.menu_i18nDialog:show(evtData.triggerPlayer) end)
        end)
    end
    stage.updateSkin = function()
        stage.menu:texture("bg/" .. PlayerLocal():skin())
    end
    stage.updateWelcome = function()
        stage.menu_mapName:text(colour.hex(colour.gold, Game():name()))
    end
    stage.updateName = function()
        stage.menu_player:text(PlayerLocal():name())
    end
    stage.updateInfo = function()
        stage.menu_info:text(table.concat(Game():infoCenter(), "|n"))
    end
    if (PlayerLocal():isPlaying()) then
        async.call(PlayerLocal(), function()
            stage.updateSkin()
            stage.updateWelcome()
            stage.updateName()
        end)
    end
    event.registerReaction(EVENT.Prop.Change, "lik_menu", function(evtData)
        if (evtData.triggerGame) then
            async.call(PlayerLocal(), function()
                if (i18n.isEnable() and evtData.key == "i18nLang") then
                    stage.updateWelcome()
                    stage.updateName()
                    stage.updateInfo()
                elseif (evtData.key == "infoCenter") then
                    stage.updateInfo()
                end
            end)
        elseif (evtData.triggerPlayer) then
            async.call(evtData.triggerPlayer, function()
                if (evtData.key == "skin") then
                    stage.updateSkin()
                elseif (evtData.key == "name") then
                    stage.updateWelcome()
                end
            end)
        end
    end)
    PlayersForeach(function(enumPlayer, _)
        event.register(enumPlayer, EVENT.Player.WorthChange, ui:kit(), function()
            local p = PlayerLocal()
            async.call(p, function()
                local r = p:worth()
                for i, k in ipairs(stage.resAllow) do
                    stage.worth[i]:text(colour.hex(stage.resOpt[k].color, math.floor(r[k] or 0)))
                end
            end)
        end)
    end)
end)