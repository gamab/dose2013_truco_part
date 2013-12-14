note
	description: "Summary description for {TR_BUTTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_BUTTON

inherit
	EV_MODEL_GROUP
	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make,
	make_with_text

feature

	make
		do
			make_with_text ("")
		end

	make_with_text (a_string: STRING)
		do
			default_create

			shown_text := a_string
			enabled := true

			initialize_pixmaps

			create btn_pic.make_with_pixmap (btn)
			extend(btn_pic)

			pointer_enter_actions.extend (agent enter)
			pointer_leave_actions.extend (agent leave)
		end

	initialize_pixmaps
		local
			l_font: EV_FONT
			l_color: EV_COLOR
			l_color_disabled: EV_COLOR
		do
			create l_font.make_with_values (3, 9, 10, 14)
			create l_color.make_with_8_bit_rgb (255, 234, 74)
			create l_color_disabled.make_with_8_bit_rgb (64, 64, 64)

			create btn
			btn.set_with_named_file (path_button)
			btn.set_font (l_font)
			btn.set_foreground_color (l_color)
			draw_text (btn)

			create btn_hover
			btn_hover.set_with_named_file (path_button_hover)
			btn_hover.set_font (l_font)
			btn_hover.set_foreground_color (l_color)
			draw_text (btn_hover)

			create btn_disabled
			btn_disabled.set_with_named_file (path_button_disabled)
			btn_disabled.set_font (l_font)
			btn_disabled.set_foreground_color (l_color_disabled)
			draw_text (btn_disabled)
		end

	width: INTEGER
		do
			Result := btn.width
		end

	height: INTEGER
		do
			Result := btn.height
		end

	is_enabled: BOOLEAN
		do
			Result := enabled
		end

	set_enabled (a_boolean: BOOLEAN)
		-- enables or disables this button. A disabled button will not fire events.
		do
			enabled := a_boolean

			if not is_enabled then
				btn_pic.set_pixmap (btn_disabled)
				pointer_button_release_actions.block
			else
				btn_pic.set_pixmap (btn)
				pointer_button_release_actions.resume
			end
		end

	set_text (a_string: STRING)
		do
			shown_text := a_string
			initialize_pixmaps
		end

	text: STRING
		do
			Result := shown_text
		end

	remake_button(truco_type: STRING)
		local
			l_font: EV_FONT
			l_color: EV_COLOR
		do
			shown_text := truco_type

			create l_font.make_with_values (3, 9, 10, 14)
			create l_color.make_with_8_bit_rgb (255, 234, 74)

			create btn
			btn.set_with_named_file (path_button)
			btn.set_font (l_font)
			btn.set_foreground_color (l_color)
			draw_text (btn)
		end

feature {NONE}

	enter
		do
			if is_enabled then
				btn_pic.set_pixmap (btn_hover)
			end
		end

	leave
		do
			if is_enabled then
				btn_pic.set_pixmap (btn)
			end
		end

	draw_text (a_pixmap: EV_PIXMAP)
		local
			l_size: TUPLE [INTEGER, INTEGER, INTEGER, INTEGER]
			l_x: INTEGER_32
			l_y: INTEGER_32
		do
			l_size := a_pixmap.font.string_size (shown_text)
			l_x := ((a_pixmap.width / 2) - (l_size.integer_32_item (1) / 2)).rounded
			l_y := ((a_pixmap.height / 2) - (l_size.integer_32_item (2) / 2)).rounded
			a_pixmap.draw_text_top_left (l_x, l_y, shown_text)
		end

feature {NONE} -- Access

	btn: EV_PIXMAP
	btn_hover: EV_PIXMAP
	btn_disabled: EV_PIXMAP
	btn_pic: EV_MODEL_PICTURE
	shown_text: STRING
	enabled: BOOLEAN

end
