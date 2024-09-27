-- Show Remaining Dodges mod by mroużon. Ver. 1.0.10
-- Contributors: FELITH, xsSplater, deluxghost
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("show_remaining_dodges")

local HudElementDodgingSettings = mod:io_dofile("show_remaining_dodges/scripts/mods/show_remaining_dodges/hud/hud_element_dodging_settings")

local UIWorkspaceSettings = mod:original_require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = mod:original_require("scripts/managers/ui/ui_widget")
local UIHudSettings = mod:original_require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = mod:original_require("scripts/managers/ui/ui_font_settings")

local bar_size = HudElementDodgingSettings.bar_size
local area_size = HudElementDodgingSettings.area_size
local glow_size = HudElementDodgingSettings.glow_size
local center_offset = HudElementDodgingSettings.center_offset

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = area_size,
		position = {0, center_offset, 0}
	},
	gauge = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "center",
		size = {212, 10},
		position = {0, 6, 1}
	},
	dodge = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "center",
		size = bar_size,
		position = {0, 0, 1}
	}
}

local value_text_style = table.clone(UIFontSettings.body_small)
value_text_style.offset = {
	0 + mod._remaining_dodges_widget_horizontal_offset,
	10 + mod._remaining_dodges_widget_vertical_offset,
	3
}
value_text_style.size = {500, 30}
value_text_style.vertical_alignment = "top"
value_text_style.horizontal_alignment = "left"
value_text_style.text_horizontal_alignment = "left"
value_text_style.text_vertical_alignment = "top"
value_text_style.text_color = mod._remaining_dodges_widget_text_appearance

local name_text_style = table.clone(value_text_style)
name_text_style.offset = {
	0 + mod._remaining_dodges_widget_horizontal_offset,
	10 + mod._remaining_dodges_widget_vertical_offset,
	3
}
name_text_style.horizontal_alignment = "right"
name_text_style.text_horizontal_alignment = "right"
name_text_style.text_color = mod._remaining_dodges_widget_text_appearance
name_text_style.drop_shadow = false

local widget_definitions = {
	gauge = UIWidget.create_definition({
		{
			value_id = "value_text",
			style_id = "value_text",
			pass_type = "text",
			value = "NaN",
			style = value_text_style
		},
		{
			value_id = "name_text",
			style_id = "name_text",
			pass_type = "text",
			value = Utf8.upper(mod:localize("hud_display_name_dodges")),
			style = name_text_style
		},
		{
			value = "content/ui/materials/hud/stamina_gauge",
			style_id = "warning",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0 + mod._remaining_dodges_widget_horizontal_offset,
					0 + mod._remaining_dodges_widget_vertical_offset,
					1
				},
				color = mod._remaining_dodges_widget_text_appearance
			}
		}
	}, "gauge")
}

local dodge = UIWidget.create_definition({
	{
		value = "content/ui/materials/hud/stamina_full",
		style_id = "full",
		pass_type = "rect",
		style = {
			offset = {
				0 + mod._remaining_dodges_widget_horizontal_offset,
				0 + mod._remaining_dodges_widget_vertical_offset,
				3
			},
			color = mod._remaining_dodges_widget_bar_appearance
		}
	}
}, "dodge")

return {
	dodge_definition = dodge,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}