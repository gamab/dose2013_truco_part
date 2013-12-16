note
	description: "Summary description for {TR_WINDOW_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_WINDOW_TABLE


inherit
	EV_HORIZONTAL_BOX

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

			controller := a_controller

			set_minimum_size (window_width, window_height)

			initialize_pictures

			init_chat_section
			extend(chat_section)

			disable_card_click := true

			-- register listener on controller to get game updates
			controller.register_game_state_changed_action (agent game_state_updated)
		end

	initialize_pictures
		local
			l_buffer: EV_PIXMAP
			l_bg: EV_PIXMAP
			l_bg_pic: EV_MODEL_PICTURE

			i,j:INTEGER


		do
			-- Initialize drawing area
			create area
			area.set_minimum_size (table_box_width, table_box_height)

			-- Initialize world/buffer/projector
			create world
			create l_buffer.make_with_size (table_box_width, table_box_height)
			create proj.make_with_buffer (world, l_buffer, area)

			-- Initialize background
			create l_bg
			l_bg.set_with_named_file (path_bg)
			create l_bg_pic.make_with_pixmap (l_bg)

			-- Initialize dealer button
			create l_dealer
			l_dealer.set_with_named_file (path_dealer)
			create l_dealer_pic.make_with_pixmap (l_dealer)
			l_dealer_pic.hide

			-- Initialize Round
			round_one_text := "Round 1:"
			round_two_text := "Round 2:"

			create round_won
			round_won.set_with_named_file(path_player_box_horizontal)

			create round_won_forgroundcolor.make_with_8_bit_rgb (255, 234, 74)
			round_won.set_foreground_color (round_won_forgroundcolor)

			round_won.draw_text_top_left (Round_won_one_text_x,Round_won_one_text_y, round_one_text)
			round_won.draw_text_top_left (Round_won_two_text_x,Round_won_two_text_y, round_two_text)



			create round_won_pic.make_with_pixmap(round_won)
			round_won_pic.set_point_position (Round_won_x, Round_won_y)

			create round_won_round_one
			round_won_round_one.set_with_named_file(path_round_not_played)
			create round_won_round_one_pic.make_with_pixmap(round_won_round_one)
			round_won_round_one_pic.set_point_position (Round_one_pos_x, Round_one_pos_y)

			create round_won_round_two
			round_won_round_two.set_with_named_file(path_round_not_played)
			create round_won_round_two_pic.make_with_pixmap(round_won_round_two)
			round_won_round_two_pic.set_point_position (Round_two_pos_x, Round_two_pos_y)


			-- Initialize Player information pixmap
			create player_info_pix_top.make_with_size (80, 128)
			create player_info_pix_right.make_with_size (128, 80)
			create player_info_pix_btm.make_with_size (80, 128)
			create player_info_pix_left.make_with_size (128, 80)

			-- Initialize Player information Model picture
			create player_info_model_top.make_with_pixmap (player_info_pix_top)
			create player_info_model_right.make_with_pixmap (player_info_pix_right)
			create player_info_model_btm.make_with_pixmap (player_info_pix_btm)
			create player_info_model_left.make_with_pixmap (player_info_pix_left)
			player_info_model_top.hide
			player_info_model_right.hide
			player_info_model_btm.hide
			player_info_model_left.hide

			-- Initialize cards
			create players_cards.make_filled (void, 0, 15)

			from i:=0 until i=4 loop
				from j:=0 until j=4 loop
					players_cards.enter (create {TR_GUI_CARD}.make_card (create {TR_CARD}.make ("swords", 1), i, false, get_position_for_card (i, j)), i*4 + j)
					players_cards[i*4 + j].hide	-- Hide cards - screen is clear from cards and can be reset with cards by invoking set_player_cards (player: TR_PLAYER)
					j:=j+1
				end
				i:=i+1
			end

			-- Set Player information Model Picture position
			player_info_model_top.set_point_position(top_player_box_x, top_player_box_y)
			player_info_model_right.set_point_position(right_player_box_x, right_player_box_y)
			player_info_model_btm.set_point_position(btm_player_box_x, btm_player_box_y)
			player_info_model_left.set_point_position(left_player_box_x, left_player_box_y)

			-- Set team color in player information sector
			create player_info_team_red
			player_info_team_red.set_with_named_file (path_info_team_color_red)
			create player_info_team_blue
			player_info_team_blue.set_with_named_file (path_info_team_color_blue)
			create player_info_team_top.make_with_pixmap (player_info_team_red)
			create player_info_team_right.make_with_pixmap (player_info_team_red)
			create player_info_team_btm.make_with_pixmap (player_info_team_red)
			create player_info_team_left.make_with_pixmap (player_info_team_red)
			player_info_team_top.set_point_position (player_info_color_top_x, player_info_color_top_y)
			player_info_team_right.set_point_position (player_info_color_right_x, player_info_color_right_y)
			player_info_team_btm.set_point_position (player_info_color_btm_x, player_info_color_btm_y)
			player_info_team_left.set_point_position (player_info_color_left_x, player_info_color_left_y)
			player_info_team_top.hide
			player_info_team_right.hide
			player_info_team_btm.hide
			player_info_team_left.hide

			-- click function - Move card to middle of table
			players_cards[BOTTOM*4].pointer_button_release_actions.extend (agent onclicked_card_btm_1(?,?,?,?,?,?,?,?))
			players_cards[BOTTOM*4 + 1].pointer_button_release_actions.extend (agent onclicked_card_btm_2(?,?,?,?,?,?,?,?))
			players_cards[BOTTOM*4 + 2].pointer_button_release_actions.extend (agent onclicked_card_btm_3(?,?,?,?,?,?,?,?))

			-- input pictures to world
			world.extend(l_bg_pic)
			world.extend(l_dealer_pic)


			from i:=0 until i=16 loop
				world.extend(players_cards[i])
				i:=i+1
			end

			-- Add Truco and Envido buttons
			add_truco_button
			add_envido_button
			set_truco_disable(true)
			set_envido_disable(true)

			world.extend (round_won_pic)
			world.extend (round_won_round_one_pic)
			world.extend (round_won_round_two_pic)

			world.extend (player_info_model_btm)
			world.extend (player_info_model_left)
			world.extend (player_info_model_right)
			world.extend (player_info_model_top)

			world.extend (player_info_team_top)
			world.extend (player_info_team_left)
			world.extend (player_info_team_btm)
			world.extend (player_info_team_right)

			-- project the world
			extend(area)

			proj.project
		end


