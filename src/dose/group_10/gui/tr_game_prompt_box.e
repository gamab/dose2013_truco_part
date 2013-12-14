note
	description: "Summary description for {TR_GAME_PROMPT_BOX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_GAME_PROMPT_BOX

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
	default_create

feature -- constructors

	clear_all
		do
			wipe_out
		end

	make_truco_called(a_controller: TR_CONTROLLER; truco_caller: STRING; can_answer_bet: BOOLEAN; a_quiero_action, a_no_quiero_action, a_retruco_action: PROCEDURE[ANY, TUPLE])
		-- Creates a "truco called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action
			retruco_action := a_retruco_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Truco", truco_caller + " called truco!")
			if can_answer_bet then
				add_queiro_buttons
				add_retruco_button
			else
				add_waiting_text
			end
		end

	make_retruco_called(a_controller: TR_CONTROLLER; truco_caller: STRING; can_answer_bet: BOOLEAN; a_quiero_action, a_no_quiero_action, a_vale_cuatro_action: PROCEDURE[ANY, TUPLE])
		-- Creates a "retruco called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action
			vale_cuatro_action := a_vale_cuatro_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Retruco", truco_caller + " called retruco!")

			if can_answer_bet then
				add_queiro_buttons
				add_vale_cuatro_button
			else
				add_waiting_text
			end
		end

	make_vale_cuatro_called(a_controller: TR_CONTROLLER; truco_caller: STRING; can_answer_bet: BOOLEAN; a_quiero_action, a_no_quiero_action: PROCEDURE[ANY, TUPLE])
		-- Creates a "vale cuatro called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Vale Cuatro", truco_caller + " called vale cuatro!")

			if can_answer_bet then
				add_queiro_buttons
			else
				add_waiting_text
			end
		end

	make_envido_called(a_controller: TR_CONTROLLER; envido_caller: STRING; can_answer_bet: BOOLEAN; envido_value: INTEGER; a_quiero_action, a_no_quiero_action, an_envido_action, a_real_envido_action, a_falta_envido_action: PROCEDURE[ANY, TUPLE])
		-- Creates an "envido called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action
			envido_action := an_envido_action
			real_envido_action := a_real_envido_action
			falta_envido_action := a_falta_envido_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Envido (" + envido_value.out + ")", envido_caller + " called envido!")

			if can_answer_bet then
				add_queiro_buttons
				add_envido_button (true)
				add_real_envido_button (true)
				add_falta_envido_button (true)
			else
				add_waiting_text
			end

		end

	make_real_envido_called(a_controller: TR_CONTROLLER; envido_caller: STRING; can_answer_bet: BOOLEAN; envido_value: INTEGER; a_quiero_action, a_no_quiero_action, a_real_envido_action, a_falta_envido_action: PROCEDURE[ANY, TUPLE])
		-- Creates a "real envido called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action
			real_envido_action := a_real_envido_action
			falta_envido_action := a_falta_envido_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Real Envido (" + envido_value.out + ")", envido_caller + " called real envido!")

			if can_answer_bet then
				add_queiro_buttons
				add_envido_button (false)
				add_real_envido_button (true)
				add_falta_envido_button (true)
			else
				add_waiting_text
			end
		end

	make_falta_envido_called(a_controller: TR_CONTROLLER; envido_caller: STRING; can_answer_bet: BOOLEAN; envido_value: INTEGER; a_quiero_action, a_no_quiero_action: PROCEDURE[ANY, TUPLE])
		-- Creates a "falta envido called" box
		do
			quiero_action := a_quiero_action
			no_quiero_action := a_no_quiero_action

			initialize_standard_box (a_controller)
			add_title_and_description ("Falta Envido (" + envido_value.out + ")", envido_caller + " called falta envido!")

			if can_answer_bet then
				add_queiro_buttons
				add_envido_button (false)
				add_real_envido_button (false)
				add_falta_envido_button (false)
			else
				add_waiting_text
			end
		end

