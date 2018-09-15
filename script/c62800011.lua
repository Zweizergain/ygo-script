--断折的名刀荣誉
function c62800011.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62800011)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c62800011.target)
	e1:SetOperation(c62800011.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,62800012)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c62800011.con)
	e2:SetCost(c62800011.cost)
	e2:SetTarget(c62800011.tg)
	e2:SetOperation(c62800011.op)
	c:RegisterEffect(e2)
end
function c62800011.filter(c,e,tp)
	return c:IsSetCard(0x1620) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62800011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c62800011.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c62800011.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c62800011.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c62800011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e)
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		c:SetCardTarget(tc)
		Duel.SpecialSummonComplete()
end
end
function c62800011.con(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
	and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c62800011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c62800011.filter1(c,e,tp)
	return c:GetLevel()>0 and c:IsSetCard(0x620) and not c:IsSetCard(0x1620) and not c:IsSetCard(0x2620) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c62800011.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function c62800011.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsSetCard(0x620) and not c:IsSetCard(0x1620) and not c:IsSetCard(0x2620) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c62800011.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c62800011.filter3(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c62800011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c62800011.filter1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62800011.op(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c62800011.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c62800011.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
   if g1 and g2 then
	g1:Merge(g2)
	local lv=g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel()
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c62800011.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
end