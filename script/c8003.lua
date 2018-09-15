--病娇腹黑 沙耶
function c8003.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8003,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8003)
	e1:SetCondition(c8003.condition)
	e1:SetCost(c8003.cost)
	e1:SetOperation(c8003.operation)
	c:RegisterEffect(e1)
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(8003,0))
	--e1:SetCategory(CATEGORY_DRAW)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetRange(LOCATION_HAND)
	--e1:SetCost(c8003.drcost)
	--e1:SetTarget(c8003.drtg)
	--e1:SetOperation(c8003.drop)
	--c:RegisterEffect(e1)	 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCountLimit(1,8003)
	e2:SetCondition(c8003.spcon)
	e2:SetOperation(c8003.spop)
	c:RegisterEffect(e2)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c8003.xyzlimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetTarget(c8003.rmtg)
	e4:SetOperation(c8003.rmop)
	c:RegisterEffect(e4)
end
function c8003.condition(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()~=tp
end
function c8003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c8003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCondition(c8003.drcon1)
	e1:SetOperation(c8003.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e2:SetCode(EVENT_RECOVER)
	--e2:SetCondition(c8003.regcon)
	--e2:SetOperation(c8003.regop)
	--e2:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e2,tp)
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e3:SetCode(EVENT_CHAIN_SOLVED)
	--e3:SetCondition(c8003.drcon2)
	--e3:SetOperation(c8003.drop2)
	--e3:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e3,tp)  
end
--function c8003.filter(c,tp)
	--return c:IsReason(Recover)>=1000
--end
function c8003.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return ev>=1000 and ep==tp
end
function c8003.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c8003.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>=1000 and ep==tp
end
function c8003.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,8003,RESET_CHAIN,0,1)
end
function c8003.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,8003)>0
end
function c8003.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,8003)
	Duel.ResetFlagEffect(tp,8003)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c8003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(1-tp,1)
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,8100,0x901,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK)
end
function c8003.spop(e,tp,eg,ep,ev,re,r,rp,c)
		local token=Duel.CreateToken(1-tp,8100)
		Duel.SpecialSummon(token,0,1-tp,1-tp,false,false,POS_FACEUP)
end
function c8003.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x901)
end
function c8003.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x40)
end
function c8003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8003.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c8003.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c8003.rmfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c8003.cfilter(c)
	return c:IsSetCard(0x901) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c8003.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c8003.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c8003.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c8003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c8003.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end