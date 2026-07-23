-- ============================================================================
-- HUMAN-CREATED SOFTWARE
-- Human-authored. Original work. Not AI-generated.
-- AI training, fine-tuning, dataset creation, and model evaluation prohibited.
-- See LICENSE for complete terms.
-- ============================================================================

local MELTDOWN_FACTOR = 1 / 8

local function convert_product_to_result(name, value)
	local floor_amount = math.floor(value)
	local fraction = value - floor_amount

	return {
		type = "item",
		name = name,
		amount = floor_amount,
		extra_count_fraction = fraction > 0 and fraction or nil,
    quality_min = "normal",
    quality_max = "normal"
	}
end

local function get_non_self_recycling_products(item_name)
	local recycle_name = item_name .. "-recycling"
	local recipe = data.raw.recipe[recycle_name]
	if not recipe then
		return nil, false
	end

	local values = {}
	local has_nontrivial = false

	for _, product in pairs(recipe.results) do
		if product.type == "item" then
			local value = ((product.amount and math.floor(product.amount) or (product.amount_min + product.amount_max) / 2) + (product.extra_count_fraction or 0)) * (product.probability or 1)

			local is_ingredient = false
			for _, ingredient in pairs(recipe.ingredients) do
				if ingredient.type == "item" and ingredient.name == product.name then
					is_ingredient = true
					break
				end
			end

			if not is_ingredient then
				has_nontrivial = true
			end
			values[product.name] = (values[product.name] or 0) + value
		end
	end

	return (has_nontrivial and values or nil)
end

local function compute_meltdown_values(item_name)
	local final_values = {}
	local to_process = {{name = item_name, value = 1, seen_items = {[item_name] = true}}}

	while #to_process > 0 do
		local new_working = {}

		for _, current in ipairs(to_process) do
			local current_name = current.name
			local current_value = current.value
			local seen_items = current.seen_items

			local recycling_products = get_non_self_recycling_products(current_name)
			if recycling_products then
				for name, value in pairs(recycling_products) do
					if not seen_items[name] then
						local new_seen = {}
						for k in pairs(seen_items) do
							new_seen[k] = true
						end
						new_seen[name] = true

						new_working[#new_working+1] = {
							name = name,
							value = value * current_value * 4,
							seen_items = new_seen,
						}
					else
						final_values[name] = (final_values[name] or 0) + value * current_value * 4 * MELTDOWN_FACTOR
					end
				end
			else
				final_values[current_name] = (final_values[current_name] or 0) + current_value * MELTDOWN_FACTOR
			end
		end

		to_process = new_working
	end

	return final_values
end

for type in pairs(defines.prototypes.item) do
  for _, item in pairs(data.raw[type] or {}) do
    ---@cast item data.ItemPrototype
    local icons = item.icons and table.deepcopy(item.icons) or {{icon = item.icon, icon_size = item.icon_size}}
    icons[#icons+1] = {
      icon = "__downgrade-port__/graphics/icons/porting.png",
      icon_size = 40,
      scale = 0.35,
      shift = {8.5, 8.5}
    }
    local product_values = compute_meltdown_values(item.name)
    local products = {}

    for product_name, value in pairs(product_values) do
      products[#products+1] = convert_product_to_result(product_name, value)
    end

    data:extend{{
      type = "recipe",
      name = item.name .. "-meltdown",
      localised_name = {
        "recipe-name.meltdown",
        {
          "?",
          item.localised_name or {"item-name." .. item.name},
          item.place_result and {"entity-name." .. item.place_result} or {"unknown-string.17"},
          item.place_as_equipment_result and {"equipment-name." .. item.place_as_equipment_result} or {"unknown-string.17"},
          item.place_as_tile and data.raw.tile[item.place_as_tile.result].localised_name or {"tile-name." .. item.name}
        },
      },
      icon = item.icon,
      icon_size = item.icon_size,
      icons = item.icons,
      hidden = item.hidden and true or false,
      -- hidden_in_factoriopedia = true,
      hide_from_player_crafting = true,
      hide_from_signal_gui = true,
      categories = {"meltdown"},
      subgroup = "meltdown",
      order = "e-a[meltdown]-" .. item.name,
      energy_required = 1.2,
      ingredients = {{type = "item", name = item.name, amount = 1}},
      results = products,
      enabled = true,
      auto_recycle = false,
      unlock_results = false,
    }}
  end
end
