local recipe_infos = {}

local long_pipes = {
	["se-space-pipe-long-j-3" ] = 3,
	["se-space-pipe-long-j-5" ] = 5,
	["se-space-pipe-long-j-7" ] = 7,
	["se-space-pipe-long-s-9" ] = 9,
	["se-space-pipe-long-s-15"] = 15,
}

local belt_colors = {
	"blue",
	"cyan",
	"green",
	"magenta",
	"red",
	"white",
	"yellow",
}

local transport_entities = {
	["underground-belt"] = "underground-belt",
	["transport-belt"]   = "transport-belt",
	["splitter"]         = "splitter",
}

local always_recover = {
	["se-space-pipe"] = true,
	["se-deep-space-underground-belt-black"] = true,
	["se-deep-space-transport-belt-black"] = true,
	["se-deep-space-transport-belt-loader-black"] = true,
	["se-deep-space-splitter-black"] = true,
}

local function is_base_entity(type, name)
	return type == "item" and always_recover[name] and true
end

for name, length in pairs(long_pipes) do
	table.insert(recipe_infos, {
		recipe_name = name,
		entity_type = "storage-tank", -- yes, not "pipe"
		technology_name = (se_recycling_extras.is_se6 and "se-space-pipe") or "se-space-platform-scaffold",
		to_icon = "se-space-pipe",
		no_percentage_test = is_base_entity,
	})
end

for _, color in pairs(belt_colors) do
	for name, type in pairs(transport_entities) do
		table.insert(recipe_infos, {
			recipe_name = "se-deep-space-".. name .."-".. color,
			entity_type = type,
			technology_name = "se-deep-space-transport-belt",
			to_icon = "se-deep-space-".. name .."-black",
			no_percentage_test = is_base_entity,
		})
	end
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end
