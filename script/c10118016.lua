--季雨 冬之冬灵
function c10118016.initial_effect(c)
	--gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(c10118016.mtop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118016,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1,10118016)
	e2:SetCondition(c10118016.spcon)
	e2:SetTarget(c10118016.sptg)
	e2:SetOperation(c10118016.spop)
	c:RegisterEffect(e2)
	--special summon 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118016,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10118116)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c10118016.cost)
	e3:SetTarget(c10118016.target)
	e3:SetOperation(c10118016.operation)
	c:RegisterEffect(e3) 
end
function c10118016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10118016.cfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c10118016.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x5331) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
end
function c10118016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if not Duel.IsExistingMatchingCard(c10118016.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) then return false end
	   if e:GetLabel()==100 then 
		  e:SetLabel(0)
		  return Duel.IsExistingMatchingCard(c10118016.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	   else 
		  return Duel.GetLocationCountFromEx(tp)>0
	   end
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g=Duel.SelectMatchingCard(tp,c10118016.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	   Duel.Release(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10118016.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10118016.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
	   g:GetFirst():CompleteProcedure()
	end
end
function c10118016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER) and re:GetHandler():IsControler(tp)
end
function c10118016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10118016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10118016.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if eg then g:Merge(eg)
	else
	   g:AddCard(c:GetReasonCard())
	end
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_RITUAL) or c:IsReason(REASON_RITUAL) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		   e1:SetCountLimit(1)
		   e1:SetDescription(aux.Stringid(10118013,1))
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(c10118016.indct)
		   tc:RegisterEffect(e1)
		end
	end
end
function c10118016.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end