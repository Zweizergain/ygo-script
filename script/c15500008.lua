--化学结合-CO2
function c15500008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c15500008.cost)
	e1:SetTarget(c15500008.target)
	e1:SetOperation(c15500008.activate)
	c:RegisterEffect(e1)
end
function c15500008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,2,nil,58071123)
		and Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,15981690) end
	local g1=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,58071123)
	local g2=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,15981690)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c15500008.filter(c,e,tp)
	return c:IsCode(15500009) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c15500008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c15500008.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c15500008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c15500008.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
