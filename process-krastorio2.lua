if not is_mod_active("Krastorio2") and not is_mod_active("K2_Turrets") then
	return function() end -- mod not enabled, do nothing
end

local recipe_infos = {
	{
		recipe_name = "kr-sentinel",
		entity_type = "radar",
		subgroup = se_recycling_extras.is_se6 and "recycling" or "space-recycling",
		-- K2_Turrets makes this available immediately
		technology_name = data.raw.technology["kr-sentinel"] and "kr-sentinel" or "se-recycling-facility",
		no_percentage_test = function() return false end,
	}
}

if data.raw.recipe["kr-medium-container"] then -- can be disabled via setting / not available with K2_Turrets
	local function is_base_container(type, name)
		return type == "item" and (name == "kr-medium-container" or name == "kr-big-container")
	end

	local logistic_variants = {
		["storage"]          = "kr-logistic-containers-1",
		["passive-provider"] = "kr-logistic-containers-1",
		["requester"]        = "kr-logistic-containers-2",
		["active-provider"]  = "kr-logistic-containers-2",
		["buffer"]           = "kr-logistic-containers-2",
	}

	for name, tech_name in pairs(logistic_variants) do
		for _, size in pairs({"kr-medium-", "kr-big-"}) do
			table.insert(recipe_infos, {
				recipe_name = size .. name .. "-container",
				entity_type = "logistic-container",
				technology_name = tech_name,
				to_icon = size .. "container",
				no_percentage_test = is_base_container,
			})
		end
	end
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end