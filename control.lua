function is_mod_active(mod_name)
	return game and game.active_mods[mod_name] -- mod not enabled, do nothing
end

local recipes_providers = { -- an array of function(consumer_function(recipe_info))
	require("process-logistic-chests"),
	require("process-aai-containers"),
    require("process-space-pipes"),
    require("process-underground-pipe-pack"),
	require("process-intermediate-bulk-containers"),
	require("process-memory-storage"),
	require("process-krastorio2"),
}

local function sync_recipe_with_research(recipe_info)
	for _, force in pairs(game.forces) do
		local tech = force.technologies[recipe_info.technology_name]
		if tech and tech.researched then
			local recipe = force.recipes[recipe_info.recipe_name]
			if recipe then 
				recipe.enabled = true
			end
		end
	end
end

local function sync_recipes_with_research()
	for _, recipes in pairs(recipes_providers) do
		recipes(sync_recipe_with_research)
	end
end

local function on_init()
	sync_recipes_with_research()
end

local function on_configuration_changed(change)
    sync_recipes_with_research()
end

script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
