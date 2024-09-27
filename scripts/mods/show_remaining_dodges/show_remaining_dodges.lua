-- Show Remaining Dodges mod by mroużon. Ver. 1.0.10
-- Contributors: FELITH, xsSplater, deluxghost
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("show_remaining_dodges")

-- ##################################################
-- Mod variables
-- ##################################################

mod._dodging = false                                            -- Whether the player is between entering and exiting the dodge state
mod._waiting_for_dodge_effectiveness_reset = false              -- Whether the player is between finishing a dodge and resetting mod._effective_dodges_left
mod._draw_widget = false                                        -- Whether the widget should be visible
mod._effective_dodges = 0                                       -- Max number of effective dodges with drawn weapon
mod._effective_dodges_left = nil                                -- Number of dodges with given weapon left before they get ineffective (can get negative)
mod._consecutive_dodges_cooldown = 0.0                          -- In-game time at which mod._effective_dodges_left will reset back to mod._effective_dodges
mod._unified_t = 0.0                                            -- In-game time unified between show_remaining_dodges.lua and hud_element_dodging.lua
mod._last_dodge_enter_t = 0.0                                   -- In-game time of last PlayerCharacterStateDodging.on_enter call
mod._unit = nil                                                 -- Player unit

mod._remaining_dodges_widget_fade_inout_speed = mod:get("remaining_dodges_widget_fade_inout_speed")
mod._remaining_dodges_show_negative_dodges = mod:get("remaining_dodges_show_negative_dodges")
mod._remaining_dodges_widget_horizontal_offset = mod:get("remaining_dodges_widget_horizontal_offset")
mod._remaining_dodges_widget_vertical_offset = -1 * mod:get("remaining_dodges_widget_vertical_offset")
mod._remaining_dodges_widget_bar_appearance = {
    255,
    mod:get("remaining_dodges_widget_bar_R"),
    mod:get("remaining_dodges_widget_bar_G"),
    mod:get("remaining_dodges_widget_bar_B")
}
mod._remaining_dodges_widget_bar_negative_dodges_appearance = {
    255,
    mod:get("remaining_dodges_widget_bar_negative_dodges_R"),
    mod:get("remaining_dodges_widget_bar_negative_dodges_G"),
    mod:get("remaining_dodges_widget_bar_negative_dodges_B")
}
mod._remaining_dodges_widget_text_appearance = {
    255,
    mod:get("remaining_dodges_widget_text_R"),
    mod:get("remaining_dodges_widget_text_G"),
    mod:get("remaining_dodges_widget_text_B")
}

local hud_element_script = "show_remaining_dodges/scripts/mods/show_remaining_dodges/hud/hud_element_dodging"
local hud_element_class = "HudElementDodging"

local dodges_hud_element = {
    use_hud_scale = true,
    filename = hud_element_script,
    class_name = hud_element_class,
    visibility_groups = {
        "alive",
        "communication_wheel"
    }
}

-- ##################################################
-- Initalization
-- ##################################################

local init = function(func, ...)
    if func then
        func(...)
    end
end

mod.reset_logic_variables = function()
    mod._dodging = false
    mod._waiting_for_dodge_effectiveness_reset = false
    mod._draw_widget = false
    mod._effective_dodges = 0
    mod._effective_dodges_left = nil
    mod._consecutive_dodges_cooldown = 0.0
    mod._unified_t = 0.0
    mod._last_dodge_enter_t = 0.0
    mod._unit = nil
end

mod.recreate_hud = function(self)
	local ui_manager = Managers.ui
	if ui_manager then
		local hud = ui_manager._hud
		if hud then
			local player = Managers.player:local_player(1)
			local peer_id = player:peer_id()
			local local_player_id = player:local_player_id()
			local elements = hud._element_definitions
			local visibility_groups = hud._visibility_groups
			hud:destroy()
			ui_manager:create_player_hud(peer_id, local_player_id, elements, visibility_groups)
		end
	end
end

mod.get_hud_element = function()
    local hud = Managers.ui:get_hud()
    return hud and hud:element(dodges_hud_element.class_name)
end

