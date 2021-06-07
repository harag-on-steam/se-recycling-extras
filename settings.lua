data:extend({
    {
        type = "int-setting",
        name = "se-recycling-percentage",
        setting_type = "startup",
        minimum_value = 0,
        maximum_value = 100,
        default_value = 75,
        order = "a1",
    },
    {
        type = "string-setting",
        name = "se-recycling-rounding-mode",
        setting_type = "startup",
        default_value = "fraction",
        allowed_values = { "up", "down", "fraction" },
        order = "a1",
    },
})
