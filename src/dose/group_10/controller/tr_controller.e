note
	description: "Summary description for {TR_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_CONTROLLER

create
	make

feature

	make
		require
		local
			l_local_player_dummy: TR_PLAYER
				-- dummy object to allow for testing
			thread_env: THREAD_ENVIRONMENT
		do
			initialize_action_lists



			create net_constants.make

			create client.make_with_less_param(Current)
			create logic.make
			create mainwindow.make(Current)
			mainwindow.show
			-- receive_network_chat_update(create {TR_CHAT_LINE}.make_filled(local_player, "hello from controller"))
			-- test observer pattern

			create thread_env
			print ("controller make: " + thread_env.current_thread_id.out + "%N")

			start_network_polling_timer


			--TEST
			-- only for testing purposes, remove later on --
			create l_local_player_dummy.make (1, 1)
			l_local_player_dummy.set_player_name ("test-player")
			local_player := l_local_player_dummy


			make_test_window
			------------------------------------------------
			--TEST
		end

feature {NONE}	--TESTING	

	text_field_game_state_action: EV_TEXT_FIELD
	text_field_game_state_who_bet: EV_TEXT_FIELD
	text_field_game_state_whos_turn: EV_TEXT_FIELD
	check_btn_played_card: EV_CHECK_BUTTON

	horizontal_box: EV_HORIZONTAL_BOX
	vertical_box: EV_VERTICAL_BOX

	scrollable_area: EV_SCROLLABLE_AREA

	changable_area: EV_FRAME


	make_test_window
		local
			test_window: EV_TITLED_WINDOW

			go_to_frame: EV_FRAME
			go_to_box: EV_VERTICAL_BOX

		do
			create test_window.make_with_title ("GUI Debug Menu")
			test_window.set_minimum_size (350, 400)
			test_window.show


			create vertical_box
			create go_to_frame.make_with_text ("Go to window")
			vertical_box.extend (go_to_frame)
			vertical_box.disable_item_expand (go_to_frame)
			test_window.extend (vertical_box)

			create go_to_box
			go_to_box.extend (create {EV_BUTTON}.make_with_text_and_action ("Menu window", agent test_go_to_menu))
			go_to_box.extend (create {EV_BUTTON}.make_with_text_and_action ("Lobby window", agent test_go_to_lobby))
			go_to_box.extend (create {EV_BUTTON}.make_with_text_and_action ("Table window", agent test_go_to_table))
			go_to_box.extend (create {EV_BUTTON}.make_with_text_and_action ("Waiting window", agent test_go_to_waiting))
			go_to_frame.extend (go_to_box)

			create changable_area
			vertical_box.extend (changable_area)

		end

	lobby_options: EV_VERTICAL_BOX

	lobby_player_options: EV_VERTICAL_BOX

	lobby_player_boxes: ARRAY[EV_HORIZONTAL_BOX]
	lobby_player_enableds: ARRAY[EV_CHECK_BUTTON]
	lobby_player_names: ARRAY[EV_TEXT_FIELD]
	lobby_player_rdys: ARRAY[EV_CHECK_BUTTON]
	lobby_player_teams: ARRAY[EV_COMBO_BOX]

	local_player_id_box: EV_HORIZONTAL_BOX
	local_player_id: EV_COMBO_BOX
	local_player_is_host: EV_CHECK_BUTTON
	host_ip_box: EV_HORIZONTAL_BOX
	host_ip: EV_TEXT_FIELD
	host_port_box: EV_HORIZONTAL_BOX
	host_port: EV_TEXT_FIELD



	add_lobby_options_to_debug_window
		local
			players_frame: EV_FRAME

			i: INTEGER
		do
			changable_area.set_text ("Lobby Options")
			create lobby_options
			changable_area.extend(lobby_options)

			create local_player_id_box
			lobby_options.extend (local_player_id_box)
			lobby_options.disable_item_expand (local_player_id_box)

			local_player_id_box.extend(create {EV_LABEL}.make_with_text ("Local player id"))
			create local_player_id
			local_player_id.disable_edit
			local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("3"))
			local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("4"))
			local_player_id_box.extend (local_player_id)

			create local_player_is_host.make_with_text ("Is local player host?")
			lobby_options.extend (local_player_is_host)
			lobby_options.disable_item_expand (local_player_is_host)


			create host_ip_box
			lobby_options.extend (host_ip_box)
			lobby_options.disable_item_expand(host_ip_box)
			host_ip_box.extend (create {EV_LABEL}.make_with_text ("Host IP:"))
			create host_ip.make_with_text ("127.0.0.1")
			host_ip_box.extend (host_ip)

			create host_port_box
			lobby_options.extend (host_port_box)
			lobby_options.disable_item_expand(host_port_box)
			host_port_box.extend (create {EV_LABEL}.make_with_text ("Host port:"))
			create host_port.make_with_text ("6666")
			host_port_box.extend (host_port)


			create players_frame.make_with_text ("Players")
			lobby_options.extend (players_frame)
			create lobby_player_options
			players_frame.extend (lobby_player_options)



			create lobby_player_boxes.make (1, 4)
			create lobby_player_enableds.make (1, 4)
			create lobby_player_names.make (1, 4)
			create lobby_player_rdys.make (1, 4)
			create lobby_player_teams.make (1, 4)

			from i:= 1 until i=5 loop
				lobby_player_boxes.force (create {EV_HORIZONTAL_BOX}, i)
				lobby_player_enableds.force (create {EV_CHECK_BUTTON}.make_with_text ("Enabled"), i)
				lobby_player_names.force (create {EV_TEXT_FIELD}.make_with_text ("player" + i.out), i)
				lobby_player_rdys.force (create {EV_CHECK_BUTTON}.make_with_text ("Ready-state"), i)
				lobby_player_teams.force (create {EV_COMBO_BOX}, i)
				lobby_player_teams.at (i).extend (create {EV_LIST_ITEM}.make_with_text ("1"))
				lobby_player_teams.at (i).extend (create {EV_LIST_ITEM}.make_with_text ("2"))
				lobby_player_teams.at (i).disable_edit

				lobby_player_boxes.at (i).extend(lobby_player_enableds.at (i))
				lobby_player_boxes.at (i).extend(lobby_player_names.at (i))
				lobby_player_boxes.at (i).extend(lobby_player_rdys.at (i))
				lobby_player_boxes.at (i).extend(lobby_player_teams.at (i))

				lobby_player_options.extend(lobby_player_boxes.at (i))
				lobby_player_options.disable_item_expand (lobby_player_boxes.at (i))
				i:=i+1
			end

			lobby_options.extend (create {EV_BUTTON}.make_with_text_and_action ("Send dummy-state to GUI", agent test_dummy_lobby_state))
		end

	table_options: EV_VERTICAL_BOX
	table_local_player_id_box: EV_HORIZONTAL_BOX
	table_local_player_id: EV_COMBO_BOX
	table_whos_turn_box: EV_HORIZONTAL_BOX
	table_whos_turn: EV_COMBO_BOX
	team_1_score_box: EV_HORIZONTAL_BOX
	team_1_score: EV_TEXT_FIELD
	team_2_score_box: EV_HORIZONTAL_BOX
	team_2_score: EV_TEXT_FIELD

	table_players_frame: EV_FRAME
	table_player_options: EV_VERTICAL_BOX

	table_player_boxes: ARRAY[EV_HORIZONTAL_BOX]
	table_player_names: ARRAY[EV_TEXT_FIELD]
	table_player_teams: ARRAY[EV_COMBO_BOX]
	table_player_cards1: ARRAY[EV_COMBO_BOX]
	table_player_cards2: ARRAY[EV_COMBO_BOX]
	table_player_cards3: ARRAY[EV_COMBO_BOX]
	table_player_cards4: ARRAY[EV_COMBO_BOX]


	table_has_action: EV_CHECK_BUTTON
	table_action_type_box: EV_HORIZONTAL_BOX
	table_action_type: EV_COMBO_BOX

	table_actions_frame: EV_FRAME
	table_actions_options: EV_VERTICAL_BOX

	table_who_caused_action_box: EV_HORIZONTAL_BOX
	table_who_caused_action: EV_COMBO_BOX

	table_bet_value_box: EV_HORIZONTAL_BOX
	table_bet_value: EV_TEXT_FIELD

	table_round1_won_box: EV_HORIZONTAL_BOX
	table_round1_won: EV_COMBO_BOX
	table_round2_won_box: EV_HORIZONTAL_BOX
	table_round2_won: EV_COMBO_BOX

	add_table_options_to_debug_window
		local
			i: INTEGER
		do
			changable_area.set_text ("Truco Table Options")
			create table_options
			changable_area.extend(table_options)

			--Local player ID
			create table_local_player_id_box
			table_options.extend (table_local_player_id_box)
			table_options.disable_item_expand (table_local_player_id_box)
			table_local_player_id_box.extend(create {EV_LABEL}.make_with_text ("Local player id"))
			create table_local_player_id
			table_local_player_id.disable_edit
			table_local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			table_local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			table_local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("3"))
			table_local_player_id.extend (create {EV_LIST_ITEM}.make_with_text ("4"))
			table_local_player_id_box.extend (table_local_player_id)

			--Whos turn is it
			create table_whos_turn_box
			table_options.extend (table_whos_turn_box)
			table_options.disable_item_expand (table_whos_turn_box)
			table_whos_turn_box.extend(create {EV_LABEL}.make_with_text ("Whos turn is it:"))
			create table_whos_turn
			table_whos_turn.disable_edit
			table_whos_turn.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			table_whos_turn.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			table_whos_turn.extend (create {EV_LIST_ITEM}.make_with_text ("3"))
			table_whos_turn.extend (create {EV_LIST_ITEM}.make_with_text ("4"))
			table_whos_turn_box.extend (table_whos_turn)

			--Team 1 score
			create team_1_score_box
			table_options.extend (team_1_score_box)
			table_options.disable_item_expand(team_1_score_box)
			team_1_score_box.extend (create {EV_LABEL}.make_with_text ("Team 1 score:"))
			create team_1_score.make_with_text ("0")
			team_1_score_box.extend (team_1_score)

			--Team 2 score
			create team_2_score_box
			table_options.extend (team_2_score_box)
			table_options.disable_item_expand(team_2_score_box)
			team_2_score_box.extend (create {EV_LABEL}.make_with_text ("Team 2 score:"))
			create team_2_score.make_with_text ("0")
			team_2_score_box.extend (team_2_score)

			--Round 1 won
			create table_round1_won_box
			table_options.extend (table_round1_won_box)
			table_options.disable_item_expand (table_round1_won_box)
			table_round1_won_box.extend(create {EV_LABEL}.make_with_text ("Who won round 1:"))
			create table_round1_won
			table_round1_won.disable_edit
			table_round1_won.extend (create {EV_LIST_ITEM}.make_with_text ("NONE"))
			table_round1_won.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			table_round1_won.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			table_round1_won_box.extend (table_round1_won)

			--Round 2 won
			create table_round2_won_box
			table_options.extend (table_round2_won_box)
			table_options.disable_item_expand (table_round2_won_box)
			table_round2_won_box.extend(create {EV_LABEL}.make_with_text ("Who won round 2:"))
			create table_round2_won
			table_round2_won.disable_edit
			table_round2_won.extend (create {EV_LIST_ITEM}.make_with_text ("NONE"))
			table_round2_won.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			table_round2_won.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			table_round2_won_box.extend (table_round2_won)

			--Players frame
			create table_players_frame.make_with_text ("Players")
			table_options.extend (table_players_frame)
			table_options.disable_item_expand (table_players_frame)
			create table_player_options
			table_players_frame.extend (table_player_options)

			create table_player_boxes.make (1, 4)
			create table_player_names.make (1, 4)
			create table_player_teams.make (1, 4)
			create table_player_cards1.make (1, 4)
			create table_player_cards2.make (1, 4)
			create table_player_cards3.make (1, 4)
			create table_player_cards4.make (1, 4)

			from i:= 1 until i=5 loop
				table_player_boxes.force (create {EV_HORIZONTAL_BOX}, i)
				table_player_names.force (create {EV_TEXT_FIELD}.make_with_text ("player" + i.out), i)
				table_player_teams.force (create {EV_COMBO_BOX}, i)
				table_player_teams.at(i).extend (create {EV_LIST_ITEM}.make_with_text ("1"))
				table_player_teams.at(i).extend (create {EV_LIST_ITEM}.make_with_text ("2"))

				table_player_cards1.force (create {EV_COMBO_BOX}, i)
				table_player_cards1.at (i).disable_edit
				from test_cards.start until test_cards.after loop
					table_player_cards1.at (i).extend (create {EV_LIST_ITEM}.make_with_text (test_cards.item_for_iteration))
					test_cards.forth
				end
				table_player_cards2.force (create {EV_COMBO_BOX}, i)
				table_player_cards2.at (i).disable_edit
				from test_cards.start until test_cards.after loop
					table_player_cards2.at (i).extend (create {EV_LIST_ITEM}.make_with_text (test_cards.item_for_iteration))
					test_cards.forth
				end
				table_player_cards3.force (create {EV_COMBO_BOX}, i)
				table_player_cards3.at (i).disable_edit
				from test_cards.start until test_cards.after loop
					table_player_cards3.at (i).extend (create {EV_LIST_ITEM}.make_with_text (test_cards.item_for_iteration))
					test_cards.forth
				end
				table_player_cards4.force (create {EV_COMBO_BOX}, i)
				table_player_cards4.at (i).disable_edit
				from test_cards.start until test_cards.after loop
					table_player_cards4.at (i).extend (create {EV_LIST_ITEM}.make_with_text (test_cards.item_for_iteration))
					test_cards.forth
				end

				table_player_boxes.at (i).extend(table_player_names.at (i))
				table_player_boxes.at (i).extend(table_player_teams.at (i))
				table_player_boxes.at (i).extend(table_player_cards1.at (i))
				table_player_boxes.at (i).extend(table_player_cards2.at (i))
				table_player_boxes.at (i).extend(table_player_cards3.at (i))
				table_player_boxes.at (i).extend(table_player_cards4.at (i))

				table_player_options.extend(table_player_boxes.at (i))
				table_player_options.disable_item_expand (table_player_boxes.at (i))
				i:=i+1
			end



			--Action frame
			create table_actions_frame.make_with_text("Action options")
			table_options.extend (table_actions_frame)
			table_options.disable_item_expand (table_actions_frame)
			create table_actions_options
			table_actions_frame.extend(table_actions_options)

			--Has action?
			create table_has_action.make_with_text ("Is action  performed?")
			table_actions_options.extend(table_has_action)

			--Action type
			create table_action_type_box
			table_actions_options.extend (table_action_type_box)
			table_action_type_box.extend (create {EV_LABEL}.make_with_text ("Type of action:"))
			create table_action_type
			table_action_type.disable_edit
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("truco"))
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("retruco"))
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("vallecuatro"))
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("envido"))
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("realenvido"))
			table_action_type.extend (create {EV_LIST_ITEM}.make_with_text ("faltaenvido"))
			table_action_type_box.extend (table_action_type)

			--Who caused action
			create table_who_caused_action_box
			table_actions_options.extend (table_who_caused_action_box)
			table_actions_options.disable_item_expand(table_who_caused_action_box)
			table_who_caused_action_box.extend (create {EV_LABEL}.make_with_text ("Who caused action:"))
			create table_who_caused_action
			table_who_caused_action.disable_edit
			table_who_caused_action.extend (create {EV_LIST_ITEM}.make_with_text ("1"))
			table_who_caused_action.extend (create {EV_LIST_ITEM}.make_with_text ("2"))
			table_who_caused_action.extend (create {EV_LIST_ITEM}.make_with_text ("3"))
			table_who_caused_action.extend (create {EV_LIST_ITEM}.make_with_text ("4"))
			table_who_caused_action_box.extend (table_who_caused_action)

			--Bet value
			create table_bet_value_box
			table_actions_options.extend(table_bet_value_box)
			table_bet_value_box.extend (create {EV_LABEL}.make_with_text ("Action (envido) value:"))
			create table_bet_value.make_with_text("0")
			table_bet_value_box.extend(table_bet_value)

			table_options.extend (create {EV_BUTTON}.make_with_text_and_action ("Send dummy-state to GUI", agent test_game_state_to_table))
		end

	test_cards: ARRAYED_LIST[STRING]
		-- create the allowed emotes
		local
			l_cards: ARRAYED_LIST[STRING]

			type: STRING
			val: INTEGER

			i,j:INTEGER
		once
			create l_cards.make (41) --0 is no card

			l_cards.force ("NOCARD 0")

			from i:=0 until i= 4 loop
				inspect i
				when 0 then type := "swords"
				when 1 then type := "cups"
				when 2 then type := "golds"
				when 3 then type := "clubs"
				end

				from j:=1 until j=11 loop
					val := j
					if j > 7 then val := j + 2 end
					l_cards.force(type + " " + val.out)
					j:=j+1
				end
				i:=i+1
			end

			Result :=l_cards
		end




	test_dummy_lobby_state
		local
			l_lobby_state: TR_SERVER_PLAYER_ARRAY
			test_server_player: TR_SERVER_PLAYER
			i:INTEGER
		do
			create l_lobby_state.make_empty

			--Players
			from i:= 1 until i=5 loop
				if lobby_player_enableds.at (i).is_selected then
					create test_server_player.make_complete (lobby_player_names.at (i).text, lobby_player_teams.at (i).selected_item.text.to_integer, void, 1, false)
					test_server_player.change_ready_state (lobby_player_rdys.at (i).is_selected)
					l_lobby_state.force (test_server_player, l_lobby_state.count)
				end
				i:=i+1
			end


			--Lobby/controller settings
			if local_player_id.selected_item.text.to_integer <= l_lobby_state.count then
				local_player.set_player_name (l_lobby_state.at (local_player_id.selected_item.text.to_integer - 1).name)
			else
				local_player.set_player_name("")
			end
			mainwindow.set_lobby_values (local_player_is_host.is_selected, host_ip.text, host_port.text)


			handle_network_lobby_state_update (l_lobby_state)
		end

	test_game_state_to_table
		local
			l_game_state: TR_GAME_STATE

			l_card: TR_CARD
			l_cards: ARRAY[TR_CARD]
			l_player: TR_PLAYER
			l_players: ARRAY[TR_PLAYER]
			l_char: CHARACTER
			l_string: STRING


			i: INTEGER
		do
			create l_game_state.make

			--Whos turn is it
			l_game_state.set_the_player_turn_id (table_whos_turn.selected_item.text.to_integer)

			--Who won what round
			if table_round1_won.selected_item.text.is_integer then
				l_game_state.set_round (table_round1_won.selected_item.text.to_integer, 1)
			end
			if table_round2_won.selected_item.text.is_integer then
				l_game_state.set_round (table_round2_won.selected_item.text.to_integer, 2)
			end

			--Players
			l_string := " "
			l_char := l_string.at (1)
			create l_players.make (0, 3)
			from i:=1 until i=5 loop
				create l_player.make (i, table_player_teams.at (i).selected_item.text.to_integer)
				l_player.set_player_name (table_player_names.at (i).text)

				if table_player_teams.at (i).selected_item.text.to_integer = 1 then
					l_player.set_player_team_score (team_1_score.text.to_integer)
				else
					l_player.set_player_team_score (team_2_score.text.to_integer)
				end


				create l_cards.make_filled (void, 0, 2)
				l_cards.enter (create {TR_CARD}.make (table_player_cards1.at (i).selected_item.text.split (l_char).first, table_player_cards1.at (i).selected_item.text.split (l_char).last.to_integer), 0)
				l_cards.enter (create {TR_CARD}.make (table_player_cards2.at (i).selected_item.text.split (l_char).first, table_player_cards2.at (i).selected_item.text.split (l_char).last.to_integer), 1)
				l_cards.enter (create {TR_CARD}.make (table_player_cards3.at (i).selected_item.text.split (l_char).first, table_player_cards3.at (i).selected_item.text.split (l_char).last.to_integer), 2)
				l_player.set_cards (l_cards)
				l_player.set_player_current_card (create {TR_CARD}.make (table_player_cards4.at (i).selected_item.text.split (l_char).first, table_player_cards4.at (i).selected_item.text.split (l_char).last.to_integer))

				l_players.enter (l_player, i-1)
				i:=i+1
			end
			l_game_state.set_all_players (l_players)

			--Have action
			if table_has_action.is_selected then l_game_state.set_action else l_game_state.remove_action end

			--Type of action
			l_game_state.set_current_bet(table_action_type.selected_item.text)

			--Who caused action
			l_game_state.set_who_bet_id (table_who_caused_action.selected_item.text.to_integer)

			--Envido value
			l_game_state.set_current_game_points (table_bet_value.text.to_integer)

			--Local player id
			local_player := l_players.at (table_local_player_id.selected_item.text.to_integer-1)

			handle_network_game_update (l_game_state)
		end

	test_background_work(str : STRING) : STRING
		local
			l_exev: EXECUTION_ENVIRONMENT
		do
			create l_exev
			Result := str + "AWESOME"
			l_exev.sleep (6000000000)
		end

	test_go_to_menu
		do
			changable_area.wipe_out
			changable_area.remove_text
			mainwindow.go_to_menu
		end

	test_go_to_lobby
		do
			changable_area.wipe_out
			add_lobby_options_to_debug_window
			mainwindow.go_to_lobby
		end

	test_go_to_table
		do
			changable_area.wipe_out
			add_table_options_to_debug_window
			mainwindow.go_to_table
		end

	test_go_to_waiting
		do
			changable_area.wipe_out
			changable_area.remove_text
			mainwindow.go_to_waiting ("Debug menu test..")
		end
	--TESTING

