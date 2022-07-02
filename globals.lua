function is_mod_active(mod_name)
    return ((mods and mods[mod_name]) or (game and game.active_mods[mod_name]))
end

local se_version = is_mod_active("space-exploration")
local k2_version = is_mod_active("Krastorio2")

se_recycling_extras = se_recycling_extras or {}

se_recycling_extras.is_se = se_version and true
se_recycling_extras.is_se6 = se_version and not string.find(se_version, "^0%.5%.")

se_recycling_extras.is_k2 = k2_version and true
se_recycling_extras.is_k2_12 = k2_version and not string.find(k2_version, "^1%.1%.")
se_recycling_extras.is_k2_13 = se_recycling_extras.is_k2_12 and not string.find(k2_version, "^1%.2%.")
