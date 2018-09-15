--乱数指挥
function c21520015.initial_effect(c)
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520015,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
--	e1:SetCondition(c21520015.con)
	e1:SetOperation(c21520015.rlevel)
	c:RegisterEffect(e1)
	--summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520015,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xbf,0xbf)
--	e2:SetCondition(c21520015.con)
	e2:SetOperation(c21520015.rlevel)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--deck synchron or to hand or spcial summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,21520015)
	e5:SetTarget(c21520015.target)
	e5:SetOperation(c21520015.operation)
	c:RegisterEffect(e5)
--	c21520015[0]=true
end
function c21520015.rlevel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320
	math.randomseed(c:GetFieldID()+ct*10000)
	local val=math.random(1,800)
	val=math.fmod(val,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) 
		and (Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and 
			Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil))
		or Duel.IsExistingMatchingCard(c21520015.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,12) 
		or Duel.IsExistingMatchingCard(c21520015.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
--	c21520015[0]=false
end
function c21520015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	if g:GetCount()==0 then return end
	local rg=g:RandomSelect(tp,1)
	Duel.ConfirmCards(tp,rg)
	Duel.ConfirmCards(1-tp,rg)
	local mg=Group.CreateGroup()
	mg:Merge(rg)
	mg:AddCard(c)
	local lv=c:GetLevel()+rg:GetFirst():GetOriginalLevel()
	local ft=Duel.GetLocationCountFromEx(tp,tp,mg)
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local spg=Duel.GetMatchingGroup(c21520015.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,lv,ft)
	local tc=rg:GetFirst()
	local op=3
	if sg:GetCount()>0 and (tc:IsAbleToHand() and hg:GetCount()>0) and (tc:IsAbleToRemove() and c:IsAbleToRemove() and spg:GetCount()>0) then
		op=Duel.SelectOption(tp,aux.Stringid(21520015,1),aux.Stringid(21520015,2),aux.Stringid(21520015,3))
	elseif sg:GetCount()>0 and (tc:IsAbleToHand() and hg:GetCount()>0) then
		op=Duel.SelectOption(tp,aux.Stringid(21520015,1),aux.Stringid(21520015,2))
	elseif sg:GetCount()>0 and (tc:IsAbleToRemove() and c:IsAbleToRemove() and spg:GetCount()>0) then
		op=Duel.SelectOption(tp,aux.Stringid(21520015,1),aux.Stringid(21520015,3))
		if op==1 then op=2 end
	elseif (tc:IsAbleToHand() and hg:GetCount()>0) and (tc:IsAbleToRemove() and c:IsAbleToRemove() and spg:GetCount()>0) then
		op=Duel.SelectOption(tp,aux.Stringid(21520015,2),aux.Stringid(21520015,3))
		op=op+1
	elseif sg:GetCount()>0 then
		op=0
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520015,1))
	elseif (tc:IsAbleToHand() and hg:GetCount()>0) then
		op=1
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520015,2))
	elseif (tc:IsAbleToRemove() and c:IsAbleToRemove() and spg:GetCount()>0) then
		op=2
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520015,3))
	end
	if op==0 then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_NONTUNER)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e6)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local syn=sg:Select(tp,1,1,nil)
		local sc=syn:GetFirst()
		Duel.SynchroSummon(tp,sc,nil,mg)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0xdff0000)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spc=spg:Select(tp,1,1,nil):GetFirst()
		Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(spc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(spc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetCost(c21520015.paycost)
		e1:SetTarget(c21520015.paytg)
		e1:SetOperation(c21520015.payop)
		e1:SetReset(RESET_EVENT+0xff0000)
		spc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(spc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetCondition(c21520015.actcon)
		e2:SetReset(RESET_EVENT+0xff0000)
		spc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
--	c21520015[0]=true
end
function c21520015.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_SYNCHRO)
end
function c21520015.spfilter(c,e,tp,lv,ft)
	if ft~=nil then
		return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(lv) and ft>0
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(lv)
	end
end
function c21520015.paycost(e,c,tp)
	return Duel.CheckLPCost(tp,2048)
end
function c21520015.paytg(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c21520015.payop(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.GetLP(tp)>2048 then
		Duel.PayLPCost(e:GetHandlerPlayer(),2048)
	else
		Duel.SetLP(tp,0)
	end
end
function c21520015.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<2048
end
--[[
function c21520015.con(e,tp,eg,ep,ev,re,r,rp)
	return c21520015[0]
end--]]