feature {ANY}

	mainwindow: TR_MAINWINDOW
	-- main window

	client: TR_CLIENT
	-- main network access

feature {NONE} -- Attributes

	server: TR_SERVER_THREAD
	-- for hosting a game

	logic: TR_LOGIC
	-- main logic API

	local_player: TR_PLAYER
	-- the local player

	ai_team: TR_AI
	-- the ai team if host

	network_update_timer: EV_TIMEOUT
	-- the timer for polling the network for updates

	host: BOOLEAN
	-- true if this is the host of a game

	net_constants: TR_NETWORK_CONSTANTS
		-- string constants used in network requests and responses

	latest_srv_playr_arr: TR_SERVER_PLAYER_ARRAY
		-- the most recent array of server players

	server_ip: INET_ADDRESS

	server_port: INTEGER

feature {NONE} -- Action lists

	chat_received_actions: LIST[PROCEDURE[ANY, TUPLE[TR_CHAT_LINE]]]
		-- when a chat message is received

	lobby_state_changed_actions: LIST[PROCEDURE[ANY, TUPLE[TR_SERVER_PLAYER_ARRAY]]]
		-- when the state of the players change

	join_response_actions: LIST[PROCEDURE[ANY, TUPLE[STRING]]]
		-- when the server has responded to the local player's join attempt

	host_response_actions: LIST[PROCEDURE[ANY, TUPLE[STRING]]]
		-- when the server thread has created a host or failed to create a host

	game_state_changed_actions: LIST[PROCEDURE[ANY, TUPLE[TR_GAME_STATE]]]
		-- when a new game state has been received from network

