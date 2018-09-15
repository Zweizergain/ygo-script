--	秘术「呼唤神风的星之仪式」
function c1231611.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1231611+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1231611.cost)
	e1:SetTarget(c1231611.target)
	e1:SetOperation(c1231611.activate)
	c:RegisterEffect(e1)	
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1231611,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1231611)
	e2:SetCost(c1231611.negcost)
	e2:SetTarget(c1231611.distg)
	e2:SetOperation(c1231611.disop)
	c:RegisterEffect(e2)
end
function c1231611.thfilter(c)
	return c:IsSetCard(0x1601) and c:IsAbleToHand() and c:IsAbleToHand() and not c:IsCode(1231611)
end
function c1231611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	--Use For AI
	Duel.RegisterFlagEffect(tp,1231611,RESET_PHASE+PHASE_END,0,1)	
end
function c1231611.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208)
end
function c1231611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231611.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c1231611.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c1231611.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c1231611.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc2=Duel.SelectMatchingCard(tp,c1231611.filter,tp,LOCATION_DECK,0,1,1,nil)
	tc:Merge(tc2)
	if tc and tc:GetCount()==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c1231611.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c1231611.dfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208)
end
function c1231611.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231611.dfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c1231611.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1231611.dfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c1231611.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

function c1231611.aclimit(e,re,tp)
	return re:GetHandler():GetLocation()==LOCATION_GRAVE
end