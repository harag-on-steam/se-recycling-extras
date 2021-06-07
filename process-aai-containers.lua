if (mods and not mods["aai-containers"]) or (game and not game.active_mods["aai-containers"]) then
	return function() end -- do nothing
end

local logistic_variants = {
	["storage"]          = "storage",
	["passive-provider"] = "storage",
	["requester"]        = "logistic",
	["active-provider"]  = "logistic",
	["buffer"]           = "logistic",
}

local sizes = {
	[2] = "strongbox",
	[4] = "storehouse",
	[6] = "warehouse",
}

local recipe_infos = {}

for size, name in pairs(sizes) do
	local base_name = "aai-" .. name
	local recipe_info = {
		recipe_name = base_name,
		entity_type = "container",
		technology_name = base_name .. "-base",
		no_percentage_test = function() return false end,
	}
	table.insert(recipe_infos, recipe_info)

	for logistic_variant, tech_suffix in pairs(logistic_variants) do
		local logistic_name = base_name .. "-" .. logistic_variant
		recipe_info = {
			recipe_name = logistic_name,
			entity_type = "logistic-container",
			technology_name = base_name .. "-" .. tech_suffix,
			no_percentage_test = function(type, name) return type == "item" and name == base_name end,
		}
		table.insert(recipe_infos, recipe_info)
	end
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end