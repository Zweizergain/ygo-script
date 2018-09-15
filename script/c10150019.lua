--守护之力
function c10150019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150019+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10150019.cost)
	e1:SetTarget(c10150019.target)
	e1:SetOperation(c10150019.activate)
	c:RegisterEffect(e1)	  
end

function c10150019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c10150019.filter(c,e,tp)
	return c:IsCode(34022290) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10150019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150019.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c10150019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10150019.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local sg=Duel.GetMatchingGroup(c10150019.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150019,0)) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	 local tg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c10150019.tdfilter(c)
	return c:IsCode(18175965) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

