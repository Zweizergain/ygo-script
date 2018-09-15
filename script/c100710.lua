--连拍「Rapid Shot」
function c100710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCountLimit(1,100710+EFFECT_COUNT_CODE_OATH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c100710.cost)
	e1:SetCondition(c100710.condition)
	e1:SetTarget(c100710.target)
	e1:SetOperation(c100710.activate)
	c:RegisterEffect(e1)		
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100710,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100710.sumcon)
	e3:SetCost(c100710.descost)
	e3:SetTarget(c100710.target3)
	e3:SetOperation(c100710.operation3)
	c:RegisterEffect(e3)
end
function c100710.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,q,ap,loc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=Duel.GetOperationInfo(ev,CATEGORY_DRAW)
	if g then 
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then loc=LOCATION_DECK end 
	end 
	return ((ex and loc==LOCATION_DECK) or ex2) and rp==tp
end
function c100710.spcfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x208) and not c:IsPublic()
end
function c100710.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100710.spcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c100710.spcfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
end
function c100710.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=re
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c100710.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=re
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c100710.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and aux.exccon(e)
end
function c100710.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100710.filter2(c)
	return c:IsCode(100700) and c:IsAbleToHand()
end
function c100710.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100710.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100710.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c100710.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end