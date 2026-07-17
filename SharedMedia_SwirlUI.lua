local LSM = LibStub("LibSharedMedia-3.0")

local BACKGROUND = LSM.MediaType.BACKGROUND
local BORDER = LSM.MediaType.BORDER
local FONT = LSM.MediaType.FONT
local SOUND = LSM.MediaType.SOUND
local STATUSBAR = LSM.MediaType.STATUSBAR

-- -----
-- BACKGROUND
-- -----
LSM:Register(BACKGROUND, 'DPS', [[Interface\Addons\SharedMedia_SwirlUI\background\DPS.tga]])
LSM:Register(BACKGROUND, 'Healer', [[Interface\Addons\SharedMedia_SwirlUI\background\Healer.tga]])
LSM:Register(BACKGROUND, 'logo', [[Interface\Addons\SharedMedia_SwirlUI\background\logo.tga]])
LSM:Register(BACKGROUND, 'spec_icons_bad', [[Interface\Addons\SharedMedia_SwirlUI\background\spec_icons_bad.tga]])
LSM:Register(BACKGROUND, 'Tank', [[Interface\Addons\SharedMedia_SwirlUI\background\Tank.tga]])

-- -----
--  BORDER
-- ----

-- -----
--   FONT
-- -----
LSM:Register(FONT, 'Swirl', [[Interface\Addons\SharedMedia_SwirlUI\font\Swirl.ttf]])

-- -----
--   SOUND
-- -----
LSM:Register(SOUND, '|cff00ff96Bloodlust |T136012:16|t|r', [[Interface\Addons\SharedMedia_SwirlUI\sound\Bloodlust.mp3]])
LSM:Register(SOUND, '|cff00ff96Whisper |T134225:16|t|r', [[Interface\Addons\SharedMedia_SwirlUI\media\Whisper.ogg]])

-- -----
--   STATUSBAR
-- -----