feature {NONE}
	produce_gui_state : TR_GUI_STATE
		local
			l_gui_state: TR_GUI_STATE
		do
			create l_gui_state.make

			-- set truco availability
			l_gui_state.truco_enabled := logic.is_truco_allowed (local_player)
			l_gui_state.retruco_enabled := logic.is_retruco_allowed (local_player)
			l_gui_state.vale_cuatro_enabled := logic.is_vale_cuatro_allowed (local_player)
			-- set envido availability
			l_gui_state.envido_enabled := logic.is_envido_allowed (local_player)
			l_gui_state.real_envido_enabled := logic.is_real_envido_allowed (local_player)
			l_gui_state.falta_envido_enabled := logic.is_falta_envido_allowed (local_player)
			Result := l_gui_state
		ensure
			Result /= Void
		end

	initialize_action_lists
		do
			chat_received_actions := create {ARRAYED_LIST[PROCEDURE[ANY, TUPLE[TR_CHAT_LINE]]]}.make (0)
			lobby_state_changed_actions := create {ARRAYED_LIST[PROCEDURE[ANY, TUPLE[TR_SERVER_PLAYER_ARRAY]]]}.make (0)
			join_response_actions := create {ARRAYED_LIST[PROCEDURE[ANY, TUPLE[STRING]]]}.make (0)
			host_response_actions := create {ARRAYED_LIST[PROCEDURE[ANY, TUPLE[STRING]]]}.make (0)
			game_state_changed_actions := create {ARRAYED_LIST[PROCEDURE[ANY, TUPLE[TR_GAME_STATE]]]}.make (0)
		end

	start_game(): STRING
		-- Initiaizes the game: creating player representations, dealing cards etc.
		-- Should only be called on the host machine.
		require
			players_valid: latest_srv_playr_arr /= Void and then latest_srv_playr_arr.count = 4 and then not latest_srv_playr_arr.all_default
			only_on_host: is_host
				-- require that no item is Void
		local
			l_i: INTEGER_32
			l_srv_player: TR_SERVER_PLAYER
			l_ply_id: INTEGER_32
			l_srv_resp: STRING
		do
			l_ply_id := 1


			produce_player_array
				-- set players in logic

			logic.new_hand
				-- shuffles deck etc

			Result := client.send_to_everyone (logic.get_current_game_state)
				-- broadcast own gamestate to clients (TODO: Blocking call)
		end

