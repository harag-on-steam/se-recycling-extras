local logistic_variants = {
	["storage"]          = "logistic-robotics",
	["passive-provider"] = "logistic-robotics",
	["requester"]        = "logistic-system",
	["active-provider"]  = "logistic-system",
	["buffer"]           = "logistic-system",
}

local recipe_infos = {}

local function is_steel_chest(type, name)
	return type == "item" and name == "steel-chest"
end

for name, tech_name in pairs(logistic_variants) do
	table.insert(recipe_infos, {
		recipe_name = "logistic-chest-" .. name,
		entity_type = "logistic-container",
		technology_name = tech_name,
		to_icon = "steel-chest",
		no_percentage_test = is_steel_chest,
	})
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end