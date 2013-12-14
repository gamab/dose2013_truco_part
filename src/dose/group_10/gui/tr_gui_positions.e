note
	description: "Summary description for {TR_GUI_POSITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_GUI_POSITIONS


feature


			-----------------------------
			-----------LOBBY-------------
			-----------------------------
			lobby_box_x: INTEGER = 319	--window_width//2 - l_lobby_box.width // 2
			lobby_box_y: INTEGER = 320	--window_height//2 - l_lobby_box.height // 2

			player_box_x: INTEGER = 319
			player_box_y: INTEGER = 245
			player_box_offset: INTEGER = 42

			ip_text_x: INTEGER = 170
			ip_text_y: INTEGER = 4
			port_text_x: INTEGER = 170
			port_text_y: INTEGER = 17

			leave_button_x: INTEGER = 321
			leave_button_y: INTEGER = 430

			add_ai_button_x: INTEGER = 475
			add_ai_button_y: INTEGER = 430

			start_button_x: INTEGER = 580
			start_button_y: INTEGER = 430

			--team picker
			team_picker_x: INTEGER = 321
			team_picker_y: INTEGER = 6

			team_color_x: INTEGER = 324
			team_color_y: INTEGER = 9

			team_picker_arrow_x: INTEGER = 347
			team_picker_arrow_y: INTEGER = 9

			team_picker_menu_x: INTEGER = 321
			team_picker_menu_y: INTEGER = 33

			team_picker_menu_red_x: INTEGER = 322
			team_picker_menu_red_y: INTEGER = 35

			team_picker_menu_blue_x: INTEGER = 322
			team_picker_menu_blue_y: INTEGER = 61

			ready_button_x: INTEGER = 293
			ready_button_y: INTEGER = 10


			-----------------------------
			-----------TABLE-------------
			-----------------------------
			-- Bottom Player positions
			Bottom_card_1_x: INTEGER = 270
			Bottom_card_1_y: INTEGER = 547

			Bottom_card_2_x: INTEGER = 360
			Bottom_card_2_y: INTEGER = 547

			Bottom_card_3_x: INTEGER = 450
			Bottom_card_3_y: INTEGER = 547

			Bottom_card_4_x: INTEGER = 360
			Bottom_card_4_y: INTEGER = 380


			-- Top player positions
			Top_card_1_x: INTEGER = 270
			Top_card_1_y: INTEGER = 5

			Top_card_2_x: INTEGER = 360
			Top_card_2_y: INTEGER = 5

			Top_card_3_x: INTEGER = 450
			Top_card_3_y: INTEGER = 5

			Top_card_4_x: INTEGER = 360
			Top_card_4_y: INTEGER = 172


			-- Left player positions
			Left_card_1_x: INTEGER = 5
			Left_card_1_y: INTEGER = 210

			Left_card_2_x: INTEGER = 5
			Left_card_2_y: INTEGER = 300

			Left_card_3_x: INTEGER = 5
			Left_card_3_y: INTEGER = 390

			Left_card_4_x: INTEGER = 232
			Left_card_4_y: INTEGER = 300


			-- Right player positions
			Right_card_1_x: INTEGER = 667
			Right_card_1_y: INTEGER = 210

			Right_card_2_x: INTEGER = 667
			Right_card_2_y: INTEGER = 300

			Right_card_3_x: INTEGER = 667
			Right_card_3_y: INTEGER = 390

			Right_card_4_x: INTEGER = 441
			Right_card_4_y: INTEGER = 300


			-- Dealer button positions
			Top_dealer_x: INTEGER = 540
			Top_dealer_y: INTEGER = 138

			Btm_dealer_x: INTEGER = 540
			Btm_dealer_y: INTEGER = 507

			Right_dealer_x: INTEGER = 622
			Right_dealer_y: INTEGER = 480

			Left_dealer_x: INTEGER = 138
			Left_dealer_y: INTEGER = 480

			-- Player information box
			Top_Player_box_x : INTEGER = 540
			Top_Player_box_y : INTEGER = 5

			Right_Player_box_x : INTEGER = 667
			Right_Player_box_y : INTEGER = 480

			Btm_Player_box_x : INTEGER = 132
			Btm_Player_box_y : INTEGER = 595

			Left_Player_box_x : INTEGER = 5
			Left_Player_box_y : INTEGER = 120

			-- Player names
			Top_Player_name_x: INTEGER = 8
			Top_Player_name_y: INTEGER = 10

			Left_Player_name_x: INTEGER = 8
			Left_Player_name_y: INTEGER = 10

			Btm_Player_name_x: INTEGER = 8
			Btm_Player_name_y: INTEGER = 10

			Right_Player_name_x: INTEGER = 8
			Right_Player_name_y: INTEGER = 10

			-- Player points
			Top_Player_points_x: INTEGER = 5
			Top_Player_points_y: INTEGER = 40

			Left_Player_points_x: INTEGER = 5
			Left_Player_points_y: INTEGER = 40

			Btm_Player_points_x: INTEGER = 5
			Btm_Player_points_y: INTEGER = 40

			Right_Player_points_x: INTEGER = 5
			Right_Player_points_y: INTEGER = 40

			-- Player team color   +85, 38
			player_info_color_top_x: INTEGER = 625
			player_info_color_top_y: INTEGER = 43

			player_info_color_left_x: INTEGER = 752
			player_info_color_left_y: INTEGER = 518

			player_info_color_btm_x: INTEGER = 217
			player_info_color_btm_y: INTEGER = 633

			player_info_color_right_x: INTEGER = 90
			player_info_color_right_y: INTEGER = 158


			-- Button positions
			Button_position_1_x: INTEGER = 540
			Button_position_1_y: INTEGER = 548

			Button_position_2_x: INTEGER = 540
			Button_position_2_y: INTEGER = 592

			-- Round Won
			Round_one_pos_x: INTEGER = 750
			Round_one_pos_y: INTEGER = 603

			Round_two_pos_x: INTEGER = 750
			Round_two_pos_y: INTEGER = 637

			Round_won_one_text_x: INTEGER = 15
			Round_won_one_text_y: INTEGER = 15
			Round_won_two_text_x: INTEGER = 15
			Round_won_two_text_y: INTEGER = 50

			Round_won_x: INTEGER = 667
			Round_won_y: INTEGER = 595

			-----------------------------
			--------GAME PROMPT----------
			-----------------------------
			prompt_box_x: INTEGER = 235	--window_width//2 - l_lobby_box.width // 2
			prompt_box_y: INTEGER = 199	--window_height//2 - l_lobby_box.height // 2

			--prompt_title_text_x: INTEGER = 170
			prompt_title_text_y: INTEGER = 40
			--prompt_description_text_x: INTEGER = 170
			prompt_description_text_y: INTEGER = 80

			quiero_button_x: INTEGER = 85
			quiero_button_y: INTEGER = 180

			no_querio_button_x: INTEGER = 195
			no_quiero_button_y: INTEGER = 180

			retruco_button_x: INTEGER = 140
			retruco_button_y: INTEGER = 230

			vale_cuatro_button_x: INTEGER = 140
			vale_cuatro_button_y: INTEGER = 230

			envido_button_x: INTEGER = 25
			envido_button_y: INTEGER = 230

			real_envido_button_x: INTEGER = 135
			real_envido_button_y: INTEGER = 230

			falta_envido_button_x: INTEGER = 245
			falta_envido_button_y: INTEGER = 230

end
