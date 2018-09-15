--RealScl
function c10199002.initial_effect(c)
	
end
  --[[  local tc,p,ac,tk,tf,dg,limitcard,slimitcard,forbiddencard,tf2=g:GetFirst(),0,0,nil,true,nil,io.open('limit.lua'),io.open('slimit.lua'),io.open('forbidden.lua'),false
	while tc do
	   p=tc:GetOwner()
	   tf=true  
	   while tf do
		 Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(10199001,2))
		 c10199001.announce_filter={TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		 ac=Duel.AnnounceCardFilter(p,table.unpack(c10199001.announce_filter))
		 tk=Duel.CreateToken(p,ac)
		 tf2=false
		 for line in io.lines('forbidden.lua') do
			 if line:byte()>47 and ac==tonumber(line) then
				tf2=false
			 end
		 end
		 for line in io.lines('limit.lua') do
			 if line:byte()>47 and ac==tonumber(line) and Duel.GetFieldGroup(p,LOCATION_DECK,0):IsExists(Card.IsCode,1,nil,ac) then
				tf2=false
			 end
		 end
		 for line in io.lines('slimit.lua') do
			 if line:byte()>47 and ac==tonumber(line) and Duel.GetFieldGroup(p,LOCATION_DECK,0):IsExists(Card.IsCode,2,nil,ac) then
				tf2=false
			 end
		 end
		 if Duel.GetFieldGroup(p,LOCATION_DECK,0):IsExists(Card.IsCode,3,nil,ac) or   
			tf2
		 then
			Duel.Hint(HINT_MESSAGE,p,aux.Stringid(10199001,3))  
		 else
			Duel.SendtoDeck(tk,nil,2,REASON_RULE)
			tf=false
		 end
	   end
	tc=g:GetNext()
	end

	if turncount==1 then 
	   while randomself==1 or randomself==3 do
			 randomself=math.random(2,8) 
	   end
	end
	if turncount==1 then 
	   while randomoppo==1 or randomoppo==2 do
			 randomoppo=math.random(3,8) 
	   end









function c10199001.buff_selfturn_function(e,turnplayer,str,doublechance)
	local randomself=math.random(1,11)
	if doublechance and doublechance==1 then
	   while c10199001.doublechance==randomself or randomself==11 do
		  randomself=math.random(1,11)
	   end
	end 
	c10199001.doublechance=randomself
	local randombuffeffect=_G["c10199001_"..randomself]
	if   randomself==1 then c10199001.effect_mode_function_random_buff_s1(e,turnplayer,str)
	elseif randomself==2 then c10199001.effect_mode_function_random_buff_s2(e,turnplayer,str)
	elseif randomself==3 then c10199001.effect_mode_function_random_buff_s3(e,turnplayer,str)
	elseif randomself==4 then c10199001.effect_mode_function_random_buff_s4(e,turnplayer,str)
	elseif randomself==5 then c10199001.effect_mode_function_random_buff_s5(e,turnplayer,str)
	elseif randomself==6 then c10199001.effect_mode_function_random_buff_so1(e,turnplayer,str)
	elseif randomself==7 then c10199001.effect_mode_function_random_buff_so2(e,turnplayer,str)
	elseif randomself==8 then c10199001.effect_mode_function_random_buff_so3(e,turnplayer,str)
	elseif randomself==9 then c10199001.effect_mode_function_random_buff_so4(e,turnplayer,str)
	elseif randomself==10 then c10199001.effect_mode_function_random_buff_so5(e,turnplayer,str)
	elseif randomself==11 then c10199001.effect_mode_function_random_buff_so6(e,turnplayer,str)
	end
end
	end ]]