--孤独存在 沙耶
function c8000.initial_effect(c)
	 --Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8000,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,0x1c0+TIMING_STANDBY_PHASE)
	e2:SetCost(c8000.cost)
	e2:SetOperation(c8000.thop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8000,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,8000)
	e1:SetCondition(c8000.spcon)
	e1:SetOperation(c8000.spop)
	c:RegisterEffect(e1)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c8000.xyzlimit)
	c:RegisterEffect(e3)
end
function c8000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c8000.cfilter(c)
	return c:IsSetCard(0x901) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c8000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	if Duel.IsExistingMatchingCard(c8000.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) then 
	local g=Duel.SelectMatchingCard(tp,c8000.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) else
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) end
	Duel.ShuffleHand(tp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	Duel.BreakEffect()
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c8000.drcon1)
	e4:SetOperation(c8000.drop1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e5:SetCondition(c8000.regcon)
	--e5:SetOperation(c8000.regop)
	--e5:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e5,tp)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e6,tp)
	--local e8=e5:Clone()
	--e8:SetCode(EVENT_SUMMON_SUCCESS)
	--Duel.RegisterEffect(e8,tp)
	--local e7=Effect.CreateEffect(c)
	--e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e7:SetCode(EVENT_CHAIN_SOLVED)
	--e7:SetCondition(c8000.drcon2)
	--e7:SetOperation(c8000.drop2)
	--e7:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e7,tp)
	--bu neng fa
	--local e9=Effect.CreateEffect(e:GetHandler())
	--e9:SetType(EFFECT_TYPE_FIELD)
	--e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e9:SetTargetRange(1,0)
	--e9:SetValue(c8000.aclimit)
	--e9:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e9,tp)
end
function c8000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(1-tp,1)
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,8100,0x901,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK)
end
function c8000.spop(e,tp,eg,ep,ev,re,r,rp,c)
		local token=Duel.CreateToken(1-tp,8100)
		Duel.SpecialSummon(token,0,1-tp,1-tp,false,false,POS_FACEUP)
end
function c8000.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x901)
end
function c8000.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c8000.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c8000.filter,1,nil,1-tp)
end
function c8000.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c8000.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c8000.filter,1,nil,1-tp) 
end
function c8000.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,8000,RESET_CHAIN,0,1)
end
function c8000.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,8000)>0
end
function c8000.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,8000)
	Duel.ResetFlagEffect(tp,8000)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c8000.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x901)
end