-- ============================================================================
-- HUMAN-CREATED SOFTWARE
-- Human-authored. Original work. Not AI-generated.
-- AI training, fine-tuning, dataset creation, and model evaluation prohibited.
-- See LICENSE for complete terms.
-- ============================================================================

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")

data:extend{
  {
		type = "furnace",
		name = "meltdown-facility",
		icon = "__meltdown-facility__/graphics/icons/arc-furnace.png",
		icon_size = 64,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.2, result = "meltdown-facility"},
		fast_replaceable_group = "meltdown-facility",
		circuit_wire_max_distance = furnace_circuit_wire_max_distance,
		circuit_connector = circuit_connector_definitions["steel-furnace"],
		max_health = 1000,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		impact_category = "metal",
		open_sound = sounds.metal_large_open,
		close_sound = sounds.metal_large_close,
		working_sound = {
			sound = {
				filename = "__base__/sound/steel-furnace.ogg",
				volume = 0.7,
				advanced_volume_control = {attenuation = "exponential"},
				audible_distance_modifier = 0.9,
				speed = 0.5,
			},
			max_sounds_per_prototype = 2,
			fade_in_ticks = 8,
			fade_out_ticks = 40,
		},
		resistances = {
			{
				type = "fire",
				percent = 100,
			},
		},
		collision_box = {{-2.1, -2.1}, {2.1, 2.1}},
		selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
		damaged_trigger_effect = hit_effects.entity(),
		crafting_categories = {"meltdown"},
		energy_usage = "3MW",
		heating_energy = feature_flags.freezing and "300kW" or nil,
		crafting_speed = 1,
		source_inventory_size = 1,
		result_inventory_size = 12,
    module_slots = 2,
    allowed_effects = {"consumption", "pollution", "speed"},
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = {pollution = 30},
		},
		graphics_set = {
			always_draw_idle_animation = true,
			idle_animation = {
				layers = {
					{
						filename = "__meltdown-facility__/graphics/entity/arc-furnace-hr-shadow.png",
						size = {600, 400},
						shift = {0, 0},
						scale = 0.5,
						line_length = 1,
						frame_count = 1,
						repeat_count = 50,
						draw_as_shadow = true,
						animation_speed = 0.25,
					},
					{
						filename = "__meltdown-facility__/graphics/entity/arc-furnace-hr-animation-1.png",
						size = {320, 320},
						shift = {0, 0},
						scale = 0.5,
						line_length = 8,
						lines_per_file = 8,
						frame_count = 50,
						animation_speed = 0.25,
					},
				},
			},
			working_visualisations = {
				{
					fadeout = true,
					secondary_draw_order = 1,
					animation = {
						layers = {
							{
								filename = "__meltdown-facility__/graphics/entity/arc-furnace-hr-emission-1.png",
								size = {320, 320},
								shift = {0, 0},
								scale = 0.5,
								line_length = 8,
								lines_per_file = 8,
								frame_count = 40,
								draw_as_glow = true,
								blend_mode = "additive",
								animation_speed = 0.25,
							},
						},
					},
				},
			},
		},
	},
  {
		type = "item",
		name = "meltdown-facility",
		icon = "__meltdown-facility__/graphics/icons/arc-furnace.png",
		icon_size = 64,
		subgroup = "meltdown-facility",
		order = "a[meltdown-facility]",
		place_result = "meltdown-facility",
		stack_size = 20,
		inventory_move_sound = item_sounds.metal_small_inventory_move,
		pick_sound = item_sounds.metal_small_inventory_pickup,
		drop_sound = item_sounds.metal_small_inventory_move,
  },
  {
		type = "recipe",
		name = "meltdown-facility",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 30},
			{type = "item", name = "electronic-circuit", amount = 10},
			{type = "item", name = "stone-brick", amount = 20},
		},
		results = {{type = "item", name = "meltdown-facility", amount = 1}},
		energy_required = 2,
		enabled = true,
    subgroup = "meltdown-facility",
    order = "e-a[meltdown]"
  },
  {
    type = "item-group",
    name = "meltdown-facility",
		icon = "__meltdown-facility__/graphics/icons/arc-furnace.png",
    order = "f-[meltdown-facility]"
  },
  {
    type = "recipe-category",
    name = "meltdown"
  },
	{
    type = "item-subgroup",
		name = "meltdown-facility",
		group = "production",
		order = "e-a[meltdown-facility]",
  },
	{
    type = "item-subgroup",
		name = "meltdown",
		group = "meltdown-facility",
  },
}
