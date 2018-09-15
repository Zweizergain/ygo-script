--刀舞锻造
function c62800004.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62800004)
	e1:SetTarget(c62800004.target)
	e1:SetOperation(c62800004.activate)
	c:RegisterEffect(e1)
end
function c62800004.filter1(c,e,tp)
	return c:IsSetCard(0x620)  and not c:IsSetCard(0x2620) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62800004.filter2(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsType(TYPE_EQUIP)
end
function c62800004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c62800004.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c62800004.filter2,tp,LOCATION_SZONE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
end
function c62800004.activate(e,tp,eg,ep,ev,re,r,rp)
	local  ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
	ft=1
  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c62800004.filter1,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,c62800004.filter2,tp,LOCATION_SZONE,0,g:GetCount(),g:GetCount(),nil)
	Duel.Destroy(tg,REASON_EFFECT)
	end
end