feature -- Implementation

	-- Set Reset round won
	set_round_won_reset()
	do
		round_won_round_one.set_with_named_file(path_round_not_played)
		create round_won_round_one_pic.make_with_pixmap(round_won_round_one)
		round_won_round_one_pic.set_point_position (Round_one_pos_x, Round_one_pos_y)

		round_won_round_two.set_with_named_file(path_round_not_played)
		create round_won_round_two_pic.make_with_pixmap(round_won_round_two)
		round_won_round_two_pic.set_point_position (Round_two_pos_x, Round_two_pos_y)
	end

	-- Set round won one
	set_round_won_one(team: INTEGER)
	do
		inspect team
			when 1 then
			round_won_round_one.set_with_named_file(path_info_team_color_red)
			create round_won_round_one_pic.make_with_pixmap(round_won_round_one)
			round_won_round_one_pic.set_point_position (Round_one_pos_x, Round_one_pos_y)

			when 2 then
			round_won_round_one.set_with_named_file(path_info_team_color_blue)
			create round_won_round_one_pic.make_with_pixmap(round_won_round_one)
			round_won_round_one_pic.set_point_position (Round_one_pos_x, Round_one_pos_y)
		end
	end

	-- Set round won two
	set_round_won_two(team: INTEGER)
	do
		inspect team
			when 1 then
			round_won_round_two.set_with_named_file(path_info_team_color_red)
			create round_won_round_two_pic.make_with_pixmap(round_won_round_two)
			round_won_round_two_pic.set_point_position (Round_two_pos_x, Round_two_pos_y)

			when 2 then
			round_won_round_two.set_with_named_file(path_info_team_color_blue)
			create round_won_round_two_pic.make_with_pixmap(round_won_round_two)
			round_won_round_two_pic.set_point_position (Round_two_pos_x, Round_two_pos_y)
		end
	end

	set_player_direction(player:TR_PLAYER; direction: INTEGER)
	-- direction is as follows {TOP = 0, RIGHT = 1, BOTTOM = 2, LEFT = 3}
	do
		inspect player.get_player_id
			when 1 then player_1_direction := direction
			when 2 then player_2_direction := direction
			when 3 then player_3_direction := direction
			when 4 then player_4_direction := direction
		end
	end

	get_player_direction(player:TR_PLAYER):INTEGER
	do
		inspect player.get_player_id
			when 1 then result := player_1_direction
			when 2 then result := player_2_direction
			when 3 then result := player_3_direction
			when 4 then result := player_4_direction
		end
	end

	Set_dealer_position(player:TR_PLAYER)
	local
		direction: INTEGER
	do
		direction := get_player_direction (player)
		l_dealer_pic.show
		inspect direction
		when TOP then l_dealer_pic.set_point_position (Top_dealer_x, Top_dealer_y)
		when RIGHT then l_dealer_pic.set_point_position (Right_dealer_x, Right_dealer_y)
		when BOTTOM then l_dealer_pic.set_point_position (Btm_dealer_x, Btm_dealer_y)
		when LEFT then l_dealer_pic.set_point_position (Left_dealer_x, Left_dealer_y)
		end
	end

	set_disable_card_click(value:BOOLEAN)
		do
			disable_card_click := value
		end

	set_player_information(player:TR_PLAYER)
		local
			direction: INTEGER
			team: INTEGER

			l_font_name: EV_FONT
			l_font_score: EV_FONT
			l_color: EV_COLOR
		do
			direction := get_player_direction (player)
			team := player.get_player_team_id

			create l_font_name.make_with_values (1, 8, 10, 14)
			create l_font_score.make_with_values (1, 6, 10, 14)
			create l_color.make_with_8_bit_rgb (255, 234, 74)




			inspect direction
			when TOP then
				create player_info_pix_top.make_with_size(128, 80)
				player_info_pix_top.set_font (l_font_name)
				player_info_pix_top.set_foreground_color (l_color)
				player_info_pix_top.set_with_named_file (path_player_box_horizontal)
				player_info_pix_top.draw_text_top_left (top_player_name_x, top_player_name_y, player.get_player_name)
				player_info_pix_top.set_font (l_font_score)
				player_info_pix_top.draw_text_top_left (top_player_points_x, top_player_points_y,"Points: " + player.get_player_team_score.out)
				player_info_model_top.set_pixmap (player_info_pix_top)
				player_info_model_top.show

				if team = 1 then
					player_info_team_top.set_pixmap (player_info_team_red)
				else
					player_info_team_top.set_pixmap (player_info_team_blue)
				end
				player_info_team_top.show
			when RIGHT then
				create player_info_pix_right.make_with_size(128, 80)
				player_info_pix_right.set_font (l_font_name)
				player_info_pix_right.set_foreground_color (l_color)
				player_info_pix_right.set_with_named_file (path_player_box_horizontal)
				player_info_pix_right.draw_text_top_left (right_player_name_x, right_player_name_y, player.get_player_name)
				player_info_pix_right.set_font (l_font_score)
				player_info_pix_right.draw_text_top_left (right_player_points_x, right_player_points_y, "Points: " + player.get_player_team_score.out)
				player_info_model_right.set_pixmap (player_info_pix_right)
				player_info_model_right.show

				if team = 1 then
					player_info_team_right.set_pixmap (player_info_team_red)
				else
					player_info_team_right.set_pixmap (player_info_team_blue)
				end
				player_info_team_right.show
			when BOTTOM then
				create player_info_pix_btm.make_with_size(128, 80)
				player_info_pix_btm.set_font (l_font_name)
				player_info_pix_btm.set_foreground_color (l_color)
				player_info_pix_btm.set_with_named_file (path_player_box_horizontal)
				player_info_pix_btm.draw_text_top_left (btm_player_name_x, btm_player_name_y, player.get_player_name)
				player_info_pix_btm.set_font (l_font_score)
				player_info_pix_btm.draw_text_top_left (btm_player_points_x, btm_player_points_y, "Points: " + player.get_player_team_score.out)
				player_info_model_btm.set_pixmap (player_info_pix_btm)
				player_info_model_btm.show

				if team = 1 then
					player_info_team_btm.set_pixmap (player_info_team_red)
				else
					player_info_team_btm.set_pixmap (player_info_team_blue)
				end
				player_info_team_btm.show

			when LEFT then
				create player_info_pix_left.make_with_size(128, 80)
				player_info_pix_left.set_font (l_font_name)
				player_info_pix_left.set_foreground_color (l_color)
				player_info_pix_left.set_with_named_file (path_player_box_horizontal)
				player_info_pix_left.draw_text_top_left (left_player_name_x, left_player_name_y, player.get_player_name)
				player_info_pix_left.set_font (l_font_score)
				player_info_pix_left.draw_text_top_left (left_player_points_x, left_player_points_y,"Points: " + player.get_player_team_score.out)
				player_info_model_left.set_pixmap (player_info_pix_left)
				player_info_model_left.show

				if team = 1 then
					player_info_team_left.set_pixmap (player_info_team_red)
				else
					player_info_team_left.set_pixmap (player_info_team_blue)
				end
				player_info_team_left.show
			else
				--FATAL ERROR
			end
		end

	set_player_cards(player:TR_PLAYER)
		local
			l_direction: INTEGER
			l_show_front: BOOLEAN
			i,j: INTEGER
		do
			l_direction := get_player_direction (player)
			if l_direction = BOTTOM then
				l_show_front := true
			else
				l_show_front := false
			end

			-- Player card 1
			if player.get_player_cards.at (0).get_card_value > 0 then
				players_cards[l_direction*4].remake_card (player.get_player_cards.at (0), l_direction, l_show_front)
				players_cards[l_direction*4].show
			else
				players_cards[l_direction*4].hide
			end
			-- Player card 2
			if player.get_player_cards.at (1).get_card_value > 0 then
				players_cards[l_direction*4 + 1].remake_card (player.get_player_cards.at (1), l_direction, l_show_front)
				players_cards[l_direction*4 + 1].show
			else
				players_cards[l_direction*4 + 1].hide
			end
			-- Player card 3
			if player.get_player_cards.at (2).get_card_value > 0 then
				players_cards[l_direction*4 + 2].remake_card (player.get_player_cards.at (2), l_direction, l_show_front)
				players_cards[l_direction*4 + 2].show
			else
				players_cards[l_direction*4 + 2].hide
			end
			-- Player card 4 (Middle card/card played)
			if player.get_player_current_card.get_card_value > 0 then
				players_cards[l_direction*4 + 3].remake_card (player.get_player_current_card, l_direction, true) --Always show middle cards
				players_cards[l_direction*4 + 3].show
			else
				players_cards[l_direction*4 + 3].hide
			end
		end

	get_position_for_card(direction, position: INTEGER): TUPLE[x:INTEGER;y:INTEGER]
		do
			inspect direction
			when TOP then
				inspect position
				when 0 then Result := [Top_card_1_x, Top_card_1_y]
				when 1 then Result := [Top_card_2_x, Top_card_2_y]
				when 2 then	Result := [Top_card_3_x, Top_card_3_y]
				when 3 then Result := [Top_card_4_x, Top_card_4_y]
				end
			when RIGHT then
				inspect position
				when 0 then Result := [Right_card_1_x, Right_card_1_y]
				when 1 then Result := [Right_card_2_x, Right_card_2_y]
				when 2 then	Result := [Right_card_3_x, Right_card_3_y]
				when 3 then Result := [Right_card_4_x, Right_card_4_y]
				end
			when BOTTOM then
				inspect position
				when 0 then Result := [Bottom_card_1_x, Bottom_card_1_y]
				when 1 then Result := [Bottom_card_2_x, Bottom_card_2_y]
				when 2 then	Result := [Bottom_card_3_x, Bottom_card_3_y]
				when 3 then Result := [Bottom_card_4_x, Bottom_card_4_y]
				end
			when LEFT then
				inspect position
				when 0 then Result := [Left_card_1_x, Left_card_1_y]
				when 1 then Result := [Left_card_2_x, Left_card_2_y]
				when 2 then	Result := [Left_card_3_x, Left_card_3_y]
				when 3 then Result := [Left_card_4_x, Left_card_4_y]
				else Result := Void
				end
			else Result := Void
			end
		ensure
			Result_not_void: Result /= Void
		end

