local long_pipes = {
	["se-space-pipe-long-j-3" ] = "",
	["se-space-pipe-long-j-5" ] = "",
	["se-space-pipe-long-j-7" ] = "",
	["se-space-pipe-long-s-9" ] = "",
	["se-space-pipe-long-s-15"] = "",
}

local recipe_infos = {}

local function is_space_pipe(type, name)
	return type == "item" and name == "se-space-pipe"
end

for name, localized_name in pairs(long_pipes) do
	table.insert(recipe_infos, {
		recipe_name = name,
		entity_type = "storage-tank", -- yes, not "pipe"
		technology_name = "se-space-platform-scaffold",
		no_percentage_test = is_space_pipe,
	})
end

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end
