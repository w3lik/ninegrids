local kit = "ninegrids_msg"
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    if (false == isStaticClass("lik_echo", UIKitClass)) then
        stage.echo = Frame(kit .. "->echo", japi.FrameGetUnitMessage(), nil)
            :absolut(FRAME_ALIGN_LEFT_BOTTOM, 0.134, 0.144)
            :size(0, 0.36)
    end
    stage.chat = Frame(kit .. "->chat", japi.FrameGetChatMessage(), nil)
        :absolut(FRAME_ALIGN_BOTTOM, 0.03, 0.20)
        :size(0.22, 0.16)
    stage.alert = FrameText(kit .. "->alert", FrameGameUI)
        :relation(FRAME_ALIGN_BOTTOM, FrameGameUI, FRAME_ALIGN_BOTTOM, 0.008, 0.15)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(13)
    event.reactRegister(EVENT.Prop.Change, "ninegrids_msg", function(evtData)
        if (evtData.triggerPlayer) then
            if ((i18n.isEnable() and evtData.key == "i18nLang") or evtData.key == "alert") then
                async.call(evtData.triggerPlayer, function()
                    stage.alert:text(evtData.new)
                end)
            end
        end
    end)
end)