--废星回收
function c21520153.initial_effect(c)
	--activity
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520153,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520153.condition)
	e1:SetTarget(c21520153.target)
	e1:SetOperation(c21520153.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520153,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,21520153)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c21520153.pcost)
	e2:SetTarget(c21520153.ptg)
	e2:SetOperation(c21520153.pop)
	c:RegisterEffect(e2)
end
function c21520153.tgfilter(c)
	return c:IsSetCard(0x491) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c21520153.filter(c)
	return not (c:IsSetCard(0x491) and (not c:IsOnField() or c:IsFaceup())) and c:IsType(TYPE_MONSTER)
end
function c21520153.filter2(c)
	return c:IsSetCard(0x491) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c21520153.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520153.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c21520153.target(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()) or chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c21520153.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
--		local rg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x492)
--		g:Sub(rg)
		return g:GetCount()>0 end
	local g1=Duel.GetMatchingGroup(c21520153.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
--	local rg1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x492)
--	g1:Sub(rg1)
	local ct=g1:GetCount()
	if ct>3 then ct=3 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,ct,0,0)
end
function c21520153.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520153.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
--	local rg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x492)
--	g:Sub(rg)
	local ct=g:GetCount()
	if ct>3 then ct=3 end
	if ct<=0 or not Duel.IsPlayerCanDraw(tp,ct) then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>3 then ct=3 end
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c21520153.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c21520153.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c21520153.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end	
end