feature {NONE} -- Initialization
	init_chat_section
		-- builds the chat section of the table screen
		do
			create chat_section.make (controller)
		end

feature {NONE}-- Network event handling

	game_state_updated (gs: TR_GAME_STATE)
		-- called from the controller when an updated game state has been received
		local
			local_player: TR_PLAYER
			local_logic : TR_LOGIC

			l_is_local_players_turn: BOOLEAN
			l_can_answer_bet: BOOLEAN
			i: INTEGER
		do
			local_player := controller.get_local_player
			create local_logic.make
			local_logic.set_current_game_state (gs)

			--Place players according to local player
			from i:=0 until i=4 loop
				if gs.get_all_players[i].get_player_name.is_equal (local_player.get_player_name) then
					set_player_direction (gs.get_all_players[i], BOTTOM)
					set_player_direction (gs.get_all_players[(i + 1)\\4], RIGHT)
					set_player_direction (gs.get_all_players[(i + 2)\\4], TOP)
					set_player_direction (gs.get_all_players[(i + 3)\\4], LEFT)
					i:=3
				end
				i:=i+1
			end

			--Who round that round
			if gs.get_round.at (1) > 0 then set_round_won_one(gs.get_round.at (1)) end
			if gs.get_round.at (2) > 0 then set_round_won_two(gs.get_round.at (2)) end

			set_player_information (gs.get_all_players[0])
			set_player_information (gs.get_all_players[1])
			set_player_information (gs.get_all_players[2])
			set_player_information (gs.get_all_players[3])

			set_player_cards(gs.get_all_players[0])
			set_player_cards(gs.get_all_players[1])
			set_player_cards(gs.get_all_players[2])
			set_player_cards(gs.get_all_players[3])

			if gs.get_all_players[gs.get_the_player_turn_id - 1].get_player_name.is_equal (local_player.get_player_name) then
				l_is_local_players_turn := true
				disable_card_click := false
			else
				l_is_local_players_turn := false
				disable_card_click := true
			end

			set_truco_disable(true)
			set_envido_disable(true)
			if not gs.get_action and l_is_local_players_turn then
				set_truco_disable(false)


				if gs.is_truco_allowed (local_player) then
					set_truco_button ("Truco", agent truco_clicked(?,?,?,?,?,?,?,?))
				elseif gs.is_retruco_allowed (local_player) then
					set_truco_button ("Retruco", agent retruco_clicked (?,?,?,?,?,?,?,?))
				elseif gs.is_vale_cuatro_allowed(local_player) then
					set_truco_button ("Vale Cuatro", agent valecuatro_clicked (?,?,?,?,?,?,?,?))
				end



				if gs.get_round_number = 0 then
					set_envido_disable(false)
				end
			end

			--TODO: SET DEALER POSITION WHEN AVAILABLE IN GAME_STATE
			--set_dealer_position (gs.get_all_players[gs])

			-- check if the truco/envido response prompt should be shown
			if prompt_box /= Void then prompt_box.hide end
			if local_logic.is_end_round then
				if prompt_box /= Void then prompt_box.show else create prompt_box end
				prompt_box.clear_all

				print("%N%NIn TR_WINDOW_TABLE : game_state_updated : Detected the end of the round%N%N")
				prompt_box.make_end_round_called (controller, gs.get_all_players[local_logic.who_played_the_first_best_card - 1].get_player_name, controller.is_host, gs.get_current_game_points, agent box_end_round_clicked)

				if not world.has (prompt_box) then world.extend (prompt_box) end
			elseif gs.get_action then

