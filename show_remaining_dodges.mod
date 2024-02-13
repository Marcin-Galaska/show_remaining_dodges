return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`show_remaining_dodges` encountered an error loading the Darktide Mod Framework.")

		new_mod("show_remaining_dodges", {
			mod_script       = "show_remaining_dodges/scripts/mods/show_remaining_dodges/show_remaining_dodges",
			mod_data         = "show_remaining_dodges/scripts/mods/show_remaining_dodges/show_remaining_dodges_data",
			mod_localization = "show_remaining_dodges/scripts/mods/show_remaining_dodges/show_remaining_dodges_localization",
		})
	end,
	packages = {},
}
