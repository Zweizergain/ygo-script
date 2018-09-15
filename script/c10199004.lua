--特殊模式-RS-技能系统
function c10199004.initial_effect(c)
	
end
function c10199001.effect_mode_function_choose_buff_skill(e,tp,str)
	c10199001.doublechance={0}
	c10199001.doublechancect=0
	local ct=Duel.GetFlagEffect(tp,10199401)
	if ct>0 then
	   for i=1,ct+1 do
		   if tp==Duel.GetTurnPlayer() then
			  c10199001.buff_selfturn_function(e,tp,str,1)
		   else
			  c10199001.buff_oppoturn_function(e,tp,str,1)
		   end
	   end
	end
end