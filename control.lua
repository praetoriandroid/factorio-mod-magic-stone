local lets_fun = false

local function find_random_free_position(surface, name, center)
    local radius = 40
    local max_tries = 100

    for _ = 1, max_tries do
        local pos = {
            x = center.x + math.random(-radius, radius),
            y = center.y + math.random(-radius, radius)
        }
        local valid = surface.can_place_entity { name = name, position = pos, force = "player" }
        if valid then
            return pos
        end
    end
    return nil
end

local function place_the_stone(player)
    local surface = player.surface
    local center = player.position

    local pos = find_random_free_position(surface, "magic_stone", center)
    if pos then
        surface.create_entity{name = "magic_stone", position = pos, force = "player"}
        game.print("Magic is at (" .. (pos.x - center.x) .. ", " .. (pos.y - center.y) .. ") from you!")
        target = pos
    else
        game.print("Failed to create the magic :(")
    end
end

local function trigger_random_effect(surface, position)
    local roll = math.random()

    if roll < 0.02 then
        -- 2% chance to create a poison cloud
        surface.create_entity{
            name = "poison-cloud",
            position = position,
        }
        return true
    elseif roll < 0.07 then
        -- 5% chance to spawn 2-5 of small bitters
        for _ = 1, math.random(2, 5) do
            surface.create_entity{
                name = "small-biter",
                position = {
                    position.x + (math.random() - 0.5) * 0.8,
                    position.y + (math.random() - 0.5) * 0.8
                },
                force = "enemy"
            }
        end
        return true
    end

    return false
end

local candidates = {}

local function pick_random_item()
    if #candidates == 0 then
        for name, proto in pairs(prototypes.item) do
            if not proto.hidden
                    and proto.localised_name
                    and proto.stack_size > 0
                    and (proto.type == "item" or proto.type == "ammo" or proto.type == "capsule")
                    and not proto.place_result then
                table.insert(candidates, name)
            end
        end

        -- Still nothing? That's strange...
        if #candidates == 0 then
            table.insert(candidates, "stone")
        end
    end

    return candidates[math.random(#candidates)]
end

script.on_init(function()
    lets_fun = true
end)

script.on_load(function()
    lets_fun = true
end)

script.on_event(defines.events.on_tick, function()
    local player = game.connected_players[1]
    if not player or not player.character then return end

    if lets_fun then
        lets_fun = false

        place_the_stone(player)
    end
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
    local entity = event.entity
    if not entity or not entity.valid or entity.name ~= "magic_stone" then return end

    local surface = entity.surface
    local position = entity.position

    -- Cancel the stone removal
    surface.create_entity {
        name = entity.name,
        position = position,
        force = entity.force
    }

    local player = game.get_player(event.player_index)

    if not trigger_random_effect(surface, position, force) then
        -- Drop item and try to pick it up
        local item_name = pick_random_item()
        local stack = { name = item_name, count = 1 }

        local inventory = player.get_main_inventory()
        if inventory and inventory.can_insert(stack) then
            player.insert(stack)

            player.create_local_flying_text {
                text = { "", "+1 ", { "item-name." .. item_name } },
                create_at_cursor = true
            }
        else
            player.surface.spill_item_stack {
                position = player.position,
                stack = stack,
                enable_looted = true,
                force = player.force
            }
        end

        surface.create_trivial_smoke {
            name = "smoke-fast",
            position = {
                position.x + (math.random() - 0.5) * 0.3,
                position.y + (math.random() - 0.5) * 0.3
            }
        }

        surface.create_trivial_smoke {
            name = "magic-spark",
            position = position
        }
    end
end)
