data:extend({
    {
        type = "simple-entity",
        name = "magic_stone",
        icon = "__magic_stone__/graphics/icons/magic_stone.png",
        icon_size = 64,
        flags = { "placeable-neutral" },
        selectable_in_game = true,
        minable = { mining_time = 1.3 },
        max_health = 100,
        collision_box = { { -0.8, -0.5 }, { 0.8, 1.2 } },
        selection_box = { { -0.9, -0.7 }, { 0.9, 1.3 } },

        animations = {
            layers = {
                {
                    filename = "__magic_stone__/graphics/entity/magic_stone.png",
                    width = 128,
                    height = 128,
                    frame_count = 12,
                    line_length = 4,
                    animation_speed = 0.1,
                    shift = { 0, 0 },
                    scale = 0.7,
                },
                {
                    filename = "__magic_stone__/graphics/entity/magic_stone_shadow.png",
                    width = 36,
                    height = 36,
                    frame_count = 12,
                    line_length = 4,
                    animation_speed = 0.1,
                    draw_as_shadow = true,
                    shift = { 1.2, 0.65 },
                    scale = 0.7,
                }
            }
        },

        working_sound = {
            sound = { filename = "__magic_stone__/sound/magic_stone.ogg", volume = 0.45, audible_distance_modifier = 0.5 },
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
    },
    {
        type = "trivial-smoke",
        name = "magic-spark",
        duration = 60,
        fade_away_duration = 40,
        color = {r = 1.0, g = 0.3, b = 1.0},
        cyclic = true,
        animation = {
            filename = "__magic_stone__/graphics/entity/magic_spark.png",
            width = 128,
            height = 128,
            frame_count = 6,
            line_length = 2,
            animation_speed = 1.2,
            scale = 0.4,
            shift = { 0, -0.5 },
            blend_mode = "additive"
        },
        affected_by_wind = false
    }
})
