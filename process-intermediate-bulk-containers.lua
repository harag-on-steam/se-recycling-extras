if not is_mod_active("intermediate-bulk-containers") then
	return function() end -- mod not enabled, do nothing
end

local no_percentage = {
	["empty-barrel"] = true,
	["pipe"] = true,
	["steel-plate"] = true,
-- the soft stuff should probably not be 100%
--	["plastic"] = true,
--	["wood"] = true,
}

local function is_metal_ingredient(type, name)
	return type == "item" and no_percentage[name]
end

local recipe_infos = {
	{
		recipe_name = "empty-pallet",
		localised_name = { "recipe-name.se-generic-recycling", { "item-name.empty-pallet"} },
		entity_type = "item",
		technology_name = "pallet-barrels",
		no_percentage_test = is_metal_ingredient,
	},
	{
		recipe_name = "empty-ibc",
		localised_name = { "recipe-name.se-generic-recycling", { "item-name.empty-ibc"} },
		entity_type = "item",
		technology_name = "ibc-totes",
		no_percentage_test = is_metal_ingredient,
	},
	{
		recipe_name = "empty-tank",
		localised_name = { "recipe-name.se-generic-recycling", { "item-name.empty-tank"} },
		entity_type = "item",
		technology_name = "ibc-tanks",
		no_percentage_test = is_metal_ingredient,
	},
}

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end
