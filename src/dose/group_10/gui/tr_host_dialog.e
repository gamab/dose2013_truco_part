note
	description: "Summary description for {TR_HOST_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_HOST_DIALOG

inherit
	EV_DIALOG
	EV_LAYOUT_CONSTANTS
		undefine
			default_create,
			copy
		end
	EV_KEY_CONSTANTS
		undefine
			default_create,
			copy
		end

	TR_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make

feature
	make
		do
			initialize_window
			initialize_controls
		end

	name: STRING
		do
			Result := name_textbox.text
		end

	is_cancelled: BOOLEAN
		do
			Result := cancelled
		end

feature {NONE}

	initialize_window
		do
			make_with_title ("Host game")
			set_minimum_size (host_dialog_width, host_dialog_height)
			disable_user_resize
			show_actions.extend (agent shown)
			close_request_actions.extend (agent cancel)
		end

	initialize_controls
		local
			label: EV_LABEL
			container: EV_VERTICAL_BOX
			button_container: EV_HORIZONTAL_BOX
			input_container: EV_HORIZONTAL_BOX
		do
			create container
			create button_container
			create input_container
			input_container.set_border_width (50)

			create label.make_with_text ("Your name:")
			input_container.extend (label)
			create name_textbox
			name_textbox.set_minimum_width (100)
			name_textbox.set_capacity (20)
			input_container.extend(name_textbox)

			create cancel_button.make_with_text ("Cancel")
			cancel_button.select_actions.extend (agent cancel)
			set_default_size_for_button (cancel_button)
			button_container.extend(cancel_button)

			create ok_button.make_with_text ("Host")
			ok_button.select_actions.extend (agent ok)
			set_default_size_for_button (ok_button)
			button_container.extend(ok_button)

			container.extend (input_container)
			container.extend (button_container)
			extend(container)

			set_default_cancel_button (cancel_button)
			set_default_push_button (ok_button)
		end

	shown
		do
			name_textbox.set_focus
		end

	cancel
		do
			cancelled := true
			hide
		end

	ok
		local
			msgbox: EV_WARNING_DIALOG
		do
			if name_textbox.text.count > 0 then
				cancelled := false
				hide
			else
				create msgbox.make_with_text ("You must enter a name.")
				msgbox.show_modal_to_window (Current)
			end
		end

feature {NONE} -- Access

	name_textbox: EV_TEXT_FIELD
	ok_button: EV_BUTTON
	cancel_button: EV_BUTTON
	cancelled: BOOLEAN

end