feature
	register_chat_received_action (action: PROCEDURE[ANY, TUPLE[TR_CHAT_LINE]])
		require
			action_not_void: action /= Void
		do
			chat_received_actions.extend (action)
		ensure
			is_registered: chat_received_actions.has (action)
		end

	register_lobby_state_change_action (action: PROCEDURE[ANY, TUPLE[TR_SERVER_PLAYER_ARRAY]])
		require
			action_not_void: action /= Void
		do
			lobby_state_changed_actions.extend (action)
		ensure
			is_registered: lobby_state_changed_actions.has (action)
		end

	register_join_response_action (action: PROCEDURE[ANY, TUPLE[STRING]])
		require
			action_not_void: action /= Void
		do
			join_response_actions.extend (action)
		ensure
			is_registered: join_response_actions.has (action)
		end

	register_host_response_action (action: PROCEDURE[ANY, TUPLE[STRING]])
		require
			action_not_void: action /= Void
		do
			host_response_actions.extend (action)
		ensure
			is_registered: host_response_actions.has (action)
		end

	register_game_state_changed_action (action: PROCEDURE[ANY, TUPLE[TR_GAME_STATE]])
		require
			action_not_void: action /= Void
		do
			game_state_changed_actions.extend (action)
		ensure
			is_registered: game_state_changed_actions.has (action)
		end

