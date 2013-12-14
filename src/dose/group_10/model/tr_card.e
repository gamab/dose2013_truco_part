note
		 description: "{TR_CARD}represent the cards on trcuo and their weights %N%
		 %the class functions'headers  at the end of the class"

		author: "tariqsenosy"
		date: "20/10/2013"
		revision: ""
class

        TR_CARD
inherit
	STORABLE
        
create
        make

feature{NONE}
        type           :STRING
        value          :INTEGER
        weight_truco   :INTEGER
        weight_envido  :INTEGER

feature{NONE}-- represent the headers of the class'functions

--make(card_type:STRING;card_value:INTEGER)
--get_card_type():STRING
----get_card_value ():INTEGER
--get_card_weight_envido():INTEGER
----get_card_weight_truco():INTEGER
--set_to_void()


feature{ANY}

 make(card_type:STRING;card_value:INTEGER)
    	do
        	type:= card_type
        	value:= card_value
        	--truco and envido weight
   			if value>=4 and value<=7 then weight_truco:=value-4
			elseif value>=10 and value<=12 then weight_truco:=value-6
			elseif value>=1 and value<=3 then weight_truco:=value+6 end
			if value = 7 and type.is_equal ( "golds" )then weight_truco:=10
		    elseif value = 7 and type.is_equal ( "swords") then weight_truco:=11
		    elseif value = 1 and type.is_equal ( "clubs" )then weight_truco:=12
		  	elseif value = 1 and type.is_equal ( "swords") then weight_truco:=13 end
			if value > 0 and value < 8 then weight_envido:=value
        	else weight_envido:=0 end
end

   get_card_type():STRING
     do
     result:= type
     end
   get_card_value ():INTEGER
     do
      result:=value
     end
   get_card_weight_envido():INTEGER
    do
    result:= weight_envido
    end
   get_card_weight_truco():INTEGER
      do
      result:= weight_truco
     end
   set_to_void()
   do
   	    type:="";value :=-1;weight_truco:=-1;weight_envido:=-1
   end

end