--				if gs.get_all_players[gs.get_who_bet_id - 1].get_player_team_id = local_player.get_player_team_id  then	
				if gs.do_i_have_to_answer_a_bet (local_player.get_player_id)  then
					l_can_answer_bet := false
				else
					l_can_answer_bet := true
				end

				if prompt_box /= Void then prompt_box.show else create prompt_box end
				prompt_box.clear_all
				if gs.get_current_bet.is_equal ("truco") then
					prompt_box.make_truco_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, agent box_quiero_clicked, agent box_no_quiero_clicked, agent box_retruco_clicked)
				elseif gs.get_current_bet.is_equal ("retruco") then
					prompt_box.make_retruco_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, agent box_quiero_clicked, agent box_no_quiero_clicked, agent box_vale_cuatro_clicked)
				elseif gs.get_current_bet.is_equal ("vallecuatro") then
					prompt_box.make_vale_cuatro_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, agent box_quiero_clicked, agent box_no_quiero_clicked)
				elseif gs.get_current_bet.is_equal ("envido") then
					prompt_box.make_envido_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, gs.get_current_game_points, agent box_quiero_clicked, agent box_no_quiero_clicked, agent box_envido_clicked, agent box_real_envido_clicked, agent box_falta_envido_clicked)
				elseif gs.get_current_bet.is_equal ("realenvido") then
					prompt_box.make_real_envido_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, gs.get_current_game_points, agent box_quiero_clicked, agent box_no_quiero_clicked, agent box_real_envido_clicked, agent box_falta_envido_clicked)
				elseif gs.get_current_bet.is_equal ("faltaenvido") then
					prompt_box.make_falta_envido_called (controller, gs.get_all_players[gs.get_who_bet_id - 1].get_player_name, l_can_answer_bet, gs.get_current_game_points, agent box_quiero_clicked, agent box_no_quiero_clicked)
				end
				if not world.has (prompt_box) then world.extend (prompt_box) end
			end

			update_screen

		end

	box_quiero_clicked
		do
			print ("quiero clicked! %N")
			controller.gui_quiero_played
			disable_card_click := true
		end

	box_no_quiero_clicked
		do
			print ("no quiero clicked! %N")
			controller.gui_noquiero_played
			disable_card_click := true
		end

	box_truco_clicked
		do
			print ("truco clicked! %N")
			controller.gui_truco_played
			disable_card_click := true
		end

	box_retruco_clicked
		do
			print ("retruco clicked! %N")
			controller.gui_retruco_played
			disable_card_click := true
		end

	box_vale_cuatro_clicked
		do
			print ("vale cuatro clicked! %N")
			controller.gui_vale_cuatro_played
			disable_card_click := true
		end

	box_envido_clicked
		do
			print ("envido clicked! %N")
			controller.gui_envido_played
			disable_card_click := true
		end

	box_real_envido_clicked
		do
			print ("real envido clicked! %N")
			controller.gui_real_envido_played
			disable_card_click := true
		end

	box_falta_envido_clicked
		do
			print ("falta envido clicked! %N")
			controller.gui_falta_envido_played
			disable_card_click := true
		end

	box_end_round_clicked
		do
			print ("end round clicked! %N")
			controller.gui_end_round_played
			disable_card_click := true
		end


