note
	description: "Summary description for {TR_MAINWINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_MAINWINDOW

inherit
	EV_TITLED_WINDOW

	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end



create
	make

feature {NONE} -- Initialization

	debug_menu: EV_VERTICAL_BOX

	make(a_controller: TR_CONTROLLER)
		local
			l_icon_pixmap: EV_PIXMAP

		do
			make_with_title ("TRUCO")

			controller := a_controller

			create l_icon_pixmap
			l_icon_pixmap.set_with_named_file (path_icon)
			set_icon_pixmap (l_icon_pixmap)

			disable_user_resize

			create menu.make(controller)
			create lobby.make(controller)
			create table.make(controller)

			extend(menu)
			close_request_actions.extend (agent request_close_window)

		end


	debug_menu_action
		do
			go_to_menu
		end

	debug_lobby_action
		do
			go_to_lobby
			lobby.set_lobby_values (true, "112.14.4.124", "23112")
		end

	debug_table_action
		do
			go_to_table
		end

feature -- Implementation

	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text ("Are you sure you want to quit?")
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
				--TODO
					-- Restore the main UI which is currently minimized
--					if attached main_ui then
--						main_ui.restore
--						main_ui.remove_reference_to_game_window (Current)
--					end
				destroy
			end
		end

feature -- Access


	go_to_menu
		do
			prune_everything
			extend(menu)

			set_size (0, 0)
		end

	go_to_lobby
		do
			prune_everything
			extend(lobby)

			set_size (0, 0)
		end

	set_lobby_values(is_host: BOOLEAN; local_ip, local_port: STRING)
		require
			lobby /= Void
		do
			lobby.set_lobby_values (is_host, local_ip, local_port)
		end

	go_to_table
		do
			prune_everything
			extend(table)

			set_size (0, 0)

			is_table := true
		end

	go_to_waiting(a_string: STRING)
		do
			prune_everything
			create waiting.make_with_string(Current, a_string)
			extend(waiting)

			set_size (0, 0)
		end

	is_table: BOOLEAN

	is_at_table: BOOLEAN
		do
			Result := is_table
		end

	prune_everything
		do
			prune_all(menu)
			prune_all(lobby)
			prune_all(table)
			prune_all(debug_menu)
			prune_all(waiting)
		end



feature {NONE} -- Attributes

	menu: TR_WINDOW_MENU
	lobby: TR_WINDOW_LOBBY
	table: TR_WINDOW_TABLE
	waiting: TR_WINDOW_WAITING

	controller: TR_CONTROLLER


end
