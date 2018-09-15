--月灵 月出
function c19002034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,19002034)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19002034.target)
	e1:SetOperation(c19002034.activate)
	c:RegisterEffect(e1)
	--revive 
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(19002034,0))
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetType(EFFECT_TYPE_IGNITION)
	e21:SetRange(LOCATION_GRAVE)
	e21:SetCountLimit(1,19002134)
	e21:SetCost(aux.bfgcost)
	e21:SetTarget(c19002034.target2)
	e21:SetOperation(c19002034.operation2)
	c:RegisterEffect(e21)
end
function c19002034.filter2(c,e,tp)
	return c:IsSetCard(0xc750) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19002034.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c19002034.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c19002034.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c19002034.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c19002034.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19002034.filter(c,e,tp)
	return c:IsSetCard(0xc750) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c19002034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19002034.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19002034.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19002034.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=tc:IsAbleToHand()
	local b2=(tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	if not b1 and not b2 then return end
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(19002034,0))) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	Duel.ConfirmCards(1-tp,tc)
end
