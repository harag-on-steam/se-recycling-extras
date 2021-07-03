if not is_mod_active("Krastorio2") then
	return function() end -- mod not enabled, do nothing
end

local previous_tier_items = {
	["radar"]      = true,
	["substation"] = true,
}

local function is_previous_tier(type, name)
	return type == "item" and previous_tier_items[name]
end

local recipe_infos = {}

if data.raw.recipe["kr-advanced-radar"] then -- has a startup setting
	table.insert(recipe_infos, {
		recipe_name = "kr-advanced-radar",
		entity_type = "radar",
		entity_name = "advanced-radar",
		item_name = "advanced-radar",
		subgroup = "space-recycling",
		technology_name = "advanced-radar",
		no_percentage_test = is_previous_tier,
	})
end

if data.raw.recipe["kr-substation-mk2"] then -- has a startup setting
	table.insert(recipe_infos, {
		recipe_name = "kr-substation-mk2",
		entity_type = "electric-pole",
		subgroup = "space-recycling",
		technology_name = "electric-energy-distribution-3",
		no_percentage_test = is_previous_tier,
	})
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end