feature {NONE} -- Network handling

	start_network_polling_timer
		-- starts the timer that periodically polls the network client for updates
		do
			create network_update_timer.make_with_interval (250)
			network_update_timer.actions.extend (agent poll_network)
		end

	stop_network_polling_timer
		-- stops the network polling timer and sets its reference to Void
		do
			network_update_timer.set_interval (0)
			network_update_timer := Void
		end

	poll_network
		-- poll the network client once for new updates. This is run by the timer
		local
			thread_env: THREAD_ENVIRONMENT
			l_chat: LIST[TR_CHAT_LINE]
			l_gamestate: TR_GAME_STATE
			l_lobby: TR_SERVER_PLAYER_ARRAY
			l_player: TR_SERVER_PLAYER
		do
			--create thread_env
			--print ("poll_network: " + (thread_env.current_thread_id).out + "%N")

			-- get chat update
			l_chat := client.get_last_messages
			if l_chat /= Void and then l_chat.count > 0 then
				from l_chat.start until l_chat.exhausted loop
					handle_network_chat_update (l_chat.item)
					l_chat.forth
				end
			end

			-- get game update
			l_gamestate := client.get_last_game_state
			if l_gamestate /= Void then
				handle_network_game_update (l_gamestate)
			end

			-- get lobby update
			l_lobby := client.get_last_array_of_players
			if l_lobby /= Void then
				latest_srv_playr_arr := l_lobby
					-- store latest update

				l_player := l_lobby[l_lobby.lower]
				if l_player.name.is_equal (local_player.get_player_name) then
					set_host (true)
				end

				handle_network_lobby_state_update (l_lobby)
			end
		end

	handle_network_game_update(updated_game_state: TR_GAME_STATE)
		-- receive an update game state from the network
		require
			updated_game_state_not_void: updated_game_state /= Void
			-- action /= Void
		local
			i:INTEGER
		do
			if not mainwindow.is_at_table then
				mainwindow.go_to_table
			end


			-- set local player
			from i:=0 until i=4 loop
				if updated_game_state.get_all_players.at (i).get_player_name.is_equal (local_player.get_player_name) then
					local_player := updated_game_state.get_all_players[i]
					i:=3
				end
				i:=i+1
			end

			-- call logic with updated state
			logic.set_current_game_state (updated_game_state)

			-- invoke ai
			invoke_ai ()

			-- call any listeners (e.g. GUI)
			from game_state_changed_actions.start
			until game_state_changed_actions.exhausted
			loop
				game_state_changed_actions.item.call ([logic.get_current_game_state])
				game_state_changed_actions.forth
			end
		end

	handle_network_chat_update(chat_line: TR_CHAT_LINE)
		-- notifies all observers of the chat update
		require
			chat_line_not_void: chat_line /= Void
		do
			from chat_received_actions.start
			until chat_received_actions.exhausted
			loop
				chat_received_actions.item.call ([chat_line])
				chat_received_actions.forth
			end
		end

	handle_network_lobby_state_update(lobby_state: TR_SERVER_PLAYER_ARRAY)
		-- notifies all observers of the lobby update
		require
			lobby_update_not_void: lobby_state /= Void
		do
			from lobby_state_changed_actions.start
			until lobby_state_changed_actions.exhausted
			loop
				lobby_state_changed_actions.item.call ([lobby_state])
				lobby_state_changed_actions.forth
			end
		end

	handle_network_join_response(response: STRING)
		-- notifies all observers of the join response
		require
			join_response_not_void: response /= Void
		do
			from join_response_actions.start
			until join_response_actions.exhausted
			loop
				join_response_actions.item.call ([response])
				join_response_actions.forth
			end
		end

	handle_network_host_response(response: STRING)
		-- notifies all observers of the host response
		require
			host_response_not_void: response /= Void
		do
			from host_response_actions.start
			until host_response_actions.exhausted
			loop
				host_response_actions.item.call ([response])
				host_response_actions.forth
			end
		end

