require("globals")
require("data-functions")

local recipes_providers = { -- an array of function(consumer_function(recipe_info))
    require("process-logistic-chests"),
    require("process-aai-containers"),
    require("process-space-pipes"),
    require("process-underground-pipe-pack"),
	require("process-intermediate-bulk-containers"),
	require("process-memory-storage"),
	require("process-krastorio2"),
}

for _, recipes in pairs(recipes_providers) do
    recipes(create_recipe)
end
