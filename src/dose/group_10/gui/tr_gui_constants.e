note
	description	: "Constants for the Eiffel Vision demo."
	author		: "haches"
	date		: "$Date$"
	revision	: "$Revision$"

class
	TR_GUI_CONSTANTS

inherit
    KL_SHARED_FILE_SYSTEM
    		-- use KL_SHARED_FILE_SYSTEM to make file paths OS independent
        export {NONE}
            all
        end


feature -- Access

----SIZES------------------------------------------------
	window_width: INTEGER = 1000
	window_height: INTEGER = 680

	table_box_width: INTEGER = 800
	table_box_height: INTEGER = 680

	chat_section_width: INTEGER = 200
	chat_section_height: INTEGER = 680

	join_dialog_width: INTEGER = 300
	join_dialog_height: INTEGER = 200
	host_dialog_width: INTEGER = 300
	host_dialog_height: INTEGER = 200


----PATHS------------------------------------------------
	Dose_folder: STRING = "dose"
	Image_folder: STRING = "images"
	Group10_folder: STRING = "group_10"

	img_path: KL_PATHNAME
			-- Path for image folder of main_ui
		do
			create Result.make
			Result.set_relative (True)
			Result.append_name (Dose_folder)
			Result.append_name (Image_folder)
			Result.append_name (Group10_folder)
		end

	path_bg: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("background.png")

			Result := file_system.pathname_to_string(path)
		end

	path_icon: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("icon.png")

			Result := file_system.pathname_to_string(path)
		end

	path_button: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("button_normal.png")

			Result := file_system.pathname_to_string(path)
		end

	path_button_hover: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("button_hover.png")

			Result := file_system.pathname_to_string(path)
		end

	path_button_disabled: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("button_disabled.png")

			Result := file_system.pathname_to_string(path)
		end

	path_deck_btm: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("deck_btm.png")

			Result := file_system.pathname_to_string(path)
		end

	path_deck_top: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("deck_top.png")

			Result := file_system.pathname_to_string(path)
		end

	path_deck_left: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("deck_left.png")

			Result := file_system.pathname_to_string(path)
		end

	path_deck_right: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("deck_right.png")

			Result := file_system.pathname_to_string(path)
		end

	path_dealer: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("dealer.png")

			Result := file_system.pathname_to_string(path)
		end

	path_lobby_box: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("lobby_box.png")

			Result := file_system.pathname_to_string(path)
		end


	path_lobby_player_box: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("lobby_player_box.png")

			Result := file_system.pathname_to_string(path)
		end


	path_transp_box: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("transp_box.png")

			Result := file_system.pathname_to_string(path)
		end


	path_team_picker: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_color_red: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_color_red.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_color_blue: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_color_blue.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_arrow: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_arrow.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_menu: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_menu.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_menu_red: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_menu_red.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_menu_blue: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_menu_blue.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_menu_red_hover: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_menu_red_hover.png")

			Result := file_system.pathname_to_string(path)
		end

	path_team_picker_menu_blue_hover: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("team_picker_menu_blue_hover.png")

			Result := file_system.pathname_to_string(path)
		end

	path_menu_box: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("menu_box.png")

			Result := file_system.pathname_to_string(path)
		end

	path_ready_button: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("ready_button.png")

			Result := file_system.pathname_to_string(path)
		end

	path_ready_button_clicked: STRING
		local
			path: KL_PATHNAME
		do
			path := img_path
			path.append_name ("ready_button_clicked.png")

			Result := file_system.pathname_to_string(path)
		end


	path_player_box_vertical: STRING
	local
		path: KL_PATHNAME
	do
		path := img_path
		path.append_name ("player_box_vertical.png")

		Result := file_system.pathname_to_string(path)
	end

	path_player_box_horizontal: STRING
	local
		path: KL_PATHNAME
	do
		path := img_path
		path.append_name ("player_box_horizontal.png")

		Result := file_system.pathname_to_string(path)
	end

	path_info_team_color_red: STRING
	local
		path: KL_PATHNAME
	do
		path := img_path
		path.append_name ("info_team_color_red.png")

		Result := file_system.pathname_to_string(path)
	end

	path_info_team_color_blue: STRING
	local
		path: KL_PATHNAME
	do
		path := img_path
		path.append_name ("info_team_color_blue.png")

		Result := file_system.pathname_to_string(path)
	end

	path_round_not_played: STRING
	local
		path: KL_PATHNAME
	do
		path := img_path
		path.append_name ("empty_team.png")

		Result := file_system.pathname_to_string(path)
	end
end