feature {NONE} -- Network send

	send_network_game_update(updated_game_state: TR_GAME_STATE)
		require
		local
			l_srv_response: STRING
				-- response from server
		do
			l_srv_response := client.send_to_everyone (updated_game_state)

			if l_srv_response.is_equal (net_constants.response_codes.send_update_success) then
				-- success
			end
		end

	send_network_chat_update(chat_line: TR_CHAT_LINE; is_private: BOOLEAN)
		require
			chat_line_not_void: chat_line /= Void
		local
			l_srv_response: STRING
			l_bg: TR_BACKGROUND_TASK
			l_func: FUNCTION[ANY, TUPLE, ANY]
		do
--			l_func := agent test_background_work ("stuff is ")

--			create l_bg.make_with_function (l_func, 3000)

--			print("TR_CONTROLLER initial call is on thread id: " + l_bg.current_thread_id.out)
--			l_bg.launch

			-- send chat line to network
			l_srv_response := client.send_line_to_server (chat_line, is_private)

			if l_srv_response.is_equal (net_constants.response_codes.send_update_success) then
				-- success
			end
		end

	send_network_change_team_update(new_team: INTEGER)
		local
			l_srv_response: STRING
		do
			l_srv_response := client.change_team (local_player.get_player_name, new_team)
			print (l_srv_response + "%N")

			if l_srv_response.is_equal(net_constants.response_codes.change_team_success) then
				--start_network_polling_timer
			end
		end

	send_network_change_ready_state_update(a_ready_state: BOOLEAN)
		local
			l_srv_response: STRING
		do
			l_srv_response := client.send_change_ready_state_request_to_server (local_player.get_player_name, a_ready_state)

			if l_srv_response.is_equal (net_constants.response_codes.change_ready_success) then
				--start_network_polling_timer
			end
		end

feature {ANY} -- GUI events

--Main menu functions

	gui_host_game(players_name: STRING)
		require
			--local_player_void: local_player = Void
		local
			l_ip: ARRAY[NATURAL_8]
		do
			-- set is_host to true
			--set_host (true)

			-- start server thread
			create server.make_server_with_controller (Current)
			server.launch

			mainwindow.go_to_waiting ("Now hosting.")

			mainwindow.go_to_waiting ("Now hosting.%NIP: " + server.get_address + "%N" + "Port: " + server.get_listening_port.out + "%N")
--			mainwindow.set_lobby_values (true, "127.0.0.1", "1234")

--			-- join the locally hosted game
--			create l_ip.make_empty
--			l_ip.force (127, 1)
--			l_ip.force (0, 2)
--			l_ip.force (0, 3)
--			l_ip.force (1, 4)
--			gui_join_game (players_name, create {INET4_ADDRESS}.make_from_host_and_address ("localhost", l_ip), server.get_listening_port)
		ensure
