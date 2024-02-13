# show_remaining_dodges
 A Warhammer 40K: Darktide mod that adds a widget showing times the player can consecutively dodge before dodging becomes ineffective.

### Darktide Mod Framework
This mod utilizes DMF, a monkey patching framework for Darktide's Autodesk Stringray engine, and is structured accordingly - a *.mod* file, 3 standard *.lua* files and a 3-file *HudElementDodging* class definition:
- show_remaining_dodges.lua - main logic of the modification.

- show_remaining_dodges_data.lua - in-game configurable variables used in the logic.

- show_remaining_dodges_localization.lua - localization strings used in UI.

- hud_element_dodging_settings.lua - HUD constants

- hud_element_dodging_definitions.lua - scenegraph and widget definitions

- hud_element_dodging.lua - widget functions

**Make sure you are familiar with the [DMF mod installation procedure](https://dmf-docs.darkti.de/#/installing-mods) before attempting to install or modify this repository.**

### Concept
This highly customizable mod adds an effective dodge counter widget to your HUD. It is updated in real time and accounts for dodge limit bonuses.

### Usage
Upon installing this mod, you are ready to go. This mod shows you your effective dodge count in combat, accordingly to the preferences you set inside DMF's mod settings:

![2024-02-1314-30-04_1-ezgif com-video-to-gif-converter](https://github.com/Marcin-Galaska/show_remaining_dodges/assets/106023363/3ee46a57-e1dd-4c90-bb88-8b0fbce4c578)

By default, the widget is located slightly below your crosshair:

![2024-02-1314-30-04-ezgif com-video-to-gif-converter](https://github.com/Marcin-Galaska/show_remaining_dodges/assets/106023363/712a5c5d-c76e-4523-aad4-f5ce00c3acb4)

You can configure the widget's color, position and fade in/out speed on the screen to your liking.

## Thanks to Zombine, Redbeardt and others for their input into the Darktide modding community. Their work helped me a lot in the process of creating this mod. The Emperor protects.

### License
BSD 2-Clause License

Copyright (c) 2023, Marcin Gałąska <br>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
