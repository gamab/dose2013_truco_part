note
	description: "Summary description for {TR_WINDOW_LOBBY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_WINDOW_LOBBY


inherit
	EV_VERTICAL_BOX

	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	TR_GUI_POSITIONS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end


create
	make

feature -- Initialization
	make(a_controller: TR_CONTROLLER)
		do
			default_create

			create net_constants.make

			controller := a_controller

			set_minimum_size (window_width, window_height)

			initialize_pictures

			-- Register listener on controller to get game updates
			controller.register_lobby_state_change_action (agent lobby_update_received(?))
		end


feature  -- Implementation

	set_lobby_values(is_local_player_host: BOOLEAN; local_ip, local_port: STRING)
		local
			l_font: EV_FONT
		do
			if is_local_player_host then
				create add_ai_button.make_with_text ("Add AI")
				add_ai_button.set_point_position (add_ai_button_x, add_ai_button_y)
				add_ai_button.pointer_button_release_actions.extend (agent add_ai_button_clicked(?,?,?,?,?,?,?,?))
				world.extend (add_ai_button)

				create start_button.make_with_text ("Start game")
				start_button.set_point_position (start_button_x, start_button_y)
				start_button.pointer_button_release_actions.extend (agent start_button_clicked(?,?,?,?,?,?,?,?))
				world.extend (start_button)
			end

			--Initialize IP+port text
			lobby_box.clear
			lobby_box.set_with_named_file (path_lobby_box)
			create l_font.make_with_values (1, 8, 10, 14)
			lobby_box.set_font (l_font)
			lobby_box.draw_text_top_left (ip_text_x, ip_text_y, "IP: " + local_ip)
			lobby_box.draw_text_top_left (port_text_x, port_text_y, "Port: " + local_port)
		end

	initialize_pictures
		--Creates all element of the lobby. Options "add ai" and "start" become available if 'is_local_player_host'
		local
			l_buffer: EV_PIXMAP

			l_bg: EV_PIXMAP
			l_bg_pic: EV_MODEL_PICTURE

			l_lobby_box_pic: EV_MODEL_PICTURE

			l_leave_button: TR_BUTTON
		do
			--Initialize and extend drawing area
			create area
			create world
			create l_buffer.make_with_size (window_width, window_height)
			create proj.make_with_buffer (world, l_buffer, area)
			extend(area)

			--Initialize background
			create l_bg
			l_bg.set_with_named_file (path_bg)
			create l_bg_pic.make_with_pixmap (l_bg)
			world.extend (l_bg_pic)

			--Initialize lobby box
			create lobby_box
			lobby_box.set_with_named_file (path_lobby_box)
			create l_lobby_box_pic.make_with_pixmap (lobby_box)
			world.extend (l_lobby_box_pic)
			l_lobby_box_pic.set_point_position (window_width//2 - lobby_box.width // 2, window_height//2 - lobby_box.height // 2)

			--Initialize buttons
			create l_leave_button.make_with_text ("Leave")
			l_leave_button.set_point_position (leave_button_x, leave_button_y)
			l_leave_button.pointer_button_release_actions.extend (agent leave_button_clicked(?,?,?,?,?,?,?,?))
			world.extend(l_leave_button)


			--Initialize player boxes
			create player_boxes.make (4)


			proj.project

		end

	make_player_box(name: STRING; initial_team: INTEGER; is_ready, is_local_player: BOOLEAN)
		--Create a "TR_LOBBY_PLAYER_BOX" and place it in first available position
		require
			current_number_of_boxes_to_high: player_boxes.count < 4
		local
			l_box: TR_LOBBY_PLAYER_BOX
			current_slot: INTEGER
			is_host: BOOLEAN
		do
			if player_boxes.count = 0 then
				is_host := true
			else
				is_host := false
			end
			current_slot := player_boxes.count
			create l_box.make (name, initial_team, is_host, is_ready, is_local_player, Current)
			l_box.set_point_position (player_box_x , player_box_slot_to_pos_y(current_slot))
			world.extend (l_box)

			print(name)
			player_boxes.put (l_box, name)
		end

	update_player_box(player_box: TR_LOBBY_PLAYER_BOX; team: INTEGER; is_ready: BOOLEAN)
		do
			player_box.change_team(team)
			player_box.change_ready_status(is_ready)
		end

	remove_player_box
		do

		end



feature {NONE} -- Network event handling
	lobby_update_received(lobby_update: TR_SERVER_PLAYER_ARRAY)
		local
			i: INTEGER

			l_server_player: TR_SERVER_PLAYER
			l_is_local_player: BOOLEAN
			l_is_unknown_player: BOOLEAN
			l_all_players_ready: BOOLEAN
			l_team1_count: INTEGER
			l_team2_count: INTEGER
		do
			l_all_players_ready := true

			from player_boxes.start until player_boxes.after loop
				player_boxes.item_for_iteration.wipe_out
				player_boxes.forth
			end
			player_boxes.wipe_out

			from i := 0 until i = lobby_update.count loop
				l_server_player := lobby_update.at (i)
				l_is_unknown_player := l_server_player.name.is_equal (net_constants.srv_unknown_player_name)
				l_is_local_player := controller.get_local_player.get_player_name.is_equal (l_server_player.name)

				if not l_is_unknown_player then
					-- update player boxes
					if player_boxes.has_key (l_server_player.name) then
						update_player_box(player_boxes.at (l_server_player.name), l_server_player.team, l_server_player.is_ready)
					else
						make_player_box(l_server_player.name, l_server_player.team, l_server_player.is_ready, l_is_local_player)
					end

					-- we can only start the game if all players are ready
					if not l_server_player.is_ready then
						l_all_players_ready := false
					end

					if l_server_player.team = 1 then
						l_team1_count := l_team1_count + 1
					else
						l_team2_count := l_team2_count + 1
					end
				end

				i := i + 1
			end

			set_lobby_values (controller.is_host, controller.client.server_address.host_address, controller.client.server_port.out)

			if controller.is_host then
				-- enable/disable start button
				if player_boxes.count = 4 and l_all_players_ready and l_team1_count = 2 and l_team2_count = 2 then
					start_button.set_enabled (true)
				else
					start_button.set_enabled (false)
				end

				-- enable/disable add ai button
				if player_boxes.count <= 2 then
					add_ai_button.set_enabled (true)
				else
					add_ai_button.set_enabled (false)
				end
			end
			proj.project
		end




feature {NONE} -- Click events handling

	player_box_slot_to_pos_y(slot: INTEGER): INTEGER
		do
			Result := player_box_y + slot * player_box_offset
		end


	leave_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			print("leaving game %N")
			controller.gui_leave_game
		end

	add_ai_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if add_ai_button.is_enabled then
				print("adding ai team %N")
				controller.gui_add_ai
			end
		end

	start_button_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if start_button.is_enabled then
				print("starting game %N")
				controller.gui_start_game
			end
		end

feature {TR_LOBBY_PLAYER_BOX}
	changed_team(new_team: INTEGER)
		do
			print("changing team to: " + new_team.out + "%N")
			controller.gui_change_team (new_team)
		end

	clicked_ready_button(a_ready_state: BOOLEAN)
		do
			print("player clicked ready button %N")
			controller.gui_change_ready_state (a_ready_state)
		end

feature {NONE} -- Attributes
	controller: TR_CONTROLLER

	area: EV_DRAWING_AREA
	world: EV_MODEL_WORLD
	proj: EV_MODEL_DRAWING_AREA_PROJECTOR

	player_boxes: HASH_TABLE[TR_LOBBY_PLAYER_BOX, STRING]

	lobby_box: EV_PIXMAP -- we need this non-local, to be able to write IP+Port on it later

	start_button: TR_BUTTON
	add_ai_button: TR_BUTTON

	net_constants: TR_NETWORK_CONSTANTS

end
