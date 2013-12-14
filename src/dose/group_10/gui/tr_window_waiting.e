note
	description: "Summary description for {TR_WINDOW_WAITING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_WINDOW_WAITING

inherit
	EV_VERTICAL_BOX
	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make,
	make_with_string

feature
	make(a_main_window: TR_MAINWINDOW)
		do
			default_create

			main_window := a_main_window

			if waiting_string = Void then
				waiting_string := ""
			end

			set_minimum_size (window_width, window_height)

			initialize_pictures
		end

	make_with_string(a_main_window: TR_MAINWINDOW; a_string: STRING)
		do
			waiting_string := a_string
			make (a_main_window)
		end

feature {NONE} -- Implementation

	initialize_pictures
		local
			l_buffer: EV_PIXMAP
			l_bg: EV_PIXMAP
			l_bg_pic: EV_MODEL_PICTURE
			l_title: STRING

			l_menu_box: EV_PIXMAP
			l_menu_box_pic: EV_MODEL_PICTURE
		do
			-- Initialize drawing area
			create area
			area.set_minimum_size (window_width, window_height)

			-- Initialize world/buffer/projector
			create world
			create l_buffer.make_with_size (window_width, window_height)
			create proj.make_with_buffer (world, l_buffer, area)

			-- Initialize background
			create l_bg
			l_bg.set_with_named_file (path_bg)
			create l_bg_pic.make_with_pixmap (l_bg)

			--Initialize menu-box
			create l_menu_box
			l_menu_box.set_with_named_file (path_menu_box)
			create l_menu_box_pic.make_with_pixmap (l_menu_box)
			l_menu_box_pic.set_point_position ((window_width//2 - l_menu_box.width//2), (window_height//2 - l_menu_box.height//2))

			-- Initialize waiting string
			l_menu_box.set_font (create {EV_FONT}.make_with_values (3, 9, 10, 24))
			l_menu_box.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 234, 74))
			l_menu_box.draw_text_top_left ((l_menu_box.width/2-l_menu_box.font.string_width (waiting_string)/2).rounded, 20, waiting_string)

			-- input picture to world
			world.extend (l_bg_pic)
			world.extend (l_menu_box_pic)

			-- extend the world
			extend (area)

			-- important here because otherwise the graphics will only be projected when activity occurs within it
			proj.project
		end

feature {NONE} -- Attributes

	main_window: TR_MAINWINDOW
	host_dialog: TR_HOST_DIALOG
	join_dialog: TR_JOIN_DIALOG

	area: EV_DRAWING_AREA
	world: EV_MODEL_WORLD
	proj: EV_MODEL_DRAWING_AREA_PROJECTOR

	waiting_string: STRING

end
