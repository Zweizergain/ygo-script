--闪光替身
function c34340007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c34340007.cost)
	e1:SetTarget(c34340007.target)
	e1:SetOperation(c34340007.activate)
	c:RegisterEffect(e1)	
end
function c34340007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c34340007.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsDiscardable() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c34340007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c34340007.spfilter(c,e,tp,lv)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34340007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c34340007.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c34340007.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c34340007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c34340007.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
