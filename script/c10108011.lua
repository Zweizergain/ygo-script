--糖果派 大师级甜点师
function c10108011.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10108011,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c10108011.tdcost)
	e1:SetCondition(c10108011.tdcon)
	e1:SetTarget(c10108011.tdtg)
	e1:SetOperation(c10108011.tdop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10108011.spcon)
	e2:SetOperation(c10108011.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c10108011.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c10108011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10108011.cfilter,1,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10108008,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) 
end
function c10108011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,ft=e:GetHandler(),Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.Hint(HINT_CARD,0,10108011)
	if c:IsHasEffect(10108005) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>=2 and Duel.SelectYesNo(tp,aux.Stringid(10108005,2)) then
	   ft=2
	else ft=1
	end
	for i=1,ft do
		local token=Duel.CreateToken(tp,10108008)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_IMMUNE_EFFECT)
		   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetOwnerPlayer(tp)
		   e1:SetValue(c10108011.efilter)
		   token:RegisterEffect(e1,true)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		   e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		   e2:SetOwnerPlayer(tp)
		   e2:SetValue(c10108011.limit)
		   e2:SetReset(RESET_EVENT+0x1fe0000)
		   token:RegisterEffect(e2,true)
		   local e3=e2:Clone()
		   e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		   token:RegisterEffect(e3,true)
		   local e4=Effect.CreateEffect(c)
		   e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e4:SetCode(EFFECT_CANNOT_RELEASE)
		   e4:SetReset(RESET_EVENT+0x1fe0000)
		   e4:SetTargetRange(0,1)
		   e4:SetTarget(c10108011.tg)
		   token:RegisterEffect(e4,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c10108011.tg(e,c)
	return c==e:GetHandler()
end
function c10108011.limit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetOwnerPlayer())
end
function c10108011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10108011.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10108011.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10108011.tdfilter(c)
	return c:IsAbleToDeck() and not c:IsType(TYPE_TOKEN)
end
function c10108011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10108011.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10108011.tdfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c10108011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10108011.tdfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end