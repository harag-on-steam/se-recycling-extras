if not is_mod_active("Deadlock-SE-bridge") then
	return function() end -- mod not enabled, do nothing
end

local recipe_infos = {}

local belt_colors = {
	"blue",
	"cyan",
	"green",
	"magenta",
	"red",
	"white",
	"yellow",
}

local function is_base_entity(type, name)
	return type == "item" and name == "se-deep-space-transport-belt-loader-black" and true
end

for _, color in pairs(belt_colors) do
	table.insert(recipe_infos, {
		recipe_name = "se-deep-space-transport-belt-loader-".. color,
		entity_type = "loader-1x1",
		technology_name = "se-deep-space-transport-belt",
		to_icon = "se-deep-space-transport-belt-loader-black",
		no_percentage_test = is_base_entity,
	})
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end
