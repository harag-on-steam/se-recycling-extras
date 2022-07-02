local logistic_variants = {
	["storage-memory-unit"]          = "logistic-memory-storage",
	["passive-provider-memory-unit"] = "logistic-memory-storage",
	["requester-memory-unit"]        = "logistic-memory-storage",
	["active-provider-memory-unit"]  = "logistic-memory-storage",
	["buffer-memory-unit"]           = "logistic-memory-storage",
}

local recipe_infos = {}

local function is_memory_unit(type, name)
	return type == "item" and name == "memory-unit"
end

if is_mod_active("logistic-memory-units") then
	for name, tech_name in pairs(logistic_variants) do
		table.insert(recipe_infos, {
			recipe_name = name,
			entity_type = "logistic-container",
			technology_name = tech_name,
			to_icon = "memory-unit",
			no_percentage_test = is_memory_unit,
		})
	end
end

if is_mod_active("fluid-memory-storage") then
	table.insert(recipe_infos, {
		recipe_name = "fluid-memory-unit",
		entity_type = "container",
		entity_name = "fluid-memory-unit-container",
		technology_name = "fluid-memory-storage",
		to_icon = "memory-unit",
		no_percentage_test = is_memory_unit,
	})
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end