feature {NONE} -- Implementation

	initialize_standard_box(a_controller: TR_CONTROLLER)
		local
			l_box: EV_PIXMAP
			l_box_pic: EV_MODEL_PICTURE
		do
			controller := a_controller

			--Initialize box
			create box
			box.set_with_named_file (path_menu_box)
			create l_box_pic.make_with_pixmap (box)
			extend (l_box_pic)
			l_box_pic.set_point_position (table_box_width//2 - box.width // 2, table_box_height//2 - box.height // 2)
		end

	add_queiro_buttons()
		local
			l_quiero_button: TR_BUTTON
			l_no_quiero_button: TR_BUTTON
		do
			--Initialize buttons
			l_quiero_button := make_button ("Quiero", quiero_button_x, quiero_button_y, agent quiero_clicked, true)
			extend (l_quiero_button)

			l_no_quiero_button := make_button ("No quiero", no_querio_button_x, no_quiero_button_y, agent no_quiero_clicked, true)
			extend (l_no_quiero_button)
		end

	add_title_and_description(a_title, a_description: STRING)
		local
			l_font_large: EV_FONT
			l_font: EV_FONT
		do
			--Initialize title
			create l_font_large.make_with_values (3, 9, 10, 30)
			box.set_font (l_font_large)
			box.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 234, 74))
			box.draw_text_top_left ((box.width/2-l_font_large.string_width (a_title)/2).rounded, 40, a_title)

			--Initialize description
			create l_font.make_with_values (1, 8, 10, 14)
			box.set_font (l_font)
			box.draw_text_top_left ((box.width/2-l_font.string_width (a_description)/2).rounded, 80, a_description)
		end

	add_waiting_text
		local
			l_font: EV_FONT
		do
			create l_font.make_with_values (1, 8, 10, 14)
			box.set_font (l_font)
			box.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 234, 74))
			box.draw_text_top_left ((box.width/2-l_font.string_width ("Waiting for response..")/2).rounded, 160, "Waiting for response..")
		end

	add_retruco_button
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Retruco", retruco_button_x, retruco_button_y, agent retruco_clicked, true)
			extend (l_button)
		end

	add_vale_cuatro_button
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Vale cuatro", vale_cuatro_button_x, vale_cuatro_button_y, agent vale_cuatro_clicked, true)
			extend (l_button)
		end

	add_envido_button (enabled: BOOLEAN)
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Envido", envido_button_x, envido_button_y, agent envido_clicked, enabled)
			extend (l_button)
		end

	add_real_envido_button (enabled: BOOLEAN)
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Real envido", real_envido_button_x, real_envido_button_y, agent real_envido_clicked, enabled)
			extend (l_button)
		end

	add_falta_envido_button (enabled: BOOLEAN)
		local
			l_button: TR_BUTTON
		do
			l_button := make_button ("Falta envido", falta_envido_button_x, falta_envido_button_y, agent falta_envido_clicked, enabled)
			extend (l_button)
		end

	make_button(a_name: STRING; x_pos, y_pos: INTEGER; an_action: PROCEDURE[ANY, TUPLE[INTEGER_32, INTEGER_32, INTEGER_32, REAL_64, REAL_64, REAL_64, INTEGER_32, INTEGER_32]]; enabled: BOOLEAN) : TR_BUTTON
		local
			l_button: TR_BUTTON
		do
			create l_button.make_with_text (a_name)
			l_button.set_point_position (x_pos + table_box_width//2 - box.width // 2, y_pos + table_box_height//2 - box.height // 2)
			l_button.set_enabled (enabled)

			if enabled then
				l_button.pointer_button_release_actions.extend (an_action)
			end

			Result := l_button
		end

	player_box_slot_to_pos_y(slot: INTEGER): INTEGER
		do
			Result := player_box_y + slot * player_box_offset
		end

	quiero_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			quiero_action.call ([])
		end

	no_quiero_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			no_quiero_action.call ([])
		end

	retruco_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			retruco_action.call ([])
		end

	vale_cuatro_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			vale_cuatro_action.call ([])
		end

	envido_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			envido_action.call ([])
		end

	real_envido_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			real_envido_action.call ([])
		end

	falta_envido_clicked(ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			falta_envido_action.call ([])
		end

feature {NONE} -- Attributes

	controller: TR_CONTROLLER

	quiero_action: PROCEDURE[ANY, TUPLE]
	no_quiero_action: PROCEDURE[ANY, TUPLE]

	retruco_action: PROCEDURE[ANY, TUPLE]
	vale_cuatro_action: PROCEDURE[ANY, TUPLE]

	envido_action: PROCEDURE[ANY, TUPLE]
	real_envido_action: PROCEDURE[ANY, TUPLE]
	falta_envido_action: PROCEDURE[ANY, TUPLE]

	box: EV_PIXMAP

--	window_width: INTEGER = 380
--	window_height: INTEGER = 283


end
