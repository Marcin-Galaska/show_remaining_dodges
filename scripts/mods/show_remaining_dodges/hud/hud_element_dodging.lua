-- Show Remaining Dodges mod by mroużon. Ver. 1.0.10
-- Contributors: FELITH, xsSplater, deluxghost
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("show_remaining_dodges")

local Definitions = mod:io_dofile("show_remaining_dodges/scripts/mods/show_remaining_dodges/hud/hud_element_dodging_definitions")
local HudElementDodgingSettings = mod:io_dofile("show_remaining_dodges/scripts/mods/show_remaining_dodges/hud/hud_element_dodging_settings")

local UIWidget = mod:original_require("scripts/managers/ui/ui_widget")
local UIHudSettings = mod:original_require("scripts/settings/ui/ui_hud_settings")

local HudElementDodging = class("HudElementDodging", "HudElementBase")

HudElementDodging.on_resolution_modified = function (self)
	HudElementDodging.super.on_resolution_modified(self)
end

HudElementDodging.init = function (self, parent, draw_layer, start_scale)
	HudElementDodging.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._dodges = {}
	self._dodge_width = 0
	self._dodge_widget = self:_create_widget("dodge", Definitions.dodge_definition)
end

HudElementDodging.destroy = function (self, ui_renderer)
	HudElementDodging.super.destroy(self, ui_renderer)
end

HudElementDodging._add_dodge = function (self)
	self._dodges[#self._dodges + 1] = {}
end

HudElementDodging._remove_dodge = function (self)
	self._dodges[#self._dodges] = nil
end

HudElementDodging.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementDodging.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_dodge_amount()
	self:_update_visibility(dt)

	mod._unified_t = t

	if mod._consecutive_dodges_cooldown < t and mod._waiting_for_dodge_effectiveness_reset and not mod._dodging then
		mod._waiting_for_dodge_effectiveness_reset = false
		mod._effective_dodges_left = mod._effective_dodges
		mod._draw_widget = false
	end
end

HudElementDodging._update_dodge_amount = function (self)
	local dodge_amount = mod._effective_dodges

	if dodge_amount ~= self._dodge_amount then
		local amount_difference = (self._dodge_amount or 0) - dodge_amount
		self._dodge_amount = dodge_amount
		local bar_size = HudElementDodgingSettings.bar_size
		local segment_spacing = HudElementDodgingSettings.spacing
		local total_segment_spacing = segment_spacing * math.max(dodge_amount - 1, 0)
		local total_bar_length = bar_size[1] - total_segment_spacing
		self._dodge_width = math.round(dodge_amount > 0 and total_bar_length / dodge_amount or total_bar_length)

		self:_set_scenegraph_size("dodge", self._dodge_width)

		local add_dodges = amount_difference < 0

		for i = 1, math.abs(amount_difference) do
			if add_dodges then
				self:_add_dodge()
			else
				self:_remove_dodge()
			end
		end
	end
end

HudElementDodging._update_visibility = function (self, dt)
	local draw = mod._draw_widget and mod._effective_dodges and mod._effective_dodges > 0

	local alpha_speed = mod._remaining_dodges_widget_fade_inout_speed
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementDodging._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local previous_alpha_multiplier = render_settings.alpha_multiplier
		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementDodging.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
		self:_draw_dodges(dt, t, ui_renderer)

		render_settings.alpha_multiplier = previous_alpha_multiplier
	end
end

local color_empty = {
	100,
	UIHudSettings.color_tint_secondary_3[2],
	UIHudSettings.color_tint_secondary_3[3],
	UIHudSettings.color_tint_secondary_3[4]
}

HudElementDodging._draw_dodges = function (self, dt, t, ui_renderer)
	local num_dodges = self._dodge_amount

	if num_dodges < 1 then
		return
	end

	local widget = self._dodge_widget
	local widget_offset = widget.offset
	local dodge_width = self._dodge_width

	local gauge_widget = self._widgets_by_name.gauge
	local dodges_left = 0
	if mod._remaining_dodges_show_negative_dodges then
		dodges_left = mod._effective_dodges_left
	elseif mod._effective_dodges_left > dodges_left then
		dodges_left = mod._effective_dodges_left
	end
	gauge_widget.content.value_text = string.format("%d", dodges_left)

	local spacing = HudElementDodgingSettings.spacing
	local x_offset = (dodge_width + spacing) * (num_dodges - 1) * 0.5
	local dodges = self._dodges

	local view_dodges_left = dodges_left
	if dodges_left < 0 then
		view_dodges_left = dodges_left * (-1)
	end
	
	for i = num_dodges, 1, -1 do
		local dodge = dodges[i]

		if not dodge then
			return
		end

		local is_full, is_empty = nil, nil

		if i <= view_dodges_left then
			is_full = true
		else
			is_empty = true
		end

		local active_color = nil

		if is_empty then
			active_color = color_empty
		elseif is_full then
			if mod._effective_dodges_left >= 0 then
				active_color = mod._remaining_dodges_widget_bar_appearance
			else
				active_color = mod._remaining_dodges_widget_bar_negative_dodges_appearance
			end
		end

		local widget_style = widget.style
		local widget_color = widget_style.full.color
		widget_color[1] = active_color[1]
		widget_color[2] = active_color[2]
		widget_color[3] = active_color[3]
		widget_color[4] = active_color[4]
		widget_offset[1] = x_offset

		UIWidget.draw(widget, ui_renderer)

		x_offset = x_offset - dodge_width - spacing
	end
end

HudElementDodging.set_offset = function(self, vertical, horizontal)
	self._widgets_by_name.gauge.style.value_text.offset = {
		0 + horizontal,
		10 + vertical,
		3
	}

	self._widgets_by_name.gauge.style.name_text.offset = {
		0 + horizontal,
		10 + vertical,
		3
	}

	self._widgets_by_name.gauge.style.warning.offset = {
		0 + horizontal,
		0 + vertical,
		1
	}

	self._widgets_by_name.dodge.style.full.offset = {
		0 + horizontal,
		0 + vertical,
		3
	}
end

HudElementDodging.set_text_appearance = function(self, appearance)
	self._widgets_by_name.gauge.style.value_text.text_color = appearance
	self._widgets_by_name.gauge.style.name_text.text_color = appearance
	self._widgets_by_name.gauge.style.warning.color = appearance
end

return HudElementDodging