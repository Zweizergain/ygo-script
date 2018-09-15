--空间乱数挤压
function c21520040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520040.condition)
	e1:SetCost(c21520040.cost)
	e1:SetTarget(c21520040.target)
	e1:SetOperation(c21520040.operation)
	c:RegisterEffect(e1)
	--hand infinity and non active and DP only
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_HAND_LIMIT)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetRange(LOCATION_SZONE)
	e2_1:SetTargetRange(1,1)
	e2_1:SetValue(200)
	c:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD)
	e2_2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_2:SetRange(LOCATION_SZONE)
	e2_2:SetTargetRange(1,1)
	e2_2:SetValue(1)
	c:RegisterEffect(e2_2)
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetType(EFFECT_TYPE_FIELD)
	e2_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_3:SetRange(LOCATION_SZONE)
	e2_3:SetTargetRange(1,1)
	e2_3:SetCode(EFFECT_SKIP_SP)
	c:RegisterEffect(e2_3)
	local e2_4=e2_3:Clone()
	e2_4:SetCode(EFFECT_SKIP_M1)
	c:RegisterEffect(e2_4)
	local e2_5=e2_3:Clone()
	e2_5:SetCode(EFFECT_SKIP_BP)
	c:RegisterEffect(e2_5)
	local e2_6=e2_3:Clone()
	e2_6:SetCode(EFFECT_SKIP_M2)
	c:RegisterEffect(e2_6)
	local e2_7=e2_3:Clone()
	e2_7:SetCode(EFFECT_CANNOT_BP)
	c:RegisterEffect(e2_7)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c21520040.econ)
	e3:SetValue(c21520040.efilter)
	c:RegisterEffect(e3)
end
function c21520040.filter(c)
	return c:IsSetCard(0x493) and c:IsFaceup() and c:IsReleasable()
end
function c21520040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c21520040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c21520040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_NUMBER,tp,g:GetCount())
	Duel.Hint(HINT_NUMBER,1-tp,g:GetCount())
	e:SetLabel(g:GetCount())
end
function c21520040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
	e:SetLabel(e:GetLabel())
end
function c21520040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct<=0 then 
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		return
	end
	for i=1,ct do
		c:RegisterFlagEffect(21520040,RESET_EVENT+0x1fe0000,0,1)
	end
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c:SetTurnCounter(0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21520040.thop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,ct)
	c:RegisterEffect(e2)
end
function c21520040.rfilter(c)
	return c:IsSetCard(0x5493) and c:IsFaceup()
end
function c21520040.econ(e)
	local ct=Group.GetClassCount(Duel.GetMatchingGroup(c21520040.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil),Card.GetOriginalCode)
	return ct>=8
end
function c21520040.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c21520040.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==c:GetFlagEffect(21520040) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		c:ResetFlagEffect(21520040)
	end
end