feature {NONE} -- Implementation

	onclicked_card_btm_1(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			print("CLICK CARD 1 %N")
			if(disable_card_click = false) then
				-- Move card to middle of table
				players_cards[BOTTOM*4].set_showing_front (true)
				set_disable_card_click (true)

				players_cards[BOTTOM*4 + 3].remake_card (players_cards[BOTTOM*4].get_card, BOTTOM, true)
				players_cards[BOTTOM*4 + 3].show
				players_cards[BOTTOM*4].hide

				play_card (players_cards[BOTTOM*4].get_card)
			end
		end

	onclicked_card_btm_2(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			print("CLICK CARD 2 %N")
			if(disable_card_click = false) then
				-- Move card to middle of table
				players_cards[BOTTOM*4 + 1].set_showing_front (true)
				set_disable_card_click (true)

				players_cards[BOTTOM*4 + 3].remake_card (players_cards[BOTTOM*4 + 1].get_card, BOTTOM, true)
				players_cards[BOTTOM*4 + 3].show
				players_cards[BOTTOM*4 + 1].hide

				play_card(players_cards[BOTTOM*4 + 1].get_card)
			end
		end

	onclicked_card_btm_3(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			print("CLICK CARD 3 %N")
			if(disable_card_click = false) then
				-- Move card to middle of table
				players_cards[BOTTOM*4 + 2].set_showing_front (true)
				set_disable_card_click (true)

				players_cards[BOTTOM*4 + 3].remake_card (players_cards[BOTTOM*4 + 2].get_card, BOTTOM, true)
				players_cards[BOTTOM*4 + 3].show
				players_cards[BOTTOM*4 + 2].hide

				play_card(players_cards[BOTTOM*4 + 2].get_card) --Send info to controller
			end
		end

	play_card (a_card: TR_CARD)
		do
			print ("card played: " + a_card.get_card_type + a_card.get_card_value.out + "%N")

			controller.gui_card_played (a_card)
			disable_card_click := true
		end

	update_screen
		do
			proj.project
		end

	add_truco_button
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Truco", button_position_1_x, button_position_1_y, agent truco_clicked(?,?,?,?,?,?,?,?), true)
			truco_button := l_button
			world.extend (l_button)
		end

	add_envido_button ()
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Envido", button_position_2_x, button_position_2_y, agent envido_clicked(?,?,?,?,?,?,?,?), true)
			envido_button := l_button
			world.extend (l_button)
		end

	set_truco_disable(disable:BOOLEAN)
		do
			if disable then
				truco_button.hide
			else
				truco_button.show
			end

		end

	set_envido_disable(disable:BOOLEAN)
		do
			if disable then
				envido_button.hide
			else
				envido_button.show
			end

		end

	make_button(a_name: STRING; x_pos, y_pos: INTEGER; an_action: PROCEDURE[ANY, TUPLE[INTEGER_32, INTEGER_32, INTEGER_32, REAL_64, REAL_64, REAL_64, INTEGER_32, INTEGER_32]]; enabled: BOOLEAN) : TR_BUTTON
			local
				l_button: TR_BUTTON
			do
				create l_button.make_with_text (a_name)
				l_button.set_point_position (x_pos, y_pos)
				l_button.set_enabled (enabled)

				if enabled then
					l_button.pointer_button_release_actions.extend (an_action)
				end

				Result := l_button
			end

	truco_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
		--Truco clicked
			controller.gui_truco_played
		end

	retruco_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
		--Retruco clicked
			controller.gui_retruco_played
		end

	valecuatro_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
		--Vale 4 clicked
			controller.gui_vale_cuatro_played
		end

	envido_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
   		-- Envido clicked
   			controller.gui_envido_played
   		end

	set_truco_button(truco_type: STRING; new_action: PROCEDURE[ANY, TUPLE[INTEGER_32, INTEGER_32, INTEGER_32, REAL_64, REAL_64, REAL_64, INTEGER_32, INTEGER_32]])
		do
			truco_button.remake_button(truco_type)
			truco_button.pointer_button_release_actions.extend (new_action)
		end

feature {NONE} -- Attributes

	controller: TR_CONTROLLER
	prompt_box: TR_GAME_PROMPT_BOX

	area: EV_DRAWING_AREA
	world: EV_MODEL_WORLD
	proj: EV_MODEL_DRAWING_AREA_PROJECTOR

	chat_section: TR_CHAT_SECTION
		-- container for widgets that compose the chat section of the table window

	l_dealer: EV_PIXMAP
	l_dealer_pic: EV_MODEL_PICTURE

	player_info_pix_top: EV_PIXMAP
	player_info_pix_right: EV_PIXMAP
	player_info_pix_btm: EV_PIXMAP
	player_info_pix_left: EV_PIXMAP

	player_info_model_top: EV_MODEL_PICTURE
	player_info_model_right: EV_MODEL_PICTURE
	player_info_model_btm: EV_MODEL_PICTURE
	player_info_model_left: EV_MODEL_PICTURE

	player_info_team_red: EV_PIXMAP
	player_info_team_blue: EV_PIXMAP

	player_info_team_top: EV_MODEL_PICTURE
	player_info_team_right: EV_MODEL_PICTURE
	player_info_team_btm: EV_MODEL_PICTURE
	player_info_team_left: EV_MODEL_PICTURE


	player_1_direction: INTEGER
	player_2_direction: INTEGER
	player_3_direction: INTEGER
	player_4_direction: INTEGER

	disable_card_click: BOOLEAN

	players_cards: ARRAY[TR_GUI_CARD]

	TOP: INTEGER = 0
	RIGHT: INTEGER = 1
	BOTTOM: INTEGER = 2
	LEFT: INTEGER = 3

	cards: ARRAY[TR_CARD]

	-- Truco and Envido buttons
	truco_action: PROCEDURE[ANY, TUPLE]
	envido_action: PROCEDURE[ANY, TUPLE]

	truco_button: TR_BUTTON
	envido_button: TR_BUTTON

	-- Test players
	player_1: TR_PLAYER
	player_2: TR_PLAYER
	player_3: TR_PLAYER
	player_4: TR_PLAYER

	-- Test cards
	card1: TR_CARD
	card2: TR_CARD
	card3: TR_CARD

	-- RoundWon
	round_won: EV_PIXMAP
	round_won_pic: EV_MODEL_PICTURE
	round_won_forgroundcolor: EV_COLOR
	round_one_text: STRING
	round_won_round_one: EV_PIXMAP
	round_won_round_one_pic: EV_MODEL_PICTURE

	round_two_text: STRING
	round_won_round_two: EV_PIXMAP
	round_won_round_two_pic: EV_MODEL_PICTURE

end
