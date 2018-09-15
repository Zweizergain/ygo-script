--紫炎的道场
function c98702008.initial_effect(c)
	c:EnableCounterPermit(0x3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98702008.target)
	e1:SetOperation(c98702008.operation)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c98702008.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(98702008,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c98702008.spcost)
	e4:SetTarget(c98702008.sptg)
	e4:SetOperation(c98702008.spop)
	c:RegisterEffect(e4)
end
function c98702008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x3,3,c) end
end
function c98702008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:AddCounter(0x3,2)
end
function c98702008.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d)
end
function c98702008.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c98702008.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x3,1)
	end
end
function c98702008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	local ct=e:GetHandler():GetCounter(0x3)
	e:SetLabel(ct)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98702008.spfilter(c,ct,e,tp)
	return c:IsLevelBelow(ct) and (c:IsSetCard(0x3d) or c:IsSetCard(0x20)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98702008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98702008.spfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCounter(0x3),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98702008.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=Duel.GetMatchingGroup(c98702008.spfilter,tp,LOCATION_DECK,0,nil,ct,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		ct=ct-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,ct+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(28577986,1))
	Duel.SpecialSummonComplete()
end
