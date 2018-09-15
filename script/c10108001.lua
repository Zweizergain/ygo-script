--糖果派 棒棒糖
function c10108001.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10108001,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10108001.sumtg)
	e1:SetOperation(c10108001.sumop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10108001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c10108001.tktg)
	e2:SetOperation(c10108001.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c10108001[c]=e2  
end
function c10108001.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10108008,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10108001.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c,ft,op=e:GetHandler(),Duel.GetLocationCount(1-tp,LOCATION_MZONE),0
	if ft<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,10108008,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) then return end
	local token=Duel.CreateToken(tp,10108008)
	if c:IsHasEffect(10108005) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>=2 and Duel.SelectYesNo(tp,aux.Stringid(10108005,2)) then
	   ft=2
	else ft=1
	end
	for i=1,ft do
		local token=Duel.CreateToken(tp,10108008)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
	local g=Duel.GetOperatedGroup()
	if g:GetCount()<=0 then return end
	if c:IsHasEffect(10108006) and Duel.SelectYesNo(tp,aux.Stringid(10108006,2)) then
	   op=2
	else
	   op=Duel.SelectOption(tp,aux.Stringid(10108001,2),aux.Stringid(10108001,3))
	end
	local tc=g:GetFirst()
	while tc do
		  local e0=Effect.CreateEffect(tc)
		  e0:SetType(EFFECT_TYPE_SINGLE)
		  e0:SetCode(EFFECT_ADD_TYPE)
		  e0:SetValue(TYPE_EFFECT)
		  e0:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e0)
	   if op~=1 then
		  local e1=Effect.CreateEffect(tc)
		  e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		  e1:SetDescription(aux.Stringid(10108001,4))
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e1)
	   end
	   if op~=0 then
		  local e2=Effect.CreateEffect(tc)
		  e2:SetType(EFFECT_TYPE_FIELD)
		  e2:SetDescription(aux.Stringid(10108001,5))
		  e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		  e2:SetRange(LOCATION_MZONE)
		  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		  e2:SetTargetRange(LOCATION_MZONE,0)
		  e2:SetReset(RESET_EVENT+0x1fe0000)
		  e2:SetValue(c10108001.atkval)
		  tc:RegisterEffect(e2)
		  local e3=e2:Clone()
		  e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		  e3:SetValue(c10108001.defval)
		  tc:RegisterEffect(e3)
	   end
	tc=g:GetNext()
	end
end
function c10108001.atkval(e,c)
	return c:GetAttack()/2
end
function c10108001.defval(e,c)
	return c:GetDefense()/2
end
function c10108001.filter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108001.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10108001.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10108001.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10108001.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end