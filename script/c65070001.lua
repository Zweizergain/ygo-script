--谜题之罐
function c65070001.initial_effect(c)
	--SPS
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c65070001.sptg)
	e1:SetOperation(c65070001.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c65070001.thcost)
	e2:SetTarget(c65070001.thtg)
	e2:SetOperation(c65070001.thop)
	c:RegisterEffect(e2)
end
c65070001.toss_coin=true

function c65070001.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65070001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65070001.spfil,tp,LOCATION_DECK,LOCATION_DECK,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end

function c65070001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.TossCoin(tp,1)
	if c==1 then
		local g1=Duel.SelectMatchingCard(tp,c65070001.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65070001,0)) then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local g2=Duel.SelectMatchingCard(1-tp,c65070001.spfil,tp,0,LOCATION_DECK,1,1,nil,e,tp)
		if g2:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(65070001,0)) then
			Duel.SpecialSummon(g2,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
function c65070001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end

function c65070001.filter(c)
	return c:IsCode(10813327,43906884,71541986,511000142,1804528,10489311,21908319,50684552,68810489,65070001,65071047)
end
function c65070001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65070001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65070001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65070001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end