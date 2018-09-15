--乱数显现
function c21520013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520013,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520013.target)
	e1:SetOperation(c21520013.activate)
	c:RegisterEffect(e1)
end
function c21520013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520013.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<1 then return end
	local tg=g:RandomSelect(tp,1)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
--[[	--not randomly
	if not tg:GetFirst():IsSetCard(0x493) then
		local sum=0
		if tg:GetFirst():IsType(TYPE_MONSTER) then
			sum=tg:GetFirst():GetOriginalLevel()
		else
			math.randomseed(tonumber(tostring(require("os").time()+10):reverse():sub(1,6)))
			sum=math.random(1,10)
		end
		Duel.Hint(HINT_NUMBER,tp,sum)
		Duel.Hint(HINT_NUMBER,1-tp,sum)
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end--]]
	Duel.BreakEffect()
	if Duel.SelectYesNo(1-tp,aux.Stringid(21520013,2)) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) then
		local thg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,thg)
		if Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(21520013,2)) then
			local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end
