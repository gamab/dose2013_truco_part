note
	description: "Summary description for {TR_GUI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_GUI

create
	make


feature
	make(a_controller: TR_CONTROLLER)
		do
			controller := a_controller

--			create mainwindow.make(Current)
--			mainwindow.show
		end

feature -- Attributes

	controller: TR_CONTROLLER

feature {TR_CONTROLLER, TR_LAUNCHER}

	mainwindow: TR_MAINWINDOW
			-- `tr_mainwindow'

	add_chatline(line: TR_CHAT_LINE)
		do

		end


	player_played_card(player: TR_PLAYER; card: TR_CARD)
		do
			--Call table-window to visualize the card played
		end

	player_called_truco(player: TR_PLAYER)
		do
			--Call table-window to visualize the truco
		end

	player_called_retruco(player: TR_PLAYER)
		do
			--Call table-window to visualize the truco
		end

	player_called_vale_cuatro(player: TR_PLAYER)
		do
			--Call table-window to visualize the truco
		end

	player_called_envido(player: TR_PLAYER)
		do
			--Call table-window to visualize the envido
		end

	player_called_real_envido(player: TR_PLAYER)
		do
			--Call table-window to visualize the envido
		end

	player_called_falta_envido(player: TR_PLAYER)
		do
			--Call table-window to visualize the envido
		end

	player_called_quiero(player: TR_PLAYER)
		do
			--Call table-window to visualize the envido
		end

	player_called_noquiero(player: TR_PLAYER)
		do
			--Call table-window to visualize the envido
		end

	init_lobby(players:LIST[TR_PLAYER]) -- All Players
		do

		end

	player_joined_lobby(player: TR_PLAYER)
		do

		end

	player_left_lobby(player:TR_PLAYER)
		do

		end

	player_change_team(player: TR_PLAYER; team: INTEGER) -- team player has changed to
		do

		end

	init_game()
		do

		end



feature
	--TR_WINDOW_MENU options:
	host_button_clicked (name: STRING)
		do
			mainwindow.go_to_waiting ("Creating game...")
			--controller.gui_host_game (name)
			-- wait for success
			--mainwindow.go_to_lobby
		end

	join_button_clicked (name: STRING; ip: STRING; port: INTEGER)
		local
			l_addr: INET4_ADDRESS
			l_dot: STRING
			l_ip_list: LIST[STRING]
			l_ip_array: ARRAY[NATURAL_8]
			l_i: INTEGER
		do
			mainwindow.go_to_waiting ("Joining game...")
			l_dot := "."
			l_ip_list := ip.split (l_dot.character_32_item (1))
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
			create l_addr.make_from_host_and_address (name, l_ip_array)
			--controller.gui_join_game (name, l_addr, port)
			-- wait for success

		end

	exit_button_clicked
		do
			mainwindow.request_close_window
		end

	--TODO:
	--Event handlers for all buttons able to be clicked on!
end
