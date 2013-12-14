note
	description: "Network response codes"
	author: "Janus Varmarken"
	date: "$Date$"
	revision: "$Revision$"

class
	TR_NET_RESPONSE_CODES

feature -- start game response codes
	start_game_success: STRING
		do
			Result := "OK_START_GAME"
		end
	start_game_fail_invalid_teams: STRING
		do
			Result := "REJECT_TEAMS_NOT_MADE"
		end
	start_game_fail_not_enough_players: STRING
		do
			Result := "REJECT_NOT_ENOUGH_PLAYERS"
		end
	start_game_fail_players_not_ready: STRING
		do
			Result := "REJECT_PLAYERS_ARE_NOT_READY"
		end

	join_game_success: STRING
		do
			Result := "PLAYER_ADDED"
		end
	join_game_fail_invalid_name: STRING
		do
			Result := "PLAYER_NAME_ALREADY_USED"
		end
	join_game_fail_server_full: STRING
		do
			Result := "ALREADY_FOUR_PLAYERS"
		end

	change_ready_success: STRING
		do
			Result := "PLAYER_READY_STATE_CHANGED"
		end
	change_ready_fail_invalid_player: STRING
		do
			Result := "PLAYER_IS_NOT_PRESENT"
		end

	change_team_success: STRING
		do
			Result := "PLAYER_TEAM_CHANGED"
		end
	change_team_fail_invalid_player: STRING
		do
			Result := "PLAYER_IS_NOT_PRESENT"
		end

	leave_lobby_success: STRING
		do
			Result := "OK_QUIT_CONNECTION_PHASE"
		end
	leavy_lobby_fail_invalid_player: STRING
		do
			Result := "PLAYER_IS_NOT_PRESENT"
		end

	stop_game_success: STRING
		do
			Result := "OK_STOPPING_THE_GAME"
		end

	send_update_success: STRING
		do
			Result := "OK_PACKET_IS_GOING_TO_BE_ROUTED"
		end
	send_update_fail_invalid_player: STRING
		do
			Result := "REJECT_PLAYER_NOT_FOUND"
		end
	send_update_fail_game_phase: STRING
		do
			Result := "REJECT_GAME_PHASE"
		end
end
