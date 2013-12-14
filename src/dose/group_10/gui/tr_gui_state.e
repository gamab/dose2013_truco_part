note
	description: "Summary description for {TR_GUI_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_GUI_STATE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature
	-- fields holding truco availability
	truco_enabled: BOOLEAN assign set_truco_enabled
	retruco_enabled: BOOLEAN assign set_retruco_enabled
	vale_cuatro_enabled: BOOLEAN assign set_vale_cuatro_enabled
	-- fields holding envido availability
	envido_enabled: BOOLEAN assign set_envido_enabled
	real_envido_enabled: BOOLEAN assign set_real_envido_enabled
	falta_envido_enabled: BOOLEAN assign set_falta_envido_enabled

	-- assigners
	set_truco_enabled(enabled: BOOLEAN)
	do
		truco_enabled := enabled
	end

	set_retruco_enabled(enabled: BOOLEAN)
	do
		retruco_enabled := enabled
	end

	set_vale_cuatro_enabled(enabled: BOOLEAN)
	do
		vale_cuatro_enabled := enabled
	end

	set_envido_enabled(enabled: BOOLEAN)
	do
		envido_enabled := enabled
	end

	set_real_envido_enabled(enabled: BOOLEAN)
	do
		real_envido_enabled := enabled
	end

	set_falta_envido_enabled(enabled: BOOLEAN)
	do
		falta_envido_enabled := enabled
	end
end
