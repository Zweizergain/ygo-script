--解放之阿里阿德涅
function c98750006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c98750006.costchange)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISCARD_COST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98750006,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98750006.regcon)
	e4:SetTarget(c98750006.regtg)
	e4:SetOperation(c98750006.regop)
	c:RegisterEffect(e4)
	--send to extra
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c98750006.seop)
	c:RegisterEffect(e5)
end
function c98750006.costchange(e,re,rp,val)
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_COUNTER) then
		return 0
	else
		return val
	end
end
function c98750006.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c98750006.cofilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c98750006.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(c98750006.cofilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98750006.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98750006.cofilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98750006.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsForbidden()
end
function c98750006.filter2(c,tp)
	return c:IsCode(56433456) and c:GetActivateEffect():IsActivatable(tp)
end
function c98750006.cfilter(c)
	return c:IsFaceup() and c:IsCode(56433456)
end
function c98750006.seop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_COUNTER) then return end
	if (not Duel.IsExistingMatchingCard(c98750006.cfilter,tp,LOCATION_ONFIELD,0,1,nil))
		and Duel.IsExistingMatchingCard(c98750006.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) then
		Duel.Hint(HINT_CARD,0,98750006)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98750006,2))
		local g=Duel.SelectMatchingCard(tp,c98750006.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
		local tc1=g:GetFirst()
		if tc1 then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif Duel.IsExistingMatchingCard(c98750006.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c98750006.filter1,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_CARD,0,98750006)
		Duel.BreakEffect()
		local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
		local g1=Duel.GetMatchingGroup(c98750006.filter1,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98750006,3))
		local sg1=g1:Select(tp,1,1,nil)
		local tc2=sg1:GetFirst()
		if b1 then
			if Duel.SelectYesNo(tp,aux.Stringid(98750006,1)) then
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			else
				Duel.SendtoExtraP(tc2,nil,REASON_EFFECT)
			end
		else
			Duel.SendtoExtraP(tc2,nil,REASON_EFFECT)
		end
	end
end
