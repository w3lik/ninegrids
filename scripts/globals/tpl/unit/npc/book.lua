TPL_UNIT.NPC_Book = UnitTpl()
    :name("一本书")
    :modelAlias("BookOfSummoning")
    :icon("unit/BookOfSummoning")
    :modelScale(1.2)
    :scale(1.3)
    :itemSlot(false)
    :superposition("noAttack", 1)
    :superposition("invulnerable", 1)
    :hp(1)
    :mp(1)
    :move(0)
    :balloon(
    {
        z = 240,
        interval = 0.01,
        message = {
            { tips = { "我是一本书", "可以教导你一些这个世界的规则", "首先是点击这个气泡“对话”，可查看更多信息" } },
            { tips = { "靠近可以对话的事物，有可能存在互动", "会提示" .. colour.hex(colour.gold, "按下H键") .. "，可触发互动，得到功能提示" } },
            { tips = { "世界将在关键点进行灵泠记录", "当右上角圈圈转动时，则是记录中", colour.hex(colour.indianred, "未记录完毕请勿随便退出") } },
            { tips = { "死亡后探索进度将会清空，从小岛复活", "但已获得的部分刻在灵泠深处的记忆不会消失", } },
            { tips = { "右侧可查看你的成就、英泠、泠器等信息", "最下方有个背包，里面存放临时材料", } },
            {
                tips = function()
                    local txt
                    if (Game():achievement(7)) then
                        txt = { "有新的内容会再补充告诉你~" }
                    else
                        txt = {
                            "好啦，你清楚明白了吗？",
                            Game():balloonKeyboardTips("清楚明白")
                        }
                    end
                    return txt
                end,
                call = function()
                    Game():achievement(7, true)
                end
            },
        },
    })