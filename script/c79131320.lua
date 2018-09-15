--灵噬的赐予
function c79131320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79131320+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c79131320.cost)
	e1:SetTarget(c79131320.target)
	e1:SetOperation(c79131320.activate)
	c:RegisterEffect(e1)
end
function c79131320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function c79131320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0 end
end
function c79131320.thfil(c)
	return c:IsCode(79131320) and c:IsAbleToHand()
end
function c79131320.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if cg:GetCount()>0 then
		local tc=cg:GetFirst()
		local con=0
		while tc do
			if tc:AddCounter(0x1206,1) then con=1 end
			tc=cg:GetNext()
		end
		if con==1 and Duel.IsExistingMatchingCard(c79131320.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79131320,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c79131320.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end