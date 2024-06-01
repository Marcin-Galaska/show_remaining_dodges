-- Show Remaining Dodges mod by mroużon. Ver. 1.0.8
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("show_remaining_dodges")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id  = "remaining_dodges_widget_settings_behaviour",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "remaining_dodges_widget_fade_inout_speed",
						tooltip = "remaining_dodges_widget_fade_inout_speed_desc",
						type = "numeric",
						default_value = 3,
						range = {1, 10}
					},
					{
						setting_id = "remaining_dodges_show_negative_dodges",
						tooltip = "remaining_dodges_show_negative_dodges_desc",
						type = "checkbox",
						default_value = false,
					}
				}
			},
			{
				setting_id  = "remaining_dodges_widget_bar_settings_appearance",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "remaining_dodges_widget_bar_R",
						tooltip = "remaining_dodges_widget_bar_R_desc",
						type = "numeric",
						default_value = 240,
						range = {0, 255}
					},
					{
						setting_id = "remaining_dodges_widget_bar_G",
						tooltip = "remaining_dodges_widget_bar_G_desc",
						type = "numeric",
						default_value = 230,
						range = {0, 255}
					},
					{
						setting_id = "remaining_dodges_widget_bar_B",
						tooltip = "remaining_dodges_widget_bar_B_desc",
						type = "numeric",
						default_value = 80,
						range = {0, 255}
					}
				}
			},
			{
				setting_id  = "negative_dodges_widget_bar_settings_appearance",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "negative_dodges_widget_bar_R",
						tooltip = "negative_dodges_widget_bar_R_desc",
						type = "numeric",
						default_value = 255,
						range = {0, 255}
					},
					{
						setting_id = "negative_dodges_widget_bar_G",
						tooltip = "negative_dodges_widget_bar_G_desc",
						type = "numeric",
						default_value = 80,
						range = {0, 255}
					},
					{
						setting_id = "negative_dodges_widget_bar_B",
						tooltip = "negative_dodges_widget_bar_B_desc",
						type = "numeric",
						default_value = 80,
						range = {0, 255}
					}
				}
			},
			{
				setting_id  = "remaining_dodges_widget_text_settings_appearance",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "remaining_dodges_widget_text_R",
						tooltip = "remaining_dodges_widget_text_R_desc",
						type = "numeric",
						default_value = 169,
						range = {0, 255}
					},
					{
						setting_id = "remaining_dodges_widget_text_G",
						tooltip = "remaining_dodges_widget_text_G_desc",
						type = "numeric",
						default_value = 191,
						range = {0, 255}
					},
					{
						setting_id = "remaining_dodges_widget_text_B",
						tooltip = "remaining_dodges_widget_text_B_desc",
						type = "numeric",
						default_value = 153,
						range = {0, 255}
					}
				}
			},
			{
				setting_id  = "remaining_dodges_widget_settings_position",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "remaining_dodges_widget_vertical_offset",
						tooltip = "remaining_dodges_widget_vertical_offset_desc",
						type = "numeric",
						default_value = 0,
						range = {-800, 1300}
					},
					{
						setting_id = "remaining_dodges_widget_horizontal_offset",
						tooltip = "remaining_dodges_widget_horizontal_offset_desc",
						type = "numeric",
						default_value = 0,
						range = {-1800, 1800}
					}
				}
			}
		}
	}
}
