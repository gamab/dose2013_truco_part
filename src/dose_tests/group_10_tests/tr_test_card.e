note
	description: "Summary description for {TR_TEST_CARD}."
	author: "Justine Compagnon"
	date: "12/11/2013"
	revision: ""

class
	TR_TEST_CARD

inherit
	EQA_TEST_SET

feature -- Test routines



	test_make
	note
		testing: "covers/{TR_CARD}.make"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		worked_well: BOOLEAN
		card: TR_CARD

	do
		create card.make ("swords", 1 )
		worked_well := false
		if (card.get_card_type.is_equal ("swords") and card.get_card_value = 1) then
			worked_well := true
		end
		assert ("make ok", worked_well )
	end




	test_get_card_type
	note
		testing: "covers/{TR_CARD}.get_card_type"
		testing: "user/TR" -- this is tag with the class-prefix
	local
		worked_well: BOOLEAN
		card: TR_CARD
		card_type: STRING
	do
		worked_well := false
		create card.make ("swords", 4)
		card_type := card.get_card_type;
		if card_type.is_equal ("swords") then
			worked_well := true;
		end
		assert ("get_card_type ok", worked_well )
	end





   test_get_card_value
   	note
		testing: "covers/{TR_CARD}.get_card_value"
		testing: "user/TR" -- this is tag with the class-prefix
   local
		worked_well: BOOLEAN
		card: TR_CARD
		card_value: INTEGER
   do
   		worked_well:= false
   		create card.make ("swords", 4)
   		card_value := card.get_card_value;
   		if card_value = 4 then
   			worked_well := true;
   		end
		assert ("get_card_value ok", worked_well )
   end




	-- Need to modify the value real_card_weight so it fits the weight is suppose to have the 1 of sword
   test_get_card_weight_truco
   	note
		testing: "covers/{TR_CARD}.get_card_weight_truco"
		testing: "user/TR" -- this is tag with the class-prefix
   local
		worked_well: BOOLEAN
		card: TR_CARD
		weight: INTEGER
		real_card_weight: INTEGER
   do
   		worked_well := false
   		real_card_weight := 13
   		create card.make ("swords", 1)
   		weight := card.get_card_weight_truco
   		if weight = real_card_weight  then
   			worked_well := true
   		end
   		assert ("get_card_weight_truco ok", worked_well )
   end



	-- Need to modify the value real_card_weight so it fits the weight is suppose to have the 1 of sword
   test_get_card_weight_envido
   	note
		testing: "covers/{TR_CARD}.get_card_weight_envido"
		testing: "user/TR" -- this is tag with the class-prefix
   local
		worked_well: BOOLEAN
		card: TR_CARD
		weight: INTEGER
		real_card_weight: INTEGER
   do
   		worked_well := false
   		real_card_weight := 1
   		create card.make ("swords", 1)
   		weight := card.get_card_weight_envido
   		if weight = real_card_weight  then
   			worked_well := true
   		end
		assert ("get_card_weight_envid ok", worked_well )
   end





end
