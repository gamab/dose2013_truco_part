note
	description: "Summary description for {TR_GUI_CARD_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TR_GUI_CARD_MANAGER


inherit
	TR_GUI_CONSTANTS



create
	initialize_manager


feature {NONE}
	initialize_manager
		do

		end


feature


	get_pixmaps_for_card(card: TR_CARD; direction: INTEGER): TUPLE[EV_PIXMAP, EV_PIXMAP]
		local
			l_pixmap: EV_PIXMAP
			l_pixmap_backside: EV_PIXMAP

			l_sheet_pos: TUPLE[x: INTEGER; y: INTEGER]
			l_sheep_pos_backside: TUPLE[x: INTEGER; y: INTEGER]

			l_temp_val: INTEGER

		do
			create l_pixmap
			create l_pixmap_backside

			inspect direction
			when 0 then --TOP
				l_pixmap.set_with_named_file (path_deck_top)
				initialize_size(l_pixmap, false)
				l_sheet_pos := get_card_position_in_sheet(card)
				l_sheep_pos_backside := get_card_back_position_in_sheet

				l_sheet_pos.x := deck_width - card_width - l_sheet_pos.x
				l_sheet_pos.y := deck_height - card_height - l_sheet_pos.y
				l_sheep_pos_backside.x := deck_width - card_width - l_sheep_pos_backside.x
				l_sheep_pos_backside.y := deck_height - card_height - l_sheep_pos_backside.y

				l_pixmap_backside := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheep_pos_backside.x, l_sheep_pos_backside.y, card_width, card_height))
				l_pixmap := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheet_pos.x, l_sheet_pos.y, card_width, card_height))

			when 1 then --RIGHT
				l_pixmap.set_with_named_file (path_deck_right)
				initialize_size(l_pixmap, true)
				l_sheet_pos := get_card_position_in_sheet(card)
				l_sheep_pos_backside := get_card_back_position_in_sheet

				l_temp_val := l_sheet_pos.y
				l_sheet_pos.y := deck_width - card_width - l_sheet_pos.x
				l_sheet_pos.x := l_temp_val
				l_temp_val := l_sheep_pos_backside.y
				l_sheep_pos_backside.y := deck_width - card_width - l_sheep_pos_backside.x
				l_sheep_pos_backside.x := l_temp_val

				l_pixmap_backside := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheep_pos_backside.x, l_sheep_pos_backside.y, card_height, card_width))
				l_pixmap := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheet_pos.x, l_sheet_pos.y, card_height, card_width))

			when 2 then --BOTTOM
				l_pixmap.set_with_named_file (path_deck_btm)
				initialize_size(l_pixmap, false)
				l_sheet_pos := get_card_position_in_sheet(card)
				l_sheep_pos_backside := get_card_back_position_in_sheet

				l_pixmap_backside := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheep_pos_backside.x, l_sheep_pos_backside.y, card_width, card_height))
				l_pixmap := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheet_pos.x, l_sheet_pos.y, card_width, card_height))

			when 3 then --LEFT	
				l_pixmap.set_with_named_file (path_deck_left)
				initialize_size(l_pixmap, true)
				l_sheet_pos := get_card_position_in_sheet(card)
				l_sheep_pos_backside := get_card_back_position_in_sheet()

				l_temp_val := l_sheet_pos.y
				l_sheet_pos.y := l_sheet_pos.x
				l_sheet_pos.x := deck_height - card_height - l_temp_val
				l_temp_val := l_sheep_pos_backside.y
				l_sheep_pos_backside.y := l_sheep_pos_backside.x
				l_sheep_pos_backside.x := deck_height - card_height - l_temp_val

				l_pixmap_backside := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheep_pos_backside.x, l_sheep_pos_backside.y, card_height, card_width))
				l_pixmap := l_pixmap.sub_pixmap (create {EV_RECTANGLE}.make (l_sheet_pos.x, l_sheet_pos.y, card_height, card_width))

			else
				--FATAL ERROR	
			end

			Result := [l_pixmap, l_pixmap_backside]
		end


	get_card_position_in_sheet(card: TR_CARD): TUPLE[x: INTEGER; y: INTEGER]
		local
			l_x_pos: INTEGER
			l_y_pos: INTEGER
		do
			l_x_pos := (card.get_card_value - 1) * card_width

			if card.get_card_type.is_equal("swords") then
				l_y_pos := 0
			elseif card.get_card_type.is_equal("clubs") then
				l_y_pos := card_height
			elseif card.get_card_type.is_equal("cups") then
				l_y_pos := card_height * 2
			elseif card.get_card_type.is_equal("gold") then
				l_y_pos := card_height * 3
			end

			Result := [l_x_pos, l_y_pos]
		end

	get_card_back_position_in_sheet: TUPLE[x: INTEGER; y: INTEGER]
		do
			Result := [7*(card_width), 0]
		end


	initialize_size(deck_pixmap: EV_PIXMAP; left_or_right: BOOLEAN)
		do
			if left_or_right then
				deck_width := deck_pixmap.height
				deck_height := deck_pixmap.width
			else
				deck_width := deck_pixmap.width
				deck_height := deck_pixmap.height
			end

			card_width := deck_width // 12
			card_height := deck_height // 4
		end


	deck_width: INTEGER
	deck_height: INTEGER
	card_width: INTEGER
	card_height: INTEGER


end
