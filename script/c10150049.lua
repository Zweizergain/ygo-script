--暗之联结
function c10150049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10150049+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10150049.target)
	e1:SetOperation(c10150049.activate)
	c:RegisterEffect(e1)	
end

function c10150049.filter(c,e,tp)
	return c:IsLevelAbove(8) and c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c10150049.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,math.floor(c:GetLevel()/2))
end
function c10150049.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10150049.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10150049.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150049.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c10150049.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10150049.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10150049.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,math.floor(tc:GetLevel()/2))
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end