--超古代金字塔
function c13301902.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13301902)
	e1:SetTarget(c13301902.target)
	e1:SetOperation(c13301902.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,13301903)
	e2:SetCondition(c13301902.spcon)
	e2:SetTarget(c13301902.sptg)
	e2:SetOperation(c13301902.spop)
	c:RegisterEffect(e2)
end
function c13301902.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13301902.target(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	   and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	   and Duel.IsExistingTarget(c13301902.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,13301904)
	   and Duel.IsExistingTarget(c13301902.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,13301905) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c13301902.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c13301902.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,13301904)
	local g2=Duel.GetMatchingGroup(c13301902.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,13301905)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13301902.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE)
end
function c13301902.filter1(c,e,tp)
	return c:IsCode(13301896) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c13301902.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c13301902.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c13301902.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13301902.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

	