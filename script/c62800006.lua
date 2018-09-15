--重斩落！
function c62800006.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c62800006.condition)
	e1:SetCountLimit(1,62800006)
	e1:SetTarget(c62800006.target)
	e1:SetOperation(c62800006.activate)
	c:RegisterEffect(e1)
end
function c62800006.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c62800006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c62800006.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1620) or c:IsSetCard(0x2620))
end
function c62800006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c62800006.spfilter(c,e,tp)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x1620) and not c:IsSetCard(0x2620) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62800006.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
	   local dg=Duel.GetOperatedGroup():GetFirst()
		 if dg:IsType(TYPE_MONSTER) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		 Duel.IsExistingMatchingCard(c62800006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c62800006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
end
