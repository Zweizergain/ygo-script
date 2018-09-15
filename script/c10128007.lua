--奇妙旅行
function c10128007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10128007)
	e1:SetTarget(c10128007.target)
	e1:SetOperation(c10128007.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128007,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,10128107)
	e2:SetCost(c10128007.drcost)
	e2:SetTarget(c10128007.drtg)
	e2:SetOperation(c10128007.drop)
	c:RegisterEffect(e2)	  
end
function c10128007.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10128007.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.DiscardHand(tp,c10128007.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c10128007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10128007.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if bit.band(tc:GetType(),0x10002)==0x10002 and tc:IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(10128007,1)) then
		   Duel.SendtoGrave(tc,REASON_EFFECT)
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c10128007.costfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsDiscardable()
end
function c10128007.filter(c)
	return c:IsSetCard(0x6336) and c:IsAbleToHand()
end
function c10128007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10128007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10128007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10128007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY)  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end