mod.on_setting_changed = function(id)
    if id == "remaining_dodges_widget_horizontal_offset" then
        mod._remaining_dodges_widget_horizontal_offset = mod:get(id)

        local dodges_element = mod.get_hud_element()
        if dodges_element then
            dodges_element:set_offset(mod._remaining_dodges_widget_vertical_offset, mod._remaining_dodges_widget_horizontal_offset)
        end
    elseif id == "remaining_dodges_widget_vertical_offset" then
        mod._remaining_dodges_widget_vertical_offset = -1 * mod:get(id)

        local dodges_element = mod.get_hud_element()
        if dodges_element then
            dodges_element:set_offset(mod._remaining_dodges_widget_vertical_offset, mod._remaining_dodges_widget_horizontal_offset)
        end
    elseif id == "remaining_dodges_widget_bar_R" then
        mod._remaining_dodges_widget_bar_appearance = {
            255,
            mod:get(id),
            mod:get("remaining_dodges_widget_bar_G"),
            mod:get("remaining_dodges_widget_bar_B")
        }
    elseif id == "remaining_dodges_widget_bar_G" then
        mod._remaining_dodges_widget_bar_appearance = {
            255,
            mod:get("remaining_dodges_widget_bar_R"),
            mod:get(id),
            mod:get("remaining_dodges_widget_bar_B")
        }
    elseif id == "remaining_dodges_widget_bar_B" then
        mod._remaining_dodges_widget_bar_appearance = {
            255,
            mod:get("remaining_dodges_widget_bar_R"),
            mod:get("remaining_dodges_widget_bar_G"),
            mod:get(id)
        }
    elseif id == "remaining_dodges_widget_bar_negative_dodges_R" then
        mod._remaining_dodges_widget_bar_negative_dodges_appearance = {
            255,
            mod:get(id),
            mod:get("remaining_dodges_widget_bar_negative_dodges_G"),
            mod:get("remaining_dodges_widget_bar_negative_dodges_B")
        }
    elseif id == "remaining_dodges_widget_bar_negative_dodges_G" then
        mod._remaining_dodges_widget_bar_negative_dodges_appearance = {
            255,
            mod:get("remaining_dodges_widget_bar_negative_dodges_R"),
            mod:get(id),
            mod:get("remaining_dodges_widget_bar_negative_dodges_B")
        }
    elseif id == "remaining_dodges_widget_bar_negative_dodges_B" then
        mod._remaining_dodges_widget_bar_negative_dodges_appearance = {
            255,
            mod:get("remaining_dodges_widget_bar_negative_dodges_R"),
            mod:get("remaining_dodges_widget_bar_negative_dodges_G"),
            mod:get(id)
        }
    elseif id == "remaining_dodges_widget_text_R" then
        mod._remaining_dodges_widget_text_appearance = {
            255,
            mod:get(id),
            mod:get("remaining_dodges_widget_text_G"),
            mod:get("remaining_dodges_widget_text_B")
        }

        local dodges_element = mod.get_hud_element()
        if dodges_element then
            dodges_element:set_text_appearance(mod._remaining_dodges_widget_text_appearance)
        end
    elseif id == "remaining_dodges_widget_text_G" then
        mod._remaining_dodges_widget_text_appearance = {
            255,
            mod:get("remaining_dodges_widget_text_R"),
            mod:get(id),
            mod:get("remaining_dodges_widget_text_B")
        }

        local dodges_element = mod.get_hud_element()
        if dodges_element then
            dodges_element:set_text_appearance(mod._remaining_dodges_widget_text_appearance)
        end
    elseif id == "remaining_dodges_widget_text_B" then
        mod._remaining_dodges_widget_text_appearance = {
            255,
            mod:get("remaining_dodges_widget_text_R"),
            mod:get("remaining_dodges_widget_text_G"),
            mod:get(id)
        }

        local dodges_element = mod.get_hud_element()
        if dodges_element then
            dodges_element:set_text_appearance(mod._remaining_dodges_widget_text_appearance)
        end
    elseif id == "remaining_dodges_widget_fade_inout_speed" then
        mod._remaining_dodges_widget_fade_inout_speed = mod:get("remaining_dodges_widget_fade_inout_speed")
    elseif id == "remaining_dodges_show_negative_dodges" then
        mod._remaining_dodges_show_negative_dodges = mod:get("remaining_dodges_show_negative_dodges")
    end
end

mod.on_all_mods_loaded = function()
    init()
    mod:recreate_hud()
end

mod.player_unit_loaded = function(self)
	self:init()
    mod:recreate_hud()
end

mod.player_unit_destroyed = function(self, player_unit)
	if player_unit == mod.player_unit then
        mod.reset_logic_variables()
        mod.initialized = false
	end
end

-- ##################################################
-- Custom functions
-- ##################################################

local _get_weapon_dodge_template = function(unit)
    local weapon_system = ScriptUnit.has_extension(unit, "weapon_system")
    if not weapon_system then
        return
    end

    return weapon_system:dodge_template()
end

