local kit = "ninegrids_cursor"
local ui = UIKit(kit)
ui:onSetup(function(this)
    this:stage().cursor = Cursor()
        :uiKit(kit)
        :sizeRate(20)
        :texture(
        {
            arrow = { width = 0.016, height = 0.016 * 68 / 46, alpha = 255, normal = "arrow\\normal", positive = "arrow\\focus", negative = "arrow\\attack" },
            aim = { width = 0.04, height = 0.04, alpha = 255, normal = "aim\\white", positive = "aim\\green", negative = "aim\\red", neutral = "aim\\gold" },
            drag = { width = 0.04, height = 0.04, alpha = 255, normal = "drag\\normal" },
            square = { alpha = 150, positive = "square\\white", negative = "square\\red" },
        })
end)