--			local_player_initialized: local_player /= Void and then local_player.get_player_name = players_name

		end

	gui_join_game(players_name: STRING; srv_ip: INET_ADDRESS; srv_port: INTEGER_32) --(address: INET_ADDRESS)
		require
			--local_player_void: local_player = Void
		local
			l_player: TR_PLAYER
				-- player object reepresenting the player on this client
			l_join_response: STRING
			l_msg_box: EV_WARNING_DIALOG
		do
			-- l_player.make (a_player_id, 1)
				-- for now all players are assigned to team 1 by default.
			-- client.join_game (ip_server: INET_ADDRESS, port_server: INTEGER_32, name: STRING_8, team: INTEGER_32, ai: BOOLEAN)
			-- TODO ask Argentina to return a TR_PLAYER from join_game
			-- local_player = -- return value of join_game goes here

			server_ip := srv_ip
			server_port := srv_port

			-- create local player
			create local_player.make (1, 1)
			local_player.set_player_name (players_name)

			-- send join request
			create client.make_with_less_param (Current)
			l_join_response := client.send_join_game_request_to_server (srv_ip, srv_port, local_player.get_player_name, local_player.get_player_team_id, false)

			print (l_join_response + "%N")

			-- was the join successful?
			if l_join_response.is_equal (net_constants.response_codes.join_game_success) then
				mainwindow.go_to_lobby
				start_network_polling_timer
				--poll_network
			else
				create l_msg_box.make_with_text (l_join_response)
				l_msg_box.show_modal_to_window (mainwindow)
			end
		ensure
			local_player_initialized: local_player /= Void and then local_player.get_player_name = players_name
		end

	gui_leave_game()-- local player leaves game
		require
			client_not_void: client /= Void
			player_not_void: local_player /= Void
		local
			l_srv_response: STRING
		do
			-- stop polling the network
			stop_network_polling_timer

			-- send quit message
			l_srv_response := client.send_quit_connection_phase_request_to_server (local_player.get_player_name)

			-- reset local_player as we should get a new instance next time we start or join a game
			local_player := Void
		ensure
			local_player_destroyed: local_player = Void
		end

-- Lobby functions

	gui_change_team(new_team_id: INTEGER_32) -- local player changed team
		require
			new_team_id_valid: new_team_id >= 1 and then new_team_id <= 2
		local
			l_srv_response: STRING
		do
			local_player.set_player_team_id (new_team_id)

			-- send to network "this player has changed team"
			send_network_change_team_update (new_team_id)
		end

	gui_change_ready_state(a_ready_state: BOOLEAN)
		do
			-- send to network "this player has changed ready state"
			send_network_change_ready_state_update (a_ready_state)
		end

	gui_start_game()
		-- GUI event-request to start the game
		local
			l_srv_resp: STRING
				-- server's response to the start game request
		do
			l_srv_resp := client.send_start_game_request_to_server
				-- TODO this is a blocking network call...
			if l_srv_resp.is_equal(net_constants.response_codes.start_game_success) then
				l_srv_resp := start_game()
					-- produce and send game state
				if l_srv_resp.is_equal (net_constants.response_codes.send_update_success) then
					mainwindow.go_to_table

					-- TODO switch to table window
				elseif l_srv_resp.is_equal (net_constants.response_codes.send_update_fail_invalid_player) then
					-- TODO error handling
				elseif l_srv_resp.is_equal (net_constants.response_codes.send_update_fail_game_phase) then
					-- TODO error handling
				else
					-- TODO crash and burn
					print("Unknown server response code: " + l_srv_resp + "%N")
				end
			elseif l_srv_resp.is_equal (net_constants.response_codes.start_game_fail_invalid_teams) then
				-- TODO show proper error
			elseif l_srv_resp.is_equal (net_constants.response_codes.start_game_fail_not_enough_players) then
				-- TODO show proper error
			elseif l_srv_resp.is_equal (net_constants.response_codes.start_game_fail_players_not_ready) then
				-- TODO show proper error
			else
				-- TODO crash and burn
				print("Unknown server response code: " + l_srv_resp + "%N")
			end
		end

	gui_add_ai()
		-- add an ai team
		local
			l_join_response: STRING
			l_ready_response: STRING
			l_msg_box: EV_WARNING_DIALOG
			l_ai_team: INTEGER
			l_ip: ARRAY[NATURAL_8]
			l_ip_addr: INET4_ADDRESS
		do
			-- create ai team
			if local_player.get_player_team_id = 1 then
				l_ai_team := 2
			else
				l_ai_team := 1
			end

			create ai_team.make_ai_with_players ("difficult", 2, 4, l_ai_team)

			-- join server as ai
			l_join_response := client.send_join_game_request_to_server (server_ip, server_port, "AI 1", l_ai_team, true)
			l_join_response := client.send_join_game_request_to_server (server_ip, server_port, "AI 2", l_ai_team, true)

			print (l_join_response + "%N")

			-- was the join successful?
			if l_join_response.is_equal (net_constants.response_codes.join_game_success) then
				--start_network_polling_timer
				--poll_network

				-- set ai players ready
				l_ready_response := client.send_change_ready_state_request_to_server ("AI 1", true)
				l_ready_response := client.send_change_ready_state_request_to_server ("AI 2", true)
			else
				create l_msg_box.make_with_text (l_join_response)
				l_msg_box.show_modal_to_window (mainwindow)
			end
		end

