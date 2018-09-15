--恶魔的不甘
function c35310014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c35310014.condition)
	e1:SetTarget(c35310014.target)
	e1:SetOperation(c35310014.activate)
	c:RegisterEffect(e1)	
end
c35310014.setname="acfiend"
function c35310014.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c35310014.setfilter1(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable(true)
end
function c35310014.setfilter2(c)
	return c35310014.setfilter1(c) and c.setname=="acfiend"
end
function c35310014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c35310014.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SendtoGrave(rc,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(c35310014.setfilter1,tp,0,LOCATION_DECK,nil)
		local g2=Duel.GetMatchingGroup(c35310014.setfilter2,tp,LOCATION_DECK,0,nil)
		if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
			Duel.ConfirmCards(1-tp,sg)
		end
		if g1:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g1:Select(1-tp,1,1,nil)
			Duel.SSet(1-tp,sg:GetFirst())
			Duel.ConfirmCards(tp,sg)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c35310014.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c35310014.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
