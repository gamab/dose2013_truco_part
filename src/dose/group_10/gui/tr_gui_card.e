note
	description: "Summary description for {TR_GUI_CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"



class
	TR_GUI_CARD


inherit
	EV_MODEL_GROUP

	TR_GUI_CARD_MANAGER
		export
			{NONE} all
		undefine
			default_create, copy
		end


create
	make_card


feature {ANY}  -- Access
	make_card (a_card: TR_CARD; direction: INTEGER; a_showing_front: BOOLEAN; position: TUPLE[x:INTEGER; y:INTEGER])

		local
			sheet_pos: TUPLE[x: INTEGER; y: INTEGER]
		do
			default_create

			card := a_card

			pixmaps := get_pixmaps_for_card(card, direction)

			showing_front := a_showing_front

			if showing_front then
				create card_model.make_with_pixmap(pixmaps.front)
			else
				create card_model.make_with_pixmap(pixmaps.back)
			end

			extend (card_model)

			set_point_position (position.x, position.y)
		end

	remake_card (a_card: TR_CARD; direction: INTEGER; show_front: BOOLEAN)
		do
			card := a_card
			pixmaps := get_pixmaps_for_card(card, direction)

			if show_front then
				card_model.set_pixmap(pixmaps.front)
			else
				card_model.set_pixmap(pixmaps.back)
			end
		end


	set_showing_front (a_showing_front: BOOLEAN)
	do
			if a_showing_front then
				card_model.set_pixmap (pixmaps.front)
			else
				card_model.set_pixmap(pixmaps.back)
			end
	end

	get_card: TR_CARD
		do
			Result := card
		end

feature {NONE}  --Attributes

	card_model: EV_MODEL_PICTURE

	pixmaps: TUPLE[front: EV_PIXMAP; back: EV_PIXMAP]

	showing_front: BOOLEAN

	card: TR_CARD
end