--In-game/table functions

	gui_card_played(card: TR_CARD)
		require
			card /= Void
		do
			-- 1. call method on logic to update game state
			logic.play_card (card, local_player)
			-- 2. update gui according to logic - but doesn't the gui do this itself? Yes it does!
	--		moves_allowed (produce_gui_state)
			-- 3. send new game state to server
			send_network_game_update (logic.get_current_game_state)
		end

	gui_truco_played()
		require
			-- truco_allowed: logic.is_truco_allowed(local_player)
		do
			-- send info of truco played by local player to local logic
			logic.send_truco (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
		--	moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		end

	gui_retruco_played()
		require
			-- retruco_allowed: logic.is_retruco_allowed(local_player)
		do
			-- send info of retruco played by local player to local logic
			logic.send_re_truco (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		end

	gui_vale_cuatro_played()
		require
			-- vale_cuatro_allowed: logic.is_vale_cuatro_allowed(local_player)
		do
			-- send info of vale cuatro played by local player to local logic
			logic.send_valle_cuatro (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		end

	gui_envido_played()
		require
			--envido_allowed: logic.is_envido_allowed(local_player)
		do
			-- send info of envido played by local player to local logic
			logic.send_envido (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		end

	gui_real_envido_played()
		require
			-- real_envido_allowed: logic.is_real_envido_allowed(local_player)
		do
			-- send info of real envido played by local player to local logic
			logic.send_re_envido (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		ensure

		end

	gui_falta_envido_played()
		require
			--falta_envido_allowed: logic.is_falta_envido_allowed(local_player)
		do
			-- send info of falta envido played by local player to local logic
			logic.send_falta_envido (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		ensure

		end

	gui_quiero_played()
		require

		do
			-- send bet accept to logic
			logic.send_accept (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		ensure

		end

	gui_noquiero_played()
		require

		do
			-- send bet decline to logic
			logic.send_reject (local_player.get_player_team_id)
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		ensure

		end

	gui_end_round_played()
		require

		do
			-- send bet decline to logic
			logic.end_round
			-- update the local GUI such that it reflects the new game state
			moves_allowed (produce_gui_state)
			-- send the updated game state to the network
			send_network_game_update (logic.get_current_game_state)
		ensure

		end

	gui_chat_message_sent (a_message: TR_CHAT_LINE; is_private: BOOLEAN)
		-- a message was typed into the chat box and "send" was pressed
		require
			message_not_void: a_message /= Void
			message_not_empty: a_message.message.count > 0
			player_not_void: a_message.player /= Void
		do
			send_network_chat_update (a_message, is_private)

		end

	moves_allowed(gui_state: TR_GUI_STATE)
		do
			-- TODO enable/disable buttons according to gamestate
		end


feature --Access

	set_server_port(port: INTEGER)
		do

		end

	get_local_player: TR_PLAYER
		do
			Result := local_player
		end

	is_host: BOOLEAN
		do
			Result := host
		end

	set_host (a_boolean: BOOLEAN)
		do
			host := a_boolean
		end

feature {NONE}
	produce_player_array
		-- initializes 4 valid players and updates the initial game state with them
		local
			l_player: TR_PLAYER
			l_host_id: INTEGER
			l_srv_ply: TR_SERVER_PLAYER
			l_idx: INTEGER
			l_ply_id: INTEGER
		do
			-- create the host
			l_ply_id := 1
			l_idx := latest_srv_playr_arr.lower
			l_srv_ply := latest_srv_playr_arr[l_idx]
			logic.set_player_info (l_srv_ply.name, l_ply_id, l_srv_ply.team)
			logic.get_current_game_state.get_all_players[l_ply_id - 1].set_player_posistion (l_ply_id)

			-- create host's teammate
			l_ply_id := 3
			from l_idx := latest_srv_playr_arr.lower + 1
			until l_idx > latest_srv_playr_arr.upper
			loop
				l_srv_ply := latest_srv_playr_arr[l_idx]
				if l_srv_ply.team = latest_srv_playr_arr[latest_srv_playr_arr.lower].team then
					logic.set_player_info (l_srv_ply.name, l_ply_id, l_srv_ply.team)
					logic.get_current_game_state.get_all_players[l_ply_id - 1].set_player_posistion (l_ply_id)
				end
				l_idx := l_idx + 1
			end

			-- create host's first and second opponent
			l_ply_id := 2
			from l_idx := latest_srv_playr_arr.lower + 1
			until l_idx > latest_srv_playr_arr.upper
			loop
				l_srv_ply := latest_srv_playr_arr[l_idx]
				if l_srv_ply.team /= latest_srv_playr_arr[latest_srv_playr_arr.lower].team then
					logic.set_player_info (l_srv_ply.name, l_ply_id, l_srv_ply.team)
					logic.get_current_game_state.get_all_players[l_ply_id - 1].set_player_posistion (l_ply_id)
					l_ply_id := 4
				end
				l_idx := l_idx + 1
			end
		end

	invoke_ai
		local
			l_ai_1_action: BOOLEAN
			l_ai_2_action: BOOLEAN
		do
			if ai_team /= Void then
				-- update ai cards if we've started a new hand
				if logic.is_new_hand then
					ai_team.update_hand (logic.get_players[1], logic.get_players[3])
				end

				l_ai_1_action := logic.get_current_game_state.do_i_have_to_play (2) or logic.get_current_game_state.do_i_have_to_answer_a_bet (2)
				l_ai_2_action := logic.get_current_game_state.do_i_have_to_play (4) or logic.get_current_game_state.do_i_have_to_answer_a_bet (4)

				-- if either of the ai players can perform some action, invoke it
				if l_ai_1_action then
					ai_team.next_move (logic.get_current_game_state.get_all_players()[1].get_player_id, logic)
					-- send the updated game state to the network
					send_network_game_update (logic.get_current_game_state)
				end
				if l_ai_2_action then
					ai_team.next_move (logic.get_current_game_state.get_all_players()[3].get_player_id, logic)
					-- send the updated game state to the network
					send_network_game_update (logic.get_current_game_state)
				end
			end
		end

invariant
	--client_not_void: client /= Void
	--logic_not_void: logic /= Void
	--gui_not_void: gui /= Void

end
