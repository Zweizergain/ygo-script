--星辰赐福
function c21520147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c21520147.condition)
	e2:SetOperation(c21520147.operation)
	c:RegisterEffect(e2)
end
function c21520147.filter(c)
	return c:IsSetCard(0x491) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c21520147.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520147.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c21520147.operation(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	local ct=1000*ev
	Duel.Recover(tp,ct,REASON_EFFECT)
end
