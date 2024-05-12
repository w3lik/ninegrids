local kit = "ninegrids_msg"
local ui = UIKit(kit)
ui:onSetup(function(this)
    local stage = this:stage()
    if (false == isStaticClass("lik_echo", UIKitClass)) then
        stage.echo = Frame(kit .. "->echo", japi.DZ_FrameGetUnitMessage(), nil)
            :absolut(FRAME_ALIGN_LEFT_BOTTOM, 0.1, 0.25)
            :size(0, 0.36)
    end
    
    stage.worldMessage = Frame(kit .. "->worldMessage", japi.DZ_FrameGetWorldFrameMessage(), nil)
        :absolut(FRAME_ALIGN_LEFT_BOTTOM, 0.31, 0.17)
    
    stage.chat = Frame(kit .. "->chat", japi.DZ_FrameGetChatMessage(), nil)
        :absolut(FRAME_ALIGN_BOTTOM, 0.03, 0.20)
        :size(0.22, 0.16)
end)