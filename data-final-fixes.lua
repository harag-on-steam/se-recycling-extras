require("globals")
require("data-functions")

local recipes_providers = { -- an array of function(consumer_function(recipe_info))
	require("process-deadlock-bridge"),
}

for _, recipes in pairs(recipes_providers) do
    recipes(create_recipe)
end
