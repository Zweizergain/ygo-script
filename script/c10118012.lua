--季雨 夏之夏恋
function c10118012.initial_effect(c)
	--gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(c10118012.mtop)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetDescription(aux.Stringid(10118012,0))
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,10118012)
	e2:SetCondition(c10118012.spcon)
	e2:SetTarget(c10118012.sptg)
	e2:SetOperation(c10118012.spop)
	c:RegisterEffect(e2) 
	--special summon 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118012,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10118112)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c10118012.cost)
	e3:SetTarget(c10118012.target)
	e3:SetOperation(c10118012.operation)
	c:RegisterEffect(e3)   
end
function c10118012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10118012.cfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c10118012.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x5331) and c:IsCanBeSpecialSummoned(e,TYPE_FUSION,tp,false,false)
end
function c10118012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if not Duel.IsExistingMatchingCard(c10118012.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
	   if e:GetLabel()==100 then 
		  e:SetLabel(0)
		  return Duel.IsExistingMatchingCard(c10118012.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	   else 
		  return Duel.GetLocationCountFromEx(tp)>0
	   end
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g=Duel.SelectMatchingCard(tp,c10118011.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	   Duel.Release(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10118012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10118012.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
	   g:GetFirst():CompleteProcedure()
	end
end
function c10118012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c10118012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10118012.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10118012.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if eg then g:Merge(eg)
	else
	   g:AddCard(c:GetReasonCard())
	end
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_SYNCHRO) or c:IsReason(REASON_RITUAL) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		   e1:SetValue(aux.tgoval)
		   e1:SetDescription(aux.Stringid(10118012,0))
		   tc:RegisterEffect(e1)
		end
	end
end