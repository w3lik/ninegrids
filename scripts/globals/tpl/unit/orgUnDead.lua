TPL_UNIT.Skeleton = UnitTpl("Skeleton")
    :name("骷髅兵")
    :icon("unit/SkeletonWarrior")
    :modelAlias("Skeleton")
    :modelScale(1)
    :scale(1)
    :weaponSound("metal_slice_medium")
    :mp(0)
    :move(220)
    :attackRange(100)
TPL_UNIT.SkeletonArcher = UnitTpl("SkeletonArcher")
    :name("骷髅弓箭手")
    :icon("unit/SkeletonArcher")
    :modelAlias("SkeletonArcher")
    :modelScale(1)
    :scale(1)
    :attackMode(AttackMode():mode("missile"):missileModel("ArrowMissile"):speed(1000):height(10))
    :mp(0)
    :move(180)
    :attackRange(400)
TPL_UNIT.SkeletonMage = UnitTpl("Necromancer")
    :name("骷髅魔法师")
    :icon("unit/SkeletonMage")
    :modelAlias("SkeletonMage")
    :modelScale(1)
    :scale(1)
    :attackMode(AttackMode():mode("missile"):homing(true):missileModel("SkeletalMageMissile"):speed(800):height(0):damageType(DAMAGE_TYPE.dark))
    :mp(0)
    :move(160)
    :attackRange(250)
TPL_UNIT.SkeletalOrc = UnitTpl("Skeleton")
    :name("骷髅兵")
    :icon("unit/SkeletalOrc")
    :modelAlias("GruntSkeleton")
    :modelScale(1)
    :scale(1.2)
    :weaponSound("metal_chop_heavy")
    :mp(0)
    :move(200)
    :attackRange(110)
TPL_UNIT.Zombie = UnitTpl("Zombie")
    :name("僵尸")
    :modelAlias("Zombie")
    :modelScale(1)
    :scale(1.0)
    :material(UNIT_MATERIAL.flesh)
    :itemSlot(false)
    :move(150)
    :weaponSound("wood_bash_medium")
    :attackRange(100)
    :attackSpaceBase(2)
    :attackMode(AttackMode():mode("common"):damageType(DAMAGE_TYPE.dark))
TPL_UNIT.Ghoul = UnitTpl("Ghoul")
    :name("食尸鬼")
    :modelAlias("Ghoul")
    :modelScale(1.0)
    :scale(1.0)
    :itemSlot(false)
    :mp(0)
    :move(310)
    :weaponSound("wood_bash_medium")
    :attackSpaceBase(1.3)
    :attackRange(100)
TPL_UNIT.Imp = UnitTpl("Ghoul")
    :name("堕尸鬼")
    :modelAlias("unit/Imp")
    :modelScale(1.0)
    :scale(1.0)
    :itemSlot(false)
    :mp(0)
    :move(320)
    :weaponSound("wood_bash_medium")
    :attackSpaceBase(1.2)
    :attackRange(110)
TPL_UNIT.SpikySpriteWhite = UnitTpl("Ghoul")
    :name("稻草鬼")
    :modelAlias("unit/SpikySpriteWhite")
    :modelScale(1.0)
    :scale(1.1)
    :itemSlot(false)
    :mp(0)
    :move(320)
    :weaponSound("wood_bash_light")
    :attackSpaceBase(1.4)
    :attackRange(120)
TPL_UNIT.Abomination = UnitTpl("Abomination")
    :name("恶鬼")
    :modelAlias("Abomination")
    :modelScale(1.0)
    :scale(1.3)
    :itemSlot(false)
    :mp(0)
    :move(270)
    :weaponSound("wood_bash_heavy")
    :attackSpaceBase(1.8)
    :attackRange(120)
TPL_UNIT.CryptFiend = UnitTpl("CryptFiend")
    :name("恶魔蜘蛛")
    :modelAlias("CryptFiend")
    :modelScale(1.1)
    :scale(1.6)
    :itemSlot(false)
    :mp(0)
    :move(240)
    :attackSpaceBase(1.8)
    :attackMode(
    AttackMode()
        :mode("missile"):missileModel("CryptFiendMissile")
        :homing(true)
        :speed(800):height(20))
    :attackRange(300)
TPL_UNIT.Ysera_MortalEN = UnitTpl("CryptFiend")
    :name("恶魔女")
    :modelAlias("unit/Ysera_MortalEN")
    :modelScale(1.0)
    :scale(1.2)
    :itemSlot(false)
    :mp(0)
    :move(260)
    :attackSpaceBase(1.6)
    :attackRange(400)
    :attackMode(
    AttackMode()
        :mode("missile"):missileModel("ShadowStrikeMissile")
        :homing(true)
        :speed(800):height(20))
TPL_UNIT.Lasher_Nightmare = UnitTpl()
    :name("堕夜魔花")
    :modelAlias("unit/Lasher_Nightmare")
    :modelScale(1.0)
    :scale(1.3)
    :itemSlot(false)
    :mp(0)
    :move(0)
    :attackSpaceBase(2)
    :attackRange(600)
    :attackMode(
    AttackMode()
        :mode("missile"):missileModel("SerpentWardMissile")
        :speed(1000):height(100):damageType(DAMAGE_TYPE.fire))
TPL_UNIT.Lasher_Nightmare2 = UnitTpl()
    :name("堕夜魔草")
    :modelAlias("unit/Nightmare")
    :modelScale(1.0)
    :scale(1.3)
    :itemSlot(false)
    :mp(0)
    :move(0)
    :attackSpaceBase(2)
    :attackRange(600)
    :attackMode(
    AttackMode()
        :mode("missile"):missileModel("SerpentWardMissile")
        :speed(1000):height(100):damageType(DAMAGE_TYPE.grass))
TPL_UNIT.NightmareSpiderBoss = UnitTpl("Nerubian")
    :name("堕夜魔希蛛")
    :modelAlias("unit/NightmareSpiderBoss")
    :modelScale(1.0)
    :scale(1.3)
    :itemSlot(false)
    :mp(0)
    :move(250)
    :weaponSound("wood_bash_heavy")
    :attackSpaceBase(1.7)
    :attackRange(110)
TPL_UNIT.Nightmare_Spider = UnitTpl("Nerubian")
    :name("堕夜魔狼蛛")
    :modelAlias("unit/Nightmare_Spider")
    :modelScale(1.0)
    :scale(1.3)
    :itemSlot(false)
    :mp(0)
    :move(240)
    :weaponSound("wood_bash_medium")
    :attackSpaceBase(1.8)
    :attackRange(100)
    :attackMode(AttackMode():mode("common"):damageType(DAMAGE_TYPE.poison))
