--季雨 季风的使者
function c10118011.initial_effect(c)
	--gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(c10118011.mtop)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetDescription(aux.Stringid(10118011,0))
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10118011)
	e2:SetCondition(c10118011.spcon)
	e2:SetTarget(c10118011.sptg)
	e2:SetOperation(c10118011.spop)
	c:RegisterEffect(e2)
	--special summon 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118011,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10118111)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c10118011.cost)
	e3:SetTarget(c10118011.target)
	e3:SetOperation(c10118011.operation)
	c:RegisterEffect(e3)
end
function c10118011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10118011.cfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsReleasable() and Duel.IsExistingMatchingCard(c10118011.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c10118011.spfilter(c,e,tp,rc)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5331) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (not rc or ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,rc)>0) or (c:IsLocation(LOCATION_DECK) and (rc:GetSequence()<5 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0))))
end
function c10118011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()==100 then
		  e:SetLabel(0)
		  return Duel.IsExistingMatchingCard(c10118011.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	   else
		  return Duel.IsExistingMatchingCard(c10118011.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,nil)
	   end
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g=Duel.SelectMatchingCard(tp,c10118011.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	   Duel.Release(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c10118011.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c36737092.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10118011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10118011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10118011.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10118011.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if eg then g:Merge(eg)
	else
	   g:AddCard(c:GetReasonCard())
	end
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_XYZ) or c:IsReason(REASON_RITUAL) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetValue(500)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   local e2=e1:Clone()
		   e2:SetCode(EFFECT_UPDATE_DEFENSE)
		   e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		   e2:SetDescription(aux.Stringid(10118011,1))
		   --if not tc:IsReason(REASON_XYZ) then
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetType(EFFECT_TYPE_SINGLE)
		   --else 
			  --e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_XMATERIAL)
			  --e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_XMATERIAL)
		   --end
		   tc:RegisterEffect(e1)
		   tc:RegisterEffect(e2)
		end
	end
end