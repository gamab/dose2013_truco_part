note
	description: "Summary description for {TR_LOBBY_BOX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_LOBBY_PLAYER_BOX


inherit
	EV_MODEL_GROUP

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


feature
	make(name: STRING; initial_team: INTEGER; is_host, a_is_ready, a_is_local_player: BOOLEAN; a_lobby: TR_WINDOW_LOBBY)
		--Creates a lobby player box (EV_MODEL_GROUP) and all its elements.
		--If a_is_local_player choosing teams will be available
		local
			l_font: EV_FONT

			l_player_box_pixmap: EV_PIXMAP
			l_player_box_pic: EV_MODEL_PICTURE
		do
			default_create

			is_ready := a_is_ready
			is_local_player := a_is_local_player
			lobby := a_lobby

			--Initialize player box
			if is_local_player then create l_font.make_with_values (1, 8, 10, 16)
			else create l_font.make_with_values (1, 7, 10, 16)
			end
			create l_player_box_pixmap
			l_player_box_pixmap.set_with_named_file (path_lobby_player_box)
			l_player_box_pixmap.set_font (l_font)
			if is_host then
				l_player_box_pixmap.draw_text_top_left (8, l_player_box_pixmap.height//2 - 10, name + " (Host)")
			else
				l_player_box_pixmap.draw_text_top_left (8, l_player_box_pixmap.height//2 - 10, name)
			end

			create l_player_box_pic.make_with_pixmap (l_player_box_pixmap)
			extend(l_player_box_pic)

			--Initialize the "team picker"
			make_team_picker(initial_team)

			--Initialize ready button
			make_ready_button
		end

	make_ready_button
		do
			create ready_btn
			ready_btn.set_with_named_file (path_ready_button)
			create ready_btn_clicked
			ready_btn_clicked.set_with_named_file (path_ready_button_clicked)
			if is_ready then
				create ready_btn_pic.make_with_pixmap(ready_btn_clicked)
			else
				create ready_btn_pic.make_with_pixmap(ready_btn)
			end
			ready_btn_pic.set_point_position (ready_button_x, ready_button_y)
			extend(ready_btn_pic)

			if is_local_player then
				ready_btn_pic.pointer_button_release_actions.extend (agent clicked_ready_button(?,?,?,?,?,?,?,?))
			end
		end


	make_team_picker(initial_team: INTEGER)
		do
			create_picker_pixmaps

			create team_picker_pic.make_with_pixmap(team_picker_pixmap)
			team_picker_pic.set_point_position (team_picker_x, team_picker_y)
			extend(team_picker_pic)

			inspect initial_team
			when 1 then create team_color_pic.make_with_pixmap(team_red_pixmap)
			when 2 then create team_color_pic.make_with_pixmap(team_blue_pixmap)
			end

			team_color_pic.set_point_position (team_color_x, team_color_y)
			extend(team_color_pic)

			if is_local_player then
				create team_picker_arrow_pic.make_with_pixmap(team_picker_arrow_pixmap)
				team_picker_arrow_pic.set_point_position (team_picker_arrow_x, team_picker_arrow_y)
				extend(team_picker_arrow_pic)

				create team_picker_menu_pic.make_with_pixmap(team_picker_menu_pixmap)
				team_picker_menu_pic.set_point_position (team_picker_menu_x, team_picker_menu_y)
				extend (team_picker_menu_pic)

				create team_picker_menu_red_pic.make_with_pixmap(team_picker_menu_red_pixmap)
				team_picker_menu_red_pic.set_point_position (team_picker_menu_red_x, team_picker_menu_red_y)
				extend (team_picker_menu_red_pic)

				create team_picker_menu_blue_pic.make_with_pixmap(team_picker_menu_blue_pixmap)
				team_picker_menu_blue_pic.set_point_position (team_picker_menu_blue_x, team_picker_menu_blue_y)
				extend (team_picker_menu_blue_pic)

				hide_team_picker_menu

				team_picker_pic.pointer_enter_actions.extend (agent pointer_hovering(0))
				team_color_pic.pointer_enter_actions.extend (agent pointer_hovering(0))
				team_picker_arrow_pic.pointer_enter_actions.extend (agent pointer_hovering(0))

				team_picker_menu_red_pic.pointer_enter_actions.extend (agent pointer_hovering(1))
				team_picker_menu_red_pic.pointer_leave_actions.extend (agent pointer_left(1))
				team_picker_menu_red_pic.pointer_button_release_actions.extend (agent red_team_picked(?,?,?,?,?,?,?,?))

				team_picker_menu_blue_pic.pointer_enter_actions.extend (agent pointer_hovering(2))
				team_picker_menu_blue_pic.pointer_leave_actions.extend (agent pointer_left(2))
				team_picker_menu_blue_pic.pointer_button_release_actions.extend (agent blue_team_picked(?,?,?,?,?,?,?,?))

			end
		end


	create_picker_pixmaps
		do
			create team_picker_pixmap
			team_picker_pixmap.set_with_named_file(path_team_picker)

			create team_picker_arrow_pixmap
			team_picker_arrow_pixmap.set_with_named_file(path_team_picker_arrow)

			create team_red_pixmap
			team_red_pixmap.set_with_named_file(path_team_color_red)
			create team_blue_pixmap
			team_blue_pixmap.set_with_named_file(path_team_color_blue)

			create team_picker_menu_pixmap
			team_picker_menu_pixmap.set_with_named_file(path_team_picker_menu)

			create team_picker_menu_red_pixmap
			team_picker_menu_red_pixmap.set_with_named_file(path_team_picker_menu_red)
			create team_picker_menu_red_hover_pixmap
			team_picker_menu_red_hover_pixmap.set_with_named_file(path_team_picker_menu_red_hover)

			create team_picker_menu_blue_pixmap
			team_picker_menu_blue_pixmap.set_with_named_file(path_team_picker_menu_blue)
			create team_picker_menu_blue_hover_pixmap
			team_picker_menu_blue_hover_pixmap.set_with_named_file(path_team_picker_menu_blue_hover)
		end


	red_team_picked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			hide_team_picker_menu
			team_color_pic.set_pixmap (team_red_pixmap)
			lobby.changed_team(1)
		end


	blue_team_picked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			hide_team_picker_menu
			team_color_pic.set_pixmap (team_blue_pixmap)
			lobby.changed_team(2)
		end

	pointer_hovering(button_type: INTEGER)
		do
			if button_type = 0 then
				show_team_picker_menu
			end

			if button_type = 1 then
				team_picker_menu_red_pic.set_pixmap (team_picker_menu_red_hover_pixmap)
			elseif button_type = 2 then
				team_picker_menu_blue_pic.set_pixmap (team_picker_menu_blue_hover_pixmap)
			end
		end

	pointer_left(button_type: INTEGER)
		do
			if button_type = 1 then
				team_picker_menu_red_pic.set_pixmap (team_picker_menu_red_pixmap)
			elseif button_type = 2 then
				team_picker_menu_blue_pic.set_pixmap (team_picker_menu_blue_pixmap)
			end
		end

	show_team_picker_menu
		do
			world.prune (team_picker_menu_pic)
			world.extend (team_picker_menu_pic)
			world.prune (team_picker_menu_red_pic)
			world.extend (team_picker_menu_red_pic)
			world.prune (team_picker_menu_blue_pic)
			world.extend (team_picker_menu_blue_pic)
			team_picker_menu_pic.show
			team_picker_menu_red_pic.show
			team_picker_menu_blue_pic.show
		end

	hide_team_picker_menu
		do
			team_picker_menu_pic.hide
			team_picker_menu_red_pic.hide
			team_picker_menu_blue_pic.hide
		end


	clicked_ready_button(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			is_ready := not is_ready

			if ready_btn_pic.pixmap = ready_btn then
				ready_btn_pic.set_pixmap (ready_btn_clicked)
			else
				ready_btn_pic.set_pixmap (ready_btn)
			end

			lobby.clicked_ready_button (is_ready)
		end


feature -- Access
	change_team(team: INTEGER)
		do
			inspect team
			when 1 then
				team_color_pic.set_pixmap (team_red_pixmap)
			when 2 then
				team_color_pic.set_pixmap (team_blue_pixmap)
			end
		end

	change_ready_status(a_is_ready: BOOLEAN)
		do
			if a_is_ready then
				ready_btn_pic.set_pixmap (ready_btn_clicked)
			else
				ready_btn_pic.set_pixmap (ready_btn)
			end
		end

feature {NONE} -- Attributes

	team_picker_pixmap: EV_PIXMAP
	team_picker_pic: EV_MODEL_PICTURE

	team_red_pixmap: EV_PIXMAP
	team_blue_pixmap: EV_PIXMAP
	team_color_pic: EV_MODEL_PICTURE

	team_picker_arrow_pixmap: EV_PIXMAP
	team_picker_arrow_pic: EV_MODEL_PICTURE

	team_picker_menu_pixmap: EV_PIXMAP
	team_picker_menu_pic: EV_MODEL_PICTURE

	team_picker_menu_red_pixmap: EV_PIXMAP
	team_picker_menu_red_hover_pixmap: EV_PIXMAP
	team_picker_menu_red_pic: EV_MODEL_PICTURE

	team_picker_menu_blue_pixmap: EV_PIXMAP
	team_picker_menu_blue_hover_pixmap: EV_PIXMAP
	team_picker_menu_blue_pic: EV_MODEL_PICTURE

	ready_btn: EV_PIXMAP
	ready_btn_clicked: EV_PIXMAP
	ready_btn_pic: EV_MODEL_PICTURE

	is_local_player: BOOLEAN
	is_ready: BOOLEAN

	lobby: TR_WINDOW_LOBBY


end
