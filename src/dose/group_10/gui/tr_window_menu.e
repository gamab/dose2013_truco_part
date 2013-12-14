note
	description: "Summary description for {TR_WINDOW_MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_WINDOW_MENU


inherit
	EV_VERTICAL_BOX
	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make

feature
	make(a_controller: TR_CONTROLLER)
		do
			default_create

			controller := a_controller

			set_minimum_size (window_width, window_height)

			initialize_pictures
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


			-- Initialize title
			l_menu_box.set_font (create {EV_FONT}.make_with_values (3, 9, 10, 30))
			l_menu_box.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 234, 74))
			l_title := "Truco"
			l_menu_box.draw_text_top_left ((l_menu_box.width/2-l_menu_box.font.string_width (l_title)/2).rounded, 20, l_title)



			-- Initialize host button
			create host_button.make_with_text ("Host game")
			host_button.set_point_position ((window_width/2-host_button.width/2).rounded, 300)
			host_button.pointer_button_release_actions.extend (agent host_button_clicked(?,?,?,?,?,?,?,?))

			-- Initialize join button
			create join_button.make_with_text ("Join game")
			join_button.set_point_position ((window_width/2-join_button.width/2).rounded, 350)
			join_button.pointer_button_release_actions.extend (agent join_button_clicked(?,?,?,?,?,?,?,?))

			-- Initialize exit button
			create exit_button.make_with_text ("Exit")
			exit_button.set_point_position ((window_width/2-exit_button.width/2).rounded, 400)
			exit_button.pointer_button_release_actions.extend (agent exit_button_clicked(?,?,?,?,?,?,?,?))

			-- input picture to world
			world.extend (l_bg_pic)
			world.extend (l_menu_box_pic)
			world.extend (host_button)
			world.extend (join_button)
			world.extend (exit_button)

			-- extend the world
			extend (area)

			-- important here because otherwise the graphics will only be projected when activity occurs within it
			proj.project
		end

	host_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		local
			name: STRING
		do
--			create host_dialog.make
--			host_dialog.show_modal_to_window (controller.mainwindow)
--			if not host_dialog.is_cancelled then
--				name := host_dialog.name
--				print (name + "%N")

--				controller.mainwindow.go_to_waiting ("Creating game...")
--				controller.set_host (true)
				controller.gui_host_game (name)
				-- wait for success
				--mainwindow.go_to_lobby

--			end
		end

	join_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		local
			l_name: STRING
			l_port: INTEGER
			l_addr: INET4_ADDRESS
			l_dot: STRING
			l_ip_list: LIST[STRING]
			l_ip_array: ARRAY[NATURAL_8]
			l_i: INTEGER
		do
			create join_dialog.make
			join_dialog.show_modal_to_window (controller.mainwindow)
			if not join_dialog.is_cancelled then
				l_name := join_dialog.name
				l_port := join_dialog.port

				controller.mainwindow.go_to_waiting ("Joining game...")
				controller.set_host (false)

				l_dot := "."
				l_ip_list := join_dialog.ip.split (l_dot.character_32_item (1))
				create l_ip_array.make_empty
				from
					l_i := 1
				until
					l_i = l_ip_list.count + 1
				loop
					l_ip_array.force (l_ip_list.at (l_i).to_natural_8, l_i)
					--print (l_ip_array.at (l_i))
					l_i := l_i + 1
				end
				create l_addr.make_from_host_and_address (l_name, l_ip_array)

				print (l_name + ", " + l_addr.out + ":" + l_port.out + "%N")

				controller.gui_join_game (l_name, l_addr, l_port)
				--controller.gui_join_game (name, l_addr, port)
				-- wait for success				
				-- go to lobby
			end
		end

	exit_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			controller.mainwindow.request_close_window
		end

feature {NONE} -- Attributes

	controller: TR_CONTROLLER

	host_dialog: TR_HOST_DIALOG
	join_dialog: TR_JOIN_DIALOG

	area: EV_DRAWING_AREA
	world: EV_MODEL_WORLD
	proj: EV_MODEL_DRAWING_AREA_PROJECTOR

	host_button: TR_BUTTON
	join_button: TR_BUTTON
	exit_button: TR_BUTTON

end
