--龙之呼唤
function c10150006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150006+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10150006.condition)
	e1:SetTarget(c10150006.target)
	e1:SetOperation(c10150006.activate)
	c:RegisterEffect(e1)	  
end

function c10150006.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end

function c10150006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10150006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c10150006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10150006.filter(c)
	return c:IsRace(RACE_DRAGON) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAbleToHand()
end

function c10150006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c10150006.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc) 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsType(TYPE_NORMAL) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(10150006,0)) then
		 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end