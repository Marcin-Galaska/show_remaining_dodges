-- Show Remaining Dodges mod by mroużon. Ver. 1.0.6b
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

-- Russian translation created with the help of xsSplater
-- Chinese localization by deluxghost

return {
	mod_name = {
		en = "Show Remaining Dodges",
		ru = "Индикатор Оставшихся Уворотов",
		pl = "Wskaźnik Pozostałych Uników",
		["zh-cn"] = "显示剩余闪避",
	},
	mod_description = {
		en = "Adds an in-game, stamina-like widget showing number of dodges remaining before dodging becomes ineffective.\n\nAuthor: mroużon",
		ru = "Добавляет внутриигровой виджет, аналогичный виджету выносливости, отображающий количество оставшихся уворотов перед тем, как увороты станут неэффективными.\n\nАвтор: mroużon",
		pl = "Dodaje podobny do wskaźnika kondycji widżet wyświetlający liczbę pozostałych uników, zanim unikanie stanie się nieefektywne.\n\nAutor: mroużon",
		["zh-cn"] = "在游戏内添加类似体力的组件，显示在闪避效率开始变差之前剩余的有效闪避数。\n\n作者：mroużon",
	},
	remaining_dodges_widget_settings_behaviour = {
		en = "Widget Behaviour",
		ru = "Поведение Индикатора",
		pl = "Zachowanie Wskaźnika",
		["zh-cn"] = "组件行为",
	},
	remaining_dodges_widget_fade_inout_speed = {
		en = "Fade In/Out Speed",
		ru = "Скорость Появления/Исчезновения",
		pl = "Prędkość Pojawiania Się/Zanikania",
		["zh-cn"] = "淡入淡出速度",
	},
	remaining_dodges_widget_fade_inout_speed_desc = {
		en = "How quickly the widget will fade in and out.",
		ru = "Как быстро будет появляться и исчезать индикатор.",
		pl = "Jak szybko wskaźnik będzie się pojawiał i znikał.",
		["zh-cn"] = "组件以多快的速度淡入淡出",
	},
	remaining_dodges_widget_bar_settings_appearance = {
		en = "Widget Bars Style",
		ru = "Стиль Баров Индикатора",
		pl = "Styl Pasków Wskaźnika",
		["zh-cn"] = "组件指示条样式",
	},
	remaining_dodges_widget_bar_R = {
		en = "Red",
		ru = "Красный",
		pl = "Czerwony",
		["zh-cn"] = "红色",
	},
	remaining_dodges_widget_bar_R_desc = {
		en = "Intensity of the color red.",
		ru = "Интенсивность Красного цвета",
		pl = "Intensywność koloru czerwonego.",
		["zh-cn"] = "红色强度。",
	},
	remaining_dodges_widget_bar_G = {
		en = "Green",
		ru = "Зелёный",
		pl = "Zielony",
		["zh-cn"] = "绿色",
	},
	remaining_dodges_widget_bar_G_desc = {
		en = "Intensity of the color green.",
		ru = "Интенсивность Зелёного цвета",
		pl = "Intensywność koloru zielonego.",
		["zh-cn"] = "绿色强度。",
	},
	remaining_dodges_widget_bar_B = {
		en = "Blue",
		ru = "Синий",
		pl = "Niebieski",
		["zh-cn"] = "蓝色",
	},
	remaining_dodges_widget_bar_B_desc = {
		en = "Intensity of the color blue.",
		ru = "Интенсивность Синего цвета",
		pl = "Intensywność koloru niebieskiego.",
		["zh-cn"] = "蓝色强度。",
	},
	remaining_dodges_widget_text_settings_appearance = {
		en = "Widget Text Style",
		ru = "Стиль Текста Индикатора",
		pl = "Styl Tekstu Wskaźnika",
		["zh-cn"] = "组件文本样式",
	},
	remaining_dodges_widget_text_R = {
		en = "Red",
		ru = "Красный",
		pl = "Czerwony",
		["zh-cn"] = "红色",
	},
	remaining_dodges_widget_text_R_desc = {
		en = "Intensity of the color red.",
		ru = "Интенсивность Красного цвета",
		pl = "Intensywność koloru czerwonego.",
		["zh-cn"] = "红色强度。",
	},
	remaining_dodges_widget_text_G = {
		en = "Green",
		ru = "Зелёный",
		pl = "Zielony",
		["zh-cn"] = "绿色",
	},
	remaining_dodges_widget_text_G_desc = {
		en = "Intensity of the color green.",
		ru = "Интенсивность Зелёного цвета",
		pl = "Intensywność koloru zielonego.",
		["zh-cn"] = "绿色强度。",
	},
	remaining_dodges_widget_text_B = {
		en = "Blue",
		ru = "Синий",
		pl = "Niebieski",
		["zh-cn"] = "蓝色",
	},
	remaining_dodges_widget_text_B_desc = {
		en = "Intensity of the color blue.",
		ru = "Интенсивность Синего цвета",
		pl = "Intensywność koloru niebieskiego.",
		["zh-cn"] = "蓝色强度。",
	},
	remaining_dodges_widget_settings_position = {
		en = "Widget Position",
		ru = "Положение Индикатора",
		pl = "Pozycja Wskaźnika",
		["zh-cn"] = "组件位置",
	},
	remaining_dodges_widget_vertical_offset = {
		en = "Vertical Offset",
		ru = "Вертикальное Смещение",
		pl = "Przesunięcie Pionowe",
		["zh-cn"] = "垂直偏移量",
	},
	remaining_dodges_widget_vertical_offset_desc = {
		en = "Offset applied to the widget in the Y axis.",
		ru = "Смещение, применённое к индикатору по оси Y.",
		pl = "Przesunięcie wskaźnika w osi Y.",
		["zh-cn"] = "组件在 Y 轴方向的偏移量。",
	},
	remaining_dodges_widget_horizontal_offset = {
		en = "Horizontal Offset",
		ru = "Горизонтальное Смещение",
		pl = "Przesunięcie Poziome",
		["zh-cn"] = "水平偏移量",
	},
	remaining_dodges_widget_horizontal_offset_desc = {
		en = "Offset applied to the widget in the X axis.",
		ru = "Смещение, применённое к индикатору по оси X.",
		pl = "Przesunięcie wskaźnika w osi X.",
		["zh-cn"] = "组件在 X 轴方向的偏移量。",
	},
	hud_display_name_dodges = {
		en = "Dodges",
		ru = "Увороты",
		pl = "Uniki",
		["zh-cn"] = "闪避",
	}
}
