--伊芙
function c99993019.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99993019)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsReleasable() end
		Duel.Release(e:GetHandler(),REASON_COST)
	end )
	e1:SetTarget(c99993019.tg1)
	e1:SetOperation(c99993019.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,99994019)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c99993019.rmtg)
	e2:SetOperation(c99993019.rmop)
	c:RegisterEffect(e2)
end
c99993019.Remi_named_with_eve=true
function c99993019.Remi_IsEve(c,f)
	local func=f or Card.GetCode
	local t={func(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.Remi_named_with_eve then return true end
	end
	return false
end
function c99993019.thfilter(c)
	return not c:IsCode(99993019) and c99993019.Remi_IsEve(c) and c:IsAbleToHand()
end
function c99993019.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99993019.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99993019.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99993019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99993019.rmfilter(c)
	return c:GetLevel()==4 and c:IsAbleToRemove()
end
function c99993019.spfilter(c,e,tp)
	return bit.band(c:GetType(),TYPE_SYNCHRO+TYPE_EFFECT)==TYPE_SYNCHRO and c:GetLevel()==8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99993019.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c99993019.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99993019.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c99993019.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99993019.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99993019.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_EFFECT)
		local spg=Duel.GetMatchingGroup(c99993019.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if spg:GetCount()~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=spg:Select(tp,1,1,nil)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		else
			local exg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(Card.IsFacedown,nil)
			if exg:GetCount()~=0 then Duel.ConfirmCards(1-tp,exg) end
		end
	end
end