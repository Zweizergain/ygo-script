--残霞的余光
function c99999993.initial_effect(c)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99999993,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,99999993+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c99999993.target)
	e1:SetOperation(c99999993.operation)
	c:RegisterEffect(e1)
end
function c99999993.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if chk==0 then return g:GetCount()>=5 and g:GetFirst():IsAbleToRemove()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99999993.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<5 or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	g=Duel.GetDecktopGroup(tp,5)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==5 then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
