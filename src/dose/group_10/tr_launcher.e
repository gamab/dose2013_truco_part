note

	description: "Summary description for {TR_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_LAUNCHER

inherit
	LAUNCHER

feature	-- Implementation

	launch (main_ui_window: MAIN_WINDOW)
			-- launch the application
		local
			l_controller: TR_CONTROLLER
		do
			create l_controller.make

			main_ui_window.add_reference_to_game (l_controller)

			--TODO: Save/send main_ui_window along
		end

end
