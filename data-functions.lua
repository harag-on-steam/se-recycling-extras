local percentage = settings.startup["se-recycling-percentage"].value / 100.0
local rounding_mode = settings.startup["se-recycling-rounding-mode"].value

local function fractional(amount)
    amount = amount * percentage

    if amount < 1 and amount > 0 then
        return { amount = 1, probability = amount }
    end

    local min = math.floor(amount)
    if min == amount then
        return { amount = amount }
    end

    return { amount_min = min, amount_max = math.ceil(amount) }
end

local function round_up(amount)
    return { amount = math.ceil(amount * percentage) }
end

local function round_down(amount)
    amount = math.floor(amount * percentage)
    return amount > 0 and { amount = amount } or nil
end

local apply_percentage = ("up" == rounding_mode and round_up) or ("down" == rounding_mode and round_down) or fractional

local function shift(icon_source, x, y)
    if not icon_source.shift then
        return {x, y}
    end

    local idx, ox, oy
    idx, ox = next(icon_source.shift)
    idx, oy = next(icon_source.shift, idx)

    return {ox + x, oy + y}
end

local function shift_bottom_left(icon_source)
    return shift(icon_source, -8,  8)
end

local function shift_top_right(icon_source)
    return shift(icon_source,  8, -8)
end

local function scale_third(icon_source, item)
    -- return (icon_source.scale or 1) * 0.33 * 64 / (icon_source.icon_size or item.icon_size)
    return 0.33 * 64 / (icon_source.icon_size or item.icon_size)
end

local function transition_icons(icon_from, icon_to)
    local icons = {
        { icon = "__space-exploration-graphics__/graphics/blank.png", scale = 0.5, shift = { 0, 0 }, icon_size = 64 }, -- to lock scale
    }

    if icon_from.icon then
        table.insert(icons, { icon = icon_from.icon, scale = scale_third(icon_from), shift = shift_top_right(icon_from), icon_size = icon_from.icon_size })
    end

    if icon_from.icons then
        for _, icon in pairs(icon_from.icons) do
            if string.match(icon.icon, "/number/") then -- keep the size-number from SE items in the top-left
                table.insert(icons, util.table.deepcopy(icon))
            else
                table.insert(icons, { icon = icon.icon, scale = scale_third(icon, icon_from), shift = shift_top_right(icon), icon_size = (icon.icon_size or icon_from.icon_size), tint = icon.tint })
            end
        end
    end

    if icon_to.icon then
        table.insert(icons, { icon = icon_to.icon, scale = scale_third(icon_to), shift = shift_bottom_left(icon_to), icon_size = icon_to.icon_size })
    end

    if icon_to.icons then
        for _, icon in pairs(icon_to.icons) do
            if not string.match(icon.icon, "/number/") then -- SE size-number already copied from source item
                table.insert(icons, { icon = icon.icon, scale = scale_third(icon, icon_to), shift = shift_bottom_left(icon), icon_size = (icon.icon_size or icon_to.icon_size), tint = icon.tint })
            end
        end
    end

    table.insert(icons, { icon = "__space-exploration-graphics__/graphics/icons/transition-arrow.png", scale = 0.5, shift = { 0, 0 }, icon_size = 64 })
    return icons
end

local function copy_icon(source, target, recipe_info)
    if not source or (not source.icon and not source.icons) then
        return false
    end

    local result_item = (recipe_info.to_icon and data.raw.item[recipe_info.to_icon]) or data.raw.item["se-scrap"]

    target.icons = transition_icons(source, result_item)

    return true

    -- target.icon = source.icon
    -- target.icons = source.icons
    -- target.icon_size = source.icon_size
    -- target.icon_mipmaps = source.icon_mipmaps
end

local function recycling_result(ingredients, no_percentage_test)
    local results = {}

    no_percentage_test = no_percentage_test or function() return false end

    for _, ingredient in pairs(ingredients) do
        local type = nil
        local name
        local amount
        local idx

        if not ingredient.name then
            -- { [1] = "name", [2] = 123 } -> { name = "name", amount = 123 }
            type = "item"
            idx, name = next(ingredient)
            idx, amount = next(ingredient, idx)
            if not amount then
                amount = 1
            end
        else
            type = ingredient.type or "item"
            name = ingredient.name
            amount = ingredient.amount or 1
        end

        if not (type == "fluid") then
            local result = no_percentage_test(type, name) and { amount = amount } or apply_percentage(amount)

            if result then
                result.type = "item"
                result.name = name
                table.insert(results, result)
            end
        end
    end

    return results
end

function create_recipe(recipe_info)
    local recipe = data.raw.recipe[recipe_info.recipe_name]
    if not recipe then return end -- mods like Deadlock Stacking have settings to disable some entities

    local entity = data.raw[recipe_info.entity_type][recipe_info.entity_name or recipe_info.recipe_name] or error("no entity for "..recipe_info.recipe_name)
    local item = data.raw.item[recipe_info.item_name or recipe_info.recipe_name] or error("no item for "..recipe_info.recipe_name)
    local tech = data.raw.technology[recipe_info.technology_name] or error("no tech for "..recipe_info.recipe_name)

    local recycling_recipe = {
        type = "recipe",
        name = "se-recycle-" .. item.name,
        localised_name = recipe_info.localised_name or { "recipe-name.se-generic-recycling", entity.localised_name or { "entity-name."..entity.name} },
        order = recipe_info.order or recipe.order or item.order or entity.order,
        category = "hard-recycling",
        subgroup = recipe_info.subgroup or recipe.subgroup or item.subgroup or "space-recycling",
        ingredients = {{ name = item.name, amount = recipe.result_count or 1 }}, -- assume single result in original recipe
        results = recycling_result(recipe.ingredients, recipe_info.no_percentage_test),
        enabled = false,
        energy_required = recipe.energy_required or recipe_info.energy_required or 1,
        requester_paste_multiplier = 1,
        overload_multiplier = 1,
        hide_from_stats = true,
        hide_from_player_crafting = true,
        allow_decomposition = false,
        allow_as_intermediate = false,
        -- always_show_made_in = true,
        show_details_in_recipe_tooltip = false,
        show_amount_in_title = false,
        always_show_products = true,
        unlock_results = false,
    }

    local _ = copy_icon(recipe_info, recycling_recipe, recipe_info) or
        copy_icon(recipe, recycling_recipe, recipe_info) or
        copy_icon(item, recycling_recipe, recipe_info)

    data:extend({ recycling_recipe })

    table.insert(tech.effects, { type = "unlock-recipe", recipe = recycling_recipe.name })
end