local _on_exit = function(self)
    mod._dodging = false
    mod._waiting_for_dodge_effectiveness_reset = true

    -- Calculate consecutive dodge cooldown
	local weapon_dodge_template = self._weapon_extension:dodge_template()
	local base_dodge_template = self._archetype_dodge_template
	local weapon_consecutive_dodges_reset = weapon_dodge_template and weapon_dodge_template.consecutive_dodges_reset or 0
	local stat_buffs = self._buff_extension:stat_buffs()
	local buff_modifier = stat_buffs.dodge_cooldown_reset_modifier
	local buff_dodge_cooldown_reset_modifier = buff_modifier and 1 - (buff_modifier - 1) or 1
	local cooldown = (base_dodge_template.consecutive_dodges_reset + weapon_consecutive_dodges_reset) * buff_dodge_cooldown_reset_modifier

    mod._consecutive_dodges_cooldown = mod._unified_t + cooldown
end

local _reset_dodges_trait_proc_func = function(params, template_data, template_context)
    local dodge_write_component = template_data.dodge_write_component

    dodge_write_component.consecutive_dodges = 0

    mod._effective_dodges_left = mod._effective_dodges
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

    local weapon_dodge_template = _get_weapon_dodge_template(mod._unit)

    mod._effective_dodges = math.ceil((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + math.round(self._buff_extension:stat_buffs().extra_consecutive_dodges or 0))

    local effective_dodges_difference = mod._effective_dodges - old_effective_dodges

    mod._effective_dodges_left = mod._effective_dodges_left + effective_dodges_difference
end)

-- Set dodge start flags, calculate effective dodges left
mod:hook_safe("PlayerCharacterStateDodging", "on_enter", function(self, unit, dt, t, previous_state, params)
    -- Band aid for a bug of the game itself
    -- Player *can* enter dodging state mulitple times in a single frame
    if t - mod._last_dodge_enter_t < 0.05 then
        return
    end
    mod._last_dodge_enter_t = t

    mod._dodging = true
    mod._draw_widget = true
    mod._unit = unit

    local weapon_dodge_template = _get_weapon_dodge_template(unit)

    mod._effective_dodges = math.ceil((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + math.round(self._buff_extension:stat_buffs().extra_consecutive_dodges or 0))

    if not mod._waiting_for_dodge_effectiveness_reset then
        mod._effective_dodges_left = mod._effective_dodges
    end

    mod._effective_dodges_left = mod._effective_dodges_left - 1
end)

-- Account for slide-dodging and sprint-slides pausing the dodge cooldown
mod:hook_safe("PlayerCharacterStateSliding", "on_enter", function(self, unit, dt, t, previous_state, params)
    if t - mod._last_dodge_enter_t < 0.05 then
        return
    end
    mod._last_dodge_enter_t = t

    mod._dodging = true
    mod._unit = unit

    local weapon_dodge_template = _get_weapon_dodge_template(unit)

    mod._effective_dodges = math.ceil((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + math.round(self._buff_extension:stat_buffs().extra_consecutive_dodges or 0))

    if mod._waiting_for_dodge_effectiveness_reset and previous_state == "dodging" then
        mod._effective_dodges_left = mod._effective_dodges_left - 1
    end

    -- Purely in case mods are reloaded during gameplay and player dodges after sliding.
    if not mod._effective_dodges_left then
        mod._effective_dodges_left = mod._effective_dodges
    end
end)

-- Set dodge end flags, calculate consecutive dodge cooldown
mod:hook_safe("PlayerCharacterStateDodging", "on_exit", function(self, unit, t, next_state)
    _on_exit(self)
end)

mod:hook_safe("PlayerCharacterStateSliding", "on_exit", function(self, unit, t, next_state)
    _on_exit(self)
end)

-- Add hud element to hud
mod:add_require_path(hud_element_script)
mod:hook(CLASS.UIHud, "init", function(func, self, elements, visibility_groups, params, ...)
	if not table.find_by_key(elements, "class_name", hud_element_class) then
		table.insert(elements, dodges_hud_element)
	end

	return func(self, elements, visibility_groups, params, ...)
end)

-- Add support for the 'Agile' trait
mod:hook_require("scripts/settings/buff/buff_templates", function(templates)
    templates.weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count.proc_func = _reset_dodges_trait_proc_func
    templates.weapon_trait_bespoke_combataxe_p2_weakspot_hit_resets_dodge_count.proc_func = _reset_dodges_trait_proc_func
end)

-- Reset on game session end
mod:hook_safe("StateGameplay", "on_exit", function(self, on_shutdown)
    mod.reset_logic_variables()
end)

