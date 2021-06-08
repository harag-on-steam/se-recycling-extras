local mod_active = (mods and mods["underground-pipe-pack"]) or (game and game.active_mods["underground-pipe-pack"])
if not mod_active then
	return function() end -- mod not enabled, do nothing
end

local variants = {
    "one-to-one-forward",
    "one-to-two-perpendicular",
    "one-to-three-forward",
    "one-to-four",
    "underground-i",
    "underground-L",
    "underground-t",
    "underground-cross",
}

local tiers = {
	{ suffix = "",       tech = "advanced-underground-piping"       },
    { suffix = "-t2",    tech = "advanced-underground-piping-t2"    },
    { suffix = "-t3",    tech = "advanced-underground-piping-t3"    },
	{ suffix = "-space", tech = "advanced-underground-piping-space" },
}

local pipe_component_set = {
	["pipe"] = true,
	["se-space-pipe"] = true,
	-- ["swivel-joint"] = true,
	-- ["small-pipe-coupler"] = true,
	-- ["medium-pipe-coupler"] = true,
	-- ["large-pipe-coupler"] = true,
	["space-pipe-coupler"] = true,
	["underground-pipe-segment-t1"] = true,
	["underground-pipe-segment-t2"] = true,
	["underground-pipe-segment-t3"] = true,
	["underground-pipe-segment-space"] = true,
}

local function is_pipe_component(type, name)
	return type == "item" and pipe_component_set[name]
end

local recipe_infos = {}

for _, tier_data in pairs(tiers) do
    for _, variant in pairs(variants) do
		local name = variant .. tier_data.suffix .. "-pipe"

		table.insert(recipe_infos, {
			recipe_name = name,
			entity_type = "pipe-to-ground",
			technology_name = tier_data.tech,
			no_percentage_test = is_pipe_component,
		})
    end
end

table.insert(recipe_infos, {
	recipe_name = "4-to-4-pipe",
	entity_type = "pipe",
	technology_name = "advanced-underground-piping",
	no_percentage_test = is_pipe_component,
})

return function(processor_function)
	for _, recipe_info in pairs(recipe_infos) do
		processor_function(recipe_info)
	end
end
