--索尔德之取引
--DoItYourself By if
function c33000106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33000105,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33000106+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33000106.target)
	e1:SetOperation(c33000106.activate)
	c:RegisterEffect(e1)
end
function c33000106.filter(c)
	return c:IsSetCard(0x402)and not c:IsCode(33000106) and c:IsAbleToHand()
end
function c33000106.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33000106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33000106.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33000106.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33000106,0))
	local g=Duel.GetMatchingGroup(c33000106.mfilter,tp,0,LOCATION_DECK,nil)
	if g:GetCount()>0 then
	    local sc=g:RandomSelect(tp,1)
		Duel.HintSelection(sc)
		local tc=sc:GetFirst()
	    if not tc then return end
	    if Duel.SendtoHand(tc,1-tp,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(c33000106.aclimit)
		Duel.RegisterEffect(e1,tp)
		Duel.ShuffleHand(1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c33000106.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
		end
	end
end
function c33000106.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end