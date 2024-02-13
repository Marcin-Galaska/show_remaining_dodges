-- Show Remaining Dodges mod by mroużon. Ver. 1.0.0
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("show_remaining_dodges")

-- ##################################################
-- Mod variables
-- ##################################################

local hud_element_script = "show_remaining_dodges/scripts/mods/show_remaining_dodges/hud/hud_element_dodging"
local hud_element_class = "HudElementDodging"

local dodges_hud_element = {
    filename = hud_element_script,
    class_name = hud_element_class,
    visibility_groups = {
        "alive",
        "tactical_overlay",
        "in_view"
    }
}

mod._dodging = false                                            -- Whether the player is between entering and exiting the dodge state
mod._waiting_for_dodge_effectiveness_reset = false              -- Whether the player is between finishing a dodge and resetting mod._effective_dodges_left
mod._draw_widget = false                                        -- Whether the widget should be visible
mod._effective_dodges = 0                                       -- Max number of effective dodges with drawn weapon
mod._effective_dodges_left = 0                                  -- Number of dodges with given weapon left before they get ineffective (can get negative)
mod._consecutive_dodges_cooldown = 0.0                          -- In-game time at which mod._effective_dodges_left will reset back to mod._effective_dodges
mod._unified_t = 0.0                                            -- In-game time unified between show_remaining_dodges.lua and hud_element_dodging.lua
mod._unit = nil                                                 -- Player unit

mod._remaining_dodges_widget_fade_inout_speed = mod:get("remaining_dodges_widget_fade_inout_speed")
mod._remaining_dodges_widget_horizontal_offset = mod:get("remaining_dodges_widget_horizontal_offset")
mod._remaining_dodges_widget_vertical_offset = -1 * mod:get("remaining_dodges_widget_vertical_offset")
mod._remaining_dodges_widget_bar_appearance = {
    255,
    mod:get("remaining_dodges_widget_bar_R"),
    mod:get("remaining_dodges_widget_bar_G"),
    mod:get("remaining_dodges_widget_bar_B")
}
mod._remaining_dodges_widget_text_appearance = {
    255,
    mod:get("remaining_dodges_widget_text_R"),
    mod:get("remaining_dodges_widget_text_G"),
    mod:get("remaining_dodges_widget_text_B")
}

-- ##################################################
-- Initalization
-- ##################################################

local init = function(func, ...)
    if func then
        func(...)
    end
end

mod.on_setting_changed = function(id)
    if id == "remaining_dodges_widget_horizontal_offset" then
        mod._remaining_dodges_widget_horizontal_offset = mod:get(id)
    elseif id == "remaining_dodges_widget_vertical_offset" then
        mod._remaining_dodges_widget_vertical_offset = mod:get(id)
    elseif id == "remaining_dodges_widget_R" then
        mod._remaining_dodges_widget_appearance = {
            mod:get(id),
            mod:get("remaining_dodges_widget_G"),
            mod:get("remaining_dodges_widget_B")
        }
    elseif id == "remaining_dodges_widget_G" then
        mod._remaining_dodges_widget_appearance = {
            mod:get("remaining_dodges_widget_R"),
            mod:get(id),
            mod:get("remaining_dodges_widget_B")
        }
    elseif id == "remaining_dodges_widget_B" then
        mod._remaining_dodges_widget_appearance = {
            mod:get("remaining_dodges_widget_R"),
            mod:get("remaining_dodges_widget_G"),
            mod:get(id)
        }
    end
end

mod.on_all_mods_loaded = function()
    init()
end

-- ##################################################
-- Hooks
-- ##################################################

-- Update variables when swapping weapons
mod:hook_safe("PlayerUnitWeaponExtension", "on_slot_wielded", function(self, slot_name, t, skip_wield_action)
    if not mod._unit then
        return
    end

    local old_effective_dodges = mod._effective_dodges

    local weapon_dodge_template = ScriptUnit.has_extension(mod._unit, "weapon_system"):dodge_template()
    mod._effective_dodges = math.ceil((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + math.round(self._buff_extension:stat_buffs().extra_consecutive_dodges or 0))

    local effective_dodges_difference = mod._effective_dodges - old_effective_dodges
    mod._effective_dodges_left = mod._effective_dodges_left + effective_dodges_difference
end)

-- Set dodge start flags, calculate effective dodges left
mod:hook_safe("PlayerCharacterStateDodging", "on_enter", function(self, unit, dt, t, previous_state, params)
    mod._dodging = true
    mod._draw_widget = true
    mod._unit = unit

    local weapon_dodge_template = ScriptUnit.has_extension(unit, "weapon_system"):dodge_template()
    mod._effective_dodges = math.ceil((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + math.round(self._buff_extension:stat_buffs().extra_consecutive_dodges or 0))

    if not mod._waiting_for_dodge_effectiveness_reset then
        mod._effective_dodges_left = mod._effective_dodges
    end

    mod._effective_dodges_left = mod._effective_dodges_left - 1
end)

-- Set dodge end flags, calculate consecutive dodge cooldown
mod:hook_safe("PlayerCharacterStateDodging", "on_exit", function(self, unit, t, next_state)
    mod._dodging = false
    mod._waiting_for_dodge_effectiveness_reset = true

	local weapon_dodge_template = self._weapon_extension:dodge_template()
	local base_dodge_template = self._archetype_dodge_template
	local weapon_consecutive_dodges_reset = weapon_dodge_template and weapon_dodge_template.consecutive_dodges_reset or 0
	local stat_buffs = self._buff_extension:stat_buffs()
	local buff_modifier = stat_buffs.dodge_cooldown_reset_modifier
	local buff_dodge_cooldown_reset_modifier = buff_modifier and 1 - (buff_modifier - 1) or 1
	local cooldown = (base_dodge_template.consecutive_dodges_reset + weapon_consecutive_dodges_reset) * buff_dodge_cooldown_reset_modifier

    mod._consecutive_dodges_cooldown = mod._unified_t + cooldown
end)

-- Add hud element to hud
mod:add_require_path(hud_element_script)

mod:hook(CLASS.UIHud, "init", function(func, self, elements, visibility_groups, params, ...)
	if not table.find_by_key(elements, "class_name", hud_element_class) then
		table.insert(elements, dodges_hud_element)
	end

	return func(self, elements, visibility_groups, params, ...)
end)
